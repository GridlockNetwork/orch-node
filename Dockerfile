# Development stage
FROM node:20-alpine AS development

# Labels for Docker Desktop to automatically configure 
LABEL com.docker.desktop.extension.icon="https://cdn-icons-png.flaticon.com/512/5968/5968322.png"
LABEL com.docker.container.network.publish.5310="5310"

# OCI Labels
LABEL org.opencontainers.image.title="Gridlock Orchestrator Node"
LABEL org.opencontainers.image.description="The orchestrator node manages and coordinates the Gridlock network operations, ensuring secure and efficient transaction processing."
LABEL org.opencontainers.image.vendor="Gridlock Network"
LABEL org.opencontainers.image.source="https://github.com/GridlockNetwork/orch-node"
LABEL org.opencontainers.image.licenses="Apache-2.0"

# Set working directory
WORKDIR /app

# Copy all application files
COPY package.json package-lock.json tsconfig.json ecosystem.config.json ./
COPY src/ ./src/

# Install dependencies (including dev dependencies)
RUN npm ci && \
    npm run compile

# Install nodemon globally for better compatibility
RUN npm install -g nodemon

# Expose the port the app runs on
EXPOSE 5310

# Set the entrypoint to run the app
CMD ["npm", "run", "dev"]

# Build stage - compile TypeScript
FROM node:20-alpine AS builder

WORKDIR /app

# Install only the build dependencies needed for native modules
RUN apk add --no-cache python3 make g++

# Copy package files
COPY package.json package-lock.json ./

# Install only dependencies needed for building
RUN npm ci && \
    npm prune --omit=optional

# Copy source code
COPY tsconfig.json ./
COPY src/ ./src/

# Build the application
RUN npm run compile

# Clean production dependencies stage with native module builds
FROM node:20-alpine AS dependencies

WORKDIR /app

# Install build dependencies for native modules
RUN apk add --no-cache python3 make g++

# Copy package files
COPY package.json package-lock.json ./

# Install ONLY production dependencies - with proper native builds
RUN npm ci --omit=dev --no-audit --no-fund && \
    npm prune --production && \
    # Clean up npm cache and tmp files
    rm -rf /root/.npm /tmp/* package-lock.json && \
    # Clean up unnecessary files in node_modules
    find node_modules -type d \( -name "test" -o -name "tests" -o -name "example" -o -name "examples" -o -name "docs" -o -name ".git" -o -name ".github" \) | xargs rm -rf || true && \
    # Remove unnecessary files by extension
    find node_modules -type f \( -name "*.md" -o -name "*.ts" -not -name "*.d.ts" -o -name "*.map" -o -name "*.min.js.map" -o -name "*.ts.map" -o -name "CHANGELOG*" -o -name "README*" -o -name "Makefile" -o -name "*.npmignore" -o -name "*.gitignore" -o -name "*.editorconfig" -o -name "*.eslintrc*" \) | xargs rm -f || true && \
    # Remove typescript and all .bin directories
    rm -rf node_modules/typescript || true

# Final production stage - ultra minimal
FROM node:20-alpine AS production

# Labels for Docker Desktop to automatically configure 
LABEL com.docker.desktop.extension.icon="https://cdn-icons-png.flaticon.com/512/5968/5968322.png"
LABEL com.docker.container.network.publish.5310="5310"

# OCI Labels
LABEL org.opencontainers.image.title="Gridlock Orchestrator Node"
LABEL org.opencontainers.image.description="The orchestrator node manages and coordinates the Gridlock network operations, ensuring secure and efficient transaction processing."
LABEL org.opencontainers.image.vendor="Gridlock Network"
LABEL org.opencontainers.image.source="https://github.com/GridlockNetwork/orch-node"
LABEL org.opencontainers.image.licenses="Apache-2.0"

# Set working directory
WORKDIR /app

# Copy only the bare minimum files needed to run the application
COPY --from=builder /app/dist ./dist
COPY --from=dependencies /app/node_modules ./node_modules
COPY ecosystem.config.json ./

# Use a non-root user with minimal permissions
RUN addgroup -S appgroup && adduser -S appuser -G appgroup && \
    chown -R appuser:appgroup /app && \
    # Remove unnecessary files
    rm -rf /var/cache/apk/* /tmp/*

USER appuser

# Expose the port the app runs on
EXPOSE 5310

# Run the application
CMD ["node", "dist/index.js"]
