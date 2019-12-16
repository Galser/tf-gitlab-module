# Module that deploys AWS instance and provision GitLab 
# With let's encrypt SSL 
# Require AMazon provider defined + some RS SSH key


resource "aws_instance" "gitlab" {
  count                  = var.max_servers
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_groups
  key_name               = var.key_name

  connection {
    user        = "ubuntu"
    type        = "ssh"
    private_key = file("${var.key_path}")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/provision.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash",
      # "sudo EXTERNAL_URL=\"https://${var.external_url}\" apt-get install gitlab-ee",
      "sudo apt-get install -y gitlab-ee"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 3",
      "sudo gitlab-ctl reconfigure"
    ]
  }
    
  tags = {
    "Name"      = "${var.name} ${count.index} / ${var.max_servers}",
    "andriitag" = "true",
  }
}

