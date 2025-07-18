package models

import (
	"database/sql"
	"time"
)

// User represents a user in the system
type User struct {
	ID        int       `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

// UserRepository handles database operations for users
type UserRepository struct {
	db *sql.DB
}

// NewUserRepository creates a new user repository
func NewUserRepository(db *sql.DB) *UserRepository {
	return &UserRepository{db: db}
}

// GetAll retrieves all users from the database
func (r *UserRepository) GetAll() ([]User, error) {
	query := `SELECT id, name, email, created_at, updated_at FROM users ORDER BY created_at DESC`

	rows, err := r.db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var users []User
	for rows.Next() {
		var user User
		err := rows.Scan(&user.ID, &user.Name, &user.Email, &user.CreatedAt, &user.UpdatedAt)
		if err != nil {
			return nil, err
		}
		users = append(users, user)
	}

	return users, rows.Err()
}

// GetByID retrieves a user by ID
func (r *UserRepository) GetByID(id int) (*User, error) {
	query := `SELECT id, name, email, created_at, updated_at FROM users WHERE id = $1`

	var user User
	err := r.db.QueryRow(query, id).Scan(&user.ID, &user.Name, &user.Email, &user.CreatedAt, &user.UpdatedAt)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, err
	}

	return &user, nil
}

// Create creates a new user
func (r *UserRepository) Create(user *User) error {
	query := `INSERT INTO users (name, email) VALUES ($1, $2) RETURNING id, created_at, updated_at`

	err := r.db.QueryRow(query, user.Name, user.Email).Scan(&user.ID, &user.CreatedAt, &user.UpdatedAt)
	if err != nil {
		return err
	}

	return nil
}

// Update updates an existing user
func (r *UserRepository) Update(user *User) error {
	query := `UPDATE users SET name = $1, email = $2, updated_at = CURRENT_TIMESTAMP 
			  WHERE id = $3 RETURNING updated_at`

	err := r.db.QueryRow(query, user.Name, user.Email, user.ID).Scan(&user.UpdatedAt)
	if err != nil {
		return err
	}

	return nil
}

// Delete deletes a user by ID
func (r *UserRepository) Delete(id int) error {
	query := `DELETE FROM users WHERE id = $1`

	result, err := r.db.Exec(query, id)
	if err != nil {
		return err
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return err
	}

	if rowsAffected == 0 {
		return sql.ErrNoRows
	}

	return nil
}
