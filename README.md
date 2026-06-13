# Observability Infrastructure Project

Terraform-based infrastructure deployment for a complete observability platform on AWS.

## Project Overview

This repository provisions the foundational AWS infrastructure required for an end-to-end observability platform.

The deployment creates:

* AWS VPC
* Public Subnet
* Internet Gateway
* Tomcat Application Server
* Observability Hub Server
* Security Groups
* Telemetry Bootstrap Configuration

Infrastructure is provisioned using reusable Terraform modules from the terraform-modules repository.

## Architecture

```text
                    AWS Cloud
                         |
          ---------------------------------
          |                               |
   Observability Hub                Tomcat App
     EC2 Instance                  EC2 Instance
          |                               |
     Grafana/Mimir/Loki          OpenTelemetry
          |                               |
          -------- Telemetry -------------
```

## Technologies Used

* Terraform
* AWS EC2
* AWS VPC
* OpenTelemetry
* Tomcat
* GitHub

## Repository Structure

```text
observability-infra-proj/
└── main.tf
```

## Deployment Steps

### Initialize

```bash
terraform init
```

### Validate

```bash
terraform validate
```

### Plan

```bash
terraform plan
```

### Deploy

```bash
terraform apply -auto-approve
```

## Outputs

After deployment Terraform returns:

| Output                      |
| --------------------------- |
| tomcat_public_ip            |
| observability_hub_public_ip |

These outputs are used by the GitOps observability repository.

## What Gets Installed Automatically

### Tomcat Node

* Java
* Tomcat 9
* JMX Exporter
* OpenTelemetry Components

### Observability Hub

* Docker
* Docker Compose
* Container Runtime

## Skills Demonstrated

* Terraform
* AWS Infrastructure Automation
* Infrastructure as Code
* EC2 Provisioning
* User Data Automation
* Observability Architecture
* GitOps Foundations

## Related Repositories

* terraform-modules
* gitops-observability-apps

## Author

Pushpak Badadale [itspushpaksworld496@gmail.com]
DevOps | Cloud | Observability
