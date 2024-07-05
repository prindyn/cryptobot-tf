data "aws_ami" "app_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["979382823631"]
}

resource "aws_vpc" "default_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "dev-vpc"
    }
}

resource "aws_subnet" "dev_subnet" {
    vpc_id     = aws_vpc.default_vpc.id
    cidr_block = "10.0.1.0/24"

    tags = {
        Name = "dev-subnet"
    }
}

resource "aws_instance" "web" {
    ami           = data.aws_ami.app_ami.id
    instance_type = var.instance_type
    subnet_id     = aws_subnet.dev_subnet.id

    vpc_security_group_ids = [aws_security_group.web.id]

    tags = {
        Name = "CryptoBot"
    }
}

resource "aws_security_group" "web" {
    name        = "web"
    description = "Allow http and https in. Allow everything out."

    vpc_id = aws_vpc.default_vpc.id
}

resource "aws_security_group_rule" "web_http_in" {
    type        = "ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "web_https_in" {
    type        = "ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "web_out" {
    type        = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = aws_security_group.web.id
}