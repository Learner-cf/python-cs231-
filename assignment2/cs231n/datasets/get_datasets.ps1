# powershell
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$dir = "cifar-10-batches-py"
$tar = "cifar-10-python.tar.gz"
$cifarUrl = "http://www.cs.toronto.edu/~kriz/cifar-10-python.tar.gz"
$imagenetUrl = "http://cs231n.stanford.edu/imagenet_val_25.npz"

# Change to script directory to ensure relative paths are correct
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
if ($scriptDir) { Set-Location $scriptDir }

if (-not (Test-Path -Path $dir -PathType Container)) {
    Write-Host "Directory ${dir} does not exist, starting CIFAR-10 download..."
    try {
        Invoke-WebRequest -Uri $cifarUrl -OutFile ${tar} -ErrorAction Stop
        Write-Host "Download completed: ${tar}"
    } catch {
        Write-Error "Download failed: $($_.Exception.Message)"
        exit 1
    }

    Write-Host "Extracting ${tar}..."
    try {
        if (Get-Command tar -ErrorAction SilentlyContinue) {
            & tar -xzf ${tar}
        } elseif (Get-Command 7z -ErrorAction SilentlyContinue) {
            # 7-Zip extraction: first extract .tar, then extract files inside
            & 7z x ${tar} -y | Out-Null
            $innerTar = [IO.Path]::ChangeExtension(${tar}, ".tar")
            if (Test-Path $innerTar) {
                & 7z x $innerTar -y | Out-Null
                Remove-Item $innerTar -Force
            }
        } else {
            Write-Error "No archive tool found. Install `tar` or `7z` (7-Zip)."
            exit 1
        }
        Write-Host "Extraction completed."
    } catch {
        Write-Error "Extraction failed: $($_.Exception.Message)"
        exit 1
    }

    try {
        Remove-Item -LiteralPath ${tar} -Force
        Write-Host "Removed ${tar}."
    } catch {
        Write-Warning "Failed to remove ${tar}: $($_.Exception.Message)"
    }

    Write-Host "Starting download of imagenet_val_25.npz..."
    try {
        Invoke-WebRequest -Uri $imagenetUrl -OutFile "imagenet_val_25.npz" -ErrorAction Stop
        Write-Host "Download completed: imagenet_val_25.npz"
    } catch {
        Write-Error "Download of imagenet_val_25.npz failed: $($_.Exception.Message)"
        exit 1
    }
} else {
    Write-Host "Directory ${dir} already exists, skipping download and extract."
}
