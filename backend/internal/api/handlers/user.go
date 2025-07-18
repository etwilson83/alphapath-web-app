package handlers

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"strings"

	"backend/internal/models"
)

// UserHandler handles HTTP requests for user operations
type UserHandler struct {
	userRepo *models.UserRepository
}

// NewUserHandler creates a new user handler
func NewUserHandler(db *sql.DB) *UserHandler {
	return &UserHandler{
		userRepo: models.NewUserRepository(db),
	}
}

// GetUsers handles GET /api/users
func (h *UserHandler) GetUsers(w http.ResponseWriter, r *http.Request) {
	users, err := h.userRepo.GetAll()
	if err != nil {
		http.Error(w, fmt.Sprintf("Failed to get users: %v", err), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(users)
}

// GetUser handles GET /api/users/{id}
func (h *UserHandler) GetUser(w http.ResponseWriter, r *http.Request) {
	// Extract ID from URL path
	idStr := strings.TrimPrefix(r.URL.Path, "/api/users/")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusBadRequest)
		return
	}

	user, err := h.userRepo.GetByID(id)
	if err != nil {
		http.Error(w, fmt.Sprintf("Failed to get user: %v", err), http.StatusInternalServerError)
		return
	}

	if user == nil {
		http.Error(w, "User not found", http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(user)
}

// CreateUser handles POST /api/users
func (h *UserHandler) CreateUser(w http.ResponseWriter, r *http.Request) {
	var user models.User
	if err := json.NewDecoder(r.Body).Decode(&user); err != nil {
		http.Error(w, "Invalid JSON", http.StatusBadRequest)
		return
	}

	// Basic validation
	if user.Name == "" || user.Email == "" {
		http.Error(w, "Name and email are required", http.StatusBadRequest)
		return
	}

	if err := h.userRepo.Create(&user); err != nil {
		if strings.Contains(err.Error(), "duplicate") || strings.Contains(err.Error(), "unique") {
			http.Error(w, "Email already exists", http.StatusConflict)
			return
		}
		http.Error(w, fmt.Sprintf("Failed to create user: %v", err), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(user)
}

// UpdateUser handles PUT /api/users/{id}
func (h *UserHandler) UpdateUser(w http.ResponseWriter, r *http.Request) {
	// Extract ID from URL path
	idStr := strings.TrimPrefix(r.URL.Path, "/api/users/")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusBadRequest)
		return
	}

	var user models.User
	if err := json.NewDecoder(r.Body).Decode(&user); err != nil {
		http.Error(w, "Invalid JSON", http.StatusBadRequest)
		return
	}

	// Set the ID from URL
	user.ID = id

	// Basic validation
	if user.Name == "" || user.Email == "" {
		http.Error(w, "Name and email are required", http.StatusBadRequest)
		return
	}

	if err := h.userRepo.Update(&user); err != nil {
		if err == sql.ErrNoRows {
			http.Error(w, "User not found", http.StatusNotFound)
			return
		}
		if strings.Contains(err.Error(), "duplicate") || strings.Contains(err.Error(), "unique") {
			http.Error(w, "Email already exists", http.StatusConflict)
			return
		}
		http.Error(w, fmt.Sprintf("Failed to update user: %v", err), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(user)
}

// DeleteUser handles DELETE /api/users/{id}
func (h *UserHandler) DeleteUser(w http.ResponseWriter, r *http.Request) {
	// Extract ID from URL path
	idStr := strings.TrimPrefix(r.URL.Path, "/api/users/")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid user ID", http.StatusBadRequest)
		return
	}

	if err := h.userRepo.Delete(id); err != nil {
		if err == sql.ErrNoRows {
			http.Error(w, "User not found", http.StatusNotFound)
			return
		}
		http.Error(w, fmt.Sprintf("Failed to delete user: %v", err), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}
