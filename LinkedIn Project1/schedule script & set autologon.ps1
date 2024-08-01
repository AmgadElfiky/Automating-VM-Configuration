# Path to the PowerShell script for which you want to create a shortcut
$targetScript = "C:\getScript.ps1"

# Path where you want to create the shortcut (.lnk file)
$shortcutPath = "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\change.lnk"

# Create a WScript Shell object
$WScriptShell = New-Object -ComObject WScript.Shell

# Create a shortcut object
$shortcut = $WScriptShell.CreateShortcut($shortcutPath)

# Set properties for the shortcut
$shortcut.TargetPath = "powershell.exe"  # PowerShell executable path
$shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$targetScript`""  # Arguments for running the script
$shortcut.Description = "Shortcut to Your PowerShell Script"  # Description for the shortcut
$shortcut.Save()  # Save the shortcut


Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultUserName" -Value "Administrator"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultPassword" -Value "Qazwsx12"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -Value "1"