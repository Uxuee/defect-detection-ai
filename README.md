# Anomaly Detection Project

Reproducible, notebook-first workflow for training and evaluating anomaly detection models. The project includes a Conda environment, an automated setup script for dependencies and data, and a clean directory layout for datasets, checkpoints, and plots.

## Design Philosophy

This project emphasizes building robust machine learning systems under realistic constraints.  
Rather than relying solely on large datasets, the focus is on developing strategies that remain effective when data is limited — a common scenario in real-world industrial applications.

Key approaches explored include:

- Transfer learning from large pretrained CNNs  
- Feature extraction to maximize information from small samples  
- Cross-validation for reliable performance estimates  
- Careful model comparison to avoid overfitting  


## Key Learnings

- Classical ML performed surprisingly well when combined with CNN feature extraction.
- Gradient boosting captured nonlinear pixel relationships but struggled with rotational variance.
- Transfer learning improved feature representation but required careful fine-tuning due to dataset size.
- Dataset variability strongly impacted generalization performance.

## Quickstart

### Prerequisites
- Conda (recomended but optional: Miniconda or Anaconda)
- Bash (recomended but optional: macOS/Linux; on Windows use WSL or Git Bash)
- Git (optional, for cloning)
- JupyterLab/Notebook (installed via the provided environment)

### Dataset download link (required)

This repository does **not** include the dataset.  
To run the project, you must manually provide the dataset download link in any setup file. For example, for `setup.ps1`:

- Open `setup.ps1`
- Replace the placeholder in:
  $DATA_URL = "************"
- Run: `.\setup.ps1`
  
The dataset .zip will be downloaded into data/raw/ (relative to the folder where setup.ps1 is located) and extracted to:

```
data/raw/archive/train/good/
data/raw/archive/train/not-good/
```

Important: the dataset zip must contain the following structure:

```
archive/
  train/
    good/
    not-good/

```

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

## Future Work

- Investigate region-based object detection models (e.g., Faster R-CNN) to better capture localized defects that may be diluted in global image representations.
- Explore patch-based inference strategies where images are divided into smaller regions prior to classification.
- Develop techniques specifically tailored for small-data regimes, such as self-supervised learning and advanced data augmentation.
- Evaluate model robustness under distribution shifts to better simulate real industrial deployment conditions.




