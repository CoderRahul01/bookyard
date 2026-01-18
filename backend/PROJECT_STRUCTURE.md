# Backend Architecture & Structure

This document provides a technical overview of the Bookyard backend architecture.

## 📂 Project Organization

```text
backend/
├── app/
│   ├── api/                    # API Route definitions
│   │   └── v1/                 # Versioned API endpoints
│   ├── core/                   # Global configuration & security
│   ├── crud/                   # CRUD logic (Database abstraction)
│   ├── db/                     # Database session & base models
│   ├── models/                 # SQLAlchemy models (Database schema)
│   ├── schemas/                # Pydantic schemas (Request/Response validation)
│   ├── services/               # Business logic & external integrations
│   ├── controllers/            # Higher-level logic orchestrators
│   └── main.py                 # Application entry point
├── data/                       # CSV Assets (Backup/Initial Data)
├── supabase/                   # Database migrations & SQL setup
├── init_db.py                  # Database initialization script
├── Dockerfile                  # Container definition
└── requirements.txt            # Python dependencies
```

## 🏗️ Technical Architecture

The backend follows a layered architecture to ensure separation of concerns and maintainability.

### 1. API Layer (`app/api/`)
Handles HTTP requests and routing. We use FastAPI's `APIRouter` with versioning (`v1`) to allow for future non-breaking updates.

### 2. Validation Layer (`app/schemas/`)
Uses **Pydantic** for rigorous data validation. Every request body and response object is validated against a schema before processing.

### 3. Business Logic Layer (`app/services/`)
Contains the "brains" of the application, such as recommendation algorithms or complex data processing, keeping the API controllers thin and clean.

### 4. Persistence Layer (`app/crud/` & `app/models/`)
- **SQLAlchemy Models**: Define the database schema for PostgreSQL/Supabase.
- **CRUD Helpers**: Encapsulate the raw SQL/ORM logic so that the rest of the app doesn't need to know how data is saved.

### 5. Core Configuration (`app/core/`)
Manages environment variables, security settings (JWT/password hashing), and global constants using **Pydantic Settings**.

---

## 🚀 Key Features

- **Auto-Initialization**: Run `init_db.py` (triggered automatically in Docker) to sync your Supabase schema.
- **Async Operations**: Fully asynchronous endpoints for high-performance data fetching.
- **Recommendation Engine**: Custom logic in `services/recommendation.py` for personalized book suggestions.
- **Versioned API**: Scalable structure ready for future expansion.
