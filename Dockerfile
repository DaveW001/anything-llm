# Base image
FROM node:18-slim

# Set working directory
WORKDIR /app

# Install basic utilities
RUN apt-get update && apt-get install -y supervisor

# Copy frontend and server package configs
COPY frontend/package.json frontend/yarn.lock ./frontend/
COPY server/package.json server/yarn.lock ./server/

# Install frontend and server dependencies
RUN yarn --cwd frontend install
RUN yarn --cwd server install

# Copy source code for frontend and server
COPY frontend ./frontend
COPY server ./server

# Copy pre-built collector (node_modules already installed locally)
COPY collector ./collector

# Copy Supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose frontend port
EXPOSE 3000

# Start Supervisor to run everything
CMD ["/usr/bin/supervisord"]
