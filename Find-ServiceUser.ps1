Function Find-ServiceUser {
    #[CmdletBinding()]
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
    $service_ = $false

    try {
        Write-Verbose -Message "Test connection to computer $computer"
        Test-Connection -ComputerName $computer -Count 1 -Quiet -ErrorAction SilentlyContinue | Out-Null
    }
    catch {
        Write-Verbose -Message "Error testing connection to computer $($computer.toupper()). Offline?"
        Write-Information -MessageData "Error testing connection to computer $($computer.toupper()). Offline?" -InformationAction Continue
        return $null
    }
    if ($Strict) {
        $filter = "startname = '$($user)'"
        #Write-Information $filter -InformationAction Continue
    }
    else {
        $filter = "startname LIKE '%$($user)%'"
    }
    Write-Verbose -Message "WMI query for system services."
    #if computer is localhost then WMI query has no -computername
    if ($computer -eq $env:COMPUTERNAME -or $computer -eq "localhost") {
        try {
            $service_ = Get-CimInstance -classname win32_service -filter "$filter" -ErrorAction Stop
        } 
        catch {
            Write-Error -Message "Failed local WMI query for system services with Service Logon Account as ""$user"": $_"
        }
        #Write-Debug ((get-variable "service_").value)
        #(get-variable "service_").value
        if ($service_) {
            Write-Verbose -Message "Return local WMI query data."
            return $service_
        } else {
            Write-Verbose -Message "NO local WMI query data."
            $out_variable = (Get-Variable service_).Value
            Write-Debug -message "Return data from inside 'Find-ServiceUser': $out_variable" -InformationAction Continue
            return $false
        }
    }  else {
        try {
            $service_ = Get-CimInstance -classname win32_service -filter "$filter" -ComputerName $computer -ErrorAction Stop
        } 
        catch {
            Write-Error -Message "Failed WMI query for system services with Service Logon Account as ""$user"": $_"
        }
        #Write-Debug ((get-variable "service_").value)
        #(get-variable "service_").value
        if ($service_) {
            Write-Verbose -Message "Return WMI query data"
            return $service_
        } else {
            Write-Verbose -Message "NO WMI query data"
            $out_variable = (Get-Variable service_).Value
            Write-Debug -message "Return data from inside 'Find-ServiceUser': $out_variable" -InformationAction Continue
            return $false
        }
    }
}# end function Find-ServiceUser
