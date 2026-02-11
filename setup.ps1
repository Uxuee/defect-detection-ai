# ============================================================
# setup.ps1 - Setup anomaly detection project (Conda or venv)
# ============================================================

Write-Host "Setting up anomaly detection project..." -ForegroundColor Cyan
$ErrorActionPreference = "Stop"

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $ScriptDir

# Dataset URL and path
$DATA_URL = "https://drive.google.com/uc?id=1z-57McRCQ5PT6UYbF640BafBJmP3L_Jj"
$OUTPUT_PATH = "data/raw/anomaly_dataset.zip"

# Create folder if missing
if (-Not (Test-Path "data/raw")) { New-Item -ItemType Directory -Path "data/raw" | Out-Null }

# Function to install pip packages safely
function Safe-PipInstall {
    param([string]$package)
    try {
        & $PythonPath -m pip install --upgrade pip
        & $PythonPath -m pip install $package
    } catch {
        Write-Host " Failed to install $package, skipping..." -ForegroundColor Yellow
    }
}

# Function to download dataset
function Download-Dataset {
    Write-Host "Downloading dataset..." -ForegroundColor Yellow
    Safe-PipInstall "gdown"
    try {
        & $PythonPath -m gdown $DATA_URL -O $OUTPUT_PATH
        Write-Host "Extracting dataset..." -ForegroundColor Yellow
        Expand-Archive -Path $OUTPUT_PATH -DestinationPath "data/raw/" -Force
        Remove-Item $OUTPUT_PATH
        Write-Host "Dataset ready!" -ForegroundColor Green
    } catch {
        Write-Host " Failed to download/extract dataset." -ForegroundColor Yellow
    }
}

# Check if conda exists
$CondaExists = Get-Command conda -ErrorAction SilentlyContinue

if ($CondaExists) {
    Write-Host "Conda detected! Using conda environment..." -ForegroundColor Cyan
    $EnvName = "screws"

    # Create/update environment
    try {
        conda env create -f environment.yml
    } catch {
        Write-Host "Environment already exists or creation failed, updating..." -ForegroundColor Yellow
        conda env update -f environment.yml --prune
    }

    # Set Python path inside conda environment
    $PythonPath = "conda run -n $EnvName python"

    # Install extra pip packages and download dataset
    Download-Dataset

    Write-Host " Setup complete! Activate your environment with: conda activate $EnvName" -ForegroundColor Green
} else {
    Write-Host "Conda not found. Falling back to Python venv..." -ForegroundColor Cyan

    # Check if Python exists
    $PythonExists = Get-Command python -ErrorAction SilentlyContinue
    if (-Not $PythonExists) {
        Write-Host "Python is not installed. Please install Python 3.9+ first." -ForegroundColor Red
        Read-Host "Press Enter to exit..."
        exit
    }

    # Create virtual environment
    $VenvPath = "screws_venv"
    Write-Host "Creating virtual environment at $VenvPath..." -ForegroundColor Yellow
    python -m venv $VenvPath

    # Activate venv
    $PythonPath = "$VenvPath\Scripts\python.exe"

    # Install requirements if requirements.txt exists
    if (Test-Path "requirements.txt") {
        try {
            & $PythonPath -m pip install --upgrade pip
            & $PythonPath -m pip install -r requirements.txt
        } catch {
            Write-Host " Some packages in requirements.txt failed to install, continuing..." -ForegroundColor Yellow
        }
    }

    # Install extra pip packages and download dataset
    Download-Dataset

    Write-Host " Setup complete! Virtual environment is in $VenvPath" -ForegroundColor Green
}

Write-Host "Press Enter to exit..." -ForegroundColor Cyan
Read-Host
