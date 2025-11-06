# Setup Guide

1. Create Python venv and install deps:

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt



2. AWS credentials:
- `aws configure` or set `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`

3. Kubernetes:
- Ensure kubectl works and points to your cluster (`kubectl get nodes`)

4. Slack:
- Set `SLACK_WEBHOOK_URL` environment variable

5. Terraform:

cd aws_terraform
terraform init
terraform plan
terraform apply

