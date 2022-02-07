module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["aws_workspaces_workspace.create-ws.workspace_id"])

  name = "aws_workspaces_workspace.create-ws.user_name-${each.key}"

  ami                    = "ami-ebd02392"
  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"
  user_data              = "./userdata-docker"

  tags = {
    Workspace = "aws_workspaces_workspace.create-ws.workspace_id"
  }
}