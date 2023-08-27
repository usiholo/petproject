# Create Custom VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${local.name}-vpc"
  }
}

# Creating public subnet 1
resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet1_cidr
  availability_zone = var.az1
  tags = {
    Name = "${local.name}-Public subnet1"
  }
}

# Creating public subnet 2
resource "aws_subnet" "public-subnet-2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet2_cidr
  availability_zone = var.az2
  tags = {
    Name = "${local.name}-Public subnet2"
  }
}

# Creating private subnet 1
resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = var.az1
  tags = {
    Name = "${local.name}-Private subnet1"
  }
}

# Creating private subnet 2
resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = var.az2
  tags = {
    Name = "${local.name}-Private subnet2"
  }
}

# Creating internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.name}-igw"
  }
}

# Security Group for Bastion Host and Ansible Server
resource "aws_security_group" "Bastion-Ansible_SG" {
  name        = "${local.name}-Bastion-Ansible"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.port_ssh
    to_port          = var.port_ssh
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.RT_cidr]
  }

  tags = {
    Name = "${local.name}-Bastion-Ansible-SG"
  }
}

# Security Group for Docker Server
resource "aws_security_group" "Docker_SG" {
  name        = "${local.name}-Docker"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.port_ssh
    to_port          = var.port_ssh
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  ingress {
    description      = "Allow proxy access"
    from_port        = var.port_proxy
    to_port          = var.port_proxy
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  ingress {
    description      = "Allow http access"
    from_port        = var.port_http
    to_port          = var.port_http
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  ingress {
    description      = "Allow https access"
    from_port        = var.port_https
    to_port          = var.port_https
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.RT_cidr]
  }

  tags = {
    Name = "${local.name}-Docker-SG"
  }
}

# Security Group for Jenkins Server
resource "aws_security_group" "Jenkins_SG" {
  name        = "${local.name}-Jenkins"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.port_ssh
    to_port          = var.port_ssh
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  ingress {
    description      = "Allow proxy access"
    from_port        = var.port_proxy
    to_port          = var.port_proxy
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.RT_cidr]
  }

  tags = {
    Name = "${local.name}-Jenkins-SG"
  }
}

# Security Group for Sonarqube Server
resource "aws_security_group" "Sonarqube_SG" {
  name        = "${local.name}-Sonarqube"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.port_ssh
    to_port          = var.port_ssh
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  ingress {
    description      = "Allow sonarqube access"
    from_port        = var.port_sonar
    to_port          = var.port_sonar
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.RT_cidr]
  }

  tags = {
    Name = "${local.name}-Sonarqube-SG"
  }
}

# Security Group for Nexus Server
resource "aws_security_group" "Nexus_SG" {
  name        = "${local.name}-Nexus"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.port_ssh
    to_port          = var.port_ssh
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  ingress {
    description      = "Allow nexus access"
    from_port        = var.port_proxy_nex
    to_port          = var.port_proxy_nex
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.RT_cidr]
  }

  tags = {
    Name = "${local.name}-Nexus-SG"
  }
}

# Security Group for MySQL RDS Database
resource "aws_security_group" "MySQL_RDS_SG" {
  name        = "${local.name}-MySQL-RDS"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allow MySQL access"
    from_port        = var.port_mysql
    to_port          = var.port_mysql
    protocol         = "tcp"
    cidr_blocks      = var.RT_cidr2
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.RT_cidr]
  }

  tags = {
    Name = "${local.name}-MySQL-SG"
  }
}

# keypair
resource "aws_key_pair" "pacpujpeu2_keypair" {
  key_name   = var.key_name
  public_key = file(var.keypair_path)
}

#elastic IP
resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.igw]
  vpc      = true
}

# create the NAT Gateway
resource "aws_nat_gateway" "NATGW" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public-subnet-2.id

  tags = {
    Name = "${local.name}-NATGW"
  }
}

#create public route table
resource "aws_route_table" "PubRT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.RT_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${local.name}-PubRT"
  }
}

#create private route table
resource "aws_route_table" "PrvtRT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.RT_cidr
    gateway_id = aws_nat_gateway.NATGW.id
  }

  tags = {
    Name = "${local.name}-PrvtRT"
  }
}

#create public_subnet_1_association
resource "aws_route_table_association" "public-subnet-1-Ass" {
  route_table_id = aws_route_table.PubRT.id
  subnet_id = aws_subnet.public-subnet-1.id
}

#create public_subnet_2_association
resource "aws_route_table_association" "public-subnet-2-Ass" {
  route_table_id = aws_route_table.PubRT.id
  subnet_id = aws_subnet.public-subnet-2.id
}

#create private_subnet_1_association
resource "aws_route_table_association" "private-subnet-1-Ass" {
  route_table_id = aws_route_table.PrvtRT.id
  subnet_id = aws_subnet.private-subnet-1.id
}

#create private_subnet_2_association
resource "aws_route_table_association" "private-subnet-2-Ass" {
  route_table_id = aws_route_table.PrvtRT.id
  subnet_id = aws_subnet.private-subnet-2.id
}

# creating Bastian Host for ec2 instance target servers
resource "aws_instance" "Bastion-Host" {
  ami                       = var.ami
  vpc_security_group_ids    = [aws_security_group.Bastion-Ansible_SG.id]
  instance_type             = var.instance_type
  key_name                  = aws_key_pair.pacpujpeu2_keypair.key_name
  subnet_id                 =  aws_subnet.public-subnet-1.id
  associate_public_ip_address = true
  user_data                 = <<-EOF
  #!/bin/bash
  echo "${var.private_keypair_path}" >> /home/ec2-user/pacpujpeu2 
  chmod 400 pacpujpeu2
  sudo hostnamectl set-hostname Bastion
  EOF 
  tags = {
    Name = "${local.name}-Bastion-Host"
  }
}

# creating nexus server for ec2 instance target servers
resource "aws_instance" "Nexus-server" {
  ami                       = var.ami
  vpc_security_group_ids    = [aws_security_group.Nexus_SG.id]
  instance_type             = var.instance_type2
  key_name                  = aws_key_pair.pacpujpeu2_keypair.key_name
  subnet_id                 =  aws_subnet.public-subnet-1.id
  associate_public_ip_address = true
  user_data = local.nexus_user_data

  tags = {
    Name = "${local.name}-Nexus"
  }
}

# creating jenkins server for ec2 instance target servers
resource "aws_instance" "jenkins-server" {
  ami                       = var.ami
  vpc_security_group_ids    = [aws_security_group.Jenkins_SG.id]
  instance_type             = var.instance_type2
  key_name                  = aws_key_pair.pacpujpeu2_keypair.key_name
  subnet_id                 =  aws_subnet.public-subnet-1.id
  associate_public_ip_address = true
  user_data = local.jenkins_user_data

  tags = {
    Name = "${local.name}-jenkins"
  }
}

# creating sonarqube server for ec2 instance target servers
resource "aws_instance" "sonarqube-server" {
  ami                       = var.ami2
  vpc_security_group_ids    = [aws_security_group.Sonarqube_SG.id]
  instance_type             = var.instance_type2
  key_name                  = aws_key_pair.pacpujpeu2_keypair.key_name
  subnet_id                 =  aws_subnet.public-subnet-2.id
  associate_public_ip_address = true
  user_data = local.sonarqube_user_data

  tags = {
    Name = "${local.name}-sonarqube"
  }
}
# creating Ec2 for Ansible Server
resource "aws_instance" "Ansible_Host" {
  ami                         = var.ami 
  instance_type                = var.instance_type
  vpc_security_group_ids      = [aws_security_group.Bastion-Ansible_SG.id]
  key_name                    = aws_key_pair.pacpujpeu2_keypair.key_name 
  subnet_id                   = aws_subnet.public-subnet-2.id
  associate_public_ip_address = true 
  user_data                   = local.ansible_user_data 
  tags = {
    Name = "${local.name}-Ansible-Server"
  }
}

# creating Docker server for ec2 instance target servers
resource "aws_instance" "Docker-server" {
  ami                       = var.ami
  vpc_security_group_ids    = [aws_security_group.Docker_SG.id]
  instance_type             = var.instance_type2
  key_name                  = aws_key_pair.pacpujpeu2_keypair.key_name
  subnet_id                 =  aws_subnet.private-subnet-1.id
  user_data = local.docker_user_data

  tags = {
    Name = "${local.name}-Docker"
  }
}

#Creating Database Subnet Group
resource "aws_db_subnet_group" "PACPUJEU2-DB-Subnet" {
  name                  = var.db_subnet_grp_name
  subnet_ids            = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
  tags = {
    name                = "${local.name}-DB-subnet"
  }  
}

#MySQL RDS database
resource "aws_db_instance" "PACPUJEU2-DB"{
  identifier             = var.identifier
  db_subnet_group_name   = aws_db_subnet_group.PACPUJEU2-DB-Subnet.name
  vpc_security_group_ids = [aws_security_group.MySQL_RDS_SG.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
  allocated_storage      = 10
  db_name                = var.db_name
  engine                 = var.db_engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = var.parameter_grp_name
  multi_az               = true
  storage_type           = var.storage_type
}

#Created route 53 zone
data "aws_route53_zone" "rt53_zone" {
  name         = "thinkeod.com"
  private_zone = false
}

#Create route 53 record 
resource "aws_route53_record" "thinkeod" {
  zone_id = data.aws_route53_zone.rt53_zone.zone_id
  name    = "thinkeod.com"
  type    = "A"
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

# create ACM certificate
resource "aws_acm_certificate" "acm_certificate" {
  domain_name       = "thinkeod.com"
  # subject_alternative_names = ["*.thinkeod.com"]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

#create route53 validation record
resource "aws_route53_record" "validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.rt53_zone.zone_id
}

#create acm certificate validition
resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_record : record.fqdn]
}

# Created Application Load balancer
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Docker_SG.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
  enable_deletion_protection = false
  tags = {
  Name = "${local.name}-alb"  
  }
}
  
# Creating Load balancer Listener for http
resource "aws_lb_listener" "pacpujpeu2_lb_listener" {
  load_balancer_arn      = aws_lb.alb.arn
  port                   = "80"
  protocol               = "HTTP"
  default_action {
    type                 = "forward"
    target_group_arn     = aws_lb_target_group.target_group.arn
    }
  }
  
# Creating a Load balancer Listener for https access
resource "aws_lb_listener" "pacpujpeu2_lb_listener_https" {
  load_balancer_arn      = aws_lb.alb.arn
  port                   = "443"
  protocol               = "HTTPS"
  ssl_policy             = "ELBSecurityPolicy-2016-08"
  certificate_arn        = "${aws_acm_certificate.acm_certificate.arn}"
  default_action {
    type                 = "forward"
    target_group_arn     = aws_lb_target_group.target_group.arn
  }
}
  
# Create Autoscaling group
resource "aws_autoscaling_group" "asg" {
  name                      = "PACPUJEU2-asg"
  desired_capacity          = 2
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 120
  health_check_type         = "EC2"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.launch-config.name
  vpc_zone_identifier       = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
  target_group_arns         = ["${aws_lb_target_group.target_group.arn}"]
  tag {
    key                 = "Name"
    value               = "${local.name}-asg"
    propagate_at_launch = true
  }
}

# create Autoscaling group policy
resource "aws_autoscaling_policy" "PACPUJEU2-asg-pol" {
  name                   = "PACPUJEU2-asg-pol"
  policy_type            = "TargetTrackingScaling"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
} 

# Creating Target Group
resource "aws_lb_target_group" "target_group" {
  name_prefix      = "alb-tg"
  port             = "30801"
  protocol         = "HTTP"
  vpc_id           = aws_vpc.vpc.id

  health_check {
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 5
  }
}
  
#Create Target group attachment
resource "aws_lb_target_group_attachment" "target_group_attach" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.Docker-server.id
  port             = "8080"
}

#launch configuration
resource "aws_launch_configuration" "launch-config" {
  name_prefix   = "launch-config"
  image_id      =  aws_ami_from_instance.docker-ami.id
  instance_type = "t2.medium"
  security_groups = [aws_security_group.Docker_SG.id]
  key_name = aws_key_pair.pacpujpeu2_keypair.key_name
  lifecycle {
    create_before_destroy = false
  }
}

#create AMI from Instance
resource "aws_ami_from_instance" "docker-ami" {
  name                    = "ami_from_instance"
  source_instance_id      = aws_instance.Docker-server.id
  snapshot_without_reboot = true
  depends_on = [aws_instance.Docker-server, time_sleep.Docker_wait_time]
}

#Create timeout
resource "time_sleep" "Docker_wait_time" {
  depends_on = [aws_instance.Docker-server]
  create_duration = "420s"
}