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
  region  = "ap-southeast-1"
  alias   = "ap_southeast_1"
  profile = "personal"

  default_tags {
    tags = {
      Environment = "Production"
      Project     = "antarticite"
      ManagedBy   = "Terraform"
    }
  }
}

