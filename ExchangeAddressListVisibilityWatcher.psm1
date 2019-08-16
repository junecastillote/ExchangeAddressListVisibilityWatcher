<#
    Function to get the current member list of the target group.
    Use this to create an initial history file (eg. GetCurrentGroupMembers -GroupID <group> | Out-File <group>-history.txt)
#>
Function GetCurrentGroupMembers {
    [CmdletBinding()]
    param (
        [parameter(Mandatory, Position = 0)]
        [string]$GroupID
    )
    try {
        $group = Get-AdGroup $GroupID -Properties *
        $members = $group.Member | ForEach-Object { (Get-ADObject $_).ObjectGUID.Guid }
        return $members
    }
    catch {
        Write-Host (Get-Date -Format g) ": $($_.Exception.Message)"
        return $null
    }
}

<#
    Function to compare the current group members against the members listed in the group's history file
    to determine the new and removed members.
#>
Function CompareGroupMembers {
    [CmdletBinding()]
    param (
        [parameter(Mandatory, Position = 0)]
        [string[]]$CurrentMemberList,
    
        [parameter(Mandatory, Position = 1)]
        [string[]]$PreviousMemberList
    )
   
    $actionables = New-Object psobject -Property  @{
        Add    = ($CurrentMemberList | Where-Object { $PreviousMemberList -notcontains $_ })
        Remove = ($PreviousMemberList | Where-Object { $CurrentMemberList -notcontains $_ })
    }
    return $actionables
}

<#
    Function to Unhide object from the Address List
#>
Function UnhideFromGAL {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string[]]$UnhideList
    )
    foreach ($item in $UnhideList ) {
        try {        
            Write-Host (Get-Date -Format g) ": UnHide - $item"
            Set-AdObject $item -Replace @{msExchHideFromAddressLists = $false }
        }
        catch {
            Write-Host (Get-Date -Format g) ": $($_.Exception.Message)  - $item"
        }
    }
}

<#
    Function to Hide object from the Address List
#>
Function HideFromGal {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string[]]$HideList
    )
    foreach ($item in $HideList ) {
        try {
            Write-Host (Get-Date -Format g) ": Hide - $item"
            Set-AdObject $item -Replace @{msExchHideFromAddressLists = $true }
        }
        catch {
            Write-Host (Get-Date -Format g) ": $($_.Exception.Message) - $item"
        }
        
    }
}
<#
    Main function that put the module together.
#>
Function UpdateAddressListVisibility {
    [CmdletBinding()]
    param (
        [parameter(Mandatory, Position = 0)]
        [string]$GroupID,

        [parameter(Mandatory, Position = 1)]
        [string]$HistoryFile,

        [parameter()]
        [switch]$UpdatelGlobalAddressList
    )

    #Check if history file exists
    if (!(Test-Path $HistoryFile)) {
        Write-Host (Get-Date -Format g) ": File $HistoryFile cannot be found. Please provide the correct path."
        return $null
    }
    else {
        Write-Host (Get-Date -Format g) ": Import history"
        $PreviousMemberList = Get-Content $HistoryFile
    }

    $CurrentMemberList = GetCurrentGroupMembers $GroupID

    if ($CurrentMemberList) {
        $updates = CompareGroupMembers $CurrentMemberList $PreviousMemberList
    }
    else {
        Write-Host (Get-Date -Format g) ": No members."
        return $null
    }

    if ($updates.Add) {
        Write-Host (Get-Date -Format g) ": Found $($updates.Add.count) to Hide"
        foreach ($i in $updates.Add) {
            HideFromGal $i
        }
    }
    else {
        Write-Host (Get-Date -Format g) ": Nothing to Hide"
    }

    if ($updates.Remove) {
        Write-Host (Get-Date -Format g) ": Found $($updates.Remove.count) to Unhide"
        foreach ($i in $updates.Remove) {
            UnhideFromGAL $i
        }
    }
    else {
        Write-Host (Get-Date -Format g) ": Nothing to Unhide"
    }

    if ($UpdatelGlobalAddressList) {
        try {
            Write-host (Get-Date -Format g) ": Trying to update Global Address List"
            Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010
            Get-GlobalAddressList | Update-GlobalAddressList
        }
        catch {
            Write-Host (Get-Date -Format g) ": $($_.Exception.Message)"
        }
    }

    #Save current memberlist in history
    $CurrentMemberList | Out-File $HistoryFile
}

