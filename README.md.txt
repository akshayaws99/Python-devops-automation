# Python DevOps Automation

This repo contains Python automation scripts and Terraform templates for common DevOps tasks:
- AWS automation (EC2, EBS cleanup, S3 backup)
- Kubernetes automation (list pods, restart failed pods, deploy)
- Monitoring & Alerts (Slack integration, Prometheus exporter)
- Jenkins pipeline example
- Terraform templates for basic infra

> **Important:** Replace placeholder values with your configs and use IAM roles / secrets manager for credentials.

## Quick start (local)

1. Create and activate virtualenv:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
