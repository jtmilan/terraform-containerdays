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
    payload = "AQICAHj9wB9l7YM8LnCBcsi941HLWygM8jn4FSjv83ggZbprBwFgOk/n15jEnp5h23464N9zAAAAzjCBywYJKoZIhvcNAQcGoIG9MIG6AgEAMIG0BgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDJOBSwUJFpTrlztzwQIBEICBhu4UqpaxXPE5wnA4e6E48gb+Zd91rVfh+0F1GR4n2LRGMt+lu0LuM2BXdQi2aMRPRWaN/tg8k6C3RuW9iBqRlqLf9fBHJOGykAX5TKemHLuZINMqCGtoqboz2Kx6SU+AY7RaYf8r9l460a3QAy0UmTUdkdrvsZGEuIP7A5Tza57jTLwd8d7e"

    context = {
      foo = "bar"
    }    
  }
}

resource "aws_iam_role_policy_attachment" "policy_attchment_drone" {
  role       = aws_iam_role.role_drone.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
