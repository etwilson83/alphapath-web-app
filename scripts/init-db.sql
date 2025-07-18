-- Database initialization script for local development
-- This runs automatically when the PostgreSQL container starts

-- Create the main database user (already created by POSTGRES_USER)
-- This file is mainly for any additional setup needed

-- Set timezone
SET timezone = 'UTC';

-- Create any extensions we might need
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- The users table will be created by the Go application migrations
-- when it starts up and calls database.Migrate()

-- You can add any other initial setup here that your research projects commonly need 