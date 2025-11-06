import boto3
import os
from scripts.utils.helpers import setup_logging
from scripts.utils.config_loader import load_config

log = setup_logging()
cfg = load_config(os.environ.get("DEPLOY_ENV", "dev"))

def create_ec2(count=1, instance_type="t2.micro", ami=None):
    ami = ami or cfg["aws"].get("default_ami")
    ec2 = boto3.resource("ec2", region_name=cfg["aws"]["region"])
    instances = ec2.create_instances(
        ImageId=ami,
        MinCount=count,
        MaxCount=count,
        InstanceType=instance_type
    )
    for i in instances:
        log.info(f"Created instance: {i.id}")
    return [i.id for i in instances]

if __name__ == "__main__":
    create_ec2()
