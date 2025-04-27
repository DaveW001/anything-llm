# Base image
FROM node:18-slim

# Set working directory
WORKDIR /app

# Install basic utilities
RUN apt-get update && apt-get install -y supervisor

# Copy package.json and lockfiles first (better caching)
COPY frontend/package.json frontend/yarn.lock ./frontend/
COPY server/package.json server/yarn.lock ./server/
COPY collector/package.json collector/yarn.lock ./collector/

# Install frontend dependencies
RUN yarn --cwd frontend install

# Install server dependencies
RUN yarn --cwd server install

# Install collector dependencies
RUN yarn --cwd collector install

# Copy all app source code
COPY frontend ./frontend
COPY server ./server
COPY collector ./collector

# Copy Supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose frontend port
EXPOSE 3000

# Start Supervisor to run everything
CMD ["/usr/bin/supervisord"]
