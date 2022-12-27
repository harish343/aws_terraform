
resource "aws_key_pair" "key-tf" {
  key_name   = "key-tf"
  public_key = file("${path.module}/id_rsa.pub")
}
output "keyname" {
  value = "${aws_key_pair.key-tf.key_name}"
}

resource "aws_security_group" "allow_tls" {
  name = "allow_tls"
  description = "Allow TLS inbound traffic"

  dynamic "ingress" {
     for_each = var.ports
     iterator = port
     content {
      description = "TLS from VPC"
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
     }  
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }
}

output securityGroupDetails {
  value = "${aws_security_group.allow_tls}"
}


resource "aws_instance" "web" {
  ami           = "${var.image_id}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.key-tf.key_name}"  
  security_groups = ["${aws_security_group.allow_tls.id}"]
  tags = {
    Name = "First_tf_instance"
  }
}
