from pydantic import BaseModel, Field, condecimal, conlist, field_validator
from sqlalchemy import Column, Float, Integer, String

from src.db import Base, engine


# Database model
class BidDB(Base):
    __tablename__ = "bids"
    id = Column(Integer, primary_key=True, index=True)
    producer = Column(String, nullable=False)
    price = Column(Float, nullable=False)


# Create the tables in the database
Base.metadata.create_all(bind=engine)

# API model
class Bid(BaseModel):
    producer: str = Field(
        ..., min_length=1, description="Producer name must not be empty"
    )
    price: condecimal(gt=0)

    # Validate producer name and price
    @field_validator("producer")
    def producer_name_not_empty(cls, v):
        if not v.strip():
            raise ValueError("Producer name cannot be empty")
        return v


class BidList(BaseModel):
    bids: conlist(Bid, min_length=1)
