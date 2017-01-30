resource "aws_s3_bucket" "wedding" {
  bucket = "alexandmarissa.com"
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
      "Resource": "arn:aws:s3:::alexandmarissa.com/*",
      "Principal": "*"
    }
  ]
}
EOF

  website {
    index_document = "index.html"
  }
}

resource "cloudflare_record" "wedding" {
  domain  = "alexandmarissa.com"
  name    = "alexandmarissa.com"
  value   = "${aws_s3_bucket.wedding.website_endpoint}"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "wedding_redirect" {
  domain  = "alexandmarissa.com"
  name    = "www"
  value   = "alexandmarissa.com"
  type    = "CNAME"
  proxied = true
}
