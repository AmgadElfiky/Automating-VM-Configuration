# Variables Section
# Name of VM
$vm = "Template-2"
# Name of new private vswitch
$PRswitch = "PrivateSwitch"
# Name of new internal vswitch
$INswitch = "InternalSwitch"
# Name of new external vswitch
$EXswitch = "ExternalSwitch"
# Number of CPUs
$cpu = 2
# RAM of VM
$ram = 2GB
# VM storage
$disk_size = 100GB

# PowerShell Commands Section
# Check if the private switch exists, create it if it doesn't
if (-not (Get-VMSwitch -Name $PRswitch -ErrorAction SilentlyContinue)) {
    New-VMSwitch -Name $PRswitch -SwitchType Private
}
else {
    # Print in console
    Write-Host "Private virtual switch '$PRswitch' already exists."
}

# Check if the internal switch exists, create it if it doesn't
if (-not (Get-VMSwitch -Name $INswitch -ErrorAction SilentlyContinue)) {
    New-VMSwitch -Name $INswitch -SwitchType Internal
}
else {
    # Print in console
    Write-Host "Internal virtual switch '$INswitch' already exists."
}

# Check if the external switch exists, create it if it doesn't
if (-not (Get-VMSwitch -Name $EXswitch -ErrorAction SilentlyContinue)) {
    # Replace 'Ethernet' with the actual name of your external network adapter
    New-VMSwitch -Name $EXswitch -NetAdapterName "Ethernet" -AllowManagementOS $true
}
else {
    # Print in console
    Write-Host "External virtual switch '$EXswitch' already exists."
}

# Check if the VM with the same name exists, print a message if it does
if (Get-VM -Name $vm -ErrorAction SilentlyContinue) {
    Write-Host "VM '$vm' already exists. Skipping VM creation."
}
else {
    Write-Host "Creating VM"
    # Create a new Generation 2 VM
    New-VM -Name $vm -Generation 2 -MemoryStartupBytes $ram -SwitchName $INswitch -VHDPath "D:\Template\Template-disk3.vhdx"

    # Set the CPU count
    Set-VMProcessor -VMName $vm -Count $cpu

    # Check if the VM has any network adapters and remove them if they exist
    $adapters = Get-VMNetworkAdapter -VMName $vm
    if ($adapters) {
        $adapters | Remove-VMNetworkAdapter
    }

    # Add a new NIC to the VM and connect it to the private switch
    Add-VMNetworkAdapter -VMName $vm -SwitchName $PRswitch -Name "PRswitch" -DeviceNaming On
    # Add a new NIC to the VM and connect it to the internal switch
    Add-VMNetworkAdapter -VMName $vm -SwitchName $INswitch -Name "INswitch" -DeviceNaming On
    # Add a new NIC to the VM and connect it to the external switch
    Add-VMNetworkAdapter -VMName $vm -SwitchName $EXswitch -Name "EXswitch" -DeviceNaming On

    # Start the VM
    Start-VM $vm
}
