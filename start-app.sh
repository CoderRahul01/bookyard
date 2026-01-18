#!/bin/bash

# Color codes for better visibility
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Bookyard Full-Stack Magic Launcher ===${NC}"

# Step 1: Checking Prerequisites
echo -e "\n${YELLOW}Step 1: Checking Prerequisites...${NC}"

# Check for port conflicts (8000 for Backend, 3000 for Frontend)
CONFLICT_8000=$(lsof -Pi :8000 -sTCP:LISTEN -t)
CONFLICT_3000=$(lsof -Pi :3000 -sTCP:LISTEN -t)

if [ ! -z "$CONFLICT_8000" ]; then
    echo -e "${RED}Error: Port 8000 is already in use (Backend conflict).${NC}"
    echo -e "Conflicting PID: $CONFLICT_8000"
    echo -e "You can stop it with: ${BLUE}kill -9 $CONFLICT_8000${NC}"
    exit 1
fi

if [ ! -z "$CONFLICT_3000" ]; then
    echo -e "${RED}Error: Port 3000 is already in use (Frontend conflict).${NC}"
    echo -e "Conflicting PID: $CONFLICT_3000"
    echo -e "You can stop it with: ${BLUE}kill -9 $CONFLICT_3000${NC}"
    exit 1
fi

# Step 2: Checking Environment
echo -e "${YELLOW}Step 2: Checking Environment...${NC}"
if [ ! -f "backend/.env" ]; then
    echo -e "Creating backend/.env from .env.example..."
    cp backend/.env.example backend/.env
    echo -e "${YELLOW}Warning: Using default .env. Please update it with real credentials if needed.${NC}"
fi

# Step 3: Build & Launch
echo -e "\n${YELLOW}Step 3: Building & Launching Full-Stack Application...${NC}"
if ! docker-compose up -d --build; then
    echo -e "${RED}Failed to launch Docker containers.${NC}"
    exit 1
fi

# Step 4: Verification
echo -e "\n${YELLOW}Step 4: Waiting for services to be ready...${NC}"
count=0
while ! curl -s http://localhost:8000/health > /dev/null; do
    echo -n "."
    sleep 2
    count=$((count+1))
    if [ $count -gt 15 ]; then
        echo -e "\n${YELLOW}Health check taking longer than expected. Checking logs...${NC}"
        docker-compose logs --tail 20 backend
        exit 1
    fi
done

echo -e "\n${GREEN}BOOM! Bookyard is officially LIVE on your local machine.${NC}"
echo -e "----------------------------------------------------"
echo -e "${BLUE}Frontend:     ${GREEN}http://localhost:3000${NC}"
echo -e "${BLUE}Backend API:  ${GREEN}http://localhost:8000/api/v1/docs${NC}"
echo -e "${BLUE}Health Check: ${GREEN}http://localhost:8000/health${NC}"
echo -e "----------------------------------------------------"
echo -e "\nTo stop the app, run: ${YELLOW}docker-compose down${NC}"
