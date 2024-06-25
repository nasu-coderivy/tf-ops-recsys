data "aws_region" "current" {}

locals {
  recsys_az = "${data.aws_region.current.name}a"
}