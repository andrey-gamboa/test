# Define the URL to download CPUStres v2.0
$downloadUrl = "https://download.sysinternals.com/files/CPUSTRES.zip"  # Replace with the actual download URL

# Define the path where you want to save the downloaded file
$downloadDirectory = [System.Environment]::GetFolderPath("DesktopDirectory")
$downloadPath = Join-Path -Path $downloadDirectory -ChildPath "CPUStres_v2.0.zip"

# Define the path where you want to extract the files
$extractPath = Join-Path -Path $downloadDirectory -ChildPath "CPUStres_v2.0"

# Number of threads
$numberOfThreads = 100

# Duration to run CPUStres (in seconds)
$durationInSeconds = 60

# Download the file using Invoke-WebRequest
Write-Host "Downloading CPUStres v2.0..."
Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath

# Check if the download was successful
if (Test-Path -Path $downloadPath) {
    Write-Host "Download complete."
    
    # Extract the files
    Write-Host "Extracting files..."
    Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force
    
    # Check if extraction was successful
    if (Test-Path -Path $extractPath) {
        Write-Host "Extraction complete."
        
        # Run CPUStres with multiple instances
        for ($i = 1; $i -le $numberOfThreads; $i++) {
            $executablePath = Join-Path -Path $extractPath -ChildPath "CPUSTRES64.EXE"  # Assuming 64-bit version
            Start-Process -FilePath $executablePath -NoNewWindow
            Write-Host "Started CPUStres instance $i"
        }

        # Wait for the specified duration
        Write-Host "Waiting for $durationInSeconds seconds..."
        Start-Sleep -Seconds $durationInSeconds

        # Stop CPUStres instances
        Get-Process "CPUSTRES64" | ForEach-Object { $_.Kill() }
        Write-Host "CPUStres instances stopped."
    } else {
        Write-Host "Failed to extract files."
    }
} else {
    Write-Host "Failed to download CPUStres v2.0."
}
