import boto3
import zipfile
import os
from scripts.utils.helpers import setup_logging
from scripts.utils.config_loader import load_config

log = setup_logging()
cfg = load_config(os.environ.get("DEPLOY_ENV", "dev"))

def package_lambda(src_dir, zip_name="/tmp/lambda.zip"):
    with zipfile.ZipFile(zip_name, 'w') as z:
        for root, _, files in os.walk(src_dir):
            for f in files:
                full = os.path.join(root, f)
                arcname = os.path.relpath(full, src_dir)
                z.write(full, arcname)
    return zip_name

def deploy_lambda(function_name, role_arn, handler="lambda_function.lambda_handler", runtime="python3.9", src_dir="."):
    client = boto3.client("lambda", region_name=cfg["aws"]["region"])
    zip_path = package_lambda(src_dir)
    with open(zip_path, "rb") as f:
        code = f.read()
    try:
        client.update_function_code(FunctionName=function_name, ZipFile=code)
        log.info("Updated code for %s", function_name)
    except client.exceptions.ResourceNotFoundException:
        client.create_function(FunctionName=function_name, Runtime=runtime, Role=role_arn, Handler=handler, Code={'ZipFile':code})
        log.info("Created function %s", function_name)
