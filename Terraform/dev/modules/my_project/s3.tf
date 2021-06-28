resource "aws_iam_instance_profile" "profile" {
  name = "terraform_instance_profile"
  role = aws_iam_role.s3_access_role.name
}