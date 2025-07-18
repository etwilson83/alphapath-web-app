package handlers

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"backend/internal/models"
)

func TestNewUserHandler(t *testing.T) {
	handler := NewUserHandler(nil)
	if handler == nil {
		t.Error("Expected handler to be created, got nil")
	}
}

func TestUserHandler_CreateUser_InvalidJSON(t *testing.T) {
	handler := NewUserHandler(nil)

	// Create request with invalid JSON
	req := httptest.NewRequest(http.MethodPost, "/api/users", bytes.NewBufferString("invalid json"))
	w := httptest.NewRecorder()

	handler.CreateUser(w, req)

	if w.Code != http.StatusBadRequest {
		t.Errorf("Expected status %d, got %d", http.StatusBadRequest, w.Code)
	}
}

func TestUserHandler_CreateUser_MissingFields(t *testing.T) {
	handler := NewUserHandler(nil)

	// Create request with missing required fields
	user := models.User{Name: "John"} // Missing email
	body, _ := json.Marshal(user)
	req := httptest.NewRequest(http.MethodPost, "/api/users", bytes.NewBuffer(body))
	w := httptest.NewRecorder()

	handler.CreateUser(w, req)

	if w.Code != http.StatusBadRequest {
		t.Errorf("Expected status %d, got %d", http.StatusBadRequest, w.Code)
	}
}

func TestUserHandler_GetUser_InvalidID(t *testing.T) {
	handler := NewUserHandler(nil)

	req := httptest.NewRequest(http.MethodGet, "/api/users/invalid", nil)
	w := httptest.NewRecorder()

	handler.GetUser(w, req)

	if w.Code != http.StatusBadRequest {
		t.Errorf("Expected status %d, got %d", http.StatusBadRequest, w.Code)
	}
}
