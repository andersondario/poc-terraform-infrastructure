resource "aws_s3_bucket" "s3_bucket" {
    bucket = "${var.application_name}-${terraform.workspace}"

    acl = "public-read"
    force_destroy = terraform.workspace == "prd"? false : true

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.application_name}-${terraform.workspace}/*"
            ]
        }
    ]
}
EOF

    website {
        index_document = "index.html"
        error_document = "error.html"
    }

    tags = var.tags
}