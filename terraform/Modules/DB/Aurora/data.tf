data "aws_secretsmanager_secret" "db_credentials" {
  name = var.db_secret_name
}

data "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}

locals {
  db_creds = jsondecode(trimspace(data.aws_secretsmanager_secret_version.db_credentials_version.secret_string))
}
