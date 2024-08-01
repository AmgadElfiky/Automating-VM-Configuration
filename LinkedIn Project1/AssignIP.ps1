param(
    [string]$publicIp,
    [string]$privateIp
)

Write-Output "Printing variables received from the first script:"
Write-Output "Public IP Address: $publicIp"
Write-Output "Private IP Address: $privateIp"

# Set the IP address for the PRswitch network adapter
New-NetIPAddress -InterfaceAlias "PRswitch" -IPAddress $privateIp -AddressFamily IPv4 -PrefixLength 24
New-NetIPAddress -InterfaceAlias "EXswitch" -IPAddress $publicIp -AddressFamily IPv4 -PrefixLength 24

# Disable the INswitch network adapter
Disable-NetAdapter -Name "INswitch" -Confirm:$false

Sleep 5

# Remove the getip script 
Remove-Item -Path "C:\getip.ps1" -Force

# Remove the getip script 
Remove-Item -Path "C:\AssignIP.ps1" -Force