# Find-TaskServiceUser
It is a powershell module for searching scheduled tasks and system services on a local or remote computer that are created or run as a given user.

## Examples:

```
Find-TaskServiceUser -Computer "WSRV00" -User "BobbyK" -Service -Task -Log
```
Find system services and scheduled tasks on "WSRV00" for user "BobbyK" with logging output to file.


```
"WSRV01","WSRV02" | Find-TaskServiceUser -Service -Task
```
Find system services and scheduled tasks on computers "WSRV01", "WSRV02" for user "Administrator"


```
"WSRV02","WSRV03" | Find-TaskServiceUser -Service -Task
"WSRV04" | Find-TaskServiceUser -Service
```


   

