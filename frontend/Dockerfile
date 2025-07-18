# Build stage
FROM node:20-alpine as build-stage

# Install pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml* ./

# Install dependencies with frozen lockfile for consistency
RUN pnpm install --frozen-lockfile

# Copy source code
COPY . .

# Accept build argument for API URL
ARG VITE_API_URL=http://localhost:8080

# Build the app with environment variable
RUN pnpm run build

# Production stage
FROM nginx:alpine as production-stage

# Copy built app from build stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Copy nginx configuration for SPA
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"] 