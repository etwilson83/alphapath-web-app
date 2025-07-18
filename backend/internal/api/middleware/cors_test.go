package middleware

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestCORS(t *testing.T) {
	// Create a test handler
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	})

	// Wrap with CORS middleware using test frontend URL
	corsHandler := CORS("https://testfrontend.example.com")(handler)

	// Test regular request
	req := httptest.NewRequest(http.MethodGet, "/test", nil)
	w := httptest.NewRecorder()

	corsHandler.ServeHTTP(w, req)

	// Check CORS headers are set to specific frontend URL
	if w.Header().Get("Access-Control-Allow-Origin") != "https://testfrontend.example.com" {
		t.Errorf("Expected Access-Control-Allow-Origin header to be 'https://testfrontend.example.com', got '%s'", w.Header().Get("Access-Control-Allow-Origin"))
	}

	if w.Header().Get("Access-Control-Allow-Methods") == "" {
		t.Error("Expected Access-Control-Allow-Methods header to be set")
	}

	if w.Header().Get("Access-Control-Allow-Credentials") != "true" {
		t.Error("Expected Access-Control-Allow-Credentials header to be 'true'")
	}

	if w.Code != http.StatusOK {
		t.Errorf("Expected status %d, got %d", http.StatusOK, w.Code)
	}
}

func TestCORS_OptionsRequest(t *testing.T) {
	// Create a test handler
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	})

	// Wrap with CORS middleware using test frontend URL
	corsHandler := CORS("https://testfrontend.example.com")(handler)

	// Test OPTIONS request (preflight)
	req := httptest.NewRequest(http.MethodOptions, "/test", nil)
	w := httptest.NewRecorder()

	corsHandler.ServeHTTP(w, req)

	// OPTIONS request should return 200 and not call the wrapped handler
	if w.Code != http.StatusOK {
		t.Errorf("Expected status %d, got %d", http.StatusOK, w.Code)
	}

	// Check CORS headers are set to specific frontend URL
	if w.Header().Get("Access-Control-Allow-Origin") != "https://testfrontend.example.com" {
		t.Errorf("Expected Access-Control-Allow-Origin header to be 'https://testfrontend.example.com', got '%s'", w.Header().Get("Access-Control-Allow-Origin"))
	}
}

func TestCORS_DifferentFrontendURL(t *testing.T) {
	// Test that different frontend URLs are properly set
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	})

	testURL := "https://myapp.azurestaticapps.net"
	corsHandler := CORS(testURL)(handler)

	req := httptest.NewRequest(http.MethodGet, "/test", nil)
	w := httptest.NewRecorder()

	corsHandler.ServeHTTP(w, req)

	if w.Header().Get("Access-Control-Allow-Origin") != testURL {
		t.Errorf("Expected Access-Control-Allow-Origin header to be '%s', got '%s'", testURL, w.Header().Get("Access-Control-Allow-Origin"))
	}
}
