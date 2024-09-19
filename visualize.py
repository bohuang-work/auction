import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import streamlit as st
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from src.models import BidDB

# SQLite database setup
DATABASE_URL = "sqlite:///./bids.db"
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})

# Create a session to connect to the database
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def get_bids_from_db():
    db = SessionLocal()
    try:
        # Query all bids from the BidDB table
        bids = db.query(BidDB).all()
        return bids
    except Exception as e:
        st.error(f"Error accessing the database: {e}")
        return []
    finally:
        db.close()


# Streamlit app for visualizing bid prices
def main():
    st.title("Renewable Energy Auction")

    # Fetch data
    bids = get_bids_from_db()

    # If there are no bids, show user a message
    if not bids:
        st.write("No bids available in the database.")
        return

    # Convert the data into a pandas DataFrame
    data = [{"producer": bid.producer, "price": bid.price} for bid in bids]
    df = pd.DataFrame(data)

    # Sort the dataframe by price in ascending order (lowest price at the top)
    df = df.sort_values(by="price", ascending=True)

    # Create a figure for the histogram
    plt.figure(figsize=(12, 6))

    # Define unique colors for each provider
    sns.set_palette("Set2")  # Seaborn color palette with distinct colors

    # Create the histogram (bar plot with different colors for each producer)
    bar_plot = sns.barplot(
        x="producer", y="price", data=df, hue="producer", palette="Set2", legend=False
    )

    # Set the x-ticks to the number of producers
    bar_plot.set_xticks(range(len(df)))

    # Rotate x-axis labels to vertical
    bar_plot.set_xticklabels(bar_plot.get_xticklabels(), rotation=90, ha="right")

    # Add labels and title to the plot
    plt.title("Prices of Renewable Energy Providers")
    plt.xlabel("Producer")
    plt.ylabel("Price per kWh")

    # Display the graph in Streamlit
    st.pyplot(plt.gcf())

    # Optional: Display some interactive controls
    if st.checkbox("Show Raw Data"):
        st.write(df)


if __name__ == "__main__":
    main()
