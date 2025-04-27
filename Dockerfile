# Base image
FROM node:18-slim

# Set working directory
WORKDIR /app

# Copy package files and node_modules
COPY frontend/package.json frontend/yarn.lock ./frontend/
COPY server/package.json server/yarn.lock ./server/
COPY collector/package.json collector/yarn.lock ./collector/

COPY frontend/node_modules ./frontend/node_modules
COPY server/node_modules ./server/node_modules
COPY collector/node_modules ./collector/node_modules

# Copy application source code
COPY frontend ./frontend
COPY server ./server
COPY collector ./collector

# Install supervisor for managing multiple services
RUN apt-get update && apt-get install -y supervisor

# Copy Supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose the web port
EXPOSE 3000

# Start Supervisor to run all apps (frontend + backend + collector)
CMD ["/usr/bin/supervisord"]
