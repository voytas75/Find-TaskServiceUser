# Find-TaskServiceUser
It is a powershell module for searching scheduled tasks and system services on a local or remote computer that are created or run as a given user.

## Examples:
1. Find system services and scheduled tasks on "WSRV00" for user "BobbyK" with logging output to a file:
```
Find-TaskServiceUser -Computer "WSRV00" -User "BobbyK" -Service -Task -Log
```
2. Find system services and scheduled tasks on computers "WSRV01", "WSRV02" for user "Administrator":
```
"WSRV01","WSRV02" | Find-TaskServiceUser -Service -Task
```
3. Find system services and scheduled tasks on computers "WSRV01", "WSRV02", "WSRV03" for user "BobbyK":
```
@("WSRV01","WSRV02"), "WSRV03" | Find-TaskServiceUser -Task - User "BobbyK"
```

   

