variable "public_key" {}
variable "private_key" {}

variable "user_data_folder" {}
variable "s3_bucket_name" {}

variable "database_user" {}
variable "database_name" {}
variable "database_password" {}
variable "rds_instance_identifier" {
  default = "terraform-mysql"
}

variable "path_playbook" {
  type = string
}

variable "instance_type" {
  default = "t2.micro"
}
