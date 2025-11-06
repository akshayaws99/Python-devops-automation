import os
import json
import requests
from scripts.utils.helpers import setup_logging

log = setup_logging()

def send_slack(message):
    webhook = os.environ.get("SLACK_WEBHOOK_URL")
    if not webhook:
        # fallback to config file (not recommended)
        try:
            with open("config/slack_config.json") as f:
                webhook = json.load(f).get("webhook_url")
        except Exception:
            webhook = None
    if not webhook:
        log.error("No Slack webhook configured. Set SLACK_WEBHOOK_URL.")
        return False
    payload = {"text": message}
    r = requests.post(webhook, json=payload)
    if r.status_code == 200:
        log.info("Sent slack message")
        return True
    else:
        log.error("Slack error: %s %s", r.status_code, r.text)
        return False

if __name__ == "__main__":
    import sys
    msg = " ".join(sys.argv[1:]) or "Test alert from Python DevOps project"
    send_slack(msg)
