"""
Key difference between api and worker to understand:
api uses redis.asyncio — async client because FastAPI is async, everything must be non-blocking. If you use sync redis in FastAPI, one slow Redis call blocks the entire server.
Worker uses plain redis — sync client because worker is a simple loop. No async needed. Simplicity wins here.
"""

import os
import redis
import time
from dotenv import load_dotenv

load_dotenv()

# Initialize Redis connection
redis_client = redis.Redis(
    host=os.getenv("REDIS_HOST"),
    port=int(os.getenv("REDIS_PORT")),
    decode_responses=True
)

# Worker function
def worker():
    print("[worker] starting up...")
    while True:
        try:
            redis_client.ping()
            print("[worker] alive — waiting for jobs...")
        except Exception as e:
            print(f"[worker] redis error: {e}")

        time.sleep(5)

if __name__ == "__main__":
    worker()