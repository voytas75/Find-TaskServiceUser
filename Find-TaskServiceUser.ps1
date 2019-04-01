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
.PARAMETER Minimal
A switch to enable minimalistic results. Object containing the computer name, number of tasks and/or number of services only. With -Log information about log file path is displayed but log file is not minimal. The return value is en object.
.PARAMETER Log
A switch to enable logging of output data to a log file. The log file with the path is defined in the "LogFile" parameter.
.PARAMETER Logfile
Path with file name where logging output. Default value is [$env:TEMP]\find-taskserviceuser.log. Works only with Log switch.
.EXAMPLE
PS> Find-TaskServiceUser -Computer "WSRV00" -User "BobbyK" -Service -Task -Log

Description
-----------
Find system services and scheduled tasks on "WSRV00" for user "BobbyK" with logging output to file.
.EXAMPLE
PS> "WSRV01","WSRV02" | Find-TaskServiceUser -Service -Task

Description
-----------
Find system services and scheduled tasks on computers "WSRV01", "WSRV02" for user "Administrator"
.LINK
https://github.com/voytas75/Find-TaskServiceUser
.LINK
https://www.powershellgallery.com/packages/Find-TaskServiceUser
.NOTES
ICON CREDITS: Module icon made by [Freepik](https://www.freepik.com/) from [Flaticon](https://www.flaticon.com/) is licensed [CC 3.0 BY](http://creativecommons.org/licenses/by/3.0/)

#>
  [CmdletBinding()]
  Param(
    [parameter(mandatory=$false, position=0, valuefrompipeline = $true, ValueFromPipelineByPropertyName=$true, HelpMessage='Computer NetBIOS, DNS name or IP.')]
    [Alias('MachineName','Server')]
    [string[]]$Computer=$env:COMPUTERNAME,

    [parameter(Mandatory=$false, HelpMessage='User or group name to find scheduled tasks and/or services. Group is used for the security context of the scheduled task only, not system services.')]
    [string]$User='Administrator',

    [parameter(Mandatory=$false, HelpMessage='Switch to find system services.')]
    [switch]$Service,

    [parameter(Mandatory=$false, HelpMessage='Switch to find scheduled tasks.')]
    [switch]$Task,

    [parameter(Mandatory=$false, HelpMessage='Minimalistic results. Object containing the computer name, number of tasks and/or number of services only. with -Log info about log file is displayed but log file is not minimal.')]
    [switch]$Minimal,

    [parameter(Mandatory=$false, HelpMessage='Switch to enable logging.')]
    [switch]$Log,

    [parameter(Mandatory=$false, HelpMessage='Log file path. Default is ''[$env:TEMP]\Find-TaskServiceUser.log''.')]
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
      if (!$Minimal) {
        if ($user -eq "administrator") {
          Write-Output "Set default user: Administrator"
        }
        if ($computer -eq $env:COMPUTERNAME) {
          Write-output "Set default computer: $env:COMPUTERNAME (localhost)"
        }  
      }
    }
    if ($Minimal) {
      Write-Verbose "Initializing minimalistic results."
      $minimal_obj = @()
      $s=0
      $t=0
      $services_count = $s
      $tasks_count = $t
    }
    if ($Log) {
      Write-Log "---------$(get-date)---------"
    }
  } # end BEGIN block
  Process {
    foreach ($item in $Computer) {
      if ($service) {    
        if (!$Minimal) {
          Write-output "Finding system services with user: ""$($user.trim().toupper())"" on machine: ""$($item.trim().toupper())"""
        }
        if ($Log) {
          Write-Log "$(get-date): Finding services with user: ""$($user.trim().toupper())"" on machine: ""$($item.trim().toupper())"""
        }
        $services = Find-ServiceUser -computer $item.Trim() -user $user
        if ($services) {
          if ($Log) {
            Write-Log "$(get-date): System services:"
          }
          $output1 = $services | select-object SystemName,Name, StartName,State
          if ($Minimal) {
            $services_count = ($services | Measure-Object).count
          } else {
            Write-output "Found system service(s) where ""$user"" matches 'Service Logon Account'"
            $output1 | Format-Table -AutoSize
          }
          if ($Log) {
            $output1 | ForEach-Object { Write-Log $_ }            
          }
        } else {
          if ($Log) {
            Write-Log "$(get-date): No services found on computer ""$item"" for user ""$user"""
          }
          if ($Minimal) {
            $services_count = $s
          } else {
            Write-output "No system services found on computer ""$item"" for user ""$user"""          
          }
        }
      }
      if ($task) {
        if (!$Minimal) {
          Write-output "Finding tasks with user: ""$($user.trim().toupper())"" on machine: ""$($item.trim().toupper())"""
        }
        if ($Log) {
          Write-Log "$(get-date): Finding tasks with user: ""$($user.trim().toupper())"" on machine: ""$($item.trim().toupper())"""
        }
        $tasks = Find-TaskUser -server $item.trim() -user $user
        if ($tasks) {
          if ($Log) {
            Write-Log "$(get-date): Scheduled tasks:"
          }
          $tasksdata = $tasks | Select-Object Hostname, Taskname, Author, "Run as user", URI
          if ($Minimal) {
            $tasks_count = ($tasks | Measure-Object).count
          } else {
            Write-output "Found scheduled task(s) where ""$user"" matches task author or 'run as user'"
            $tasksdata | Format-Table -AutoSize
          }
          if ($Log) {
            $tasksdata | ForEach-Object { Write-Log $_ }
          }
          } else {
            if ($Log) {
              Write-Log "$(get-date): No scheduled tasks on computer ""$item"" for user ""$user"""
            }
            if ($Minimal) {
              $tasks_count = $t
            } else {
              Write-output "No scheduled tasks found on computer ""$item"" for user ""$user"""
            }
          }
        }
        if (!$tasks) {
          $tasks_count = $null
        }
        if (!$services) {
          $services_count = $null
        }
        if ($Minimal) {
          $minimal_obj += [PSCustomObject]@{
            ComputerName  = $item
            Services      = $services_count
            Tasks         = $tasks_count
          }
          $services_count = $s
          $tasks_count = $t
        }
    } # end foreach
  } # end PROCESS block
  End {
    if ($Log -and !$Minimal) { 
      Write-output "Log File: $($Logfile)"
    } else {
      Write-Information -MessageData "Log File: $($Logfile)" -InformationAction Continue
      return $minimal_obj
    }
  } # end END block
} # end Find-TaskServiceUser function
