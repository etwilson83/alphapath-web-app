# Cursor Configuration for Alpha Path Web UI

This directory contains configuration files for Cursor AI to better understand and assist with this project.

## Files Overview

### `.cursor/rules`
Contains project-specific rules and guidelines that help Cursor understand:
- Project architecture and structure
- Coding standards and conventions
- Key files and directories
- Development workflow
- Environment variables and dependencies

### `.cursor/settings.json`
Configures Cursor's editor behavior for this project:
- Language-specific settings (Go, TypeScript, Vue.js, Terraform)
- File associations and formatting rules
- Excluded files and directories
- Editor preferences (tab size, rulers, etc.)
- Terminal configuration

### `.cursor/tasks.json`
Defines common development tasks that can be run from Cursor:
- Build and deployment commands
- Testing tasks
- Local development setup
- Infrastructure management
- Dependency installation

## How to Use

### Running Tasks
1. Open the Command Palette (`Cmd+Shift+P` on Mac)
2. Type "Tasks: Run Task"
3. Select from the available tasks:
   - **Build Backend**: `azd package backend`
   - **Build Frontend**: `azd package frontend`
   - **Deploy All**: `azd up`
   - **Start Local Development**: `docker-compose up --build`
   - **Test Backend**: `go test ./...`
   - **Test Frontend**: `pnpm test`

### Project Understanding
Cursor will now understand:
- This is a full-stack Azure application with Go backend and Vue.js frontend
- Terraform only manages application-specific resources
- Uses existing Azure infrastructure (Resource Group, Container Registry, Container Apps Environment)
- Deployment workflow with azd
- Proper file structure and conventions

### Code Assistance
Cursor will provide better assistance for:
- Go backend development with proper error handling
- Vue.js frontend with TypeScript
- Terraform infrastructure as code
- Azure-specific configurations
- Docker containerization

## Customization

You can modify these files to:
- Add new tasks for your specific workflow
- Update coding standards or conventions
- Change editor preferences
- Add new file associations
- Modify excluded files/directories

## Notes

- These files are project-specific and should be committed to version control
- They help team members get consistent Cursor behavior
- They improve AI assistance for project-specific patterns and conventions
- They can be updated as the project evolves 