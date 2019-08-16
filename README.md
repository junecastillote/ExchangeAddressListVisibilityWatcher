# ExchangeAddressListVisibilityWatcher
 
## SYNOPSIS
This module can be used to watch specific groups for membership changes, and then triggers the hide or unhide of the recipient object from the address lists.

## CmdLets

## GetCurrentGroupMembers
Use this command to get the current members list of the target group.

The output values are the members' ObjectGUID.

### SYNTAX
```
GetCurrentGroupMembers [-GroupID] <string> [<CommonParameters>]

