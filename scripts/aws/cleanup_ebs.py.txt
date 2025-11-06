import boto3
from scripts.utils.helpers import setup_logging
from scripts.utils.config_loader import load_config
import os

log = setup_logging()
cfg = load_config(os.environ.get("DEPLOY_ENV", "dev"))

def cleanup_ebs():
    client = boto3.client("ec2", region_name=cfg["aws"]["region"])
    res = client.describe_volumes(Filters=[{"Name":"status","Values":["available"]}])
    volumes = res.get("Volumes", [])
    if not volumes:
        log.info("No unattached volumes found.")
        return

    for v in volumes:
        vid = v["VolumeId"]
        try:
            log.info(f"Deleting volume {vid}")
            client.delete_volume(VolumeId=vid)
        except Exception as e:
            log.error(f"Failed to delete {vid}: {e}")

if __name__ == "__main__":
    cleanup_ebs()
