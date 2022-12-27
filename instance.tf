
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
     for_each = [22,80,3306,27017]
     iterator = port
     content {
      description = "TLS from VPC"
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
     }  
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0574da719dca65348"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.key-tf.key_name}"  
  tags = {
    Name = "First_tf_instance"
  }
}
