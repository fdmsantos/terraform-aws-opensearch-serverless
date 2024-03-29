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
  vpce_security_group_sources = [
    {
      type    = "IPv4"
      sources = ["0.0.0.0/0"]
    },
    {
      type    = "IPv6"
      sources = ["::/0"]
    }
  ]
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
  create_data_lifecycle_policy = true
  data_lifecycle_policy_rules = [
    {
      indexes = ["index1", "index2"]
    },
    {
      indexes   = ["index3", "index4"]
      retention = "81d"
    },
    {
      indexes   = ["index5"]
      retention = "Unlimited"
    }
  ]
  create_security_config = true
  saml_metadata          = "${path.module}/saml-metadata.xml"
  saml_user_attribute    = "example"
  saml_group_attribute   = "example"
  saml_session_timeout   = 90
  tags = {
    Environment : "Dev"
  }
}
