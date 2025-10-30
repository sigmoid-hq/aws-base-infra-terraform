"""
Example FastAPI application served behind CloudFront at the `/api` path.

The container image published by the ECS module can run this module directly
via `uvicorn index:app`. The endpoint selection keeps things
intentionally simple so teams can extend the surface without rewriting the
entire stack.
"""

from __future__ import annotations

import os
from datetime import datetime, timezone
from typing import List

from fastapi import APIRouter, FastAPI, HTTPException
from pydantic import BaseModel


# FastAPI is lightweight enough for an example API and provides automatic docs.
app = FastAPI(
    title="Sigmoid Example API",
    version="1.0.0",
    description="Sample endpoints backing the `/api` CloudFront path.",
    docs_url="/docs",
    redoc_url=None,
    openapi_url="/openapi.json",
)

# Define routes on a reusable router so we can mount it twice (`/` and `/api`).
router = APIRouter()


class Todo(BaseModel):
    """Simple todo item stored in-memory for demonstration purposes."""

    id: int
    title: str
    completed: bool = False


class CreateTodoRequest(BaseModel):
    title: str


# Keep a small todo list in memory so the API feels interactive.
_todos: List[Todo] = [
    Todo(id=1, title="Deploy static site", completed=True),
    Todo(id=2, title="Ship API container", completed=False),
]


def _next_todo_id() -> int:
    """Return the next identifier for a todo entry."""

    return max((todo.id for todo in _todos), default=0) + 1


@router.get("/health")
async def health() -> dict[str, str]:
    """
    Lightweight health check used by load balancers and observers.

    Returning the environment name makes it easy to confirm CloudFront routing.
    """

    return {
        "status": "ok",
        "service": os.getenv("SERVICE_NAME", "sigmoid-api"),
        "environment": os.getenv("ENVIRONMENT", "unknown"),
    }


@router.get("/time")
async def current_time() -> dict[str, str]:
    """Expose the current UTC timestamp to prove the container is alive."""

    now = datetime.now(tz=timezone.utc)
    return {"timestamp": now.isoformat()}


@router.get("/todos", response_model=list[Todo])
async def list_todos() -> list[Todo]:
    """Return the current in-memory todo list."""

    return _todos


@router.post("/todos", response_model=Todo, status_code=201)
async def create_todo(payload: CreateTodoRequest) -> Todo:
    """Add a todo entry to the in-memory store."""

    if not payload.title.strip():
        raise HTTPException(status_code=400, detail="title must not be blank")

    todo = Todo(id=_next_todo_id(), title=payload.title.strip())
    _todos.append(todo)
    return todo


# Define remaining endpoints, then mount the router so all routes are registered.
@router.post("/echo")
async def echo(message: dict) -> dict:
    """Echo back arbitrary JSON payloads for quick testing."""

    return {"echo": message, "received_at": datetime.now(tz=timezone.utc).isoformat()}


# Mount the router at the root and under `/api` so either path works.
app.include_router(router)
app.include_router(router, prefix="/api")


if __name__ == "__main__":
    import uvicorn

    # Uvicorn serves the ASGI app in the container entrypoint.
    uvicorn.run(
        "index:app",
        host="0.0.0.0",
        port=int(os.getenv("PORT", "8000")),
        log_level="info",
    )
