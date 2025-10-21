resource "aws_instance" "nginxserver" {
  ami                         = "ami-02d26659fd82cf299"
  instance_type               = "t3.nano"
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.nginx-sg.id]
  associate_public_ip_address = true
  # key_name                   = "your-key-pair-name"  # Uncomment and add your key pair name

  user_data = <<-EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
EOF

  tags = {
    Name = "NginxServer"
  }
}