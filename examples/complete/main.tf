data "aws_caller_identity" "current" {}

module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  name            = "${var.name_prefix}-vpc"
  cidr            = var.vpc_cidr
  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets
}

module "opensearch_serverless" {
  source              = "../../"
  name                = var.name_prefix
  network_policy_type = "PublicCollectionPrivateDashboard"
  vpce_vpc_id         = module.vpc.vpc_id
  vpce_subnet_ids     = [module.vpc.private_subnets[0]]
  access_policy_rules = [
    {
      type        = "collection"
      permissions = ["All"]
      principals  = [data.aws_caller_identity.current.arn]
    },
    {
      type        = "collection"
      permissions = ["Read"]
      principals  = [data.aws_caller_identity.current.arn]
    },
    {
      type        = "index"
      permissions = ["Create", "Update", "Delete", "ReadDocument", "WriteDocument"]
      indexes     = ["index1", "index2"]
      principals  = [data.aws_caller_identity.current.arn]
    }
  ]
  tags = {
    Environment : "Dev"
  }
}
