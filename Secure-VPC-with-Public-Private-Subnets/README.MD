# AWS Security Lab with Terraform

This project provisions a simple **AWS security lab** using **Terraform**.  
It creates a secure VPC environment with a **public bastion host** and a **private EC2 instance** for practicing cybersecurity, networking, and AWS security concepts.

---

## 🏗️ Architecture

- **VPC**: `10.0.0.0/16`
- **Subnets**:
  - Public Subnet (`10.0.0.0/24`) → Bastion Host
  - Private Subnet (`10.0.1.0/24`) → Private EC2
- **Internet Gateway**: Allows the bastion host to access the internet.
- **NAT Gateway / NAT Instance (optional)**: Allows the private EC2 to reach the internet (for updates).
- **Security Groups**:
  - Bastion SG: SSH access **only from your IP**.
  - Private EC2 SG: SSH access **only from the bastion host**.

---

## 📦 Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) v1.x+
- AWS Account with IAM user & programmatic access
- AWS CLI configured:
  ```bash
  aws configure
  ```
- SSH key pair (`.pem`) created in AWS (or generated locally and imported).

---

## 🚀 Deployment

1. Clone the repo:
   ```bash
   git clone https://github.com/ashabtariq/VPC-with-Public-Private-Subnets.git
   cd aws-security-lab
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Validate configuration:
   ```bash
   terraform validate
   ```

4. Plan deployment:
   ```bash
   terraform plan -var="project_name=securitylab" -var="environment=dev"
   ```

5. Apply:
   ```bash
   terraform apply -auto-approve
   ```

---

## 🖥️ Access

- **SSH into Bastion Host**:
  ```bash
  ssh -i my-key.pem ubuntu@<bastion-public-ip>
  ```

- **SSH into Private EC2** (from inside bastion):
  ```bash
  ssh ubuntu@<private-ec2-private-ip>
  ```

---

## 🧹 Cleanup

To destroy all resources and avoid AWS charges:
```bash
terraform destroy -auto-approve
```

---

## 📚 Learning Goals

- VPC Networking (public vs private subnets)
- Bastion host and jump-box security
- Security groups and NACLs
- Internet Gateway vs NAT Gateway
- Terraform best practices and modularization

---

## 📜 License

MIT License © 2025 Ashab Tariq