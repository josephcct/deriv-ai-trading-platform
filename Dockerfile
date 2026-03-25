# Dockerfile for Multi-Stage Build

## Stage 1: Node.js
FROM node:14 AS node-build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

## Stage 2: Python
FROM python:3.9 AS python-build
WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY --from=node-build /app/dist ./dist

# Final stage
FROM python:3.9
WORKDIR /app
COPY --from=python-build /app/dist ./dist
EXPOSE 5000
CMD ["python", "-m", "dist.app"]