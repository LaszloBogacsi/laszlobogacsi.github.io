# Hugo Site Development Commands
.PHONY: help start dev build clean serve install update

# Default target
help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Install Hugo dependencies
	@echo "Installing Hugo modules..."
	hugo mod get -u

start: ## Start development server (alias for dev)
	@$(MAKE) dev

dev: ## Start Hugo development server with drafts and live reload
	@echo "Starting Hugo development server..."
	@echo "Opening browser at http://localhost:1313..."
	@(sleep 2 && open http://localhost:1313) &
	hugo server --buildDrafts --buildFuture --disableFastRender

serve: ## Start Hugo development server (production-like)
	@echo "Starting Hugo server in production mode..."
	hugo server --environment production

build: ## Build the site for production
	@echo "Building site for production..."
	hugo --gc --minify

clean: ## Clean generated files
	@echo "Cleaning generated files..."
	rm -rf public/ resources/_gen/

update: ## Update Hugo modules and dependencies
	@echo "Updating Hugo modules..."
	hugo mod get -u
	hugo mod tidy

new-post: ## Create a new blog post (usage: make new-post TITLE="My New Post")
	@if [ -z "$(TITLE)" ]; then \
		echo "Usage: make new-post TITLE=\"Your Post Title\""; \
		exit 1; \
	fi
	hugo new posts/$(shell echo "$(TITLE)" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')/index.md

preview: ## Build and serve the site locally for preview
	@$(MAKE) build
	@$(MAKE) serve

lint: ## Check for common Hugo issues
	@echo "Checking Hugo configuration..."
	hugo config
	@echo "Validating content..."
	hugo --gc --minify --dry-run

stats: ## Show site statistics
	@echo "Site statistics:"
	@hugo list all | wc -l | xargs -I {} echo "Total pages: {}"
	@find content/posts -name "*.md" | wc -l | xargs -I {} echo "Blog posts: {}"
