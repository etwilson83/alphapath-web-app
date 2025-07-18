package config

import (
	"os"

	"github.com/joho/godotenv"
)

// Config holds all configuration for the application
type Config struct {
	Port        string
	DatabaseURL string
	Environment string
	LogLevel    string
	FrontendURL string
}

// Load reads configuration from environment variables
func Load() (*Config, error) {
	// Load .env file if it exists (for local development)
	_ = godotenv.Load()

	cfg := &Config{
		Port:        getEnv("PORT", "8080"),
		DatabaseURL: getEnv("DATABASE_URL", ""),
		Environment: getEnv("ENVIRONMENT", "development"),
		LogLevel:    getEnv("LOG_LEVEL", "info"),
		FrontendURL: getEnv("FRONTEND_URL", "http://localhost:3000"),
	}

	return cfg, nil
}

// getEnv retrieves an environment variable with a fallback default value
func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
