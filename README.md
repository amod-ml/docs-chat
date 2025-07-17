# Docs Chat

This repository contains a project for an agentic AI tool built on top of Agno, designed to have conversations with documentation. It uses a web crawler to populate a knowledge base, a vector database for retrieval, and a large language model for generating responses.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- Python 3.12+
- [uv](https://docs.astral.sh/uv/) for Python dependency management.
- [Node.js](https://nodejs.org/en) and [pnpm](https://pnpm.io/) for the frontend.
- [Docker](https://www.docker.com/) for running PostgreSQL (and optionally Qdrant) databases.
- A Google Gemini API key.
- **Optional:** A [Qdrant Cloud](https://cloud.qdrant.io) account for managed vector database.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/docs-chat.git
    cd docs-chat
    ```

2.  **Set up the backend:**
    - Install the Python dependencies:
      ```bash
      uv sync
      ```
    - Set up the required environment variables in `.env`:
      
      **For Local Development:**
      ```bash
      # Qdrant configuration for local development
      QDRANT_URL=http://localhost:6333
      QDRANT_KEY=

      # Google Gemini API configuration
      GEMINI_API_KEY=your_actual_gemini_api_key_here
      ```
      
      **For Qdrant Cloud (Recommended):**
      ```bash
      # Qdrant Cloud configuration
      QDRANT_URL=https://your-cluster-id.region.qdrant.cloud:6333
      QDRANT_KEY=your_qdrant_cloud_api_key

      # Google Gemini API configuration
      GEMINI_API_KEY=your_actual_gemini_api_key_here
      ```
      **Important:** Replace placeholders with your actual API keys and cluster details.

3.  **Set up the frontend:**
    - Install pnpm if not already installed:
      ```bash
      npm install -g pnpm
      ```
    - Install the Node.js dependencies:
      ```bash
      make install-ui
      ```

## Running the Application

### Option A: Local Development (with local Qdrant)

1. **Start local services:**
   ```bash
   make start-services-local
   ```
   This starts both PostgreSQL and Qdrant locally.

### Option B: Cloud Development (with Qdrant Cloud)

1. **Start required services:**
   ```bash
   make start-services-cloud
   ```
   This starts only PostgreSQL locally (Qdrant runs in the cloud).

2. **Test Qdrant Cloud connection:**
   ```bash
   make test-qdrant
   ```

### 2. Run the Backend

```bash
make run-chatbot
```

**Note:** The first time you run this, it will load the knowledge base by crawling the configured websites. This may take several minutes. You can comment out `knowledge_base.load(upsert=True, recreate=False)` in `app/doc_chat.py` for subsequent runs to speed up startup time.

### 3. Run the Frontend

In a separate terminal:

```bash
make run-ui
```

The UI will be available at `http://localhost:3000`.

## Qdrant Cloud Setup

### Benefits of Qdrant Cloud:
- ✅ **Managed Infrastructure**: No Docker containers to manage
- ✅ **Automatic Scaling**: Handles traffic spikes automatically  
- ✅ **High Availability**: Professional uptime guarantees
- ✅ **Performance**: Optimized for vector operations
- ✅ **Security**: Built-in authentication and encryption

### Setup Steps:
1. Sign up at [cloud.qdrant.io](https://cloud.qdrant.io)
2. Create a new cluster
3. Copy your cluster URL and API key
4. Update your `.env` file with the cloud credentials
5. Use `make start-services-cloud` instead of `make start-services-local`

## Useful Commands

- **Local development:** `make start-services-local`
- **Cloud development:** `make start-services-cloud`
- **Test Qdrant connection:** `make test-qdrant`
- **Check service status:** `make check-services`
- **Stop services:** `make stop-services`
- **Restart services:** `make stop-services && make start-services-local`

## Environment Variables

The application requires these environment variables in your `.env` file:

| Variable | Description | Local Example | Cloud Example |
|----------|-------------|---------------|---------------|
| `QDRANT_URL` | Qdrant server URL | `http://localhost:6333` | `https://xyz-abc.us-east.qdrant.cloud:6333` |
| `QDRANT_KEY` | Qdrant API key | Leave empty for local | Your cloud API key |
| `GEMINI_API_KEY` | Google Gemini API key | Your actual API key | Your actual API key |

## Troubleshooting

### Database Connection Issues

If you see PostgreSQL connection errors:
```bash
make stop-services
make start-services-local  # or start-services-cloud
make check-services
```

### Qdrant Connection Issues

**For Local Qdrant:**
```bash
docker ps | grep qdrant
```

**For Qdrant Cloud:**
```bash
make test-qdrant
```

### Knowledge Base Loading

The first run will take time to crawl and process the website content. Subsequent runs are faster as the data is cached in the vector database.

## Development

- **Format code:** `make format`
- **Lint code:** `make lint`
- **Fix linting:** `make fix`
- **Clean cache:** `make clean`

