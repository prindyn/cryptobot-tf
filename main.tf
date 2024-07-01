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

resource "aws_vpc" "dev" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "dev-vpc"
    }
}

resource "aws_subnet" "dev_subnet" {
    vpc_id     = aws_vpc.dev.id
    cidr_block = "10.0.1.0/24"

    tags = {
        Name = "dev-subnet"
    }
}

resource "aws_instance" "web" {
    ami           = data.aws_ami.app_ami.id
    instance_type = "t3.nano"
    subnet_id     = aws_subnet.dev_subnet.id

    tags = {
        Name = "CryptoBot"
    }
}