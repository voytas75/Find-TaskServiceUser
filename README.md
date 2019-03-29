# Find-TaskServiceUser
It is a powershell module for searching scheduled tasks and system services on a local or remote computer that are created or run as a given user.

## Examples:
```
Find-TaskServiceUser -Computer "WSRV00" -User "BobbyK" -Service -Task
Find-TaskServiceUser -Computer "WSRV01" -User "BobbyK" -Task -Log
"WSRV02","WSRV03" | Find-TaskServiceUser -Service -Task
"WSRV04" | Find-TaskServiceUser -Service
```
