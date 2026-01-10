"""
FastAPI application with health check endpoint.
"""

import logging
from contextlib import asynccontextmanager
from datetime import datetime
from fastapi import FastAPI
from fastapi.responses import JSONResponse
from pydantic import BaseModel

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


# Lifespan context manager
@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Handle application startup and shutdown events.
    
    Yields:
        None
    """
    # Startup
    logger.info("Application startup")
    logger.info("Bookyard API is running")
    
    yield
    
    # Shutdown
    logger.info("Application shutdown")


# Initialize FastAPI app
app = FastAPI(
    title="Bookyard API",
    description="FastAPI application for Bookyard",
    version="0.1.0",
    lifespan=lifespan
)


# Models
class HealthResponse(BaseModel):
    """Health check response model."""
    status: str
    timestamp: datetime
    version: str


class Message(BaseModel):
    """Generic message response model."""
    message: str


# Routes
@app.get("/", response_model=Message)
async def root():
    """Root endpoint."""
    return {"message": "Welcome to Bookyard API"}


@app.get("/health", response_model=HealthResponse)
async def health_check():
    """
    Health check endpoint.
    
    Returns:
        HealthResponse: Status, timestamp, and API version
    """
    logger.info("Health check endpoint called")
    return {
        "status": "healthy",
        "timestamp": datetime.utcnow(),
        "version": "0.1.0"
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )
