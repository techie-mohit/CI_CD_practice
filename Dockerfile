FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "index.js"]


# -------------------------------
# 1. Base Image
# -------------------------------
# Use official Node.js image (lightweight Alpine version)
# Alpine = smaller size → faster builds → less memory usage
# FROM node:20-alpine


# -------------------------------
# 2. Working Directory
# -------------------------------
# This creates a folder inside container (/app)
# and sets it as the default directory
# All commands will run inside this folder
# WORKDIR /app


# -------------------------------
# 3. Copy Dependency Files First
# -------------------------------
# Copies:
# - package.json
# - package-lock.json
# WHY?
# - Enables Docker layer caching
# - Dependencies install only when these files change
# COPY package*.json ./


# -------------------------------
# 4. Install Dependencies
# -------------------------------
# npm install → installs dependencies
# BEST PRACTICE: use "npm ci" in production/CI
# because:
# - Faster
# - Uses exact versions from package-lock.json
# - More reliable builds
# RUN npm ci
# RUN npm install


# -------------------------------
# 5. Copy Remaining Code
# -------------------------------
# Copies all project files (index.js, routes, etc.)
# COPY . .


# -------------------------------
# 6. Expose Port
# -------------------------------
# This tells Docker that app runs on port 3000
# (It does NOT actually publish the port)
# EXPOSE 3000


# -------------------------------
# 7. Start Application
# -------------------------------
# CMD defines the default command when container starts
# Format: ["executable", "argument"]
# This runs: node index.js
# CMD ["node", "index.js"]


# ==========================================================
# 🔥 FRONTEND + BACKEND NOTES (VERY IMPORTANT FOR INTERVIEW)
# ==========================================================

# ---------- BACKEND (Node.js / Express) ----------
# This Dockerfile is mainly used for backend
# Example:
# - Express API server
# - MongoDB connection
# - REST APIs
#
# Typical backend flow:
# Client → React → Node API → MongoDB


# ---------- FRONTEND (React) ----------
# React apps are NOT run using "node index.js"
# Instead:
# 1. Build React app → npm run build
# 2. Serve static files using Nginx
#
# Example frontend Dockerfile:

# FROM node:20-alpine as build
# WORKDIR /app
# COPY package*.json ./
# RUN npm ci
# COPY . .
# RUN npm run build   # creates production build

# FROM nginx:alpine
# COPY --from=build /app/build /usr/share/nginx/html
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]


# ---------- FULL MERN (Frontend + Backend Together) ----------
# Option 1 (BEST PRACTICE):
# - Separate containers:
#   backend → Node container
#   frontend → Nginx container
#   database → MongoDB container
#
# Managed using Docker Compose


# ---------- DOCKER COMPOSE EXAMPLE ----------
# version: "3"
# services:
#   backend:
#     build: ./backend
#     ports:
#       - "5000:5000"
#
#   frontend:
#     build: ./frontend
#     ports:
#       - "3000:3000"
#
#   mongodb:
#     image: mongo
#     ports:
#       - "27017:27017"


# ---------- CI/CD CONNECTION ----------
# In CI/CD (like GitHub Actions):
# Steps:
# 1. Install dependencies
# 2. Run tests
# 3. Build Docker image
# 4. Push image to registry
# 5. Deploy container
#
# Example:
# docker build -t my-app .
# docker run -p 3000:3000 my-app


# ---------- ENV VARIABLES ----------
# Instead of hardcoding:
# use .env file or Docker ENV
#
# Example:
# ENV PORT=3000
# OR
# use docker-compose env_file


# ---------- IMPORTANT BEST PRACTICES ----------
# ✔ Use npm ci instead of npm install
# ✔ Keep image small (alpine)
# ✔ Use .dockerignore to avoid copying node_modules
# ✔ Never store secrets in Dockerfile
# ✔ Use multi-stage build for frontend