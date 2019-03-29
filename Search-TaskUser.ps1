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
        Write-Verbose -Message 'filtering tasks'
        $a=$task_ | Where-Object {$_ -match $user}
        # join header with data 
        return $task_[0],$a
    }
    end {

    }
}
