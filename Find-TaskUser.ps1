Function Find-TaskUser {
    [CmdletBinding()]
    param(
        [string]$server,

        [string]$user
    )
    process {
        if ([bool](Get-Command Get-ScheduledTask -ErrorAction SilentlyContinue)) {
            Write-Verbose -Message 'Running ''Get-ScheduleTask'''
            return Get-ScheduledTask * | Where-Object {$_.author -match $user -or $_.Principal.userid -match $user}  | Select-Object hostname, author, taskname, @{Name="Run As User"; Expression = {$_.Principal.userid}}
        } else {
            Write-Verbose -Message 'Running system command ''schtasks'''
            if ($server -match $env:COMPUTERNAME -or $server -eq "localhost") {
                try {
                    $tasks=Invoke-Expression "schtasks /query /fo csv /NH /v" -ErrorAction Stop
                }
                catch {
                    Write-Error -Message "Failed to invoke ""schtasks"": $_"
                }
            } else {
                try {
                    $tasks=Invoke-Expression "schtasks /query /s $server /NH /fo csv /v" -ErrorAction Stop
                }
                catch {
                    Write-Error -Message "Failed to invoke ""schtasks"": $_"
                }
            } 
            Write-Verbose -Message 'Filtering scheduled tasks'
            $header = "HostName","TaskName","Next Run Time","Status","Logon Mode","Last Run Time","Last Result","Author","Task To Run","Start In","Comment","Scheduled Task State","Idle Time","Power Management","Run As User","Delete Task If Not Rescheduled","Stop Task If Runs X Hours and X Mins","Schedule","Schedule Type","Start Time","Start Date","End Date","Days","Months","Repeat: Every","Repeat: Until: Time","Repeat: Until: Duration","Repeat: Stop If Still Running"
            $data = $tasks | ConvertFrom-Csv -Header $header | Where-Object {$_."Run As User" -match $user -or $_."Author" -match $user}
            foreach ($record in $data) {
                $data.hostname = $server
            }
            return $data
        } # end if
    }
    end {

    }
}
