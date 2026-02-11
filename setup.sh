#!/bin/bash
echo "Setting up anomaly detection project..."

# Stop the script if any command fails
set -e

cd "$(dirname "$0")"

# Create and activate environment 
echo "Creating conda environment from environment.yml..."
conda env create -f environment.yml || conda env update -f environment.yml --prune
source activate screws
echo "Activating environment..."

# Create folders
#mkdir -p data/raw checkpoints

# Download dataset
echo "Downloading dataset..."
pip install gdown 
DATA_URL="https://drive.google.com/uc?id=1z-57McRCQ5PT6UYbF640BafBJmP3L_Jj"
OUTPUT_PATH="data/raw/anomaly_dataset.zip"

# Use gdown to download from Google Drive
gdown $DATA_URL -O $OUTPUT_PATH

# Unzip
unzip -o $OUTPUT_PATH -d data/raw/
rm $OUTPUT_PATH

echo "Setup complete!"
echo "Activate your environment with: conda activate screws"
echo "Press Enter to exit."
read