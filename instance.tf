
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

  ingress{
    description = "TLS from VPS"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    description = "TLS from VPS"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    description = "TLS from VPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    # cidr_blocks = [aws_vpc.main.cidr_block]
    cidr_blocks = ["0.0.0.0/0"]
   
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
