resource "aws_opensearchserverless_collection" "this" {
  name             = var.name
  description      = var.description
  standby_replicas = var.use_standby_replicas ? "ENABLED" : "DISABLED"
  type             = var.type
  tags             = var.tags
  depends_on       = [aws_opensearchserverless_security_policy.encryption]
}

resource "aws_opensearchserverless_security_policy" "encryption" {
  count       = var.create_encryption_policy ? 1 : 0
  name        = coalesce(var.encryption_policy_name, "${var.name}-encryption-policy")
  type        = "encryption"
  description = var.encryption_policy_description
  policy = jsonencode(merge({
    "Rules" = [
      {
        "Resource"     = ["collection/${var.name}"] # local.encryption_policy_collections
        "ResourceType" = "collection"
      }
    ] }, var.encryption_policy_kms_key_arn == null ? {
    AWSOwnedKey = true
    } : {}, var.encryption_policy_kms_key_arn != null ? {
    KmsARN = var.encryption_policy_kms_key_arn
    } : {}
  ))
}

resource "aws_opensearchserverless_security_policy" "network" {
  count       = var.create_network_policy ? 1 : 0
  name        = coalesce(var.network_policy_name, "${var.name}-network-policy")
  type        = "network"
  description = var.network_policy_description
  policy      = jsonencode(local.network_policies[var.network_policy_type])
}

resource "aws_opensearchserverless_vpc_endpoint" "this" {
  count              = local.create_vpce ? 1 : 0
  name               = coalesce(var.vpce_name, "${var.name}-vpce")
  subnet_ids         = var.vpce_subnet_ids
  vpc_id             = var.vpce_vpc_id
  security_group_ids = var.vpce_security_group_ids
}

resource "aws_opensearchserverless_access_policy" "this" {
  count       = var.create_access_policy ? 1 : 0
  name        = coalesce(var.access_policy_name, "${var.name}-access-policy")
  type        = "data"
  description = var.access_policy_description
  policy      = jsonencode(local.access_policy)
}

resource "aws_opensearchserverless_lifecycle_policy" "this" {
  count       = var.create_data_lifecycle_policy ? 1 : 0
  name        = coalesce(var.data_lifecycle_policy_name, "${var.name}-data-lifecycle-policy")
  type        = "retention"
  description = var.data_lifecycle_policy_description
  policy = jsonencode({
    "Rules" : local.data_lifecycle_policy
  })
}

resource "aws_opensearchserverless_security_config" "this" {
  count       = var.create_security_config ? 1 : 0
  name        = coalesce(var.security_config_name, "${var.name}-security-config")
  description = var.security_config_description
  type        = "saml"
  saml_options {
    metadata        = file(var.saml_metadata)
    group_attribute = var.saml_group_attribute
    user_attribute  = var.saml_user_attribute
    session_timeout = var.saml_session_timeout
  }
}

##################
# Security Group
##################
resource "aws_security_group" "this" {
  count       = local.crate_sg ? 1 : 0
  name        = local.sg_name
  description = var.vpce_security_group_description
  vpc_id      = var.vpce_vpc_id
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = flatten([for i, item in var.vpce_security_group_sources : [for k, source in item.sources : source] if item.type == "IPv4"])
    ipv6_cidr_blocks = flatten([for i, item in var.vpce_security_group_sources : [for k, source in item.sources : source] if item.type == "IPv6"])
    prefix_list_ids  = flatten([for i, item in var.vpce_security_group_sources : [for k, source in item.sources : source] if item.type == "PrefixLists"])
    security_groups  = flatten([for i, item in var.vpce_security_group_sources : [for k, source in item.sources : source] if item.type == "SGs"])
    description      = "Allow Inbound HTTPS Traffic"
  }
  tags = merge(
    var.tags,
    {
      Name : local.sg_name
    }
  )
}
