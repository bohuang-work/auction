#!/bin/bash

# Check if requirements.txt exists
if [[ ! -f requirements.txt ]]; then
    echo "requirements.txt not found! Please create it first."
    exit 1
fi

# Create a virtual environment
python3 -m venv venv

# Activate the virtual environment
source venv/bin/activate

# Upgrade pip to the latest version
pip install --upgrade pip

# Install dependencies from requirements.txt
pip install -r requirements.txt

echo "Setup complete! Virtual environment created and dependencies installed."
echo "To activate the virtual environment, run:"

echo "##########################"
echo "source venv/bin/activate"
echo "##########################"
