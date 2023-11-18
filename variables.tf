variable "bucket" {
  default     = null
  type        = string
  description = "(Optional, Forces new resource) The name of the bucket to create. If omitted, Terraform will assign a random, unique name."
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
