Function Find-TaskUser {
    [CmdletBinding()]
    param(
        [string]$server,

        [string]$user,

        [switch]$Strict
    )
    process {
        $server = $server.trim()
        $user = $user.trim()
        #26 start
        if ($server -eq $env:COMPUTERNAME -or $server -eq "localhost") {
            #local
            Write-Verbose -Message "$server`: Local computer."
            try {
                Write-Verbose -Message "$server`: Try use Get-ScheduledTask."
                #do cimsession on local to have "pscomputername" property
                if ($Strict) {
                    return Get-ScheduledTask -CimSession $server -ErrorAction stop | Where-Object { $_.author -eq $user -or $_.Principal.userid -eq $user } | Select-Object @{Name = "Hostname"; Expression = { $_.PSComputerName } }, taskname, @{Name = "Run As User"; Expression = { $_.Principal.userid } }, Author, URI
                }
                return Get-ScheduledTask -CimSession $server -ErrorAction stop | Where-Object { $_.author -match $user -or $_.Principal.userid -match $user } | Select-Object @{Name = "Hostname"; Expression = { $_.PSComputerName } }, taskname, @{Name = "Run As User"; Expression = { $_.Principal.userid } }, Author, URI
            }
            catch {
                Write-Verbose -Message "$server`: Get-ScheduledTask error: $_"
                Write-Verbose -Message "$server`: Switching to schtasks command."
                if ($Strict) {
                    Invoke-SCHTasks -server $server -user $user -Strict
                } else {
                    Invoke-SCHTasks -server $server -user $user
                }
            }   
        }
        else {
            #remote
            Write-Verbose -Message "$server`: Remote computer."
            try {
                Write-Verbose -Message "$server`: Test-connection."
                Test-Connection -ComputerName $server -Count 1 -ErrorAction Stop | Out-Null
            }
            catch {
                Write-Verbose -Message "$server`: Test-Connection error: $_"
                Write-Information -MessageData "$server Offline?" -InformationAction Continue
                return $null
            }
            try {
                Write-Verbose -Message "$server`: Try use Get-ScheduledTask."
                try {
                    #check if is local get-scheduledtask
                    Write-Verbose -Message "$server`: Is local command Get-ScheduledTask ?"
                    Invoke-Command -ScriptBlock { Get-Command Get-ScheduledTask -ErrorAction Stop } -ErrorAction stop | Out-Null
                }
                catch {
                    # no local get-scheduledtask
                    #check if is remote get-scheduledtask
                    Write-Verbose -Message "$server`: No local command Get-ScheduledTask."
                    try {
                        Write-Verbose -Message "$server`: Is remote command Get-ScheduledTask ?"
                        Invoke-Command -ComputerName $server -EnableNetworkAccess -ScriptBlock { Get-Command Get-ScheduledTask -ErrorAction stop } -ErrorAction stop | Out-Null
                        try {
                            Write-Verbose -Message "$server`: Try use remote command Get-ScheduledTask."
                            if ($Strict) {
                                $remote_data = Invoke-Command -ComputerName $server -EnableNetworkAccess -ScriptBlock { Get-ScheduledTask -erroraction stop } -erroraction stop | Where-Object { $_.author -eq $user -or $_.Principal.userid -eq $user } | Select-Object @{Name = "Hostname"; Expression = { $_.PSComputerName } }, taskname, @{Name = "Run As User"; Expression = { $_.Principal.userid } }, Author, URI
                            } else {
                                $remote_data = Invoke-Command -ComputerName $server -EnableNetworkAccess -ScriptBlock { Get-ScheduledTask -erroraction stop } -erroraction stop | Where-Object { $_.author -match $user -or $_.Principal.userid -match $user } | Select-Object @{Name = "Hostname"; Expression = { $_.PSComputerName } }, taskname, @{Name = "Run As User"; Expression = { $_.Principal.userid } }, Author, URI
                            }
                            #$remote_data
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
                            Write-Verbose -Message "$server`: Error useing remote command Get-ScheduledTask: $_"
                            Write-Verbose -Message "$server`: Switch to SCHTASK."
                            if ($Strict) {
                                $remote_schtask_data = Invoke-SCHTasks -server $server -user $user -Strict
                            } else {
                                $remote_schtask_data = Invoke-SCHTasks -server $server -user $user
                            }
                            return $remote_schtask_data
                        }
                    }
                    catch {
                        Write-Verbose -Message $_
                        return $null
                    }
                }
            }
            catch {
                Write-Verbose -Message $_
                return $null
            }
        }
        #26 end
    }
}
