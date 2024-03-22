######
# OpenSearch Collection
######
output "collection_arn" {
  description = "Amazon Resource Name (ARN) of the collection."
  value       = aws_opensearchserverless_collection.this.arn
}

output "collection_id" {
  description = "Unique identifier for the collection."
  value       = aws_opensearchserverless_collection.this.id
}

output "collection_endpoint" {
  description = "Collection-specific endpoint used to submit index, search, and data upload requests to an OpenSearch Serverless collection."
  value       = aws_opensearchserverless_collection.this.collection_endpoint
}

output "dashboard_endpoint" {
  description = "Collection-specific endpoint used to access OpenSearch Dashboards."
  value       = aws_opensearchserverless_collection.this.dashboard_endpoint
}

output "kms_key_arn" {
  description = "The ARN of the Amazon Web Services KMS key used to encrypt the collection."
  value       = aws_opensearchserverless_collection.this.kms_key_arn
}
#######
## Encryption Policy
#######
output "encryption_policy_version" {
  description = "Version of the encryption policy."
  value       = var.create_encryption_policy ? aws_opensearchserverless_security_policy.encryption[0].policy_version : null
}

output "encryption_policy_name" {
  description = "Name of the encryption policy."
  value       = var.create_encryption_policy ? aws_opensearchserverless_security_policy.encryption[0].name : null
}

#######
## Network Policy
#######
output "network_policy_version" {
  description = "Version of the network policy."
  value       = var.create_network_policy ? aws_opensearchserverless_security_policy.network[0].policy_version : null
}

output "network_policy_name" {
  description = "Name of the network policy."
  value       = var.create_network_policy ? aws_opensearchserverless_security_policy.network[0].name : null
}

#######
## Vpce
#######
output "vpce_name" {
  description = "Name of the interface endpoint."
  value       = local.create_vpce ? aws_opensearchserverless_vpc_endpoint.this[0].name : null
}

output "vpce_id" {
  description = "Id of the vpce."
  value       = local.create_vpce ? aws_opensearchserverless_vpc_endpoint.this[0].id : null
}

#######
## Data Access Policy
#######
output "access_policy_version" {
  description = "Version of the data access policy."
  value       = var.create_access_policy ? aws_opensearchserverless_access_policy.this[0].policy_version : null
}

output "access_policy_name" {
  description = "Name of the data access policy."
  value       = var.create_access_policy ? aws_opensearchserverless_access_policy.this[0].name : null
}

#######
## Data Lifecycle Policy
#######
output "data_lifecycle_policy_version" {
  description = "Version of the data lifecycle access policy."
  value       = var.create_data_lifecycle_policy ? aws_opensearchserverless_lifecycle_policy.this[0].policy_version : null
}

output "data_lifecycle_policy_name" {
  description = "Name of the data lifecycle policy."
  value       = var.create_data_lifecycle_policy ? aws_opensearchserverless_lifecycle_policy.this[0].name : null
}
