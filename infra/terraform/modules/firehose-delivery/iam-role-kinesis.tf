resource "aws_iam_role" "kinesis_role" {
  name               = "${local.name_prefix}-kinesis-role"
  assume_role_policy = data.aws_iam_policy_document.kinesis_firehose_assume_policy.json
}

data "aws_iam_policy_document" "kinesis_firehose_assume_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role_policy" "firehose_policy" {
  name   = "${local.name_prefix}-firehose"
  role   = aws_iam_role.kinesis_role.name
  policy = data.aws_iam_policy_document.firehose_policy.json
}

data "aws_iam_policy_document" "firehose_policy" {
  statement {
    effect = "Allow"

    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords"
    ]

    resources = [
      var.stream_arn
    ]
  }
}
