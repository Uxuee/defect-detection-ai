import os
import shutil
import numpy as np
from pathlib import Path
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
from tensorflow.keras.applications.resnet50 import preprocess_input

if not Path("data/raw/archive").exists():
    os.chdir("..")

print("Working directory:", os.getcwd())

#Setting up (relative) paths
models_dir = Path("checkpoints")
TEST_DIR = Path('data/raw/archive/test')
OUTPUT_DIR = Path('data/processed/ResNet50')
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
GOOD_DIR = OUTPUT_DIR / 'good'
BAD_DIR = OUTPUT_DIR / 'bad'
# Create output folders if they don't exist
GOOD_DIR.mkdir(parents=True, exist_ok=True)
BAD_DIR.mkdir(parents=True, exist_ok=True)

# Load model
model = load_model(models_dir / "resnet50_screw_finetuned_augmented.keras")

# Function to load and preprocess a single image
def load_preprocess_img(img_path, target_size=(224, 224)):
    img = image.load_img(img_path, target_size=target_size)
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array = preprocess_input(img_array)
    return img_array

# Iterate through test images and classify
for fname in os.listdir(TEST_DIR):
    fpath = os.path.join(TEST_DIR, fname)
    if not os.path.isfile(fpath):
        continue
    
    img_array = load_preprocess_img(fpath)
    pred = model.predict(img_array)
    
    # For binary classification: assuming output is sigmoid
    if pred[0][0] >= 0.5:
        dest_dir = BAD_DIR
    else:
        dest_dir = GOOD_DIR
    
    shutil.copy(fpath, os.path.join(dest_dir, fname))

print("Done! Images have been classified and saved.")
