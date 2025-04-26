# Base image
FROM node:18-slim

# Create app directories
WORKDIR /app

# Install dependencies for all services
COPY frontend/package.json frontend/yarn.lock ./frontend/
COPY server/package.json server/yarn.lock ./server/
COPY collector/package.json collector/yarn.lock ./collector/

RUN cd frontend && yarn install
RUN cd ../server && yarn install
RUN cd ../collector && yarn install

# Copy all app files
COPY frontend ./frontend
COPY server ./server
COPY collector ./collector

# Build frontend
RUN cd frontend && yarn build

# Install process manager
RUN apt-get update && apt-get install -y supervisor

# Copy Supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose ports
EXPOSE 3000

# Start all services
CMD ["/usr/bin/supervisord"]
