resource "aws_s3_bucket" "bob" {
  bucket = "bobrosssearch.com"
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
      "Resource": "arn:aws:s3:::bobrosssearch.com/*",
      "Principal": "*"
    }
  ]
}
EOF

  website {
    index_document = "index.html"
  }
}

resource "cloudflare_record" "bob" {
  domain  = "bobrosssearch.com"
  name    = "bobrosssearch.com"
  value   = "${aws_s3_bucket.bob.website_endpoint}"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "bob_redirect" {
  domain  = "bobrosssearch.com"
  name    = "www"
  value   = "bobrosssearch.com"
  type    = "CNAME"
  proxied = true
}
