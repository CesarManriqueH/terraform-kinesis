resource "aws_iam_role" "s3_role" {
  name               = "${local.name_prefix}-s3-role"
  assume_role_policy = data.aws_iam_policy_document.s3_firehose_assume_policy.json
}

data "aws_iam_policy_document" "s3_firehose_assume_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role_policy" "s3_policy" {
  name   = "${local.name_prefix}-s3"
  role   = aws_iam_role.s3_role.name
  policy = data.aws_iam_policy_document.s3_policy.json
}

// TODO: files are not deliver to s3, probably due to a permission issue
data "aws_iam_policy_document" "s3_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.output.arn,
      "${aws_s3_bucket.output.arn}/*"
    ]
  }
}
