resource "aws_instance" "blog" {
    ami                    = data.aws_ami.app_ami.id
    instance_type          = var.instance_type
    subnet_id              = module.dev_vpc.public_subnets[0]
    vpc_security_group_ids = [module.blog_sg.security_group_id]

    associate_public_ip_address = true

    tags = {
        Name = "Learning Terraform"
    }
}