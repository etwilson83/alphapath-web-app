package handlers

import (
	"database/sql"
	"encoding/json"
	"net/http"

	"backend/internal/config"
)

// HealthHandler handles health check endpoints
type HealthHandler struct {
	db  *sql.DB
	cfg *config.Config
}

// NewHealthHandler creates a new health handler
func NewHealthHandler(db *sql.DB) *HealthHandler {
	cfg, _ := config.Load()
	return &HealthHandler{
		db:  db,
		cfg: cfg,
	}
}

// HealthResponse represents the health check response
type HealthResponse struct {
	Status   string `json:"status"`
	Database string `json:"database"`
	Version  string `json:"version"`
}

// ConfigResponse represents the configuration debug response
type ConfigResponse struct {
	Port        string `json:"port"`
	Environment string `json:"environment"`
	FrontendURL string `json:"frontend_url"`
	LogLevel    string `json:"log_level"`
}

// Check performs a health check
func (h *HealthHandler) Check(w http.ResponseWriter, r *http.Request) {
	response := HealthResponse{
		Status:  "ok",
		Version: "1.0.0",
	}

	// Check database connection
	if err := h.db.Ping(); err != nil {
		response.Database = "error: " + err.Error()
		w.WriteHeader(http.StatusServiceUnavailable)
	} else {
		response.Database = "ok"
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

// Config returns the current configuration for debugging
func (h *HealthHandler) Config(w http.ResponseWriter, r *http.Request) {
	response := ConfigResponse{
		Port:        h.cfg.Port,
		Environment: h.cfg.Environment,
		FrontendURL: h.cfg.FrontendURL,
		LogLevel:    h.cfg.LogLevel,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}
