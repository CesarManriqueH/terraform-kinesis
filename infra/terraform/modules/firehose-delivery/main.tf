resource "aws_kinesis_firehose_delivery_stream" "firehose_delivery" {
  name        = local.name_prefix
  destination = "s3"

  kinesis_source_configuration {
    kinesis_stream_arn = var.stream_arn
    role_arn           = aws_iam_role.kinesis_role.arn
  }

  s3_configuration {
    role_arn        = aws_iam_role.s3_role.arn
    bucket_arn      = aws_s3_bucket.output.arn
    buffer_size     = 5
    buffer_interval = 60
  }
}
