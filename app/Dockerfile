# syntax=docker/dockerfile:1

# ---- build stage ----
FROM node:20-alpine AS build
WORKDIR /app

# Install deps
COPY package*.json ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build

# ---- runtime stage ----
FROM node:20-alpine AS runtime
ENV NODE_ENV=production
WORKDIR /app

# Healthcheck tools + static server + non-root user
RUN apk add --no-cache curl \
  && npm i -g serve@14 \
  && addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy only built assets
COPY --from=build /app/build ./build

# Healthcheck: server must respond on /
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD curl -fsS http://localhost:3000/ > /dev/null || exit 1

USER appuser
EXPOSE 3000
CMD ["serve", "-s", "build", "-l", "3000"]
