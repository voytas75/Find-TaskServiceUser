Function Find-ServiceUser {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, position = 0)]
        [string[]]
        $computer,

        [parameter(mandatory = $false, position = 1)]
        [string]
        $user,

        [parameter(Mandatory = $false, HelpMessage = 'Turns on the search after the exact username.')]
        [switch]
        $Strict
    )
    $user = $user.trim()
    $computer = $computer.trim()
    if ([bool](Test-Connection -ComputerName $computer -Count 1 -ErrorAction SilentlyContinue)) {
        if ($Strict) {
            $filter = "startname = '$($user)'"
            #Write-Information $filter -InformationAction Continue
        } else {
            $filter = "startname LIKE '%$($user)%'"
        }
        Write-Verbose -Message "WMI query for system services."
        try {
            $service_ = Get-CimInstance -classname win32_service -filter "$filter" -ComputerName $computer -ErrorAction Stop
        } 
        catch {
            Write-Error -Message "Failed WMI query for system services with Service Logon Account as ""$user"": $_"
        }
        if ($service_) {
            Write-Verbose -Message "Return WMI query data"
            return $service_
        } 
    }
    else {
        Write-Verbose -Message "$computer`: Connection failed!"
        Write-Information -MessageData "$computer`: Connection failed!" -InformationAction Continue
        return $null
    }
}# end function Find-ServiceUser
