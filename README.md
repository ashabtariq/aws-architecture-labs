# 🌩️ AWS Architecture Labs with Terraform

[![Terraform](https://img.shields.io/badge/Terraform-v1.x+-blueviolet?logo=terraform)](https://developer.hashicorp.com/terraform)
[![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonaws)](https://aws.amazon.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)
[![Infrastructure as Code](https://img.shields.io/badge/IaC-Terraform-blue)](https://www.terraform.io/)

A collection of **AWS architecture blueprints** built with **Terraform**.  
Each lab demonstrates **networking, security, and cloud best practices** while helping learners gain hands-on experience with AWS Infrastructure as Code (IaC).

---


Each lab contains:
- `main.tf` → Terraform resources  
- `variables.tf` → Input variables  
- `outputs.tf` → Outputs  
- `README.md` → Lab-specific guide  

---


## 📦 Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) v1.x+  
- AWS Account with IAM user & programmatic access  
- AWS CLI configured (`aws configure`)  
- SSH key pair (`.pem`) for EC2-based labs  

---

## 🚀 Getting Started

Clone this repository:

```bash
git clone https://github.com/your-username/aws-architecture-labs.git
cd aws-architecture-labs/lab1-security-vpc-bastion
```

Initialize and apply:

```bash
terraform init
terraform plan -var="project_name=my-lab" -var="environment=dev"
terraform apply -auto-approve
```

To destroy resources:

```bash
terraform destroy -auto-approve
```

---


## 📚 Learning Goals

- Understand **AWS core services** (VPC, EC2, S3, ALB, IAM, etc.)  
- Apply **security best practices** (private subnets, bastion hosts, IAM roles)  
- Explore **networking options** (IGW vs NAT, SG vs NACL)  
- Automate deployments with **Terraform**  

---

## 📜 License

This repository is licensed under the [MIT License](./LICENSE).  