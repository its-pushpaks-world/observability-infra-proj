terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws"; version = "~> 5.0" }
  }
}

provider "aws" { region = "ap-south-1" }

# 1. Deploy Free Tier Network Layer
module "network" {
  source      = "git::https://github.com/its-pushpaks-world/terraform-modules.git//vpc?ref=main"
  vpc_cidr    = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"
  az          = "ap-south-1a"
}

# 2. Deploy Tomcat Server Instance
module "tomcat_node" {
  source        = "git::https://github.com/its-pushpaks-world/terraform-modules.git//ec2-instance?ref=main"
  instance_name = "free-tomcat-app"
  vpc_id        = module.network.vpc_id
  subnet_id     = module.network.subnet_id
  
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install default-jdk -y
              # Install OpenTelemetry Collector Contrib
              wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.98.0/otelcol-contrib_0.98.0_linux_amd64.deb
              sudo dpkg -i otelcol-contrib_0.98.0_linux_amd64.deb
              EOF
}

# 3. Deploy Observability Engine (Replaces expensive EKS)
module "observability_hub" {
  source        = "git::https://github.com/its-pushpaks-world/terraform-modules.git//ec2-instance?ref=main"
  instance_name = "free-observability-hub"
  vpc_id        = module.network.vpc_id
  subnet_id     = module.network.subnet_id

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              # Install Docker and Docker Compose
              sudo apt-get install docker.io docker-compose -y
              sudo systemctl start docker
              sudo systemctl enable docker
              EOF
}

output "tomcat_public_ip" { value = module.tomcat_node.public_ip }
output "observability_hub_public_ip" { value = module.observability_hub.public_ip }
output "observability_hub_private_ip" { value = module.observability_hub.private_ip }
