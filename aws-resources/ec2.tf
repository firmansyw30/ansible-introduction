# EC2 instance as the control node for Ansible
resource "aws_instance" "instance_1" {
  ami           = "ami-012972a9e728b3b9c"
  instance_type = "t3.nano"
  associate_public_ip_address = true
  key_name      = "sample-key-pair-firman" # Create it first on console (if don't have)
  user_data = file("user_data_instance_1.sh")
  vpc_security_group_ids = [aws_security_group.control_node_sg.id]
  subnet_id = aws_subnet.main.id  # Add subnet_id

  tags = {
    Name = "Instance-1-Control-Node"
  }
}

# EC2 Instance that will be installed apache2 & for host simple html files
resource "aws_instance" "instance_2" {
  ami           = "ami-012972a9e728b3b9c"
  instance_type = "t3.nano"
  associate_public_ip_address = true
  key_name      = "sample-key-pair-firman" # Create it first on console (if don't have)
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  subnet_id = aws_subnet.main.id  # Add subnet id

  tags = {
    Name = "Instance-2-Web-Server" 
  }
}

output "instance1_ip" {
  value = aws_instance.instance_1.public_ip
}

output "instance2_ip" {
  value = aws_instance.instance_2.public_ip
}
