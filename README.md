# terraform-aws-s3-bucket
Terraform module which creates S3 bucket resources on AWS, following best practices

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.9.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_object_lock_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.encryption_in_transit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.public_read_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.combined_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="bucket"></a> [bucket](#input\_bucket) | (Optional, Forces new resource) The name of the bucket to create. If omitted, Terraform will assign a random, unique name. | `string` | `null` | no |
| <a name="bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | (Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket. | `string` | `null` | no |
| <a name="force_destroy"></a> [force\_destroy](#input\_force\_destroy) | (Optional, Default:false) Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. These objects are not recoverable. This only deletes objects when the bucket is destroyed, not when setting this parameter to true. Once this parameter is set to true, there must be a successful terraform apply run before a destroy is required to update this value in the resource state. Without a successful terraform apply after this parameter is set, this flag will have no effect. If setting this field in the same operation that would require replacing the bucket or destroying the bucket, this flag will not work. Additionally when importing a bucket, a successful terraform apply is required to set this value in state before it will take effect on a destroy operation. | `bool` | `false` | no |
| <a name="object_lock_enabled"></a> [object\_lock\_enabled](#input\_object\_lock\_enabled) | (Optional, Default:false, Forces new resource) Indicates whether this bucket has an Object Lock configuration enabled. | `bool` | `false` | no |
| <a name="tags"></a> [tags](#input\_tags) | (Optional) Map of tags to assign to the bucket. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `{}` | no |
| <a name="block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | (Optional, Default:true) Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `true` | no |
| <a name="block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | (Optional, Default:true) Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | (Optional, Default:true) Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `true` | no |
| <a name="restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | (Optional, Default:true) Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="enforce_encryption_in_transit"></a> [enforce\_encryption\_in\_transit](#input\_enforce\_encryption\_in\_transit) | (Optional, Default:true) Whether to enforce encryption for data in transit. | `bool` | `true` | no |
| <a name="minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | (Optional, Default:1.3) The minimum version of TLS to allow connectivity over. | `string` | `1.3` | no |
| <a name="enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | (Optional, Default:true) Whether to enable encryption for data at rest. | `bool` | `true` | no |
| <a name="expected_bucket_owner"></a> [expected\_bucket\_owner](#input\_expected\_bucket\_owner) | (Optional, Forces new resource) Account ID of the expected bucket owner. | `string` | `null` | no |
| <a name="bucket_key_enabled"></a> [bucket\_key\_enabled](#input\_bucket\_key\_enabled) | (Optional, Default:true) Whether or not to use Amazon S3 Bucket Keys for SSE-KMS. | `bool` | `true` | no |
| <a name="sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | (Optional, Default:AES256) Server-side encryption algorithm to use. | `string` | `AES256` | no |
| <a name="kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | (Optional) AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms. | `string` | `null` | no |
| <a name="object_ownership"></a> [object\_ownership](#input\_object\_ownership) | (Optional, Default:BucketOwnerEnforced) Object ownership. | `string` | `BucketOwnerEnforced` | no |
| <a name="enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | (Optional, Default:true) Whether to enabled object versioning. | `bool` | `true` | no |
| <a name="versioning_status"></a> [versioning\_status](#input\_versioning\_status) | (Optional, Default:Enabled) Versioning state of the bucket. Valid values: Enabled, Suspended, or Disabled. Disabled should only be used when creating or importing resources that correspond to unversioned S3 buckets. | `string` | `Enabled` | no |
| <a name="days_until_abort_incomplete_multipart_upload"></a> [days\_until\_abort\_incomplete\_multipart\_upload](#input\_days\_until\_abort\_incomplete\_multipart\_upload) | (Optional, Default:7) Number of days after which Amazon S3 aborts an incomplete multipart upload. | `number` | `7` | no |
| <a name="object_lock_retention_mode"></a> [object\_lock\_retention\_mode](#input\_object\_lock\_retention\_mode) | (Optional, Default:GOVERNANCE) Default object Lock retention mode you want to apply to objects placed in the specified bucket. Valid values: (COMPLIANCE, GOVERNANCE). | `string` | `GOVERNANCE` | no |
| <a name="object_lock_days"></a> [object\_lock\_days](#input\_object\_lock\_days) | (Optional, Required if object_lock_enabled is true and object_lock_years is not specified) Number of days that you want to specify for the default retention period. | `string` | `null` | no |
| <a name="object_lock_years"></a> [object\_lock\_years](#input\_object\_lock\_years) | (Optional, Required if object_lock_enabled is true and object_lock_days is not specified) Number of years that you want to specify for the default retention period. | `number` | `null` | no |
| <a name="index_document_suffix"></a> [index\_document\_suffix](#input\_index\_document\_suffix) | (Optional, Conflicts with redirect_all_requests_to_host_name) Suffix that is appended to a request that is for a directory on the website endpoint. | `string` | `null` | no |
| <a name="redirect_all_requests_to_host_name"></a> [redirect\_all\_requests\_to\_host\_name](#input\_redirect\_all\_requests\_to\_host\_name) | (Optional, Conflicts with index_document_suffix) Name of the host where requests are redirected. | `string` | `null` | no |
| <a name="error_document_key"></a> [error\_document\_key](#input\_error\_document\_key) | (Optional, Conflicts with redirect_all_requests_to_host_name) Object key name to use when a 4XX class error occurs. | `string` | `null` | no |
| <a name="redirect_all_request_to_protocol"></a> [redirect\_all\_request\_to\_protocol](#input\_redirect\_all\_request\_to\_protocols) | (Optional) Protocol to use when redirecting requests. The default is the protocol that is used in the original request. Valid values: (https, http, null). | `string` | `null` | no |
| <a name="enable_public_read_access"></a> [enable\_public\_read\_access](#input\_enable\_public\_read\_access) | (Optional, Default:false) Whether to enable public read access for the content of the bucket. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | Name of the bucket. |
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | ARN of the bucket. |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | Bucket domain name. |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | The bucket region-specific domain name. The bucket domain name including the region name. |
| <a name="output_bucket_hosted_zone_id"></a> [bucket\_hosted\_zone\_id](#output\_bucket\_hosted\_zone\_id) | Route 53 Hosted Zone ID for this bucket's region. |
| <a name="output_bucket_region"></a> [bucket\_region](#output\_bucket\_region) | AWS region this bucket resides in. |
| <a name="output_bucket_tags_all"></a> [bucket\_tags\_all](#output\_bucket\_tags\_all) | Map of tags assigned to the resource. |
| <a name="output_bucket_website_domain"></a> [bucket\_website\_domain](#output\_bucket\_website\_domain) | Domain of the website endpoint. This is used to create Route 53 alias records. |
| <a name="output_bucket_website_endpoint"></a> [bucket\_website\_endpoint](#output\_bucket\_website\_endpoint) | Website endpoint. |
