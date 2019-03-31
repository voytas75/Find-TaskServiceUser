Function Find-TaskServiceUser {
<#
.SYNOPSIS
Finding scheduled tasks, system services on computer by user name. 
.DESCRIPTION
Finding scheduled tasks, system services on local or remote computer by given user name. 
'Administrator' and local computer are default values.
The results can be redirected to the log file (see 'log' parameter).
.PARAMETER User
User name to find scheduled tasks or system services. Default value is 'Administrator'.
.PARAMETER Computer
Computer to find tasks/services. Default value is 'localhost' ($env:COMPUTERNAME).
.PARAMETER Task
A Switch to enable finding scheduled tasks.
.PARAMETER Service
A Switch to enable finding system services.
.PARAMETER Log
A switch to enable logging of output data to a log file. The log file with the path is defined in the "LogFile" parameter.
.PARAMETER Logfile
Path with file name where logging output. Default value is [$env:TEMP]\find-taskserviceuser.log. Works only with Log switch.
.EXAMPLE
Find-TaskServiceUser -Computer "WSRV00" -User "BobbyK" -Service -Task -Log

Description
-----------
Find system services and scheduled tasks on "WSRV00" for user "BobbyK" with logging output to file.
.EXAMPLE
"WSRV01","WSRV02" | Find-TaskServiceUser -Service -Task

Description
-----------
Find system services and scheduled tasks on computers "WSRV01", "WSRV02" for user "Administrator"
.LINK
https://github.com/voytas75/Find-TaskServiceUser
.LINK
https://www.powershellgallery.com/packages/Find-TaskServiceUser
.NOTES
VERSIONS:
version 1.3.0:
- add module icon (read ICON CREDITS)
- minor changes
version 1.2.0, 30.03.2019:
- improved find of tasks
- change in grouping the results of tasks and services 
- minor changes
version 1.1.0, 30.03.2019:
- change private functions names
- minor fixes.
version 1.0.1, 29.03.2019:
- minor bug fixes.
version 1.0, 27.03.2019:
- first build of module created from function.
ICON CREDITS: Module icon made by [Freepik](https://www.freepik.com/) from [Flaticon](https://www.flaticon.com/) is licensed [CC 3.0 BY](http://creativecommons.org/licenses/by/3.0/)

#>
  [CmdletBinding()]
  Param(
    [parameter(mandatory=$false, position=0, valuefrompipeline = $true, ValueFromPipelineByPropertyName=$true, HelpMessage='Computer NetBIOS, DNS name or IP.')]
    [Alias('MachineName','Server')]
    [string[]]$Computer=$env:COMPUTERNAME,

    [parameter(Mandatory=$false, HelpMessage='User name to find services and/or tasks.')]
    [string]$User='Administrator',

    [parameter(Mandatory=$false, HelpMessage='Switch to find system services.')]
    [switch]$Service,

    [parameter(Mandatory=$false, HelpMessage='Switch to find scheduled tasks.')]
    [switch]$Task,

    [parameter(Mandatory=$false, HelpMessage='Switch to enable logging.')]
    [switch]$Log,

    [parameter(Mandatory=$false, HelpMessage='Log file path. Default is ''[$env:TEMP]\Find-TaskServiceUser.log''')]
    [string]$Logfile="$env:TEMP\Find-TaskServiceUser.log"
  )
  Begin {
    if (!$service -and !$task) {
      Write-output "You must provide 'service' or/and 'task' parameter`n"
      Write-output 'Examples:'
      Write-output '  Find-TaskServiceUser -Computer "WSRV00" -User "BobbyK" -Service -Task'
      Write-output '  Find-TaskServiceUser -Computer "WSRV01" -User "BobbyK" -Task -Log' 
      Write-output '  "WSRV00","WSRV03" | Find-TaskServiceUser -Service -Task'
      Write-output '  "WSRV04" | Find-TaskServiceUser -Service'
    } else {
      if ($user -eq "administrator") {
        Write-Output "Set default user: Administrator"
      }
      if ($computer -eq $env:COMPUTERNAME) {
        Write-output "Set default computer: $env:COMPUTERNAME (localhost)"
      }  
    }
    if ($Log) {
      Write-Log "---------$(get-date)---------"
    }
  } # end BEGIN block
  Process {
    foreach ($item in $Computer) {
      if ($service) {    
        Write-output "Finding system services with user: ""$($user.trim().toupper())"" on machine: ""$($item.trim().toupper())"""
        if ($Log) {
          Write-Log "$(get-date): Finding services with user: ""$($user.trim().toupper())"" on machine: ""$($item.trim().toupper())"""
        }
        $services = Find-ServiceUser -computer $item.Trim() -user $user
        if ($services) {
          Write-Verbose "System services were found"
          if ($Log) {
            Write-Log "$(get-date): System services:"
          }
          Write-output "Found system service(s) where ""$user"" matches 'Service Logon Account'"
          $output1 = $services | select-object SystemName,Name, StartName,State
          $output1 | Format-Table -AutoSize
          if ($Log) {
            $output1 | ForEach-Object { Write-Log $_ }            
          }
        } else {
          if ($Log) {
            Write-Log "$(get-date): No services found on computer ""$item"" for user ""$user"""
          }
          Write-output "No system services found on computer ""$item"" for user ""$user"""          
        }
      }
    } # end foreach
    foreach ($item in $Computer) {
    if ($task) {
      Write-output "Finding tasks with user: ""$($user.trim().toupper())"" on machine: ""$($item.trim().toupper())"""
      if ($Log) {
        Write-Log "$(get-date): Finding tasks with user: ""$($user.trim().toupper())"" on machine: ""$($item.trim().toupper())"""
      }
      $tasks = Find-TaskUser -server $item.trim() -user $user
      if ($tasks) {
        Write-Verbose "Scheduled tasks were found"
        if ($Log) {
          Write-Log "$(get-date): Scheduled tasks:"
        }
        Write-output "Found scheduled task(s) where ""$user"" matches task author or 'run as user'"
        $tasksdata = $tasks | Select-Object Hostname, Taskname, Author, "Run as user" 
        $tasksdata | Format-Table -AutoSize
        if ($Log) {
          $tasksdata | ForEach-Object { Write-Log $_ }
        }
        } else {
          if ($Log) {
            Write-Log "$(get-date): No scheduled tasks on computer ""$item"" for user ""$user"""
          }
          Write-output "No scheduled tasks found on computer ""$item"" for user ""$user"""
        }
      }
    } # end foreach
  } # end PROCESS block
  End {
    if ($Log) { 
      Write-output "Log File: $($Logfile)"
    }
  } # end END block
} # end Find-TaskServiceUser function
