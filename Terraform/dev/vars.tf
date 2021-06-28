variable "access_key_id" {
  type = string
}

variable "secret_access_key" {
  type = string
}

variable "region" {
  default = "eu-central-1"
}

variable "path_playbook" {
  type = string
}
variable "public_key" {}
variable "private_key" {}

variable "user_data_folder" {}
variable "s3_bucket_name" {}

variable "database_name" {}
variable "database_user" {}
variable "database_password" {}