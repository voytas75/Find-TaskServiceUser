Function Invoke-SCHTasks {
    [CmdletBinding()]
    param(
        [string]$server,

        [string]$user
    )
    process {
        if (($server -match $env:COMPUTERNAME) -or ($server -eq "localhost")) {
            Write-Verbose -Message "$server : Try use schtasks on local computer"
            try {
                $tasks = Invoke-Expression "schtasks /query /fo csv /v" -ErrorAction Stop
            }
            catch {
                Write-Error -Message "Failed to invoke ""schtasks"": $_"
            }
        }
        else {
            Write-Verbose -Message "$server : Try use schtasks on remote computer"
            $exp_schtasks = "schtasks /Query /S $server /FO CSV /V"
            Write-Verbose $exp_schtasks
            try {
                $tasks = Invoke-Expression $exp_schtasks -ErrorAction Stop
            }
            catch {
                Write-Error -Message "Failed to invoke ""schtasks"": $_"
            }
        } 
        Write-Verbose -Message "$server : Filtering scheduled tasks"
        $header = "HostName", "TaskName", "Next Run Time", "Status", "Logon Mode", "Last Run Time", "Last Result", "Author", "Task To Run", "Start In", "Comment", "Scheduled Task State", "Idle Time", "Power Management", "Run As User", "Delete Task If Not Rescheduled", "Stop Task If Runs X Hours and X Mins", "Schedule", "Schedule Type", "Start Time", "Start Date", "End Date", "Days", "Months", "Repeat: Every", "Repeat: Until: Time", "Repeat: Until: Duration", "Repeat: Stop If Still Running"
        return $tasks | ConvertFrom-Csv -Header $header | Where-Object { $_."Run As User" -match $user -or $_."Author" -match $user } | Select-Object hostname, @{Name = "taskname"; Expression = { ($_.TaskName).split("\")[-1] } }, "run as user", author, @{Name = "URI"; Expression = { $_.TaskName } } -Unique
    }
}