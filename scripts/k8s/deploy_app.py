import subprocess
import os
from scripts.utils.helpers import setup_logging

log = setup_logging()

def kubectl_apply(file_path):
    cmd = ["kubectl", "apply", "-f", file_path]
    log.info("Running: %s", " ".join(cmd))
    subprocess.check_call(cmd)

if __name__ == "__main__":
    # Example: apply all manifests in k8s_manifests/
    folder = os.environ.get("K8S_MANIFESTS_DIR", "k8s_manifests")
    for f in sorted(os.listdir(folder)):
        if f.endswith(".yaml") or f.endswith(".yml"):
            kubectl_apply(os.path.join(folder, f))
