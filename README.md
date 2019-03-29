<h1>Find-TaskServiceUser</h1>
This module is for finding scheduled tasks and system services on local or remote computer. 

<h2>Examples:</h2>
<code>Find-TaskServiceUser -Computer "WSRV00" -User "BobbyK" -Service -Task</code></br>
<code>Find-TaskServiceUser -Computer "WSRV01" -User "BobbyK" -Task -Log</code></br>
<code>"WSRV02","WSRV03" | Find-TaskServiceUser -Service -Task</code></br>
<code>"WSRV04" | Find-TaskServiceUser -Service</code></br>

