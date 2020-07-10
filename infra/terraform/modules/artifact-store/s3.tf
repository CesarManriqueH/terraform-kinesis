resource "aws_s3_bucket" "artifact_store" {
  bucket        = "${var.name_prefix}-artifact-store"
  acl           = "private"
  force_destroy = true
}

locals {
  deps_path = "${path.module}/dependencies"
}

// TODO
// - Move deps one dir down, like deps/.... and update every reference to these files
// - Check that public-read, how to keep it private
resource "aws_s3_bucket_object" "deps" {
  for_each = fileset("${local.deps_path}/", "**")

  bucket = aws_s3_bucket.artifact_store.id
  key    = each.value
  acl    = "public-read"
  source = "${local.deps_path}/${each.value}"
  # etag makes the file update when it changes
  # see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
  etag = filemd5("${local.deps_path}/${each.value}")
}
