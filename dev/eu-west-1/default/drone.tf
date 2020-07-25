resource "aws_kms_key" "kms_drone" {
  description             = "KMS Key used to encrypt / decrypt drone secrets"
  deletion_window_in_days = 30
  key_usage               = "ENCRYPT_DECRYPT"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_alias" "kms_alias_drone" {
  name          = "alias/drone-containerdays"
  target_key_id = aws_kms_key.kms_drone.key_id
}

resource "aws_iam_role" "role_drone" {
  name               = "DroneTerraformContainerDays"
  assume_role_policy = data.aws_iam_policy_document.assume_policy_drone.json
}

data "aws_iam_policy_document" "assume_policy_drone" {
  statement {
    effect = "Allow"
    principals {
      identifiers = [
        data.aws_kms_secrets.drone.plaintext["trusted_account_arn"],
      ]
      type = "AWS"
    }
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      values   = [data.aws_kms_secrets.drone.plaintext["external_id"]]
      variable = "sts:ExternalId"
    }
  }
}

data "aws_kms_secrets" "drone" {
  secret {
    name    = "external_id"
    payload = "AQICAHj9wB9l7YM8LnCBcsi941HLWygM8jn4FSjv83ggZbprBwFN/I4DoOzgfdOXN0YBoskuAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDD+KjBrRGWVAmGa7sAIBEIBDkhghfxiyRVg3BIm+w39qd/wIaXtku9tngUh3oob/JoDCXT18Bnnk/VuUR7FyRJTnyYepJxW0m1ZoeKyFt++CmNTGlg=="

    context = {
        foo = "bar"
    }    
  }

  secret {
    name    = "trusted_account_arn"
    payload = "AQICAHj9wB9l7YM8LnCBcsi941HLWygM8jn4FSjv83ggZbprBwGbCgdjVIbzAK8ecmA8yyqNAAAAhTCBggYJKoZIhvcNAQcGoHUwcwIBADBuBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDP58mgx2kWKxGdyGRwIBEIBBgN8sbXSNkR9on9J7NzDo7Z5PoEW4fvnxk+m7v+HpDznndQk+SoXZUioXmKppU6FTJuAt1AzRczFh/WKNCDrGDcc="

    context = {
      foo = "bar"
    }    
  }
}

resource "aws_iam_role_policy_attachment" "policy_attchment_drone" {
  role       = aws_iam_role.role_drone.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
