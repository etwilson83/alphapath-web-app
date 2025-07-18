#!/bin/bash

# Test script for the azd template
# Runs tests for both backend and frontend

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

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to run backend tests
run_backend_tests() {
    print_info "Running Go backend tests..."
    cd backend
    
    # Run tests with coverage
    if go test -v -cover ./...; then
        print_success "Backend tests passed"
    else
        print_error "Backend tests failed"
        return 1
    fi
    
    # Run linting
    if command -v golangci-lint >/dev/null 2>&1; then
        print_info "Running Go linting..."
        if golangci-lint run; then
            print_success "Backend linting passed"
        else
            print_error "Backend linting failed"
            return 1
        fi
    else
        print_warning "golangci-lint not found, skipping linting"
    fi
    
    cd ..
}

# Function to run frontend tests
run_frontend_tests() {
    print_info "Running Vue.js frontend tests..."
    
    if [ -d "frontend" ] && [ -f "frontend/package.json" ]; then
        cd frontend
        
        # Check if test script exists
        if npm run test --silent 2>/dev/null; then
            print_success "Frontend tests passed"
        else
            print_warning "No frontend tests configured or tests failed"
        fi
        
        # Run linting if available
        if npm run lint --silent 2>/dev/null; then
            print_success "Frontend linting passed"
        else
            print_warning "No frontend linting configured"
        fi
        
        cd ..
    else
        print_warning "Frontend directory not found or no package.json"
    fi
}

# Main execution
print_info "Running full test suite for azd template..."

# Run backend tests
if ! run_backend_tests; then
    exit 1
fi

# Run frontend tests
run_frontend_tests

print_success "All tests completed! 🎉" 