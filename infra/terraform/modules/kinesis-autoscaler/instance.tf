resource "aws_iam_instance_profile" "profile" {
  name = "${local.name_prefix}-profile"
  role = aws_iam_role.autoscaler_role.name
}

resource "aws_instance" "kinesis_autoscaler" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.profile.name
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags                   = { Name = local.name_prefix }

  user_data = templatefile("${path.module}/templates/bootstrap.sh", {
    artifact_store_bucket = var.artifact_store_bucket,
    config = templatefile("${path.module}/templates/config.json.tpl", {
      in_stream = var.in_stream_name
      region    = var.region
    })
  })
}

// TODO: Setup Log Group
