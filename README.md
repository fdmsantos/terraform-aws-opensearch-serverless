# AWS Opensearch Serverless Terraform module

[![semantic-release: angular](https://img.shields.io/badge/semantic--release-angular-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)

Dynamic Terraform module, which creates a Opensearch Serverless Collection and related resources.

## Table of Contents

- [AWS Opensearch Serverless Terraform module](#aws-opensearch-serverless-terraform-module)
    * [Table of Contents](#table-of-contents)
    * [Module versioning rule](#module-versioning-rule)
    * [Features](#features)
    * [How to Use](#how-to-use)
        + [Basic Example](#basic-example)
        + [Encryption Policy](#encryption-policy)
        + [Network Policy](#network-policy)
            - [VPC Access](#vpc-access)
        + [Data Access Policy](#data-access-policy)
    * [Examples](#examples)
    * [Requirements](#requirements)
    * [Providers](#providers)
    * [Modules](#modules)
    * [Resources](#resources)
    * [Inputs](#inputs)
    * [Outputs](#outputs)
    * [License](#license)


## Module versioning rule

| Module version | AWS Provider version |
|----------------|----------------------|
| >= 1.x.x       | => 5.31              |

## Features

- Encryption Policy
- Network Policy
- Data Access Policy
- Opensearch Serverless VPCE

## How to Use

### Basic Example

This example will create:
    * Opensearch Serverless Collection
    * Encryption Policy with AWS Managed KMS Key
    * Public Network Policy to Both Endpoints
    * Data Access Policy with all permissions to collection and all indexes

```hcl
module "firehose" {
  source              = "fdmsantos/opensearch-serverless/aws"
  version             = "x.x.x"
  name                = "demo-collection"
  access_policy_rules = [
    {
      type        = "collection"
      permissions = ["All"]
      principals  = [data.aws_caller_identity.current.arn]
    },
    {
      type        = "index"
      permissions = ["All"]
      indexes     = ["*"]
      principals  = [data.aws_caller_identity.current.arn]
    }
  ]
}
```

### Encryption Policy

By default, the encryption policy use AWS managed KMS Key. To Use Customer Managed KMS Key use the variable `encryption_policy_kms_key_arn`

### Network Policy

By default, the network policy is created with public access to dashboard and collection endpoints. 
To change the network policy use variable `network_policy_type`. The supported values are:

| Value                            | Description                                                        |
|----------------------------------|--------------------------------------------------------------------|
| AllPublic                        | Public endpoints for Dashboard and Collection                      |
| AllPrivate                       | Private endpoints for Dashboard and Collection                     |
| PublicCollectionPrivateDashboard | Public endpoint for Collection and Private endpoint for Collection |
| PrivateCollectionPublicDashboard | Private endpoint for Collection and Public endpoint forCollection  |

#### VPC Access

If the variable `network_policy_type` is different from "AllPublic", the module will create Opensearch Serverless Endpoint to private access.
In this case it's necessary configure the following variables: `vpce_subnet_ids` and `vpce_vpc_id`. `vpce_security_group_ids` is optional.

### Data Access Policy

To configure data access policy use variable `access_policy_rules`. This variable is a list of data access rules.
Each rule contains the following fields:

| Field       | Supported Values                                                                                                     |
|-------------|----------------------------------------------------------------------------------------------------------------------|
| type        | collection;index                                                                                                     |
| permissions | Collection Type: All;Create;Read;Update;Delete. Index Type: All;Create;Read;Update;Delete;ReadDocument;WriteDocument |                  
| principals  | IAM Users;IAM Roles;SAML users;SAML Groups                                                                           |
| principals  | IAM Users;IAM Roles;SAML users;SAML Groups                                                                           |
| indexes     | List of indexes to be used on policy rule                                                                            |

## Examples

- [Complete](https://github.com/fdmsantos/terraform-aws-opensearch-serverless/tree/main/examples/complete) - Creates an opensearch serverless collection with all features.

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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_opensearchserverless_access_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_access_policy) | resource |
| [aws_opensearchserverless_collection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_collection) | resource |
| [aws_opensearchserverless_security_policy.encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_security_policy) | resource |
| [aws_opensearchserverless_security_policy.network](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_security_policy) | resource |
| [aws_opensearchserverless_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_vpc_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policy_description"></a> [access\_policy\_description](#input\_access\_policy\_description) | Description of the access policy. | `string` | `null` | no |
| <a name="input_access_policy_name"></a> [access\_policy\_name](#input\_access\_policy\_name) | The name of the data access policy. | `string` | `null` | no |
| <a name="input_access_policy_rules"></a> [access\_policy\_rules](#input\_access\_policy\_rules) | Rules to apply on access policy. | <pre>list(object({<br>    type        = string<br>    permissions = list(string)<br>    principals  = list(string)<br>    indexes     = optional(list(string), [])<br>  }))</pre> | `[]` | no |
| <a name="input_create_access_policy"></a> [create\_access\_policy](#input\_create\_access\_policy) | Controls if data access policy should be created. | `bool` | `true` | no |
| <a name="input_create_encryption_policy"></a> [create\_encryption\_policy](#input\_create\_encryption\_policy) | Controls if encryption policy should be created. | `bool` | `true` | no |
| <a name="input_create_network_policy"></a> [create\_network\_policy](#input\_create\_network\_policy) | Controls if network policy should be created. | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the collection. | `string` | `null` | no |
| <a name="input_encryption_policy_description"></a> [encryption\_policy\_description](#input\_encryption\_policy\_description) | Description of the encryption policy. | `string` | `null` | no |
| <a name="input_encryption_policy_kms_key_arn"></a> [encryption\_policy\_kms\_key\_arn](#input\_encryption\_policy\_kms\_key\_arn) | MS Customer managed key arn to use in the encryption policy. | `string` | `null` | no |
| <a name="input_encryption_policy_name"></a> [encryption\_policy\_name](#input\_encryption\_policy\_name) | The name of the encryption policy. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the collection. | `string` | n/a | yes |
| <a name="input_network_policy_description"></a> [network\_policy\_description](#input\_network\_policy\_description) | Description of the network policy. | `string` | `null` | no |
| <a name="input_network_policy_name"></a> [network\_policy\_name](#input\_network\_policy\_name) | The name of the network policy. | `string` | `null` | no |
| <a name="input_network_policy_type"></a> [network\_policy\_type](#input\_network\_policy\_type) | Type of Network Policy. Supported Values are: AllPublic, AllPrivate, PublicCollectionPrivateDashboard, PrivateCollectionPublicDashboard | `string` | `"AllPublic"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the collection. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of collection. One of SEARCH, TIMESERIES, or VECTORSEARCH. Defaults to TIMESERIES. | `string` | `"TIMESERIES"` | no |
| <a name="input_use_standby_replicas"></a> [use\_standby\_replicas](#input\_use\_standby\_replicas) | Indicates whether standby replicas should be used for a collection. | `bool` | `true` | no |
| <a name="input_vpce_name"></a> [vpce\_name](#input\_vpce\_name) | Name of the interface endpoint. | `string` | `null` | no |
| <a name="input_vpce_security_group_ids"></a> [vpce\_security\_group\_ids](#input\_vpce\_security\_group\_ids) | One or more security groups that define the ports, protocols, and sources for inbound traffic that you are authorizing into your endpoint. Up to 5 security groups can be provided. | `list(string)` | `null` | no |
| <a name="input_vpce_subnet_ids"></a> [vpce\_subnet\_ids](#input\_vpce\_subnet\_ids) | One or more subnet IDs from which you'll access OpenSearch Serverless. Up to 6 subnets can be provided. | `list(string)` | `[]` | no |
| <a name="input_vpce_vpc_id"></a> [vpce\_vpc\_id](#input\_vpce\_vpc\_id) | ID of the VPC from which you'll access OpenSearch Serverless. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_collection_arn"></a> [collection\_arn](#output\_collection\_arn) | Amazon Resource Name (ARN) of the collection. |
| <a name="output_collection_endpoint"></a> [collection\_endpoint](#output\_collection\_endpoint) | Collection-specific endpoint used to submit index, search, and data upload requests to an OpenSearch Serverless collection. |
| <a name="output_collection_id"></a> [collection\_id](#output\_collection\_id) | Unique identifier for the collection. |
| <a name="output_dashboard_endpoint"></a> [dashboard\_endpoint](#output\_dashboard\_endpoint) | Collection-specific endpoint used to access OpenSearch Dashboards. |
| <a name="output_encryption_policy_name"></a> [encryption\_policy\_name](#output\_encryption\_policy\_name) | Name of the encryption policy. |
| <a name="output_encryption_policy_version"></a> [encryption\_policy\_version](#output\_encryption\_policy\_version) | Version of the encryption policy. |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The ARN of the Amazon Web Services KMS key used to encrypt the collection. |
| <a name="output_network_policy_name"></a> [network\_policy\_name](#output\_network\_policy\_name) | Name of the network policy. |
| <a name="output_network_policy_version"></a> [network\_policy\_version](#output\_network\_policy\_version) | Version of the network policy. |
| <a name="output_vpce_id"></a> [vpce\_id](#output\_vpce\_id) | Id of the vpce. |
| <a name="output_vpce_name"></a> [vpce\_name](#output\_vpce\_name) | Name of the interface endpoint. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See [LICENSE](https://github.com/fdmsantos/terraform-aws-opensearch-serverlesse/tree/main/LICENSE) for full details.
