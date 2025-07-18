package router

import (
	"database/sql"
	"net/http"
	"strings"

	"backend/internal/api/handlers"
	"backend/internal/api/middleware"
	"backend/internal/config"
	"backend/internal/database"
)

// New creates a new HTTP router with all routes configured
func New(db *sql.DB, cfg *config.Config) http.Handler {
	// Run database migrations
	if err := database.Migrate(db); err != nil {
		panic("Failed to run database migrations: " + err.Error())
	}

	// Initialize handlers
	userHandler := handlers.NewUserHandler(db)
	healthHandler := handlers.NewHealthHandler(db)
	helloHandler := handlers.NewHelloHandler(db)

	// Create main router
	mux := http.NewServeMux()

	// Health endpoint
	mux.HandleFunc("/health", healthHandler.Check)

	// Hello endpoint for frontend integration testing
	mux.HandleFunc("/api/hello", helloHandler.GetHello)

	// User endpoints with method routing
	mux.HandleFunc("/api/users", func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			userHandler.GetUsers(w, r)
		case http.MethodPost:
			userHandler.CreateUser(w, r)
		default:
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	})

	// User by ID endpoints
	mux.HandleFunc("/api/users/", func(w http.ResponseWriter, r *http.Request) {
		// Check if this is a specific user endpoint (has ID)
		if strings.Count(r.URL.Path, "/") != 3 || strings.HasSuffix(r.URL.Path, "/") {
			http.Error(w, "Not found", http.StatusNotFound)
			return
		}

		switch r.Method {
		case http.MethodGet:
			userHandler.GetUser(w, r)
		case http.MethodPut:
			userHandler.UpdateUser(w, r)
		case http.MethodDelete:
			userHandler.DeleteUser(w, r)
		default:
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	})

	// Apply middleware (order matters - applied in reverse)
	handler := middleware.RequestValidation(mux)
	handler = middleware.CORS(cfg.FrontendURL)(handler)
	handler = middleware.HTTPSEnforcement(cfg.Environment)(handler)
	handler = middleware.Logging(handler)

	return handler
}
