package middleware

import "net/http"

// CORS adds CORS headers to the response with the specified frontend URL
func CORS(frontendURL string) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			// Set CORS headers with specific frontend domain
			w.Header().Set("Access-Control-Allow-Origin", frontendURL)
			w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
			w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
			w.Header().Set("Access-Control-Allow-Credentials", "true")
			w.Header().Set("Access-Control-Max-Age", "86400")

			// Handle preflight OPTIONS request
			if r.Method == "OPTIONS" {
				w.WriteHeader(http.StatusOK)
				return
			}

			next.ServeHTTP(w, r)
		})
	}
}

// HTTPSEnforcement adds security headers and enforces HTTPS in production
func HTTPSEnforcement(environment string) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			// Add security headers
			w.Header().Set("X-Content-Type-Options", "nosniff")
			w.Header().Set("X-Frame-Options", "DENY")
			w.Header().Set("X-XSS-Protection", "1; mode=block")

			// Enforce HTTPS in production
			if environment == "production" {
				w.Header().Set("Strict-Transport-Security", "max-age=31536000; includeSubDomains")

				// Redirect to HTTPS if request is HTTP
				if r.Header.Get("X-Forwarded-Proto") == "http" {
					http.Redirect(w, r, "https://"+r.Host+r.URL.String(), http.StatusMovedPermanently)
					return
				}
			}

			next.ServeHTTP(w, r)
		})
	}
}

// RequestValidation adds basic request validation (content-type, size limits)
func RequestValidation(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Limit request body size to 1MB for basic protection
		r.Body = http.MaxBytesReader(w, r.Body, 1048576)

		// Validate content-type for POST/PUT requests
		if r.Method == "POST" || r.Method == "PUT" {
			contentType := r.Header.Get("Content-Type")
			if contentType != "" && contentType != "application/json" {
				http.Error(w, "Invalid content-type. Expected application/json", http.StatusUnsupportedMediaType)
				return
			}
		}

		next.ServeHTTP(w, r)
	})
}
