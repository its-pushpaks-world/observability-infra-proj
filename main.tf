terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# 1. Deploy Free Tier Network Layer
module "network" {
  source      = "git::https://github.com/its-pushpaks-world/terraform-modules.git//vpc?ref=main"
  vpc_cidr    = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"
  az          = "ap-south-1a"
}

# 2. Deploy Tomcat Server Instance
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
              
              # 1. Install Tomcat 9
              sudo apt-get install tomcat9 tomcat9-admin -y
              
              # 2. Download Prometheus JMX Exporter for metrics
              sudo wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.19.0/jmx_prometheus_javaagent-0.19.0.jar -O /usr/share/tomcat9/lib/jmx_prometheus_javaagent.jar
              
              # 3. Create a basic JMX config file for Prometheus
              sudo cat <<EOT > /usr/share/tomcat9/lib/tomcat.yml
              ---
              lowercaseOutputLabelNames: true
              lowercaseOutputName: true
              rules:
              - pattern: ".*"
              EOT
              
              # 4. Bind the Java Agent to Tomcat's startup parameters (Exposes metrics on port 9404)
              echo 'JAVA_OPTS="$JAVA_OPTS -javaagent:/usr/share/tomcat9/lib/jmx_prometheus_javaagent.jar=9404:/usr/share/tomcat9/lib/tomcat.yml"' | sudo tee -a /etc/default/tomcat9
              
              # Restart Tomcat to apply the telemetry agent
              sudo systemctl restart tomcat9

              # 5. Install OpenTelemetry Collector Contrib
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

output "tomcat_public_ip" {
  value = module.tomcat_node.public_ip
}

output "observability_hub_public_ip" {
  value = module.observability_hub.public_ip
}

output "observability_hub_private_ip" {
  value = module.observability_hub.private_ip
}
