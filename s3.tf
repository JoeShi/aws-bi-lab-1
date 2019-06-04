resource "random_string" "s3_bucket_suffix" {
  length = 6
  lower = true
  upper = false
  special = false
  number = false
}

resource "aws_s3_bucket" "source" {
  bucket = "lab-bi-${random_string.s3_bucket_suffix.result}"
}


output "Bucket name:" {
  value = "${aws_s3_bucket.source.bucket}"
}

