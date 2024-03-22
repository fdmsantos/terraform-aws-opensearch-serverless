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
  name        = local.encryption_policy_name
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
  name        = local.network_policy_name
  type        = "network"
  description = var.network_policy_description
  policy      = jsonencode(local.network_policies[var.network_policy_type])
}

resource "aws_opensearchserverless_vpc_endpoint" "this" {
  count              = local.create_vpce ? 1 : 0
  name               = local.vpce_name
  subnet_ids         = var.vpce_subnet_ids
  vpc_id             = var.vpce_vpc_id
  security_group_ids = var.vpce_security_group_ids
}

resource "aws_opensearchserverless_access_policy" "this" {
  count       = var.create_access_policy ? 1 : 0
  name        = local.access_policy_name
  type        = "data"
  description = var.access_policy_description
  policy      = jsonencode(local.access_policy)
}

resource "aws_opensearchserverless_lifecycle_policy" "this" {
  count       = var.create_data_lifecycle_policy ? 1 : 0
  name        = local.data_lifecycle_policy_name
  type        = "retention"
  description = var.data_lifecycle_policy_description
  policy = jsonencode({
    "Rules" : local.data_lifecycle_policy
  })
}
