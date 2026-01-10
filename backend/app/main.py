from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import os

load_dotenv()

from app.api.endpoints import books, profiles, reservations
from app.db.session import init_db

app = FastAPI(
    title="Bookyard API",
    description="Refined FastAPI application for Bookyard with Supabase Integration",
    version="0.2.0"
)

# Initialize database tables
@app.on_event("startup")
def on_startup():
    init_db()

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # Adjust for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(books.router, prefix="/api/books", tags=["books"])
app.include_router(profiles.router, prefix="/api/profiles", tags=["profiles"])
app.include_router(reservations.router, prefix="/api/reservations", tags=["reservations"])

@app.get("/")
async def root():
    return {"message": "Welcome to BookYard API"}
