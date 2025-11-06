# Troubleshooting

- **ModuleNotFoundError**: Run `pip install -r requirements.txt`
- **Kubernetes auth**: Ensure kubeconfig exists or the pod has service account
- **AWS permissions**: Verify IAM role/policies
- **Slack errors**: Confirm webhook and network connectivity
- **Disk full on node**: Clean logs and docker images, monitor disk metrics


---------------------------------------------------------------------
# Additional information

1.Replace placeholders:

ami-0abcdef1234567890 → your AMI

Slack webhook → SLACK_WEBHOOK_URL

AWS region/account details

2.Use IAM roles (recommended) rather than long-term credentials for production.

3.Run locally to test scripts before adding to CI/CD.

4.Once files are in your local repo, run the Git commands you already have to push to GitHub.
