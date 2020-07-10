module "artifact_store" {
  source      = "./modules/artifact-store"
  name_prefix = local.name_prefix
}

resource "aws_kinesis_stream" "in_stream" {
  name                      = "in_stream"
  shard_count               = 1
  retention_period          = 24
  enforce_consumer_deletion = true

  lifecycle {
    ignore_changes = [shard_count]
  }
}

module "kinesis_producer" {
  source                = "./modules/kinesis-producer"
  name_prefix           = local.name_prefix
  region                = var.region
  instance_type         = "t2.micro"
  ami_id                = data.aws_ami.ubuntu.id
  key_name              = var.key_pair
  in_stream_name        = aws_kinesis_stream.in_stream.name
  in_stream_arn         = aws_kinesis_stream.in_stream.arn
  artifact_store_bucket = module.artifact_store.bucket
}

module "firehose_delivery" {
  source      = "./modules/firehose-delivery"
  name_prefix = local.name_prefix
  stream_name = aws_kinesis_stream.in_stream.name
  stream_arn  = aws_kinesis_stream.in_stream.arn
}

module "kinesis_stream_autoscaler" {
  source                = "./modules/kinesis-autoscaler"
  name_prefix           = local.name_prefix
  region                = var.region
  instance_type         = "t2.micro"
  ami_id                = data.aws_ami.ubuntu.id
  key_name              = var.key_pair
  in_stream_name        = aws_kinesis_stream.in_stream.name
  in_stream_arn         = aws_kinesis_stream.in_stream.arn
  artifact_store_bucket = module.artifact_store.bucket
}
