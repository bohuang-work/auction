# Aution System for Renewable Energy Provider

![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi)
![Swagger](https://img.shields.io/badge/-Swagger-%23Clojure?style=for-the-badge&logo=swagger&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-3.36.0-brightgreen?style=for-the-badge)

## Introduction

In a competitive renewable energy market, multiple energy producers (solar, wind, hydro, and possibly others) bid to supply energy to the grid at various prices. The challenge is to always select the supplier offering the lowest cost per kWh, ensuring the grid gets the most affordable renewable energy. Bids are continuously updated as new offers come in from producers.

## Dependecies

RESTful-api implemented using Fast-API framework:

- FastAPI
- SQLite
- Pydantic
- SQLAlchemy
- StreamLit

## Setup

- run `./setup.sh`

It create a python virtual environment locally and install all the rependencies based on requirements.txt

## Run

#### Run FastAPI with uvicorn and visit the backend swagger:

- run `source venv/bin/activate` to activate the virtual environment
- run `uvicorn main:app --reload`

visite page: http://127.0.0.1:8000/docs
![alt text](https://github.com/bohuang-work/auction/blob/main/img/swagger.png)

- post fake data to endpoint `/add_bid`:

```json
{
  "bids": [
    {
      "producer": "SolarCo",
      "price": 50.0
    },
    {
      "producer": "WindWorks",
      "price": 45.0
    },
    {
      "producer": "NextEra Energy",
      "price": 48.5
    },
    {
      "producer": "SunPower",
      "price": 55.2
    },
    {
      "producer": "Vestas Wind Systems",
      "price": 42.7
    },
    {
      "producer": "Brookfield Renewable Partners",
      "price": 51.0
    },
    {
      "producer": "First Solar",
      "price": 47.3
    },
    {
      "producer": "Orsted",
      "price": 49.9
    },
    {
      "producer": "Enel Green Power",
      "price": 44.6
    },
    {
      "producer": "Iberdrola",
      "price": 46.8
    },
    {
      "producer": "Siemens Gamesa",
      "price": 43.5
    },
    {
      "producer": "Pattern Energy",
      "price": 52.1
    }
  ]
}
```

#### Run streamlit and visulize the bilds:

- open a new terminal, run `source venv/bin/activate`
- run `streamlit run visualize.py`

visite page: http://localhost:8501/
![alt text](https://github.com/bohuang-work/auction/blob/main/img/histogram.png)
