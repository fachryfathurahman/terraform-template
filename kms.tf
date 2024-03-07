data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "cloudtrail_kms" {
  statement {
    actions = [
      "kms:*",
    ]
    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
      type = "AWS"
    }
    resources = [
      "*",
    ]
    sid = "Enable IAM User Permissions"
  }

  statement {
    actions = [
      "kms:GenerateDataKey*",
    ]
    condition {
      test = "StringLike"
      values = [
        "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*",
      ]
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
    }
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
      type = "Service"
    }
    resources = [
      "*",
    ]
    sid = "Allow CloudTrail to encrypt logs"
  }

  statement {
    actions = [
      "kms:DescribeKey",
    ]
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
      type = "Service"
    }
    resources = [
      "*",
    ]
    sid = "Allow CloudTrail to describe key"
  }
}

resource "aws_kms_key" "kms_key" {
  description         = "KMS key 1"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.cloudtrail_kms.json
}

resource "aws_kms_alias" "alias_key" {
  name          = "alias/${var.alias_key}"
  target_key_id = aws_kms_key.kms_key.key_id
}