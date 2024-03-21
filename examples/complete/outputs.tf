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
