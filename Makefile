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

# Start required services for LOCAL development
start-services-local:
	docker run -d -e POSTGRES_DB=ai -e POSTGRES_USER=ai -e POSTGRES_PASSWORD=ai -e PGDATA=/var/lib/postgresql/data/pgdata -v pgvolume:/var/lib/postgresql/data -p 5532:5432 --name pgvector agnohq/pgvector:16 || echo "PostgreSQL already running"
	docker run -d -p 6333:6333 -p 6334:6334 -v qdrant_storage:/qdrant/storage:z --name qdrant qdrant/qdrant || echo "Qdrant already running"

# Start required services for CLOUD development (only PostgreSQL needed)
start-services-cloud:
	docker run -d -e POSTGRES_DB=ai -e POSTGRES_USER=ai -e POSTGRES_PASSWORD=ai -e PGDATA=/var/lib/postgresql/data/pgdata -v pgvolume:/var/lib/postgresql/data -p 5532:5432 --name pgvector agnohq/pgvector:16 || echo "PostgreSQL already running"

# Alias for backward compatibility
start-services: start-services-local

# Stop services
stop-services:
	docker stop pgvector qdrant || true
	docker rm pgvector qdrant || true

# Check service status
check-services:
	docker ps | grep -E "(pgvector|qdrant)"

# Test Qdrant connection
test-qdrant:
	uv run python -c "from qdrant_client import QdrantClient; import os; from dotenv import load_dotenv; load_dotenv(); client = QdrantClient(url=os.getenv('QDRANT_URL'), api_key=os.getenv('QDRANT_KEY')); print('Qdrant connection successful!'); print('Collections:', [c.name for c in client.get_collections().collections])"

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
