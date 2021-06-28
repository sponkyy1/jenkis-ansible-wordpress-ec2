#----------------------------------------------------
# My Terraform 
#
# Made by Yurii
#----------------------------------------------------
module "ec2_instance" {
  source            = "./modules/my_project/"
  path_playbook     = var.path_playbook
  public_key        = var.public_key
  private_key       = var.private_key
  database_password = var.database_password
  user_data_folder  = var.user_data_folder
  s3_bucket_name    = var.s3_bucket_name
  database_name     = var.database_name
  database_user     = var.database_user
}
