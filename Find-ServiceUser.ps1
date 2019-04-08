Function Find-ServiceUser {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, position = 0)]
        [string[]]
        $computer,

        [parameter(mandatory = $false, position = 1)]
        [string]
        $user
    )
    $user = $user.trim()
    $computer = $computer.trim()
    if ([bool](Test-Connection -ComputerName $computer -Count 1 -ErrorAction SilentlyContinue)) {
        $filter = "startname like '%$($user)%'"
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
            #New-Object -TypeName psobject -Property @{`
            #Server = $service_.Systemname;
            #Servicename = $service_.Name;
            #ServicePath =  $service_.Pathname;
            #ServiceDisplayName = $service_.Displayname;
            #StartUser = $service_.Startname;
            #ServiceState = $service_.state
            #}
        } 
    }
    else {
        Write-Verbose -Message "$computer`: Connection failed!"
        Write-Information -MessageData "$computer`: Connection failed!" -InformationAction Continue
        return $null
    }
}# end function Find-ServiceUser
