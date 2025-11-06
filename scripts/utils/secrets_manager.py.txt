import os

def get_secret(name, default=None):
    # Prefer environment variables or expand to use AWS Secrets Manager / Vault
    return os.environ.get(name, default)
