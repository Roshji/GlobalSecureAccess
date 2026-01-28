<#
.SYNOPSIS
Uninstalls the Global Secure Access Client on x64 devices

.DESCRIPTION
This PowerShell script to install the Global Secure Access Client. 
It also removes necessary registry settings for both Microsoft Edge and Google Chrome to ensure proper DNS over HTTPS functionality and restricts non-privileged users.

.VERSION
1.1.0

.AUTHOR
Remco van Diermen - RvD IT Consulting

.NOTES
- Created on: 22-10-2025
- This script is compatible with Windows 10 and later versions.

#>

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\GlobalSecureAccessUnInstall.log" -Append

# Uninstalling Global Secure Access Client

if (Test-Path "C:\Program Files\Global Secure Access Client\GlobalSecureAccessTunnelingService.exe") {
    Write-Host "Global Secure Access Client is installed. Uninstalling..."
    $process = Start-Process -FilePath "GlobalSecureAccessClient.exe" -ArgumentList "/uninstall /norestart /quiet" -Wait -PassThru
    if (($process.ExitCode -ne 0) -and ($process.ExitCode -ne 3010)) {
        Write-Host "Uninstallation of Global Secure Access Client failed with exit code: $($process.ExitCode)"
        Write-Error "Uninstallation of Global Secure Access Client failed with exit code $($process.ExitCode)"
        exit $process.ExitCode
    }
} else {
    Write-Host "GSA Client not found exiting..."
        exit 1
    }

# Global Secure Access Client uninstalled successfully

Write-Host "Global Secure Access Client Uninstalled successfully."

write-host "Removing registry keys..."

# Remove registry keys and values
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Global Secure Access Client" -Name "RestrictNonPrivilegedUsers" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters" -Name "FarKdcTimeout" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "DnsOverHttpsMode" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "BuiltInDnsClientEnabled" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "DnsOverHttpsMode" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "BuiltInDnsClientEnabled" -ErrorAction SilentlyContinue

Stop-Transcript
