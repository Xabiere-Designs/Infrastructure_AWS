module "ec2_instance" {
  source  = "./modules/ec2"

  for_each = toset(["one", "two"])

  name = "instance-${each.key}"

  instance_type = var.instance_type
  key_name      = var.key_name
  ami           = var.ami_id
  subnet_id     = var.subnet_id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}