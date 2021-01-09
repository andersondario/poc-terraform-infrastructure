resource "aws_s3_bucket" "s3_bucket" {
    bucket = "${var.application_name}-${terraform.workspace}"

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

    tags = var.tags
}