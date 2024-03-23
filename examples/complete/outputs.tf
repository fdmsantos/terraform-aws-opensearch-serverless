output "collection_arn" {
  description = "Amazon Resource Name (ARN) of the collection."
  value       = module.opensearch_serverless.collection_arn
}

output "collection_id" {
  description = "Unique identifier for the collection."
  value       = module.opensearch_serverless.collection_id
}

output "collection_endpoint" {
  description = "Collection-specific endpoint used to submit index, search, and data upload requests to an OpenSearch Serverless collection."
  value       = module.opensearch_serverless.collection_endpoint
}

output "dashboard_endpoint" {
  description = "Collection-specific endpoint used to access OpenSearch Dashboards."
  value       = module.opensearch_serverless.dashboard_endpoint
}

output "encrypt_policy_version" {
  description = "Encryption policy version."
  value       = module.opensearch_serverless.encryption_policy_version
}

output "network_policy_version" {
  description = "Network policy version."
  value       = module.opensearch_serverless.network_policy_version
}

output "data_access_policy_version" {
  description = "Data Access policy version."
  value       = module.opensearch_serverless.access_policy_version
}

output "data_lifecycle_policy_version" {
  description = "Data Lifecycle policy version."
  value       = module.opensearch_serverless.data_lifecycle_policy_version
}

#output "security_config_version" {
#  description = "Security Config version."
#  value       = module.opensearch_serverless.security_config_version
#}
