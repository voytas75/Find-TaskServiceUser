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
   http://voytas.net
.LINK
   http://gallery.technet.microsoft.com/Find-tasks-and-53d1a77b
.NOTES
   Voytas

   version 1.2, 26-5-2014:
      - add logging to env:TEMP and verbose
      - minor changes
   version 1.1, 5-5-2014:
      - minor changes
   version 1.0, may 2014:
      - first build of cmdlet
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
        [string[]]
        $Computer=$env:COMPUTERNAME,

        [parameter(Mandatory=$false,
                   HelpMessage='User name to search services and/or tasks.'
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
    Write-Verbose -Message 'start of begin block'
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
    }
    function LogWrite {
      param([string]$logstring)
      if ($Log) {
        Write-Verbose -Message 'log update'
        Add-Content $logfile -Value $logstring
      }
    }

    function Search-ServiceUser {
      param (
      [parameter(mandatory=$true,position=0)]
      [string[]]$computer,

      [parameter(mandatory=$false,position=1)]
      [string]$user
      )
    $filter = "startname like '%$($user)%'"
    Write-Verbose -Message 'query WMI of services with filter'
    $service_ = Get-WmiObject win32_service -filter "$filter" -ComputerName $computer
    if ($service_) {
      Write-Verbose -Message 'return WMI of Services with filter'
      return $service_
      #New-Object -TypeName psobject -Property @{`
      #Server = $service_.Systemname;
      #Servicename = $service_.Name;
      #ServicePath =  $service_.Pathname;
      #ServiceDisplayName = $service_.Displayname;
      #StartUser = $service_.Startname;
      #ServiceState = $service_.state
      #}
    } # end function Search-ServiceUser
}
    
    function Search-TaskUser {
    param(
    [string]$server,

    [string]$user
    )
        Write-Verbose -Message 'query tasks'
        $task_=Invoke-Expression "schtasks /query /s $server /fo csv /v"
        $match_ = "$user"
        Write-Verbose -Message 'filter tasks'
        $task_ | Where-Object {$_ -match $match_} 
    }

    LogWrite "---------$(get-date)---------"
    Write-Verbose -Message 'end of begin block'
    if ($Log) { Write-Verbose "Log File: $($Logfile)" }
    } # end BEGIN block
    Process
    {
    Write-Verbose -Message 'start of process block'
    if ($service) {    
        write-host "Searching services with user: $($user.trim().toupper()) on machine: $($computer.trim().toupper())"
        LogWrite "$(get-date): Searching services with user: $($user.trim().toupper()) on machine: $($computer.trim().toupper())"
        $comp = $computer.Trim()
        $services = Search-ServiceUser -computer $comp -user $user
      if ($services) {
          LogWrite "$(get-date): Services:"
          Write-Verbose -Message 'display services'
          $output = $services | select-object SystemName,Name,DisplayName,StartName,State | Format-Table -AutoSize
          $output
          $output = $services | select-object SystemName,Name,DisplayName,StartName,State
          $output | ForEach-Object {LogWrite $_}
      } else {
        LogWrite "$(get-date): No services"
       Write-Output 'No services'
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
        LogWrite "$(get-date): No tasks"
        Write-Output 'No tasks'
      }
    }
    Write-Verbose -Message 'end of process block'
    } # end PROCESS block
    End
    {
    Write-Verbose -Message 'start of end block'
    $ErrorActionPreference = $ErrorActionPreference_
    Write-Verbose -Message 'end of end block'
    } # end END block
} # end function Find-TaskServiceUser
