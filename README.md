# Anomaly Detection Project

Reproducible, notebook-first workflow for training and evaluating anomaly detection models. The project includes a Conda environment, an automated setup script for dependencies and data, and a clean directory layout for datasets, checkpoints, and plots.

## Quickstart

### Prerequisites
- Conda (recomended but optional: Miniconda or Anaconda)
- Bash (recomended but optional: macOS/Linux; on Windows use WSL or Git Bash)
- Git (optional, for cloning)
- JupyterLab/Notebook (installed via the provided environment)

### Setup Instructions

This project can be set up in **three ways**, depending on your system and whether you have Conda installed.

---

#### **Option 1 — Using Conda (recommended if available)**

```
# On Linux / macOS / Git Bash on Windows
bash setup.sh
```

**What it does:**

* Creates a Conda environment from `environment.yml` (`screws`)
* Installs all packages listed in `environment.yml`
* Installs `gdown` to download the dataset
* Downloads and extracts the dataset to `data/raw/`

**To activate the environment:**

```
# on a cmd
conda activate screws
```

Then you can run the project scripts.

---

### **Option 2 — Using PowerShell (Windows)**

```
# In PowerShell
.\setup.ps1
```

**What it does:**

* Detects if Conda is available:

  * If yes, behaves like Option 1
  * If no, creates a Python virtual environment (`screws_venv`)
* Installs required packages using pip
* Downloads and extracts the dataset to `data/raw/`

**To activate the environment:**

```
# In Powershell
screws_venv\Scripts\activate
```

---

### **Option 3 — Pure Python fallback (any OS, no Conda needed)**

```
python setup.py
```

**What it does:**

* Creates a Python virtual environment (`screws_venv`) if it doesn’t exist
* Installs essential packages via pip:

  * TensorFlow, Keras, scikit-learn, XGBoost, LightGBM
  * Core libraries: numpy, pandas, matplotlib, tqdm, Pillow, pathlib
  * `gdown` to download dataset
* Downloads and extracts the dataset to `data/raw/`

**After setup:**

```
# Activate venv
screws_venv\Scripts\activate
```

---

####  Notes

* If a package fails to install, the scripts continue with the next package.
* Make sure Python 3.9+ is installed for Options 2 & 3.
* The dataset is automatically downloaded to `data/raw/`.


## Usage

### Notebooks and scripts

   - `notebooks/main.ipynb`
        Main training and evaluation pipeline (uses K-Fold CV, multiple models)
   - `notebooks/exploration.ipynb` 
        Optional exploratory analysis of data
   - `notebooks/myTest.ipynb` 
        Evaluation of the model performance in the test data
   - `scripts/classificationResNet.nb`
        Ready-to-run ResNet50 test script — applies the fine-tuned model to test data and automatically separates images into good and bad folders

---

#### Notes
If you only want to test the final model, use scripts/classificationResNet.nb


## Project Structure

```
anomaly_detection_project/
│
├── README.md
├── environment.yml                 # Conda environment definition
├── requirement.txt                 # dependencies in txt format
├── setup.sh                        # Script to auto-download dependencies
├── setup.ps1                        # Script to auto-download dependencies
├── setup.py                        # Script to auto-download dependencies
│
├── data/
│   ├── raw/                        # Where dataset will be downloaded
│   ├── processed/                  # After preprocessing 
│
├── checkpoints/                    # Saved models
│
├── notebooks/
│   ├── exploration.ipynb           # Optional: initial data exploration
│   ├── main.ipynb                  # Main training/evaluation pipeline
│   └── myTest.ipynb                # Evaluation of the model performance on test data
│
├── plots/                          # Produced plots
│
├── scripts/
│   └── classificationResNet.nb     # script to classificate the test images
```

## Model Development Pipeline

1. Data preprocessing

2. K-Fold cross-validation for all models

3. Machine Learning models:
Random Forest, SVM (RBF), Logistic Regression, XGBoost, LightGBM

4. Feature extraction:
CNN-based extractor applied to all ML models

5. Deep Learning models:
Simple Neural Network (baseline)

6. Pretrained CNNs (ResNet50, EfficientNet) with fine-tuning

7. Hyperparameter tuning

8. Final testing on manually labeled dataset

## Configuration

- Environment: managed via `environment.yml`. If you change dependencies, update and re-export:
  ```
  conda env export --no-builds > environment.yml
  ```
- Notebook parameters (e.g., data paths, thresholds, seeds) are set at the top of each notebook. Consider centralizing common settings in one cell for easy tweaks.



