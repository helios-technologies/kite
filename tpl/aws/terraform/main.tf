# Specify the provider and access details
provider "aws" {
  region = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

resource "aws_key_pair" "platform_key" {
  key_name   = "${var.keypair_name}"
  public_key = "${file("${var.public_key}")}"
}

resource "aws_instance" "bastion" {
  ami = "${lookup(var.aws_amis, var.region)}"
  instance_type = "t2.small"
  key_name = "${var.keypair_name}"

  vpc_security_group_ids = ["${aws_security_group.bastion_sg.id}"]
  subnet_id = "${var.public_subnet_id != "" ? var.public_subnet_id : join(" ", aws_subnet.platform_dmz.*.id)}"

  associate_public_ip_address = true

  tags {
    Name = "bastion"
  }

  connection {
    user = "ubuntu"
    private_key = "${file(var.private_key)}"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -fsSL get.docker.com | sh"
    ]
  }
}
