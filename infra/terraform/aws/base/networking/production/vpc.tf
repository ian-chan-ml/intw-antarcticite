module "vpc" {
  source = "../../../../modules/vpc"

  name     = "ex-prod-antarticite"
  vpc_cidr = "10.0.0.0/16"

  region = "ap-southeast-3"

  tags = {
    GithubRepo = "ian-chan-ml/intw-antarticite"
    Owner      = "quanianitis@moneylion.com"
  }
}
