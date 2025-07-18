#!/bin/bash

# Development startup script for the azd Go + Vue.js + PostgreSQL template
# This script provides an easy way to start the full development environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

print_info "Starting azd development environment..."

# Check if .env file exists in backend
if [ ! -f "./backend/.env" ]; then
    print_warning "No .env file found in backend directory. Creating from template..."
    cp "./backend/.env.example" "./backend/.env" 2>/dev/null || true
fi

# Build and start services
print_info "Building and starting services with Docker Compose..."
docker-compose up --build -d

# Wait for services to be healthy
print_info "Waiting for services to start..."
sleep 5

# Check service health
print_info "Checking service health..."

# Check PostgreSQL
if docker-compose exec -T postgres pg_isready -U developer -d research_app > /dev/null 2>&1; then
    print_success "PostgreSQL is ready"
else
    print_warning "PostgreSQL is still starting up..."
fi

# Check backend
if curl -f http://localhost:8080/health > /dev/null 2>&1; then
    print_success "Backend API is ready"
else
    print_warning "Backend API is still starting up..."
fi

# Print status and helpful information
echo ""
print_success "Development environment started!"
echo ""
print_info "🎯 Service URLs:"
echo "   Frontend (Vue.js): http://localhost:3000"
echo "   Backend API:       http://localhost:8080"
echo "   Health Check:      http://localhost:8080/health"
echo "   Database:          postgresql://developer:developer123@localhost:5432/research_app"
echo ""
print_info "📋 Useful commands:"
echo "   View logs:         docker-compose logs -f"
echo "   Stop services:     docker-compose down"
echo "   Rebuild:           docker-compose up --build"
echo "   Database shell:    docker-compose exec postgres psql -U developer -d research_app"
echo ""
print_info "📁 Dev environment ready! Happy coding! 🚀" 