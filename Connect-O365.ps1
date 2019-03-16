if (Get-Module -ListAvailable -Name MSOnline) {
    Import-Module -Name MSOnline
}
else {
    Write-Host "MSOnline module not installed, use 'Install-Module -Name MSOnline' in elevated PowerShell"
    Break
}
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList (Read-Host -Prompt "Username"),(Read-Host -Prompt "Password" -AsSecureString)
try {
    Connect-MsolService -Credential $Credential -EA Stop
}
catch { 
    $ErrorMessage = $_.Exception.Message
    Write-Host "Error message: $ErrorMessage" -ForegroundColor Black -BackgroundColor Red
    Break    
} 