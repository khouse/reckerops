resource "aws_s3_bucket" "blog" {
  bucket = "alexrecker.com"
  acl    = "public-read"

  policy = <<EOF
{
  "Id": "bucket_policy_site",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "bucket_policy_site_main",
      "Action": [
	"s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::alexrecker.com/*",
      "Principal": "*"
    }
  ]
}
EOF

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket" "randomimage" {
  bucket = "random.png"
  acl    = "private"
}

resource "aws_iam_role" "randomimage" {
    name = "RandomImageGetter"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
	"Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "randomimage" {
    name = "randomimage-policy"
    role = "${aws_iam_role.randomimage.id}"
    policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Action":["s3:ListBucket", "s3:GetObject"],
      "Resource":["arn:aws:s3:::random.png", "arn:aws:s3:::random.png/*"]
    }
  ]
}
EOF
}

resource "aws_lambda_function" "randomimage" {
  filename = "lambda/randompng.zip"
  source_code_hash = "${base64sha256(file("lambda/randompng.zip"))}"
  function_name = "get-random-image"
  handler = "randompng.handler"
  runtime = "python2.7"
  role = "${aws_iam_role.randomimage.arn}"
  timeout = "60"
}

resource "aws_api_gateway_rest_api" "blog" {
  name = "Blog"
  description = "Random methods for my blog"
}

resource "aws_api_gateway_resource" "randomimage" {
  rest_api_id = "${aws_api_gateway_rest_api.blog.id}"
  parent_id = "${aws_api_gateway_rest_api.blog.root_resource_id}"
  path_part = "random-image"
}

resource "aws_api_gateway_method" "randomimageget" {
  rest_api_id = "${aws_api_gateway_rest_api.blog.id}"
  resource_id = "${aws_api_gateway_resource.randomimage.id}"
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = "${aws_api_gateway_rest_api.blog.id}"
  resource_id = "${aws_api_gateway_resource.randomimage.id}"
  http_method = "${aws_api_gateway_method.randomimageget.http_method}"
  integration_http_method = "POST"
  type = "AWS"
  uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.randomimage.arn}/invocations"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.randomimage.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.blog.id}/*/${aws_api_gateway_method.randomimageget.http_method}"
}

resource "aws_api_gateway_method_response" "randomimage200" {
  rest_api_id = "${aws_api_gateway_rest_api.blog.id}"
  resource_id = "${aws_api_gateway_resource.randomimage.id}"
  http_method = "${aws_api_gateway_method.randomimageget.http_method}"
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}


resource "aws_api_gateway_integration_response" "randomimage" {
  rest_api_id = "${aws_api_gateway_rest_api.blog.id}"
  resource_id = "${aws_api_gateway_resource.randomimage.id}"
  http_method = "${aws_api_gateway_method.randomimageget.http_method}"
  status_code = "${aws_api_gateway_method_response.randomimage200.status_code}"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS,GET,PUT,PATCH,DELETE'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_deployment" "blog" {
  depends_on = ["aws_api_gateway_method.randomimageget"]
  rest_api_id = "${aws_api_gateway_rest_api.blog.id}"
  stage_name = "v1"
}

resource "cloudflare_record" "blog" {
  domain  = "alexrecker.com"
  name    = "alexrecker.com"
  value   = "${aws_s3_bucket.blog.website_endpoint}"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "blog_redirect" {
  domain  = "alexrecker.com"
  name    = "www"
  value   = "alexrecker.com"
  type    = "CNAME"
  proxied = true
}

# Not used, since AWS requires a cert and all that
# resource "cloudflare_record" "api" {
#   domain  = "alexrecker.com"
#   name    = "api"
#   value   = "${aws_api_gateway_rest_api.blog.id}.execute-api.${var.aws_region}.amazonaws.com"
#   type    = "CNAME"
#   proxied = true
# }
