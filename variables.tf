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

  validation {
    condition     = !can(cidrnetmask("${var.bucket}/32"))
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
}
