from prometheus_client import start_http_server, Gauge
import random
import time

# Example exporter with dummy metric
REQUEST_LATENCY = Gauge("app_request_latency_seconds", "Latency of app requests")

def main(port=8000):
    start_http_server(port)
    while True:
        # In production, collect real metrics (e.g., parse logs or query app)
        REQUEST_LATENCY.set(random.random())
        time.sleep(5)

if __name__ == "__main__":
    main()
