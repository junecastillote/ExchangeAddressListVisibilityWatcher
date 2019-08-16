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

