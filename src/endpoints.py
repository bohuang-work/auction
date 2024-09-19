from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from src.db import get_db
from src.models import BidDB, BidList

# Create an APIRouter instance
router = APIRouter()


# Add single or multiple bids endpoint
@router.post(
    "/add_bid",
    description="Add one or multiple bids. Each bid should contain a producer name and price per kWh.",
)
async def add_bid(bid_list: BidList, db: Session = Depends(get_db)):
    try:
        for bid in bid_list.bids:
            db_bid = BidDB(producer=bid.producer, price=float(bid.price))
            db.add(db_bid)
        db.commit()
        return {"message": "Bids added successfully"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail=str(e))


# Get the lowest bid endpoint
@router.get("/get_lowest_bid")
async def get_lowest_bid(db: Session = Depends(get_db)):
    lowest_bid = db.query(BidDB).order_by(BidDB.price).first()
    if not lowest_bid:
        raise HTTPException(status_code=404, detail="No bids available")
    return {"producer": lowest_bid.producer, "price": lowest_bid.price}
