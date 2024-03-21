locals {
  encryption_policy_name = var.encryption_policy_name != null ? var.encryption_policy_name : "${var.name}-encryption-policy"
  network_policy_name    = var.network_policy_name != null ? var.network_policy_name : "${var.name}-network-policy"
  access_policy_name     = var.access_policy_name != null ? var.access_policy_name : "${var.name}-access-policy"

  vpce_name            = var.vpce_name != null ? var.vpce_name : "${var.name}-vpce"
  create_vpce          = var.create_network_policy && var.network_policy_type != "AllPublic" ? true : false
  network_policy_vpces = local.create_vpce ? [aws_opensearchserverless_vpc_endpoint.this[0].id] : null
  network_policies = {
    AllPublic = [{
      Description = "Public access to collection and Dashboards endpoint for ${var.name} collection",
      Rules = [
        {
          ResourceType = "collection",
          Resource     = ["collection/${var.name}"]
          }, {
          ResourceType = "dashboard"
          Resource     = ["collection/${var.name}"]
        }
      ],
      AllowFromPublic = true
    }],
    AllPrivate = [{
      Description = "VPC access to collection and Dashboards endpoint for ${var.name} collection",
      Rules = [
        {
          ResourceType = "collection",
          Resource     = ["collection/${var.name}"]
          }, {
          ResourceType = "dashboard"
          Resource     = ["collection/${var.name}"]
        }
      ],
      AllowFromPublic = false,
      SourceVPCEs     = local.network_policy_vpces
    }],
    PublicCollectionPrivateDashboard = [{
      Description = "Public access to collection endpoint for ${var.name} collection",
      Rules = [{
        ResourceType = "collection",
        Resource     = ["collection/${var.name}"]
      }],
      AllowFromPublic = true
      }, {
      Description = "VPC access to dashboard endpoint for ${var.name} collection",
      Rules = [{
        ResourceType = "dashboard",
        Resource     = ["collection/${var.name}"]
      }],
      AllowFromPublic = false
      SourceVPCEs     = local.network_policy_vpces
    }],
    PrivateCollectionPublicDashboard = [{
      Description = "Public access to dashboard endpoint for ${var.name} collection",
      Rules = [{
        ResourceType = "dashboard",
        Resource     = ["collection/${var.name}"]
      }],
      AllowFromPublic = true
      },
      {
        Description = "VPC access to collection endpoint for ${var.name} collection",
        Rules = [{
          ResourceType = "collection",
          Resource     = ["collection/${var.name}"]
        }],
        AllowFromPublic = false
        SourceVPCEs     = local.network_policy_vpces
    }],
  }

  access_policy_collection_permissions = {
    All    = "aoss:*",
    Create = "aoss:CreateCollectionItems"
    Read   = "aoss:DescribeCollectionItems"
    Update = "aoss:UpdateCollectionItems"
    Delete = "aoss:DeleteCollectionItems"
  }

  access_policy_index_permissions = {
    All           = "aoss:*",
    Create        = "aoss:CreateIndex"
    Read          = "aoss:DescribeIndex"
    Update        = "aoss:UpdateIndex"
    Delete        = "aoss:DeleteIndex"
    ReadDocument  = "aoss:ReadDocument"
    WriteDocument = "aoss:WriteDocument"
  }

  access_policy = var.create_access_policy ? [for i, rule in var.access_policy_rules : {
    Rules = [{
      ResourceType = rule.type
      Resource     = rule.type == "collection" ? ["collection/${var.name}"] : [for i, index in rule.indexes : "index/${var.name}/${index}"]
      Permission   = rule.type == "collection" ? [for k, permission in rule.permissions : local.access_policy_collection_permissions[permission]] : [for k, permission in rule.permissions : local.access_policy_index_permissions[permission]]
    }],
    Principal = rule.principals
  }] : []
}
