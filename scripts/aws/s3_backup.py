import boto3
import os
from datetime import datetime
from scripts.utils.helpers import setup_logging
from scripts.utils.config_loader import load_config

log = setup_logging()
cfg = load_config(os.environ.get("DEPLOY_ENV", "dev"))

def backup_file(local_path, bucket_name, key_prefix="backups"):
    s3 = boto3.client("s3", region_name=cfg["aws"]["region"])
    date = datetime.utcnow().strftime("%Y%m%dT%H%M%SZ")
    key = f"{key_prefix}/{date}/{os.path.basename(local_path)}"
    s3.upload_file(local_path, bucket_name, key)
    log.info(f"Uploaded {local_path} to s3://{bucket_name}/{key}")
    return key

if __name__ == "__main__":
    # example usage: export BACKUP_FILE=/tmp/db.dump; export S3_BUCKET=my-bucket
    local = os.environ.get("BACKUP_FILE")
    bucket = os.environ.get("S3_BUCKET")
    if not local or not bucket:
        log.error("Set BACKUP_FILE and S3_BUCKET environment variables")
    else:
        backup_file(local, bucket)
