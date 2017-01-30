resource "aws_s3_bucket" "demo" {
  bucket = "demo.alexrecker.com"
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
      "Resource": "arn:aws:s3:::demo.alexrecker.com/*",
      "Principal": "*"
    }
  ]
}
EOF

  website {
    index_document = "index.html"
  }
}

resource "cloudflare_record" "demo" {
  domain  = "alexrecker.com"
  name    = "demo.alexrecker.com"
  value   = "${aws_s3_bucket.demo.website_endpoint}"
  type    = "CNAME"
  proxied = true
}
