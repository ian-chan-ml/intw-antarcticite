provider "aws" {
  region  = "ap-southeast-3"
  profile = "personal"
}

provider "aws" {
  region  = "us-east-1"
  profile = "personal"
  alias   = "us_east_1"
}

