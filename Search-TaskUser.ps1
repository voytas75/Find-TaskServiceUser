Function Search-TaskUser {
    [CmdletBinding()]
    param(
        [string]$server,

        [string]$user
    )
    process {
        Write-Verbose -Message 'running system command ''schtasks'''
        if ($server -match $env:COMPUTERNAME) {
            try {
                $task_=Invoke-Expression "schtasks /query /fo csv /v" -ErrorAction Stop
            }
            catch {
                Write-Error -Message "Failed to invoke ""schtasks"": $_"
            }
        } else {
            try {
                $task_=Invoke-Expression "schtasks /query /s $server /fo csv /v" -ErrorAction Stop
            }
            catch {
                Write-Error -Message "Failed to invoke ""schtasks"": $_"
            }
        } 
        $match_ = "$user"
        Write-Verbose -Message 'filter tasks'
        $task_ | Where-Object {$_ -match $match_} 
    }
    end {

    }
}
