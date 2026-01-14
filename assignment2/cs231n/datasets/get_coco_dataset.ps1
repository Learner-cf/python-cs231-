# powershell
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Change to script directory to ensure relative paths are correct
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
if ($scriptDir) { Set-Location $scriptDir }

$dir = 'coco_captioning'
$zip = 'coco_captioning.zip'
$url = 'http://cs231n.stanford.edu/coco_captioning.zip'

if (-not (Test-Path -Path $dir -PathType Container)) {
    Write-Host "Directory ${dir} does not exist, starting download..."
    try {
        Invoke-WebRequest -Uri $url -OutFile ${zip} -ErrorAction Stop
        Write-Host "Download completed: ${zip}"
    } catch {
        Write-Error "Download failed: $($_.Exception.Message)"
        exit 1
    }

    try {
        Write-Host "Extracting ${zip} ..."
        Expand-Archive -LiteralPath ${zip} -DestinationPath . -Force
        Write-Host "Extraction completed."
    } catch {
        Write-Error "Extraction failed: $($_.Exception.Message)"
        exit 1
    }

    try {
        Remove-Item -LiteralPath ${zip} -Force
        Write-Host "Removed ${zip}."
    } catch {
        Write-Warning "Failed to remove ${zip}: $($_.Exception.Message)"
    }
} else {
    Write-Host "Directory ${dir} already exists, skipping download and extract."
}
