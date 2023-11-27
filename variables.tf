variable "bucket" {
  default     = null
  type        = string
  description = "(Optional, Forces new resource) The name of the bucket to create. If omitted, Terraform will assign a random, unique name."

  validation {
    condition     = var.bucket == null ? true : length(var.bucket) >= 3 && length(var.bucket) <= 63
    error_message = "Bucket names must be between 3 (min) and 63 (max) characters long."
  }

  validation {
    condition     = var.bucket == null ? true : can(regex("^[a-z0-9.-]*$", var.bucket))
    error_message = "Bucket names can consist only of lowercase letters, numbers, dots (.), and hyphens (-)."
  }

  validation {
    condition     = var.bucket == null ? true : can(regex("^[a-z0-9].*[a-z0-9]$", var.bucket))
    error_message = "Bucket names must begin and end with a letter or number."
  }

  validation {
    condition     = !can(regex(".*[.][.].*", var.bucket))
    error_message = "Bucket names must not contain two adjacent periods."
  }

  # Whilst this regex is not accurate for an IP validation, AWS disallows strings that LOOK like IP addresses, such as: 900.102.1.888
  validation {
    condition     = !can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.bucket))
    error_message = "Bucket names must not be formatted as an IP address (for example, 192.168.5.4)."
  }

  validation {
    condition     = var.bucket == null ? true : !startswith(var.bucket, "xn--")
    error_message = "Bucket names must not start with the prefix xn--."
  }

  validation {
    condition     = var.bucket == null ? true : !startswith(var.bucket, "sthree-")
    error_message = "Bucket names must not start with the prefix sthree-."
  }

  validation {
    condition     = var.bucket == null ? true : !endswith(var.bucket, "-s3alias")
    error_message = "Bucket names must not end with the suffix -s3alias. This suffix is reserved for access point alias names. For more information, see Using a bucket-style alias for your S3 bucket access point (https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-points-alias.html)."
  }

  validation {
    condition     = var.bucket == null ? true : !endswith(var.bucket, "--ol-s3")
    error_message = "Bucket names must not end with the suffix --ol-s3. This suffix is reserved for Object Lambda Access Point alias names. For more information, see How to use a bucket-style alias for your S3 bucket Object Lambda Access Point (https://docs.aws.amazon.com/AmazonS3/latest/userguide/olap-use.html#ol-access-points-alias)."
  }
}

variable "bucket_prefix" {
  default     = null
  type        = string
  description = "(Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket."

  validation {
    condition     = var.bucket_prefix == null ? true : length(var.bucket_prefix) <= 37
    error_message = "Bucket prefix names must be less than or equal to 37 characters long."
  }

  validation {
    condition     = var.bucket_prefix == null ? true : can(regex("^[a-z0-9.-]*$", var.bucket_prefix))
    error_message = "Bucket prefix names can consist only of lowercase letters, numbers, dots (.), and hyphens (-)."
  }

  validation {
    condition     = var.bucket_prefix == null ? true : can(regex("^[a-z0-9]", var.bucket_prefix))
    error_message = "Bucket prefix names must begin with a letter or number."
  }

  validation {
    condition     = !can(regex(".*[.][.].*", var.bucket_prefix))
    error_message = "Bucket prefix names must not contain two adjacent periods."
  }

  # Whilst this regex is not accurate for an IP validation, AWS disallows strings that LOOK like IP addresses, such as: 900.102.1.888
  validation {
    condition     = !can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.bucket_prefix))
    error_message = "Bucket prefix names must not be formatted as an IP address (for example, 192.168.5.4)."
  }

  validation {
    condition     = var.bucket_prefix == null ? true : !startswith(var.bucket_prefix, "xn--")
    error_message = "Bucket prefix names must not start with the prefix xn--."
  }

  validation {
    condition     = var.bucket_prefix == null ? true : !startswith(var.bucket_prefix, "sthree-")
    error_message = "Bucket prefix names must not start with the prefix sthree-."
  }
}

variable "force_destroy" {
  default     = false
  type        = bool
  description = "(Optional, Default:false) Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. These objects are not recoverable. This only deletes objects when the bucket is destroyed, not when setting this parameter to true. Once this parameter is set to true, there must be a successful terraform apply run before a destroy is required to update this value in the resource state. Without a successful terraform apply after this parameter is set, this flag will have no effect. If setting this field in the same operation that would require replacing the bucket or destroying the bucket, this flag will not work. Additionally when importing a bucket, a successful terraform apply is required to set this value in state before it will take effect on a destroy operation."
}

variable "object_lock_enabled" {
  default     = false
  type        = bool
  description = "(Optional, Default:false, Forces new resource) Indicates whether this bucket has an Object Lock configuration enabled."
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "(Optional) Map of tags to assign to the bucket. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."

  validation {
    condition     = alltrue([for obj in keys(var.tags) : !startswith(obj, "aws:")])
    error_message = "System created tags that begin with aws: are reserved for AWS use."
  }

  validation {
    condition     = alltrue([for obj in keys(var.tags) : length(obj) >= 1 && length(obj) <= 128])
    error_message = "Tag keys must be between 1 (min) and 128 (max) characters long."
  }

  validation {
    condition     = alltrue([for obj in values(var.tags) : length(obj) <= 256])
    error_message = "Tag values must be less than 256 characters long."
  }
}

variable "block_public_acls" {
  default     = true
  type        = bool
  description = "(Optional, Default:true) Whether Amazon S3 should block public ACLs for this bucket."
}

variable "block_public_policy" {
  default     = true
  type        = bool
  description = "(Optional, Default:true) Whether Amazon S3 should block public bucket policies for this bucket."
}

variable "ignore_public_acls" {
  default     = true
  type        = bool
  description = "(Optional, Default:true) Whether Amazon S3 should ignore public ACLs for this bucket."
}

variable "restrict_public_buckets" {
  default     = true
  type        = bool
  description = "(Optional, Default:true) Whether Amazon S3 should restrict public bucket policies for this bucket."
}

variable "enforce_encryption_in_transit" {
  default     = true
  type        = bool
  description = "(Optional, Default:true) Whether to enforce encryption for data in transit."
}

variable "minimum_tls_version" {
  default     = "1.3"
  type        = string
  description = "(Optional, Default:1.3) The minimum version of TLS to allow connectivity over."

  validation {
    condition     = contains(["1.0", "1.1", "1.2", "1.3"], var.minimum_tls_version)
    error_message = "Valid TLS versions are: (1.0, 1.1, 1.2, 1.3)."
  }
}

variable "enable_encryption_at_rest" {
  default     = true
  type        = bool
  description = "(Optional, Default:true) Whether to enable encryption for data at rest."
}

variable "expected_bucket_owner" {
  default     = null
  type        = string
  description = "(Optional, Forces new resource) Account ID of the expected bucket owner."

  validation {
    condition     = var.expected_bucket_owner == null ? true : can(regex("^[0-9]{12}$", var.expected_bucket_owner))
    error_message = "Account Id must be exactly twelve digits."
  }
}

variable "bucket_key_enabled" {
  default     = true
  type        = bool
  description = "(Optional, Default:true) Whether or not to use Amazon S3 Bucket Keys for SSE-KMS."
}

variable "sse_algorithm" {
  default     = "AES256"
  type        = string
  description = "(Optional, Default:AES256) Server-side encryption algorithm to use."

  validation {
    condition     = contains(["AES256", "aws:kms", "aws:kms:dsse"], var.sse_algorithm)
    error_message = "Valid encryption algorithms are: (AES256, aws:kms, aws:kms:dsse)."
  }
}

variable "kms_master_key_id" {
  default     = null
  type        = string
  description = "(Optional) AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms."
}

variable "object_ownership" {
  default     = "BucketOwnerEnforced"
  type        = string
  description = "(Optional, Default:BucketOwnerEnforced) Object ownership."

  validation {
    condition     = contains(["BucketOwnerPreferred", "ObjectWriter", "BucketOwnerEnforced"], var.object_ownership)
    error_message = "Valid object ownership policies are: (BucketOwnerPreferred, ObjectWriter, BucketOwnerEnforced)."
  }
}

variable "enable_versioning" {
  default     = true
  type        = bool
  description = "(Optional, Default:true) Whether to enabled object versioning."
}

variable "versioning_status" {
  default     = "Enabled"
  type        = string
  description = "(Optional, Default:Enabled) Versioning state of the bucket. Valid values: Enabled, Suspended, or Disabled. Disabled should only be used when creating or importing resources that correspond to unversioned S3 buckets."

  validation {
    condition     = contains(["Enabled", "Suspended", "Disabled"], var.versioning_status)
    error_message = "Valid object ownership policies are: (Enabled, Suspended, Disabled)."
  }
}

variable "days_until_abort_incomplete_multipart_upload" {
  default     = 7
  type        = number
  description = "(Optional, Default:7) Number of days after which Amazon S3 aborts an incomplete multipart upload."
}
