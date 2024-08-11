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

