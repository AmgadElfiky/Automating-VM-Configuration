# Changing name of adapters
$adapterProperties = Get-NetAdapterAdvancedProperty | Where-Object { $_.DisplayName -eq "Hyper-V Network Adapter Name" }
foreach ($adapterProperty in $adapterProperties) {
    $Name = $adapterProperty.Name
    $DisplayValue = $adapterProperty.DisplayValue
    Rename-NetAdapter -Name $Name -NewName $DisplayValue
}

# Set IP address on the adapter
New-NetIPAddress -InterfaceAlias "INswitch" -IPAddress "10.0.0.2" -AddressFamily IPv4 -PrefixLength 24

Sleep 5

# Define the URL to request and the output file path
$url = "http://10.0.0.1:91/"
$outputFile = "C:\settings.ps1"

# Send the HTTP GET request
$response = Invoke-WebRequest -Uri $url

# Save the response content to the output file
$response.Content | Out-File -FilePath $outputFile -Encoding utf8
Write-Output "Response saved to $outputFile"

# Wait for 3 seconds
Start-Sleep -Seconds 3

# Execute the downloaded PowerShell script
Start-Process powershell.exe -ArgumentList "-File C:\settings.ps1" -NoNewWindow -Wait
