# Complete Opensearch Serverless

Configuration in this directory creates opensearch serverless collection with all supported features.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.31 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.31 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_opensearch_serverless"></a> [opensearch\_serverless](#module\_opensearch\_serverless) | ../../ | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix to use in resources | `string` | `"demo"` | no |
| <a name="input_vpc_azs"></a> [vpc\_azs](#input\_vpc\_azs) | Redshift AZs | `list(string)` | <pre>[<br>  "eu-west-1a",<br>  "eu-west-1b",<br>  "eu-west-1c"<br>]</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | VPC Private Subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_vpc_public_subnets"></a> [vpc\_public\_subnets](#input\_vpc\_public\_subnets) | VPC Public Subnets | `list(string)` | <pre>[<br>  "10.0.101.0/24",<br>  "10.0.102.0/24",<br>  "10.0.103.0/24"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_collection_arn"></a> [collection\_arn](#output\_collection\_arn) | Amazon Resource Name (ARN) of the collection. |
| <a name="output_collection_endpoint"></a> [collection\_endpoint](#output\_collection\_endpoint) | Collection-specific endpoint used to submit index, search, and data upload requests to an OpenSearch Serverless collection. |
| <a name="output_collection_id"></a> [collection\_id](#output\_collection\_id) | Unique identifier for the collection. |
| <a name="output_dashboard_endpoint"></a> [dashboard\_endpoint](#output\_dashboard\_endpoint) | Collection-specific endpoint used to access OpenSearch Dashboards. |
| <a name="output_data_access_policy_version"></a> [data\_access\_policy\_version](#output\_data\_access\_policy\_version) | Data Access policy version. |
| <a name="output_data_lifecycle_policy_version"></a> [data\_lifecycle\_policy\_version](#output\_data\_lifecycle\_policy\_version) | Data Lifecycle policy version. |
| <a name="output_encrypt_policy_version"></a> [encrypt\_policy\_version](#output\_encrypt\_policy\_version) | Encryption policy version. |
| <a name="output_network_policy_version"></a> [network\_policy\_version](#output\_network\_policy\_version) | Network policy version. |
| <a name="output_security_config_version"></a> [security\_config\_version](#output\_security\_config\_version) | Security Config version. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Id of the security group. |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | Name of the security group. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
