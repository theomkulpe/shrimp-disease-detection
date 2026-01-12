# Lightweight Python base image
FROM python:3.10-slim

# Prevents Python from buffering logs
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# System dependencies (important for PIL & Torch)
RUN apt-get update && apt-get install -y \
    build-essential \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy dependencies first (Docker cache optimization)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port
EXPOSE 8000

# Start production server
CMD ["gunicorn", "-k", "uvicorn.workers.UvicornWorker", "-w", "2", "main:app", "--bind", "0.0.0.0:8000"]