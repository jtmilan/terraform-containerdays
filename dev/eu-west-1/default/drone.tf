### First part
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

### Second part

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
    payload = "AQICAHj9KV3Z/210SeUw0IIViLtnqJ7qYUZ5R0pURVFs0GMNCQHiQWUSabftbhGH7ZEkMLEMAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDB2C+8nNbEQXL/pbQwIBEIBD4UUX9gQh3OLulGQeoVP7GwcAKwSAwuQHknKTvqfpjvPBT0mQtwztzMUXXyoZX+dSChJllMC2EF+BsNhnoKrN+7zfBA=="

    context = {
        foo = "bar"
    }    
  }

  secret {
    name    = "trusted_account_arn"
    payload = "AQICAHj9KV3Z/210SeUw0IIViLtnqJ7qYUZ5R0pURVFs0GMNCQFBl2oqdKxvauivPp3YBA0gAAAAhTCBggYJKoZIhvcNAQcGoHUwcwIBADBuBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDN7PZ7LYAntbC7qX/wIBEIBBfa/R+zIXwbJwRQU7sLwAKovIaxHuINZP1JbUbFGsEDHJ5zFEOcjflUyrX2L7KkJowHqAEVuOs9o5eOKMG9dNIAg="

    context = {
      foo = "bar"
    }    
  }
}

resource "aws_iam_role_policy_attachment" "policy_attchment_drone" {
  role       = aws_iam_role.role_drone.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
