packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ubuntu-noble-crio-aws"
  instance_type = "t3.small"
  region        = "eu-north-1"
  source_ami    = "ami-075449515af5df0d1"
  ssh_username  = "ubuntu"
}

build {
  name = "ubuntu-noble"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = ["curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg"]
  }

  provisioner "file" {
    source      = "crio.list"
    destination = "/tmp/crio.list"
  }

  provisioner "shell" {
    inline = ["sudo mv /tmp/crio.list /etc/apt/sources.list.d/crio.list"]
  }

  provisioner "shell" {
    inline = ["sudo apt-get update", "sudo apt-get -y install cri-o"]
  }

  provisioner "shell" {
    inline = ["sudo systemctl enable crio"]
  }
}