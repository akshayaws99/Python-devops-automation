import yaml
from pathlib import Path

def load_config(env="dev"):
    path = Path("config") / f"{env}_config.yaml"
    if not path.exists():
        path = Path("config") / "dev_config.yaml"
    with open(path) as f:
        return yaml.safe_load(f)
