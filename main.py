from fastapi import FastAPI

from src.endpoints import router as bid_router

# App Config
app = FastAPI(
    title="Renewable Energy Auction System",
    description="API for managing bids in a renewable energy auction system.",
    version="1.0.0",
)

# Endpoints
app.include_router(bid_router)

if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
