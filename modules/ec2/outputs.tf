output "instance" {
  value = aws_instance.myapp-server
}

output "sg_id" {
  value = aws_security_group.myapp-sg.id
}
