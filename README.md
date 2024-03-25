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
              - [Security Group](#security-group)
        + [Data Access Policy](#data-access-policy)
        + [Data Lifecycle Policy](#data-lifecycle-policy)
        + [Security Config](#security-config)
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
- Data Lifecycle Policy
- Security Config

## How to Use

### Basic Example

This example will create:
    * Opensearch Serverless Collection
    * Encryption Policy with AWS Managed KMS Key
    * Public Network Policy to Both Endpoints
    * Data Access Policy with all permissions to collection and all indexes

```hcl
module "opensearch_serverless" {
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

##### Security Group

* To add existing security group, please use the variable `vpce_security_group_ids`.
* By Default, module creates a new security group. To disable this put the variable `vpce_create_security_group = false`.
* To choose the allowed sources for the created security group, you should use the variable `vpce_security_group_sources`.
  * This variable supports two fields:

| Field   | Allowed Values                                                                              |
|---------|---------------------------------------------------------------------------------------------|
| type    | IPv4, IPv6, PrefixLists, SGs                                                                |
| sources | List of sources to be allowed. For example: To type IPv4 should be list of IPv4 CIDR blocks |

* Example:

```hcl
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
```

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

### Data Lifecycle Policy

To create data lifecycle policy use variable `create_data_lifecycle_policy = true`. Configure the rules with variable `data_lifecycle_policy_rules` .
The default retention is `Unlimited`.

Example:

```hcl
data_lifecycle_policy_rules = [
  {
     indexes = ["index1", "index2"]
     retention = "Unlimited"
  },
  {
     indexes = ["index3", "index4"]
     retention = "81d"
  },
  {
     indexes = ["index5"]
  }
]
```

### Security Config

To create security config use variable `create_security_config = true`.
```hcl
create_security_config = true
saml_metadata          = "${path.module}/saml-metadata.xml"
saml_user_attribute    = "example"
saml_group_attribute   = "example"
saml_session_timeout   = 90
```

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
| [aws_opensearchserverless_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_lifecycle_policy) | resource |
| [aws_opensearchserverless_security_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_security_config) | resource |
| [aws_opensearchserverless_security_policy.encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_security_policy) | resource |
| [aws_opensearchserverless_security_policy.network](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_security_policy) | resource |
| [aws_opensearchserverless_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_vpc_endpoint) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policy_description"></a> [access\_policy\_description](#input\_access\_policy\_description) | Description of the access policy. | `string` | `null` | no |
| <a name="input_access_policy_name"></a> [access\_policy\_name](#input\_access\_policy\_name) | The name of the data access policy. | `string` | `null` | no |
| <a name="input_access_policy_rules"></a> [access\_policy\_rules](#input\_access\_policy\_rules) | Rules to apply on access policy. | <pre>list(object({<br>    type        = string<br>    permissions = list(string)<br>    principals  = list(string)<br>    indexes     = optional(list(string), [])<br>  }))</pre> | `[]` | no |
| <a name="input_create_access_policy"></a> [create\_access\_policy](#input\_create\_access\_policy) | Controls if data access policy should be created. | `bool` | `true` | no |
| <a name="input_create_data_lifecycle_policy"></a> [create\_data\_lifecycle\_policy](#input\_create\_data\_lifecycle\_policy) | Controls if data lifecycle policy should be created. | `bool` | `false` | no |
| <a name="input_create_encryption_policy"></a> [create\_encryption\_policy](#input\_create\_encryption\_policy) | Controls if encryption policy should be created. | `bool` | `true` | no |
| <a name="input_create_network_policy"></a> [create\_network\_policy](#input\_create\_network\_policy) | Controls if network policy should be created. | `bool` | `true` | no |
| <a name="input_create_security_config"></a> [create\_security\_config](#input\_create\_security\_config) | Controls if security config should be created. | `bool` | `false` | no |
| <a name="input_data_lifecycle_policy_description"></a> [data\_lifecycle\_policy\_description](#input\_data\_lifecycle\_policy\_description) | Description of the data lifecycle policy. | `string` | `null` | no |
| <a name="input_data_lifecycle_policy_name"></a> [data\_lifecycle\_policy\_name](#input\_data\_lifecycle\_policy\_name) | The name of the data lifecycle policy. | `string` | `null` | no |
| <a name="input_data_lifecycle_policy_rules"></a> [data\_lifecycle\_policy\_rules](#input\_data\_lifecycle\_policy\_rules) | Rules to apply on data lifecycle policy. | <pre>list(object({<br>    indexes   = list(string)<br>    retention = optional(string, "Unlimited")<br>  }))</pre> | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the collection. | `string` | `null` | no |
| <a name="input_encryption_policy_description"></a> [encryption\_policy\_description](#input\_encryption\_policy\_description) | Description of the encryption policy. | `string` | `null` | no |
| <a name="input_encryption_policy_kms_key_arn"></a> [encryption\_policy\_kms\_key\_arn](#input\_encryption\_policy\_kms\_key\_arn) | MS Customer managed key arn to use in the encryption policy. | `string` | `null` | no |
| <a name="input_encryption_policy_name"></a> [encryption\_policy\_name](#input\_encryption\_policy\_name) | The name of the encryption policy. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the collection. | `string` | n/a | yes |
| <a name="input_network_policy_description"></a> [network\_policy\_description](#input\_network\_policy\_description) | Description of the network policy. | `string` | `null` | no |
| <a name="input_network_policy_name"></a> [network\_policy\_name](#input\_network\_policy\_name) | The name of the network policy. | `string` | `null` | no |
| <a name="input_network_policy_type"></a> [network\_policy\_type](#input\_network\_policy\_type) | Type of Network Policy. Supported Values are: AllPublic, AllPrivate, PublicCollectionPrivateDashboard, PrivateCollectionPublicDashboard | `string` | `"AllPublic"` | no |
| <a name="input_saml_group_attribute"></a> [saml\_group\_attribute](#input\_saml\_group\_attribute) | Specify an attribute for group to map user groups or roles from your assertion. | `string` | `null` | no |
| <a name="input_saml_metadata"></a> [saml\_metadata](#input\_saml\_metadata) | The XML IdP metadata file generated from your identity provider. Needs to be path to a file. | `string` | `null` | no |
| <a name="input_saml_session_timeout"></a> [saml\_session\_timeout](#input\_saml\_session\_timeout) | Session timeout, in minutes. Minimum is 5 minutes and maximum is 720 minutes (12 hours). Default is 60 minutes. | `number` | `60` | no |
| <a name="input_saml_user_attribute"></a> [saml\_user\_attribute](#input\_saml\_user\_attribute) | Specify a custom attribute for user ID if your assertion does not use NameID as the default attribute. | `string` | `null` | no |
| <a name="input_security_config_description"></a> [security\_config\_description](#input\_security\_config\_description) | Description of the security config. | `string` | `null` | no |
| <a name="input_security_config_name"></a> [security\_config\_name](#input\_security\_config\_name) | The name of the security config. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the collection. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of collection. One of SEARCH, TIMESERIES, or VECTORSEARCH. Defaults to TIMESERIES. | `string` | `"TIMESERIES"` | no |
| <a name="input_use_standby_replicas"></a> [use\_standby\_replicas](#input\_use\_standby\_replicas) | Indicates whether standby replicas should be used for a collection. | `bool` | `true` | no |
| <a name="input_vpce_create_security_group"></a> [vpce\_create\_security\_group](#input\_vpce\_create\_security\_group) | Creates a security group for VPCE. | `bool` | `true` | no |
| <a name="input_vpce_name"></a> [vpce\_name](#input\_vpce\_name) | Name of the interface endpoint. | `string` | `null` | no |
| <a name="input_vpce_security_group_description"></a> [vpce\_security\_group\_description](#input\_vpce\_security\_group\_description) | Security Group description for VPCE. | `string` | `null` | no |
| <a name="input_vpce_security_group_ids"></a> [vpce\_security\_group\_ids](#input\_vpce\_security\_group\_ids) | One or more security groups that define the ports, protocols, and sources for inbound traffic that you are authorizing into your endpoint. Up to 5 security groups can be provided. | `list(string)` | `null` | no |
| <a name="input_vpce_security_group_name"></a> [vpce\_security\_group\_name](#input\_vpce\_security\_group\_name) | Security Group name for VPCE. | `string` | `null` | no |
| <a name="input_vpce_security_group_sources"></a> [vpce\_security\_group\_sources](#input\_vpce\_security\_group\_sources) | Sources for inbound traffic to Opensearch Serverless | <pre>list(object({<br>    type    = string<br>    sources = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_vpce_subnet_ids"></a> [vpce\_subnet\_ids](#input\_vpce\_subnet\_ids) | One or more subnet IDs from which you'll access OpenSearch Serverless. Up to 6 subnets can be provided. | `list(string)` | `[]` | no |
| <a name="input_vpce_vpc_id"></a> [vpce\_vpc\_id](#input\_vpce\_vpc\_id) | ID of the VPC from which you'll access OpenSearch Serverless. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_policy_name"></a> [access\_policy\_name](#output\_access\_policy\_name) | Name of the data access policy. |
| <a name="output_access_policy_version"></a> [access\_policy\_version](#output\_access\_policy\_version) | Version of the data access policy. |
| <a name="output_collection_arn"></a> [collection\_arn](#output\_collection\_arn) | Amazon Resource Name (ARN) of the collection. |
| <a name="output_collection_endpoint"></a> [collection\_endpoint](#output\_collection\_endpoint) | Collection-specific endpoint used to submit index, search, and data upload requests to an OpenSearch Serverless collection. |
| <a name="output_collection_id"></a> [collection\_id](#output\_collection\_id) | Unique identifier for the collection. |
| <a name="output_dashboard_endpoint"></a> [dashboard\_endpoint](#output\_dashboard\_endpoint) | Collection-specific endpoint used to access OpenSearch Dashboards. |
| <a name="output_data_lifecycle_policy_name"></a> [data\_lifecycle\_policy\_name](#output\_data\_lifecycle\_policy\_name) | Name of the data lifecycle policy. |
| <a name="output_data_lifecycle_policy_version"></a> [data\_lifecycle\_policy\_version](#output\_data\_lifecycle\_policy\_version) | Version of the data lifecycle access policy. |
| <a name="output_encryption_policy_name"></a> [encryption\_policy\_name](#output\_encryption\_policy\_name) | Name of the encryption policy. |
| <a name="output_encryption_policy_version"></a> [encryption\_policy\_version](#output\_encryption\_policy\_version) | Version of the encryption policy. |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The ARN of the Amazon Web Services KMS key used to encrypt the collection. |
| <a name="output_network_policy_name"></a> [network\_policy\_name](#output\_network\_policy\_name) | Name of the network policy. |
| <a name="output_network_policy_version"></a> [network\_policy\_version](#output\_network\_policy\_version) | Version of the network policy. |
| <a name="output_security_config_name"></a> [security\_config\_name](#output\_security\_config\_name) | Name of the security config. |
| <a name="output_security_config_version"></a> [security\_config\_version](#output\_security\_config\_version) | Version of the security config. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Id of the security group. |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | Name of the security group. |
| <a name="output_vpce_id"></a> [vpce\_id](#output\_vpce\_id) | Id of the vpce. |
| <a name="output_vpce_name"></a> [vpce\_name](#output\_vpce\_name) | Name of the interface endpoint. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See [LICENSE](https://github.com/fdmsantos/terraform-aws-opensearch-serverlesse/tree/main/LICENSE) for full details.
