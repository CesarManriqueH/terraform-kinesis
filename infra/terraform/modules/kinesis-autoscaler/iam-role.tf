resource "aws_iam_role" "autoscaler_role" {
  name               = "${local.name_prefix}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
}

data "aws_iam_policy_document" "assume_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy" "policy" {
  name   = "${local.name_prefix}-policy"
  role   = aws_iam_role.autoscaler_role.name
  policy = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect = "Allow"
    actions = [
      "kinesis:*" // TODO: Assign fine grained permissions here
    ]
    resources = [var.in_stream_arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:GetMetricStatistics"
    ]
    resources = ["*"]
  }
}
