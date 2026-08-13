locals {
  ami_ids = {
    ubuntu = data.aws_ami.ubuntu.id
    nginx  = data.aws_ami.ubuntu.id
  }

  nginx_user_data = <<-EOF
    #!/bin/bash
    set -eux
    apt-get update
    apt-get install -y nginx
    systemctl enable --now nginx
  EOF
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Owner is Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Commented out because of last lesson in this section
# resource "aws_instance" "from_count" {
#   count         = var.ec2_instance_count
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t3.micro"
#   subnet_id     = aws_subnet.main[count.index % length(aws_subnet.main)].id

#   tags = {
#     Name    = "${local.project}-${count.index}"
#     Project = local.project
#   }
# }

resource "aws_instance" "from_list" {
  count         = length(var.ec2_instance_config_list)
  ami           = local.ami_ids[var.ec2_instance_config_list[count.index].ami]
  instance_type = var.ec2_instance_config_list[count.index].instance_type
  subnet_id     = aws_subnet.main["default"].id
  # user_data     = var.ec2_instance_config_list[count.index].ami == "nginx" ? local.nginx_user_data : null

  tags = {
    Name    = "${local.project}-${count.index}"
    Project = local.project
  }
}

resource "aws_instance" "from_map" {
  # each.key => holds key of the map
  for_each      = var.ec2_instance_config_map
  ami           = local.ami_ids[each.value.ami]
  instance_type = each.value.instance_type
  subnet_id     = aws_subnet.main[each.value.subnet_name].id
  user_data     = each.value.ami == "nginx" ? local.nginx_user_data : null

  tags = {
    Name    = "${local.project}-${each.key}"
    Project = local.project
  }
}
