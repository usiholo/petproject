# aws region
variable "aws_region" {
  description = "This is the aws region"
}

# Project profile
variable "project_profile" {
  description = "project profile to be used"
}

# vpc cidr block
variable "vpc_cidr" {
  description = "This is our vpc" 
}


# public subnet-1 cidr block
variable "public_subnet1_cidr" {
  description = "public subnet 1 cidr block"
}

# availability zone 1
variable "az1" {
  description = "availability zone 1"
}

# public subnet-2 cidr block
variable "public_subnet2_cidr" {
  description = "public subnet 2 cidr block"
}

# availability zone 2
variable "az2" {
  description = "availability zone 2"
}

# private subnet-1 cidr block
variable "private_subnet1_cidr" {
  description = "private subnet 1 cidr block"
}

# private subnet-2 cidr block
variable "private_subnet2_cidr" {
  description = "private subnet 2 cidr block"
}

# all traffic cidr
variable "RT_cidr" {
  description = "all traffic access cidr block"
}

# all traffic from private subnet to rds security group 
variable "RT_cidr2" {
  description = "all traffic from private subnet to rds security group"
}

# ssh port access
variable "port_ssh" {
  description = "ssh port access"
}

# proxy port for Jenkins and Docker 
variable "port_proxy" {
  description = "port access for Jenkins and Docker server"
}

# http port access
variable "port_http" {
  description = "http port access"
}

# https port access
variable "port_https" {
  description = "https port access"
}

# sonarqube port access
variable "port_sonar" {
  description = "sonarqube server port access"
}

# nexus port access
variable "port_proxy_nex" {
  description = "nexus server port access"
}

# Mysql port access
variable "port_mysql" {
  description = "MySQL RDS port access"
}

# key pair name
variable "key_name" {
  description = "keypair name for the project"
}

# key pair path
variable "keypair_path" {
  description = "file path to locate the keypair"
}

# private key pair path
variable "private_keypair_path" {
  description = "file path to locate the private keypair"
}

# variable "private_subnet2_cidr" {
#   default = "10.0.4.0/24"
#   }

  variable "instance_type" {
    default = "t2.micro"
  }

  variable "ami" {
    default = "ami-0f4447ed9b385bedf"
  }

  variable "ami2" {
    default = "ami-05b457b541faec0ca"
  }

  variable "instance_type2" {
    default = "t2.medium"
  }

  #Database name
  variable "db_name"{
    description = "database name"
  }

  #Database Engine
  variable "db_engine" {
    description = "MySQL engine"
  }

  #Database Version
  variable "engine_version" {
    description = "Database Version"
  }
#database Storage type
variable "storage_type" {
  default = "gp2"
}

#database Instance type
variable "instance_class" {
  default = "db.t3.micro"
}
#database username
variable "db_username" {
  description = " database username"
}
#database password
variable "db_password" {
  description = "database password"  
}
#database parameter group name
variable "parameter_grp_name" {
  description = "parameter GRP name"
}

#database subnet group name
variable "db_subnet_grp_name" {
  description = "Database subnet group name"
}

#database subnet identifier
variable "identifier" {
  description = "Database identifier"
}

variable "newrelicfile" {
  description = "Path to newRelic file"
}