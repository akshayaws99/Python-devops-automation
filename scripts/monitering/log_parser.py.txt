import re
from pathlib import Path
from scripts.utils.helpers import setup_logging
from scripts.monitoring.send_slack_alert import send_slack

log = setup_logging()

def find_errors(log_dir="logs", pattern=r"ERROR|Exception"):
    p = Path(log_dir)
    if not p.exists():
        log.error("Log dir %s not found", log_dir)
        return []
    errors = []
    for file in p.glob("*.log"):
        with open(file, errors='ignore') as fh:
            for line in fh:
                if re.search(pattern, line):
                    errors.append((file.name, line.strip()))
    return errors

if __name__ == "__main__":
    res = find_errors()
    if res:
        for f,l in res[:10]:
            print(f, l)
        send_slack(f"Found {len(res)} error lines in logs")
    else:
        print("No errors found")
