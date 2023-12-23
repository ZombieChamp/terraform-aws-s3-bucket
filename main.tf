locals {
  expected_bucket_owner = var.expected_bucket_owner == null ? data.aws_caller_identity.current.account_id : var.expected_bucket_owner
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "this" {
  bucket              = var.bucket
  bucket_prefix       = var.bucket_prefix
  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled
  tags                = var.tags
}

resource "aws_s3_bucket_public_access_block" "this" {
  count = var.enable_public_read_access ? 0 : 1

  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

data "aws_iam_policy_document" "encryption_in_transit" {
  statement {
    sid       = "EnforceEncryptionInTransit"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }

    condition {
      test     = "NumericLessThan"
      variable = "s3:TlsVersion"
      values   = [var.minimum_tls_version]
    }
  }
}

data "aws_iam_policy_document" "public_read_access" {
  statement {
    sid       = "PublicReadGetObject"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

data "aws_iam_policy_document" "combined_bucket_policy" {
  source_policy_documents = [
    var.enforce_encryption_in_transit ? data.aws_iam_policy_document.encryption_in_transit.json : "",
    var.enable_public_read_access ? data.aws_iam_policy_document.public_read_access.json : "",
  ]
}

resource "aws_s3_bucket_policy" "this" {
  count = var.enforce_encryption_in_transit || var.enable_public_read_access ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.combined_bucket_policy.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = var.enable_encryption_at_rest ? 1 : 0

  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = local.expected_bucket_owner

  rule {
    bucket_key_enabled = var.bucket_key_enabled

    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.kms_master_key_id
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_versioning" "this" {
  count = var.enable_versioning ? 1 : 0

  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = local.expected_bucket_owner
  mfa                   = null # TODO: Find a better way of managing MFA enablement for object deletion. The issue is that the root account needs to apply it, however this is against good practice to store and use root AWS keys.

  versioning_configuration {
    status     = var.versioning_status
    mfa_delete = null # TODO: Find a better way of managing MFA enablement for object deletion. The issue is that the root account needs to apply it, however this is against good practice to store and use root AWS keys.
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = var.enable_versioning ? 1 : 0

  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = local.expected_bucket_owner

  rule {
    id     = "AbortIncompleteMultipartUploads"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = var.days_until_abort_incomplete_multipart_upload
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "this" {
  count = var.object_lock_enabled ? 1 : 0

  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = local.expected_bucket_owner

  rule {
    default_retention {
      mode  = var.object_lock_retention_mode
      days  = var.object_lock_days
      years = var.object_lock_days
    }
  }
}

resource "aws_s3_bucket_website_configuration" "this" {
  count = var.index_document_suffix != null || var.redirect_all_requests_to_host_name  != null ? 1 : 0

  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = local.expected_bucket_owner

  dynamic "error_document" {
    for_each = var.error_document_key == null ? [] : [1]

    content {
      key = var.error_document_key
    }
  }

  dynamic "index_document" {
    for_each = var.index_document_suffix == null ? [] : [1]

    content {
      suffix = var.index_document_suffix
    }
  }

  dynamic "redirect_all_requests_to" {
    for_each = var.redirect_all_requests_to_host_name == null ? [] : [1]

    content {
      host_name = var.redirect_all_requests_to_host_name
      protocol  = var.redirect_all_request_to_protocol
    }
  }
}
