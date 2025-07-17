# Docs Chat

This repository contains a project for an agentic AI tool built on top of Agno, designed to have conversations with documentation. It uses a web crawler to populate a knowledge base, a vector database for retrieval, and a large language model for generating responses.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- Python 3.12+
- [uv](https://docs.astral.sh/uv/) for Python dependency management.
- [Node.js](https://nodejs.org/en) and [pnpm](https://pnpm.io/) for the frontend.
- A running Postgres database.
- A running Qdrant instance.

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
    - Create a `.env` file in the root of the project and add the following environment variables:
      ```
      QDRANT_URL=<your-qdrant-url>
      QDRANT_KEY=<your-qdrant-api-key>
      GEMINI_API_KEY=<your-gemini-api-key>
      ```

3.  **Set up the frontend:**
    - Install the Node.js dependencies:
      ```bash
      make install-ui
      ```

## Running the Application

1.  **Run the backend:**
    ```bash
    make run-chatbot
    ```
    The first time you run this, it will load the knowledge base. You can comment out `knowledge_base.load(upsert=True, recreate=False)` in `app/doc_chat.py` for subsequent runs to speed up startup time.

2.  **Run the frontend:**
    ```bash
    make run-ui
    ```
    The UI will be available at `http://localhost:3000`.

