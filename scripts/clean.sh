#!/bin/bash

# Cleanup script for the azd development environment
# This script stops services and optionally cleans up data

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Parse command line arguments
CLEAN_DATA=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --data)
            CLEAN_DATA=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [--data]"
            echo ""
            echo "Options:"
            echo "  --data    Also remove database data (⚠️  destructive)"
            echo "  -h, --help Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

print_info "Cleaning up azd development environment..."

# Stop and remove containers
print_info "Stopping Docker Compose services..."
docker-compose down

# Remove unused images
print_info "Cleaning up unused Docker images..."
docker image prune -f

# Optionally clean data
if [ "$CLEAN_DATA" = true ]; then
    print_warning "Removing database data..."
    docker-compose down -v
    docker volume rm azd-template-go-vue-pg_postgres_data 2>/dev/null || true
    print_success "Database data removed"
fi

print_success "Cleanup complete!"
print_info "To start fresh, run: ./scripts/dev.sh" 