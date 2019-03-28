Function Find-TaskServiceUser 
{
<#
.SYNOPSIS
Finding scheduled tasks, system services on computer by user name. 
.DESCRIPTION
Finding scheduled tasks, system services on local or remote computer by given user name. 
'Administrator' and local computer are default values.
The results can be redirected to the log file (see 'log' parameter).
.PARAMETER User
User name to search scheduled tasks or system services. Default value is 'Administrator'.
.PARAMETER Computer
Computer to search tasks/services. Default value is 'localhost' ($env:COMPUTERNAME).
.PARAMETER Task
A Switch to enable searching scheduled tasks.
.PARAMETER Service
A Switch to enable searching system services.
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
   https://github.com/voytas75
.LINK
   http://gallery.technet.microsoft.com/Find-tasks-and-53d1a77b
.NOTES
   version 1.0, 27.03.2019:
      - first build of module created from function 
#>
  [CmdletBinding()]
  Param(
    [parameter(mandatory=$false, position=0, valuefrompipeline = $true,
                ValueFromPipelineByPropertyName=$true,
                HelpMessage='Computer NetBIOS, DNS name or IP.')]
    [Alias('MachineName','Server')]
    [string[]]$Computer=$env:COMPUTERNAME,

    [parameter(Mandatory=$false, HelpMessage='User name to search services and/or tasks.')]
    [string]$User='Administrator',

    [parameter(Mandatory=$false, HelpMessage='Switch to search system services.')]
    [switch]$Service,

    [parameter(Mandatory=$false, HelpMessage='Switch to search scheduled tasks.')]
    [switch]$Task,

    [parameter(Mandatory=$false, HelpMessage='Switch to enable logging.')]
    [switch]$Log,

    [parameter(Mandatory=$false, HelpMessage='Log file path. Default is ''[$env:TEMP]\Find-TaskServiceUser.log''')]
    [string]$Logfile="$env:TEMP\Find-TaskServiceUser.log"
  )
  Begin {
    $ErrorActionPreference_ = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
    
    if (!$service -and !$task) {
      Write-Host "You must provide 'service' or/and 'task' parameter`n"
      Write-Host 'Examples:'
      Write-Host '  Find-TaskServiceUser -Computer computerA -User UserA -Service -Task'
      Write-Host '  Find-TaskServiceUser -Computer computerB -User UserB -Task -Log' 
      Write-Host '  "comp1","comp2" | Find-TaskServiceUser -Service -Task'
      Write-Host '  "comp3" | Find-TaskServiceUser -Service'
    } else {
      if ($user -eq "administrator") {
        Write-Host "Set default user: Administrator" -ForegroundColor Cyan
      }
      if ($computer -eq $env:COMPUTERNAME) {
        Write-Host "Set default computer: $env:COMPUTERNAME (localhost)" -ForegroundColor Cyan
      }  
    }
    LogWrite "---------$(get-date)---------"
  } # end BEGIN block
  Process {
    #Write-Verbose -Message 'start of process block'
    if ($service) {    
      write-host "Searching system services with user: ""$($user.trim().toupper())"" on machine: ""$($computer.trim().toupper())"""
      LogWrite "$(get-date): Searching services with user: ""$($user.trim().toupper())"" on machine: ""$($computer.trim().toupper())"""
      $comp = $computer.Trim()
      $services = Search-ServiceUser -computer $comp -user $user
      if ($services) {
        Write-Verbose "services found"
        LogWrite "$(get-date): Services:"
        #Write-Verbose -Message 'display services'
        $output = $services | select-object SystemName,Name,DisplayName,StartName,State | Format-Table -AutoSize
        $output
        $output = $services | select-object SystemName,Name,DisplayName,StartName,State
        $output | ForEach-Object {LogWrite $_}
      } else {
        LogWrite "$(get-date): No services found on computer ""$computer"" for user ""$user"""
        Write-Host "No services found on computer ""$computer"" for user ""$user"""
      }
    }
    if ($task) {
      Write-Host "Searching tasks with user: ""$($user.trim().toupper())"" on machine: ""$($computer.trim().toupper())"""
      LogWrite "$(get-date): Searching tasks with user: ""$($user.trim().toupper())"" on machine: ""$($computer.trim().toupper())"""
      $tasks = Search-TaskUser -server $computer -user $user
      if ($tasks) {
        LogWrite "$(get-date): Tasks:"
        Write-Verbose -Message 'display tasks'
        Write-Host "Task with author or start as $user"
        # split problem - to TODO
        $tasks | ForEach-Object { $b=$_.split(',');write-host $b[0], $b[1]}
        $tasks | ForEach-Object {LogWrite $_}
      } else {
        LogWrite "$(get-date): No tasks on computer ""$computer"" for user ""$user"""
        Write-Host "No tasks foundon computer ""$computer"" for user ""$user"""
      }
    }
    #Write-Verbose -Message 'end of process block'
  } # end PROCESS block
  End {
    #Write-Verbose -Message 'start of end block'
    if ($Log) { Write-Host "Log File: $($Logfile)" -ForegroundColor Gray}
    $ErrorActionPreference = $ErrorActionPreference_
    #Write-Verbose -Message 'end of end block'
  } # end END block
} # end Find-TaskServiceUser function
