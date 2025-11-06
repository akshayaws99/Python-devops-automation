import os
import logging

def setup_logging():
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
    return logging.getLogger("devops")

def env(var_name, default=None):
    return os.environ.get(var_name, default)
