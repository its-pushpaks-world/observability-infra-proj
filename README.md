# observability-infra-proj

This repository contains the root Terraform configuration to provision the foundational network and compute layer for the GitOps observability stack. It consumes the `terraform-modules` repository to deploy a VPC, subnets, and two EC2 instances: the Observability Hub and the Tomcat Application Node.

## Prerequisites
* AWS CLI configured with appropriate credentials.
* Terraform (`>= 1.5.0`) installed locally.
* An existing AWS SSH Key Pair.

## Deployment Steps

1. **Initialize Terraform**
   Downloads the required modules and providers.
   ```bash
   terraform init
   ```

2. **Review the Execution Plan**
   ```bash
   terraform plan
   ```

3. **Deploy the Infrastructure**
   Deploys the EC2 instances. The `user_data` scripts will automatically install Docker on the Hub node, and Tomcat 9 + OpenTelemetry on the application node.
   ```bash
   terraform apply -auto-approve
   ```

4. **Save the Outputs**
   Once the deployment finishes, save the generated IP addresses for the backend configuration phase:
   * `tomcat_public_ip`
   * `observability_hub_public_ip`
