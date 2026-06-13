# ☁️ AWS Infrastructure for Observability Platform

Terraform-based infrastructure deployment for a complete Observability Platform on AWS.

This repository provisions the AWS infrastructure required for metrics collection, log aggregation, and visualization.

---

## 🚀 What Gets Deployed

### Networking

- VPC
- Public Subnet
- Internet Gateway
- Route Tables

### Compute

- Observability Hub EC2 Instance
- Tomcat Application EC2 Instance

### Automated Bootstrap

Observability Hub:

- Docker
- Docker Compose

Tomcat Node:

- Tomcat 9
- OpenTelemetry Collector
- JMX Exporter

---

## 🏛️ Architecture

```text
                    AWS Cloud
                         │
        ┌────────────────────────────────┐
        │                                │
        ▼                                ▼
┌─────────────────┐          ┌─────────────────┐
│ Observability   │          │ Tomcat App      │
│ Hub             │◄────────►│ Server          │
│                 │          │                 │
│ Grafana         │          │ OpenTelemetry   │
│ Loki            │          │ JMX Exporter    │
│ Mimir           │          │                 │
└─────────────────┘          └─────────────────┘
```

---

## 🛠️ Technologies Used

- Terraform
- AWS EC2
- AWS VPC
- OpenTelemetry
- Tomcat
- Linux

---

## 📋 Prerequisites

- AWS CLI configured
- Terraform >= 1.5
- Existing AWS Key Pair

Verify AWS access:

```bash
aws sts get-caller-identity
```

---

## 🚀 Deployment Steps

### Initialize Terraform

```bash
terraform init
```

### Review Changes

```bash
terraform plan
```

### Deploy Infrastructure

```bash
terraform apply -auto-approve
```

---

## 📤 Important Outputs

Save these values after deployment:

| Output |
|----------|
| tomcat_public_ip |
| observability_hub_public_ip |

These are required for deploying the observability stack.

---

## ✅ Validation

Check outputs:

```bash
terraform output
```

Check state:

```bash
terraform state list
```

---

## 🧹 Cleanup

Destroy all resources:

```bash
terraform destroy -auto-approve
```

---

## 🎯 Skills Demonstrated

- Terraform
- Infrastructure as Code
- AWS Networking
- EC2 Provisioning
- Cloud Automation
- User Data Bootstrapping
- Observability Foundations

---

## 🔗 Related Repositories

- terraform-modules
- gitops-observability-apps

---

## 👨‍💻 Author

**Pushpak Badadale**

📧 [Email](mailto:itspushpaksworld496@gmail.com)

💼 [LinkedIn](https://www.linkedin.com/in/pushpak-badadale-492409179)

🐙 [GitHub](https://github.com/its-pushpaks-world)
