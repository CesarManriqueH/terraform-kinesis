resource "aws_s3_bucket" "output" {
  bucket        = local.name_prefix
  acl           = "private"
  force_destroy = true
}
