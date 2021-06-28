resource "aws_security_group" "my_frontserver" {
  name = "WebServer Security Group"

  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = ["80", "8080", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_frontserver" {
  ami                    = "ami-05f7491af5eef733a"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_frontserver.id]
  subnet_id              = aws_subnet.public-subnet.id
  key_name               = "mykeypair-key"
  tags = {
    Name = "bastion-instance"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "echo '${file(var.private_key)}' > terraform",
      "sudo chmod 0600 terraform",
      "sudo mv terraform .ssh/",
      "echo 'Dan131296' > ~/.ansible_vault_pass"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key)
      host        = aws_instance.my_frontserver.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu -i '${aws_instance.my_frontserver.public_ip},' --private-key ${var.private_key} ${var.path_playbook}"
  }
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair-key"
  public_key = var.public_key
}