Function Find-TaskUser {
    [CmdletBinding()]
    param(
        [string]$server,

        [string]$user
    )
    process {
        $server = $server.trim()
        $user = $user.trim()
        <#
        #23 start
        #if ([bool](Get-Command Get-ScheduledTask -ErrorAction SilentlyContinue)) {
        if ([bool](Test-Connection -ComputerName $server -Count 1 -ErrorAction SilentlyContinue)){
            if ([bool](Invoke-Command -ComputerName $server -EnableNetworkAccess -ScriptBlock {[bool](Get-Command Get-ScheduledTask -ErrorAction SilentlyContinue)} -erroraction silentlycontinue)) {
                try {
                    Write-Verbose -Message "$server : Try use Get-ScheduledTask"
                    $data = Get-ScheduledTask -CimSession $server -ErrorAction stop | Where-Object {$_.author -match $user -or $_.Principal.userid -match $user} | Select-Object @{Name="Hostname"; Expression = {$_.PSComputerName}}, taskname, @{Name="Run As User"; Expression = {$_.Principal.userid}}, Author, URI
                    return $data
                } 
                catch {
                    Write-verbose -Message "Get-ScheduledTask error: $_"
                    Write-Verbose -Message "$server : Switching to schtasks command."

                    Invoke-SCHTasks -server $server -user $user

                }
            } else {
                Invoke-SCHTasks -server $server -user $user

            }
        } else {
            Write-verbose -Message "$server`: Connection failed!"
            Write-Information -MessageData "$server`: Connection failed!" -InformationAction Continue
            return $null
        }
        #23 end
#>
        #26 start
        if ($server -eq $env:COMPUTERNAME -or $server -eq "localhost") {
            #local
            Write-Verbose -Message "$server`: Local computer."
            try {
                Write-Verbose -Message "$server`: Try use Get-ScheduledTask."
                #do cimsession on local to have "pscomputername" property
                return Get-ScheduledTask -CimSession $server -ErrorAction stop | Where-Object {$_.author -match $user -or $_.Principal.userid -match $user} | Select-Object @{Name="Hostname"; Expression = {$_.PSComputerName}}, taskname, @{Name="Run As User"; Expression = {$_.Principal.userid}}, Author, URI
            }
            catch {
                Write-verbose -Message "$server`: Get-ScheduledTask error: $_"
                Write-Verbose -Message "$server`: Switching to schtasks command."
                Invoke-SCHTasks -server $server -user $user
            }   
        } else {
            #remote
            Write-Verbose -Message "$server`: Remote computer."
            try {
                Write-Verbose -Message "$server`: Test-connection."
                Test-Connection -ComputerName $server -Count 1 -ErrorAction Stop | Out-Null
            }
            catch {
                Write-verbose -Message "$server`: Test-Connection error: $_"
                Write-Information -MessageData "$server Offline?" -InformationAction Continue
                return $null
            }
            try {
                Write-Verbose -Message "$server`: Try use Get-ScheduledTask."
                try {
                    #check if is local get-scheduledtask
                    Write-Verbose -Message "$server`: Is local command Get-ScheduledTask ?"
                    Invoke-Command -ScriptBlock {Get-Command Get-ScheduledTask} -ErrorAction Stop
                }
                catch {
                    # no local get-scheduledtask
                    #check if is remote get-scheduledtask
                    Write-Verbose -Message "$server`: No local command Get-ScheduledTask."
                    try {
                        Write-Verbose -Message "$server`: Is remote command Get-ScheduledTask ?"
                        Invoke-Command -ComputerName $server -EnableNetworkAccess -ScriptBlock {Get-Command Get-ScheduledTask -ErrorAction SilentlyContinue} -erroraction Stop
                        try {
                            Write-Verbose -Message "$server`: Try use remote command Get-ScheduledTask."
                            $remote_data = Invoke-Command -ComputerName $server -EnableNetworkAccess -ScriptBlock {Get-ScheduledTask -erroraction stop} -erroraction Stop | Where-Object {$_.author -match $user -or $_.Principal.userid -match $user} | Select-Object @{Name="Hostname"; Expression = {$_.PSComputerName}}, taskname, @{Name="Run As User"; Expression = {$_.Principal.userid}}, Author, URI
                            $remote_data
                            if ($remote_data) {
                                Write-Verbose -Message "$server`: return data from remote command Get-ScheduledTask."
                                return $remote_data
                            }
                            else {
                                Write-Verbose -Message "$server`: NULL."
                                return $null
                            }                        
                        }
                        catch {
                            Write-Verbose -Message "$server error useing remote command Get-ScheduledTask: $_"
                            Write-Verbose -Message "$server`: Switch to SCHTASK."
                            $remote_schtask_data = Invoke-SCHTasks -server $server -user $user
                            return $remote_schtask_data
                        }
                    }
                    catch {
                        Write-Verbose -Message $_
                        return $null
                    }
                }
                #return Get-ScheduledTask -CimSession $server -ErrorAction stop | Where-Object {$_.author -match $user -or $_.Principal.userid -match $user} | Select-Object @{Name="Hostname"; Expression = {$_.PSComputerName}}, taskname, @{Name="Run As User"; Expression = {$_.Principal.userid}}, Author, URI
            }
            catch {
                #Write-verbose -Message "Get-ScheduledTask error: $_"
                #Write-Verbose -Message "$server`: Switching to schtasks command."
                #Invoke-SCHTasks -server $server -user $user
                Write-Verbose -Message $_
                return $null
            }
        }
        #26 end


<#
        if ([bool](Get-Command Get-ScheduledTask -ErrorAction SilentlyContinue)) {
            Write-Verbose -Message 'Running ''Get-ScheduleTask'''
            $data = Get-ScheduledTask -CimSession $server.trim() | Where-Object {$_.author -match $user.trim() -or $_.Principal.userid -match $user.trim()} | Select-Object hostname, taskname, @{Name="Run As User"; Expression = {$_.Principal.userid}}, Author, URI
            foreach ($record in $data) {
                $record.hostname = $server.trim()
            }
            return $data
        } else {
            Write-Verbose -Message 'Running system command ''schtasks'''
            if ($server.trim() -match $env:COMPUTERNAME -or $server.trim() -eq "localhost") {
                try {
                    $tasks=Invoke-Expression "schtasks /query /fo csv /NH /v" -ErrorAction Stop
                }
                catch {
                    Write-Error -Message "Failed to invoke ""schtasks"": $_"
                }
            } else {
                try {
                    $tasks=Invoke-Expression "schtasks /query /s $server.trim() /NH /fo csv /v" -ErrorAction Stop
                }
                catch {
                    Write-Error -Message "Failed to invoke ""schtasks"": $_"
                }
            } 
            Write-Verbose -Message 'Filtering scheduled tasks'
            $header = "HostName","TaskName","Next Run Time","Status","Logon Mode","Last Run Time","Last Result","Author","Task To Run","Start In","Comment","Scheduled Task State","Idle Time","Power Management","Run As User","Delete Task If Not Rescheduled","Stop Task If Runs X Hours and X Mins","Schedule","Schedule Type","Start Time","Start Date","End Date","Days","Months","Repeat: Every","Repeat: Until: Time","Repeat: Until: Duration","Repeat: Stop If Still Running"
            return $tasks | ConvertFrom-Csv -Header $header | Where-Object {$_."Run As User" -match $user -or $_."Author" -match $user}| Select-Object hostname, @{Name="taskname"; Expression = {($_.TaskName).split("\")[-1]}}, "run as user", author, @{Name="URI"; Expression = {$_.TaskName}} -Unique
        } # end if
#>    
    
    }
}
