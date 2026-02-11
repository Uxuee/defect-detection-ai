import os
import sys
import subprocess
import venv
from pathlib import Path

# -----------------------------
# Configuration
# -----------------------------
VENV_DIR = "screws_venv"
REQUIREMENTS = [
    # Core
    "numpy", "pandas", "matplotlib", "tqdm", "Pillow", "pathlib",
    # TensorFlow / Keras
    "tensorflow", "scikit-learn", "scikeras", "xgboost", "lightgbm",
    # Extra for dataset
    "gdown"
]
DATA_URL = "https://drive.google.com/uc?id=1z-57McRCQ5PT6UYbF640BafBJmP3L_Jj"
DATA_PATH = Path("data/raw/anomaly_dataset.zip")
DATA_DIR = Path("data/raw")

# -----------------------------
# Helper functions
# -----------------------------
def run(cmd, check=True):
    print(f"Running: {' '.join(cmd)}")
    subprocess.run(cmd, check=check)

def safe_pip_install(pip_exe, package):
    try:
        subprocess.run([PYTHON_EXE, "-m", "pip", "install", "--upgrade", "pip"])
        subprocess.run([PYTHON_EXE, "-m", "pip", "install", package])
    except subprocess.CalledProcessError:
        print(f" Failed to install {package}, skipping.")

# -----------------------------
# Create virtual environment if not exists
# -----------------------------
if not Path(VENV_DIR).exists():
    print(f"Creating virtual environment at {VENV_DIR}...")
    venv.create(VENV_DIR, with_pip=True)
else:
    print(f"Virtual environment {VENV_DIR} already exists.")

# Determine python/pip executables inside the venv
PYTHON_EXE = Path(VENV_DIR) / "Scripts" / "python.exe"
PIP_EXE = [str(PYTHON_EXE), "-m", "pip"]

# -----------------------------
# Install all required packages
# -----------------------------
for pkg in REQUIREMENTS:
    safe_pip_install(str(PYTHON_EXE), pkg)

# -----------------------------
# Download and extract dataset
# -----------------------------
DATA_DIR.mkdir(parents=True, exist_ok=True)
try:
    import gdown
    print("Downloading dataset...")
    gdown.download(DATA_URL, str(DATA_PATH), quiet=False)
    import zipfile
    print("Extracting dataset...")
    with zipfile.ZipFile(DATA_PATH, "r") as zip_ref:
        zip_ref.extractall(DATA_DIR)
    DATA_PATH.unlink()
    print("Dataset ready!")
except Exception as e:
    print(f" Failed to download/extract dataset: {e}")

print("\n Setup complete!")
print(f"Activate your virtual environment with: {VENV_DIR}\\Scripts\\activate")
print("Then you can run your project scripts with the installed packages.")
