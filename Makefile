format:
	uv run ruff format

lint:
	uv run ruff check .

fix:
	uv run ruff check --fix .

# Clean up the project including _pycache_
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name ".ruff_cache" -exec rm -rf {} +
	find . -type d -name ".DS_Store" -exec rm -rf {} +
	find . -type d -name ".vscode" -exec rm -rf {} +


run-chatbot:
	uv run python -m app.doc_chat

install-ui:
	cd agent-ui && pnpm install

run-ui:
	cd agent-ui && pnpm run dev

build-ui:
	cd agent-ui && pnpm run build

lint-ui:
	cd agent-ui && pnpm run lint
