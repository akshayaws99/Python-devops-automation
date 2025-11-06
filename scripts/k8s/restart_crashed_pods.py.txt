from kubernetes import client, config
from scripts.utils.helpers import setup_logging
from scripts.utils.config_loader import load_config
import os

log = setup_logging()
cfg = load_config(os.environ.get("DEPLOY_ENV", "dev"))

def restart_failed(namespace=None):
    namespace = namespace or cfg["k8s"].get("namespace", "default")
    try:
        config.load_kube_config()
    except:
        config.load_incluster_config()
    v1 = client.CoreV1Api()
    pods = v1.list_namespaced_pod(namespace)
    restarted = []
    for p in pods.items:
        # status.phase rarely equals CrashLoopBackOff; check container statuses
        cs = p.status.container_statuses or []
        for c in cs:
            if c.state.waiting and c.state.waiting.reason in ("CrashLoopBackOff","ImagePullBackOff","ErrImagePull"):
                log.info(f"Restarting pod {p.metadata.name} due to {c.state.waiting.reason}")
                try:
                    v1.delete_namespaced_pod(p.metadata.name, namespace)
                    restarted.append(p.metadata.name)
                except Exception as e:
                    log.error(f"Failed to delete {p.metadata.name}: {e}")
    if not restarted:
        log.info("No crashed pods found")

if __name__ == "__main__":
    restart_failed()
