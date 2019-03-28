Function Find-TaskServiceUser 
{
<#
.SYNOPSIS
   Finding Tasks, Services on remote/local computer. 
.DESCRIPTION
   Finding Tasks, Services on remote/local computer with specific user. User 'Administrator' is default.
   First do:
   . .\Find-TaskServiceUser.ps1
.PARAMETER User
    Give user to search tasks/services. Default value is 'Administrator'.
.PARAMETER Computer
    Give computer to search tasks/services. Default value is 'localhost' ($env:COMPUTERNAME).
.PARAMETER Task
    if you want search tasks.
.PARAMETER Service
    if you want search services.
.PARAMETER Log
    if you want log file.
.PARAMETER Logfile
    Give path and log file name. Default value is $:env:TEMP\find-taskserviceuser.log. Works only with Log switch.
.EXAMPLE
    Find-TaskServiceUser -Computer computer_name -User User -Service -Task

    Description
    -----------
    To find services and tasks on 'computer_name' for user 'user'.
.EXAMPLE
   "comp1","comp2" | Find-TaskServiceUser -Service -Task

    Description
    -----------
    Stream two computers names to cmdlet to find services and tasks:
.LINK
   https://github.com/voytas75
.LINK
   http://gallery.technet.microsoft.com/Find-tasks-and-53d1a77b
.NOTES
   version 1.0, 27.03.2019:
      - first build of module created from function 
#>
  [CmdletBinding()]
    Param
    (
        #Computer
        [parameter(
                   mandatory=$false,
                   position=0,
                   valuefrompipeline = $true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage='Computer NetBIOS, DNS name or IP.'
                   )]
        [Alias('MachineName','Server')]
        [string[]]$Computer=$env:COMPUTERNAME,

        [parameter(Mandatory=$false,
                   HelpMessage='User name to search services and/or tasks. '
                  )]
        [string]$User='Administrator',

        # Searching in Services
        [parameter(Mandatory=$false,
                   HelpMessage='Switch to search services.'
                  )]
        [switch]$Service,

        # Searching in Task scheduler
        [parameter(Mandatory=$false,
                   HelpMessage='Switch to search tasks.'
                  )]
        [switch]$Task,

        #log
        [parameter(Mandatory=$false,
                   HelpMessage='Switch to enable logging.'
                  )]
        [switch]$Log,

        #logpath
        [parameter(Mandatory=$false,
                   HelpMessage='Log file with path. Path based on env:'
                  )]
        [string]$Logfile="$env:TEMP\find-taskserviceuser.log"

    )

    Begin
    {
    $ErrorActionPreference_ = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
    
    if (!$service -and !$task) {
    Write-Output '
    Examples:
      Find-TaskServiceUser -Computer computerA -User UserA -Service -Task
      Find-TaskServiceUser -Computer computerB -User UserB -Task -Log 
      "comp1","comp2" | Find-TaskServiceUser -Service -Task
      "comp3" | Find-TaskServiceUser -Service
    '
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
    Process
    {
#   Write-Verbose -Message 'start of process block'
    if ($service) {    
        write-host "Searching services with user: ""$($user.trim().toupper())"" on machine: ""$($computer.trim().toupper())"""
        LogWrite "$(get-date): Searching services with user: $($user.trim().toupper()) on machine: $($computer.trim().toupper())"
        $comp = $computer.Trim()
        $services = Search-ServiceUser -computer $comp -user $user
      if ($services) {
        Write-Verbose "services found"
          LogWrite "$(get-date): Services:"
#          Write-Verbose -Message 'display services'
          $output = $services | select-object SystemName,Name,DisplayName,StartName,State | Format-Table -AutoSize
          $output
          $output = $services | select-object SystemName,Name,DisplayName,StartName,State
          $output | ForEach-Object {LogWrite $_}
      } else {
        LogWrite "$(get-date): No services found on computer ""$computer"" for user ""$user"""
       Write-Output "No services found on computer ""$computer"" for user ""$user"""
      }
    }
    if ($task){
        Write-Output "Searching tasks with user: $($user.trim().toupper()) on machine: $($computer.trim().toupper())"
        $tasks = Search-TaskUser -server $computer -user $user
      if ($tasks) {
          LogWrite "$(get-date): Tasks:"
        Write-Verbose -Message 'display tasks'
        Write-Output "Task with author or start as $user"
        # split problem - to TODO
        $tasks | ForEach-Object { $b=$_.split(',');write-host $b[0], $b[1]}
        $tasks | ForEach-Object {LogWrite $_}
      } else {
        LogWrite "$(get-date): No tasks on computer ""$computer"" for user ""$user"""
        Write-Output "No tasks foundon computer ""$computer"" for user ""$user"""
      }
    }
#    Write-Verbose -Message 'end of process block'
    } # end PROCESS block
    End
    {
#    Write-Verbose -Message 'start of end block'
if ($Log) { Write-Host "Log File: $($Logfile)" -ForegroundColor Gray}
    $ErrorActionPreference = $ErrorActionPreference_
#    Write-Verbose -Message 'end of end block'
    } # end END block
} # end function Find-TaskServiceUser
