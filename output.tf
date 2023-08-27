# nexus server public ip
output "nexus_server_ip" {
 value = aws_instance.Nexus-server.public_ip
}

# Ansible server public ip
output "ansible_server_ip" {
 value = aws_instance.Ansible_Host.public_ip
}

# docker server public ip
output "docker_server_ip" {
 value = aws_instance.Docker-server.private_ip
}

# sonaque server public ip
output "sonaque_server_ip" {
 value = aws_instance.sonarqube-server.public_ip
}

# jenkins server public ip
output "jenkins_server_ip" {
 value = aws_instance.jenkins-server.public_ip
}

output "docker-dns" {
 value = aws_lb.alb.dns_name
}