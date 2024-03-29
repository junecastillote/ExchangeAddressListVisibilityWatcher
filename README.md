# ExchangeAddressListVisibilityWatcher
 
## SYNOPSIS
This module can be used to watch specific groups for membership changes, and then triggers the hide or unhide of the recipient object from the address lists.

## CmdLets

## GetCurrentGroupMembers
Use this command to get the current members list of the target group.

The output values are the members' ObjectGUID.

### SYNTAX
```
GetCurrentGroupMembers [-GroupID] <string>
 [<CommonParameters>]
```
## CompareGroupMembers
Command to compare the current member list and the previous member list to determine whether new members are added or removed.

### SYNTAX
```
CompareGroupMembers [-CurrentMemberList] <string[]>
 [-PreviousMemberList] <string[]> [<CommonParameters>]
```

## HideFromGal
Command to hide recipient object from the address list

### SYNTAX
```
HideFromGal [-HideList] <string[]>
 [<CommonParameters>]
```

## UnHideFromGal
Command to unhide recipient object from the address list

### SYNTAX
```
UnHideFromGal [-HideList] <string[]>
 [<CommonParameters>]
```

## UpdateAddressListVisibility
The main command to execute to perform the update workflow.

This also has the option to trigger an update of the Global Address List.

### SYNTAX
```
UpdateAddressListVisibility [-GroupID] <string>
 [-HistoryFile] <string>
 [-UpdatelGlobalAddressList]
 [<CommonParameters>]
```

## DESCRIPTION
You need to be assigned permissions before you can use this function properly. This module requires the ActiveDirectory Module and the Microsoft.Exchange.Management.PowerShell.E2010 Snap-In - which is included in the Exchange Management Tools.

## HOW TO INSTALL
You can install this several ways

### MANUAL FROM GITHUB
1. Download the code (zip)
2. Extract to your chosen $env:PSModulePath
    - (eg. C:\Program Files\WindowsPowerShell\Modules)
3. The folder structure must be "\ExchangeAddressListVisibilityWatcher\<version>"
    - (eg. C:\Program Files\WindowsPowerShell\Modules\ExchangeAddressListVisibilityWatcher\1.0)

![Module Install Path](images/module-install-path.png)

### ONLINE FROM POWERSHELL GALLERY
If you have PowerShell version 5.0+
```
Install-Module -Name ExchangeAddressListVisibilityWatcher
```

### VERIFY INSTALLATION
```
Get-Module ExchangeAddressListVisibilityWatcher -ListAvailable
```

![Verify Installation](images/module-install-verify.png)


## HOW TO USE
### Create initial membership history file
```
GetCurrentGroupMembers -GroupID GroupA | Out-File C:\history\GroupA-History.txt
```

Under normal circumstances, you only this to do this once for each group you want to watch.
This example gets the member list of the group GroupA and save to file C:\history\GroupA-History.txt
![History File](images/history-file-example.png)

### Run the update
```
UpdateAddressListVisibility -GroupID GroupA -HistoryFile C:\history\GroupA-History.txt
```

This example gets the current members of GroupA, compare it with the previous member list GroupA, and then perform the hide or unhide depending on membership changes.

#### Example run with no changes
![Without Change](images/without-change-example.png)

#### Example run with changes
![With Change](images/hide-unhide-example.png)



https://lazyexchangeadmin.com