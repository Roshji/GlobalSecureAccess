# Update 22-10-2025 
# Author: Remco van Diermen

# Detection script for the Global Secure Client. Includes version check and changed to dll path.
# This detection script works for x64 and ARM versions of the GSA client

# Define file paths
$gsaServicePath = "C:\Program Files\Global Secure Access Client\TrayApp\GlobalSecureAccessClient.dll"

# Define minimum required version
$requiredVersion = [version]"2.24.117.0"

# Check if GlobalSecureAccessClient.dll exists and its version
$gsaServiceExists = Test-Path -Path $gsaServicePath
$gsaServiceVersion = if ($gsaServiceExists) {
    (Get-Item $gsaServicePath).VersionInfo.FileVersion
} else {
    $null
}

# Validate conditions
if ($gsaServiceExists -and [version]$gsaServiceVersion -ge $requiredVersion) {
    exit 0
} else {
    exit 1
}
