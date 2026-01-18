# 📚 Bookyard: Local Development Guide

Welcome to the **Bookyard** contribution team! This guide will help you set up and run the entire full-stack application locally with zero friction.

---

## 🛠️ Prerequisites

Before you start, ensure you have the following installed:
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (includes Docker Compose)
- A [Supabase](https://supabase.com/) account for database hosting.

---

## 🚀 Getting Started

### 1. External Configuration
The application requires a PostgreSQL database (Supabase).
- Copy the template:
  ```bash
  cp backend/.env.example backend/.env
  ```
- Edit `backend/.env` and provide your real `DATABASE_URL`.

### 2. The "One-Command" Magic Launch (Recommended 🚀)
We provide a specialized script that handles everything—from environment checks to health-check verification for both Frontend and Backend.

**Just run it and boom! The entire app is ready.**

```bash
./start-app.sh
```

**What happens under the hood?**
- ✅ **Port Guard**: Detects if another project is clogging Port 8000 (Backend) or Port 3000 (Frontend).
- ✅ **Environment Shield**: Prevents launching if `.env` is missing.
- ✅ **Full-Stack Build**: Compiles both Frontend and Backend into a unified container network.
- ✅ **Auto-Verify**: Waits until the Backend API is *actually* healthy before declaring success.

---

## 📖 Live Endpoints

Once the launch is successful, you can access the following:

| Component | URL | Description |
| :--- | :--- | :--- |
| **Frontend** | [http://localhost:3000](http://localhost:3000) | The main React/Vite user interface. |
| **API Docs (Swagger)** | [http://localhost:8000/api/v1/docs](http://localhost:8000/api/v1/docs) | Interactive testing for all endpoints. |
| **API Health** | [http://localhost:8000/health](http://localhost:8000/health) | System status & version info. |

---

## 📂 Project Architecture

For a deep dive into the folder structure and technical layers, check out our **[Project Architecture Doc](./backend/PROJECT_STRUCTURE.md)**.

> [!IMPORTANT]
> **Hot Reload**: The Backend container syncs your local `backend/` directory. Save a file, and the server restarts automatically!
> **Frontend Build**: The Frontend is currently built into a production-ready Nginx container for consistency.

---

## 🔧 Troubleshooting

### Port Conflicts
If the script fails with a port error, it means another project is using Port 8000 or 3000.
- **Stop conflicting process**: The script will provide the exact `kill` command to use.

### Database Connection Error
If the backend starts but cannot connect to Supabase:
- Ensure your `DATABASE_URL` is correct.
- Run `docker-compose logs -f backend` to see the exact error message.

---

Happy coding! We're excited to see your contributions. 🥂
