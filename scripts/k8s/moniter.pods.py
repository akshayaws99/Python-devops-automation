from kubernetes import client, config
import time
from scripts.utils.helpers import setup_logging
from scripts.monitoring.send_slack_alert import send_slack

log = setup_logging()

def monitor(namespace="production", interval=60):
    try:
        config.load_kube_config()
    except:
        config.load_incluster_config()
    v1 = client.CoreV1Api()
    while True:
        pods = v1.list_namespaced_pod(namespace)
        for p in pods.items:
            cs = p.status.container_statuses or []
            for c in cs:
                if c.restart_count and c.restart_count > 3:
                    msg = f"Pod {p.metadata.name} in {namespace} restarted {c.restart_count} times"
                    log.warning(msg)
                    send_slack(msg)
        time.sleep(interval)

if __name__ == "__main__":
    monitor()
