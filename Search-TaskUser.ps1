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
