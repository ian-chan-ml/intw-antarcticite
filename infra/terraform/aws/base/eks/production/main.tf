provider "aws" {
  region  = "ap-southeast-3"
  profile = "personal"
  default_tags {
    tags = {
      Environment = "Production"
      Project     = "antarticite"
      ManagedBy   = "Terraform"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "personal"
  alias   = "us_east_1"
  default_tags {
    tags = {
      Environment = "Production"
      Project     = "antarticite"
      ManagedBy   = "Terraform"
    }
  }
}

