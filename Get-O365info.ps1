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

function Show-Tenant {
    param ()
    $Tenant = Get-MsolCompanyInformation
    Write-Host "Name: " -NoNewLine
    Write-Host $Tenant.DisplayName
    Write-Host "Street: " -NoNewLine
    Write-Host $Tenant.Street
    Write-Host "PC/City: " -NoNewLine
    Write-Host $Tenant.PostalCode $Tenant.City
    Write-Host "Phone: " -NoNewLine
    Write-Host $Tenant.TelephoneNumber
    Write-Host "Adminmail: " -NoNewLine
    Write-Host $Tenant.TechnicalNotificationEmails
    Write-Host
    Write-Host "DirSync: " -NoNewline
    Write-Host $Tenant.DirectorySynchronizationEnabled
    Write-Host "DirSync status: " -NoNewline
    Write-Host $Tenant.DirectorySynchronizationStatus
    Write-Host "DirSync time: " -NoNewline
    Write-Host $Tenant.LastDirSyncTime
    Write-Host
    Write-Host "Password Sync: " -NoNewline
    Write-Host $Tenant.PasswordSynchronizationEnabled
    Write-Host "Password Sync time: " -NoNewline
    Write-Host $Tenant.LastPasswordSyncTime
    Write-Host
    Write-Host "Delegated Admin: " -NoNewline
    Write-Host $Tenant.DapEnabled
}

function MenuMain {
    param ()
    Clear-Host
    Show-Tenant
    Write-Host "`r`n 1 = List Domains, 2 = List Users, 3 = List Licenses, 4 = Exit `r`n"
    switch (Read-Host -Prompt "Choose") {
        1 { Clear-Host
            $domain = Get-MsolDomain
            foreach ($i in $domain) {
                Write-Host ($i | Format-List -Property Name, Status, VerificationMethod, IsDefault, Capabilities, Authentication | Out-String)
                Write-Host
            }
            Read-Host -Prompt "Press Enter to continue"
            MenuMain
        }
        2 { Clear-Host
            Write-Host (Get-MsolUser | Sort-Object -Property @{Expression = "IsLicensed"; Descending = $True}, @{Expression = "DisplayName"; Descending = $False} | Format-Table -Property DisplayName, SignInName, IsLicensed, UserType -AutoSize | Out-String)
            Read-Host -Prompt "Press Enter to continue"
            MenuMain
        }
        3 { Clear-Host
            Write-Host (Get-MsolAccountSku | Sort-Object | Format-Table -Property SkuPartNumber, TargetClass, ActiveUnits, ConsumedUnits, LockedOutUnits -AutoSize | Out-String)
            Read-Host -Prompt "Press Enter to continue"
            MenuMain
        }
        4 { Exit }
        Default {MenuMain}
    }    
}

MenuMain
