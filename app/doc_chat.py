from dotenv import load_dotenv
import os

from agno.agent import Agent
from agno.embedder.google import GeminiEmbedder
from agno.models.google import Gemini
from agno.playground import Playground, serve_playground_app
from agno.knowledge.website import WebsiteKnowledgeBase
from agno.vectordb.qdrant import Qdrant

load_dotenv(override=True)

COLLECTION_NAME = "website-content"


vector_db = Qdrant(
    collection=COLLECTION_NAME,
    url=os.getenv("QDRANT_URL"),
    api_key=os.getenv("QDRANT_KEY"),
    embedder=GeminiEmbedder(
        id="gemini-embedding-exp-03-07",
        dimensions=1536,
        api_key=os.getenv("GEMINI_API_KEY"),
    ),
)


# Create a knowledge base with the seed URLs
knowledge_base = WebsiteKnowledgeBase(
    urls=["https://relevanceai.com/docs/get-started/introduction"],
    max_links=50,
    vector_db=vector_db,
    embedder=GeminiEmbedder(
        id="gemini-embedding-exp-03-07",
        dimensions=1536,
        api_key=os.getenv("GEMINI_API_KEY"),
    ),
)

# Create an agent with the knowledge base
agent = Agent(
    knowledge=knowledge_base,
    search_knowledge=True,
    debug_mode=False,
    read_chat_history=True,
    model=Gemini(
        id="gemini-2.5-pro",
        api_key=os.getenv("GEMINI_API_KEY"),
    ),
    instructions=[
        "Always search your knowledge base first and use it if available.",
        "Important: Use tables where possible.",
    ],
    markdown=True,
)


app = Playground(agents=[agent]).get_app()

if __name__ == "__main__":
    # Load the knowledge base: Comment after first run as the knowledge base is already loaded
    knowledge_base.load(upsert=True, recreate=False)

    serve_playground_app("app.doc_chat:app", reload=True)
