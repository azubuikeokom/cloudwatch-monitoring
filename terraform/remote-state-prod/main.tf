locals{
    name = "ecs-remote-backend"
    region = ["us-east-1","us-west-2"]
}

resource "aws_s3_bucket" "backend" {
  bucket = "${local.name}-bucket-prod"
  object_lock_enabled = "true"    
}
resource "aws_s3_bucket_policy" "allow_access_from_any_where" {
  bucket = aws_s3_bucket.backend.id
  policy =  data.aws_iam_policy_document.allow_access_from_any_where.json
}
data "aws_iam_policy_document" "allow_access_from_any_where" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
        aws_s3_bucket.backend.arn,
        "${aws_s3_bucket.backend.arn}/*"
    ]
  }
}