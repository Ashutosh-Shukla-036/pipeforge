# FastAPI server to start docker container

import os
import redis.asyncio as redis
from fastapi import FastAPI
from dotenv import load_dotenv

load_dotenv()

# Initialize FastAPI app
app = FastAPI(title="PipeForge API", version="1.0.0")

# Initialize Redis connection
redis_client = redis.Redis(
    host=os.getenv("REDIS_HOST"),
    port=int(os.getenv("REDIS_PORT")),
    decode_responses=True
)

# Health check endpoint
@app.get("/health")
async def health():
    try:
        await redis_client.ping()
        redis_status = "ok"
    except Exception as e:
        redis_status = f"error: {str(e)}"
    return {"api": "ok", "status": "healthy", "redis": redis_status}
