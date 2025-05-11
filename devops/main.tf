terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "stage_key" {
  key_name = "recipe10-key"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "ssh_web" {
  name = "recipe10-sg"
  description = "Allow ssh and http access"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

resource "aws_instance" "recipe10_stage_ec2" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = aws_key_pair.stage_key.key_name
  security_groups = [aws_security_group.ssh_web.name]

  tags = {
    Name = "recipe10-stage-ec2"
  }

  provisioner "remote-exec" {
    on_failure = continue

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file(var.private_key_path)
      host = self.public_ip
    }

    inline = [
      "echo 'Updating OS and installing dependencies...'",
      "sudo yum update -y",
      "sudo yum install -y git curl",
      "echo 'Installing docker...'",
      "sudo amazon-linux-extras enable docker",
      "sudo yum install -y docker",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -aG docker ec2-user",
      "echo 'Done installing docker. Rebooting now...'",
      "sudo reboot || true"
    ]
  }
}
 
resource "null_resource" "post_reboot_provision" {
  depends_on = [aws_instance.recipe10_stage_ec2]

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file(var.private_key_path)
      host = aws_instance.recipe10_stage_ec2.public_ip
    }

    inline = [
      "echo 'Waiting 50 seconds for EC2 to finish rebooting...'",
      "sleep 50",
      "echo 'Installing Docker compose command...'",
      "mkdir -p ~/.docker/cli-plugins/",
      "curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose",
      "chmod +x ~/.docker/cli-plugins/docker-compose",
      "docker compose version",
      "echo 'Cloning the repo...'",
      "cd ~",
      "if [ -d recipe10 ]; then cd recipe10 && git pull; else git clone ${var.repo_url} recipe10 && cd recipe10; fi",
      "echo 'Running docker compose...'",
      "docker compose version",
      "docker compose -f devops/stage/docker-compose.yml up -d",
      "echo \"Done running. Your website should be accessible at http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):3000\""
    ]
  }
}