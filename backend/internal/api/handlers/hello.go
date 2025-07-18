package handlers

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"time"
)

type HelloResponse struct {
	Message   string    `json:"message"`
	Timestamp time.Time `json:"timestamp"`
	Database  string    `json:"database"`
	Server    string    `json:"server"`
}

type HelloHandler struct {
	db *sql.DB
}

func NewHelloHandler(db *sql.DB) *HelloHandler {
	return &HelloHandler{db: db}
}

func (h *HelloHandler) GetHello(w http.ResponseWriter, r *http.Request) {
	// Get current timestamp from database to prove connectivity
	var dbTimestamp time.Time
	err := h.db.QueryRow("SELECT NOW()").Scan(&dbTimestamp)
	if err != nil {
		http.Error(w, "Database connection failed", http.StatusInternalServerError)
		return
	}

	response := HelloResponse{
		Message:   "🎉 Full stack integration successful! Vue.js ↔ Go ↔ PostgreSQL",
		Timestamp: dbTimestamp,
		Database:  "Connected to PostgreSQL",
		Server:    "Go backend with Air hot-reload",
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}
