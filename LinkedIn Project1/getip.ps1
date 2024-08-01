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

# URL of the NGINX server serving the JSON data
$jsonUrl = "http://10.0.0.1:88"

try {
    # Fetch JSON data from NGINX
    $response = Invoke-RestMethod -Uri $jsonUrl -Method Get -ContentType "application/json"

    # Parse JSON data and store values in variables
    $publicIp = $response.public
    $privateIp = $response.private

    Start-Process powershell.exe -ArgumentList "-File C:\Users\Amgad\Desktop\AssignIP.ps1", "-publicIp", $publicIp, "-privateIp", $privateIp -NoNewWindow -Wait

} catch {
    Write-Error "Failed to fetch JSON data from $jsonUrl : $_"
}
