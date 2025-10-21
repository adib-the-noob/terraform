output "nginx_server_public_ip" {
  description = "Public IP of the Nginx server"
  value       = aws_instance.nginxserver.public_ip
}
output "instance_url" {
  description = "URL of the Nginx server"
  value       = "http://${aws_instance.nginxserver.public_ip}"
}