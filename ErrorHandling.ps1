# Stop the script
Get-Process "test" -ErrorAction Stop

# Continue without showing error message
Get-Process "test" -ErrorAction SilentlyContinue

# Continue and get error message
Get-Process "test" -ErrorAction SilentlyContinue -ErrorVariable errorMessage
Write-Host $errorMessage

# try/catch
try {
    Get-Process "test" -ErrorAction Stop
}
catch {
    Write-Host "Process not found"
}
