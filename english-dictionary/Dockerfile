# Multi-stage build for smaller image
FROM python:3.12-alpine AS builder

WORKDIR /app

# Install build dependencies (use --no-scripts to avoid QEMU busybox trigger issue)
RUN apk add --no-cache --no-scripts --virtual .build-deps \
    gcc \
    musl-dev \
    libffi-dev && \
    pip install --no-cache-dir --upgrade pip

COPY requirements.txt .
# Install to /install instead of user directory
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt && \
    apk del --no-scripts .build-deps


# Final runtime stage
FROM python:3.11-alpine

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH=/install/bin:$PATH \
    PYTHONPATH=/install/lib/python3.11/site-packages

# Install runtime dependencies and create user (use --no-scripts to avoid QEMU busybox trigger issue)
RUN apk add --no-cache --no-scripts curl && \
    addgroup -g 1000 appgroup && \
    adduser -u 1000 -D -G appgroup appuser

# Copy installed packages from builder to /install (not /root/.local)
COPY --from=builder /install /install

# Copy application files with ownership
COPY --chown=appuser:appgroup ./app ./app
COPY --chown=appuser:appgroup ./static ./static

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8000/api/health || exit 1

# Run application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
