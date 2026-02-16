# Resume Matcher - Railway Backend Deployment
# Only runs the backend API, frontend is deployed to Vercel

FROM python:3.13-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# Install system dependencies for Playwright
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libpango-1.0-0 \
    libcairo2 \
    libatspi2.0-0 \
    libgtk-3-0 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app/backend

# Copy backend files
COPY apps/backend/pyproject.toml .
COPY apps/backend/app ./app

# Install Python dependencies
RUN pip install --no-cache-dir .

# Install Playwright Chromium
RUN python -m playwright install chromium --with-deps

# Create data directory
RUN mkdir -p /app/backend/data

# Expose the backend port
EXPOSE 8000

# Set default port (Railway will override this)
ENV PORT=8000

# Start the backend server
# Use shell form for environment variable expansion
CMD python -m uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}
