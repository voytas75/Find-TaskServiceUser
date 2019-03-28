function Search-TaskUser{
    [CmdletBinding()]
    param(
        [string]$server,

        [string]$user
    )
    process {
        Write-Verbose -Message 'running system command ''schtasks'''
        try {
            $task_=Invoke-Expression "schtasks /query /s $server /fo csv /v" -ErrorAction Stop
        }
        catch {
            Write-Host $_.Exception.Message
        }
        $match_ = "$user"
        Write-Verbose -Message 'filter tasks'
        $task_ | Where-Object {$_ -match $match_} 
    }
    end {

    }
}
