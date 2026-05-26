from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.v1.routes import router as v1_router
from app.core.config import APP_NAME, APP_VERSION


app = FastAPI(
    title=APP_NAME,
    description=(
        "English: Backend API for the Cubox mobile-first speedcubing learning app. "
        "This MVP supports Fridrich/CFOP PLL algorithms only.\n\n"
        "Español: API backend para Cubox, una app mobile-first para aprender speedcubing. "
        "Este MVP solo soporta algoritmos PLL de Fridrich/CFOP."
    ),
    version=APP_VERSION,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
def health() -> dict[str, str]:
    return {
        "status": "ok",
        "service": APP_NAME,
        "version": APP_VERSION,
    }


app.include_router(v1_router, prefix="/api/v1")
