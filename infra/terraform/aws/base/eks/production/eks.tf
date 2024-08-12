module "antarticite-eks-1" {
  source = "../../../../modules/eks"

  name = "antarticite-eks-1"

  cluster_version = "1.30"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}

