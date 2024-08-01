Add-Type -AssemblyName System.Windows.Forms

# Function to show the form and get user input
function Show-UserForm {
    param (
        [ref]$password
    )

    # Create a new form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Change Admin Password'
    $form.Width = 330
    $form.Height = 270
    $form.StartPosition = 'CenterScreen'

    # Create a label for the message
    $messageLabel = New-Object System.Windows.Forms.Label
    $messageLabel.Text = 'Please enter the new Administartor password'
    $messageLabel.AutoSize = $true
    $messageLabel.Top = 20
    $messageLabel.Left = 40
    $form.Controls.Add($messageLabel)

    # Create a label and textbox for password
    $passwordLabel = New-Object System.Windows.Forms.Label
    $passwordLabel.Text = 'Password:'
    $passwordLabel.AutoSize = $true
    $passwordLabel.Top = 60
    $passwordLabel.Left = 50
    $form.Controls.Add($passwordLabel)

    $passwordTextbox = New-Object System.Windows.Forms.TextBox
    $passwordTextbox.Width = 200
    $passwordTextbox.Top = 80
    $passwordTextbox.Left = 50
    $passwordTextbox.UseSystemPasswordChar = $true
    $form.Controls.Add($passwordTextbox)

    # Create a label and textbox for password confirmation
    $confirmPasswordLabel = New-Object System.Windows.Forms.Label
    $confirmPasswordLabel.Text = 'Confirm Password:'
    $confirmPasswordLabel.AutoSize = $true
    $confirmPasswordLabel.Top = 120
    $confirmPasswordLabel.Left = 50
    $form.Controls.Add($confirmPasswordLabel)

    $confirmPasswordTextbox = New-Object System.Windows.Forms.TextBox
    $confirmPasswordTextbox.Width = 200
    $confirmPasswordTextbox.Top = 140
    $confirmPasswordTextbox.Left = 50
    $confirmPasswordTextbox.UseSystemPasswordChar = $true
    $form.Controls.Add($confirmPasswordTextbox)

    # Create an OK button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = 'OK'
    $okButton.Top = 180
    $okButton.Left = 120
    $okButton.Add_Click({
        if ($passwordTextbox.Text -ne $confirmPasswordTextbox.Text) {
            [System.Windows.Forms.MessageBox]::Show("Passwords do not match. Please try again.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        } elseif (-not ($passwordTextbox.Text -match '[A-Z]') -or -not ($passwordTextbox.Text -match '[a-z]') -or -not ($passwordTextbox.Text -match '\d') -or ($passwordTextbox.Text.Length -lt 8)) {
            [System.Windows.Forms.MessageBox]::Show("Password must contain at least one uppercase letter, one lowercase letter, and one number and be at least 8 characters long. Please try again.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        } else {
            $password.Value = $passwordTextbox.Text
            $form.Close()
        }

    })
    $form.Controls.Add($okButton)

    # Show the form
    $form.ShowDialog()
}

# Initialize variables to store user input
$password = [ref]"" 

# Loop to show the form until valid input is provided
do {
    Show-UserForm -password $password
} while (-not $password.Value)

# Change Admin password
$securePassword = ConvertTo-SecureString $password.Value -AsPlainText -Force
Get-LocalUser -Name "Administrator" | Set-LocalUser -Password $securePassword

# Delay to ensure the user sees the password change confirmation
Start-Sleep -Seconds 3

# Remove registry entries related to automatic logon
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultPassword" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultUserName" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -ErrorAction SilentlyContinue

Start-Process powershell.exe -ArgumentList "-File C:\getip.ps1" -NoNewWindow -Wait

# Remove the script from the Startup folder
Remove-Item -Path "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\*" -Force

# Remove the getip script 
Remove-Item -Path "C:\getip.ps1" -Force

# Remove the script itself
Remove-Item -Path $MyInvocation.MyCommand.Path -Force

