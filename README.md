# 🚀 DevOps Automation Project – Python + Terraform + Kubernetes + Jenkins

This repository demonstrates a real-world DevOps implementation using:  
✅ Python Automation  
✅ Terraform for AWS Infrastructure as Code  
✅ Kubernetes Deployment & Monitoring  
✅ Jenkins CI/CD Pipeline  
✅ Slack Alerts + Prometheus Exporter for Monitoring

---

## 🏗 Architecture Overview

1. **Terraform (IaC)**
   - Creates S3 bucket (backups, logs)  
   - Creates IAM roles for EC2, EKS & Jenkins  
   - Creates DynamoDB table for Terraform state locking  
   - Configures remote backend for Terraform state in S3  
   - (Optional) EC2, VPC, EKS cluster infrastructure

2. **Python Automation (`scripts/`)**
   - `scripts/aws/` – EC2 creation, S3 backup, EBS cleanup  
   - `scripts/k8s/` – List pods, restart CrashLoopBackOff pods, deploy Kubernetes YAML  
   - `scripts/monitoring/` – Slack alerts, Prometheus metrics, log parser  
   - `scripts/utils/` – Config loader, logging, secret management

3. **Kubernetes (`k8s_manifests/`)**
   - Deployment, Service, Ingress, ConfigMap files  
   - Can be applied via `kubectl` or Python automation

4. **Jenkins Pipeline (`Jenkinsfile`)**
   - Installs dependencies  
   - Runs Python automation  
   - Optionally runs Terraform  
   - Sends Slack alerts on success or failure

---

## 🧠 How to Explain This in an Interview?

**Sample Answer:**

*"I built an end-to-end DevOps automation project. I used Terraform to provision AWS infrastructure like IAM roles, S3 buckets with encryption and lifecycle rules, and DynamoDB for Terraform state locking.  
All infrastructure is version-controlled in GitHub.  
Then, using Python+Boto3, I automated tasks like creating EC2 instances, cleaning EBS volumes, uploading backups to S3, and triggering Lambda functions.  
For Kubernetes, I wrote Python scripts using the Kubernetes API to monitor pods, restart failed pods automatically, and deploy YAML files.  
CI/CD is handled by Jenkins using a Jenkinsfile — it runs Terraform & Python, and sends Slack alerts if a pipeline fails.  
This setup shows infrastructure automation, cloud integration, and monitoring — which is exactly what a DevOps engineer does in real production systems."*

---

## ✅ Technologies Used

| Tool        | Purpose                        |
|-------------|----------------------------------|
| Python      | Automation scripts (AWS/K8s)     |
| Terraform   | Infrastructure provisioning       |
| Jenkins     | CI/CD Pipeline                   |
| Kubernetes  | Application deployment           |
| Slack API   | Alerts/Notifications             |
| Prometheus  | Metrics Export                   |
| AWS (IAM, S3, EC2, DynamoDB) | Cloud Resources |

---

## ✔ How to Run?

```bash
git clone <repo-url>
cd python-devops-automation
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cd aws_terraform
terraform init
terraform apply
python scripts/aws/create_ec2.py
python scripts/k8s/list_pods.py
