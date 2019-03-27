function Search-ServiceUser {
    param (
    [parameter(mandatory=$true,position=0)]
    [string[]]$computer,

    [parameter(mandatory=$false,position=1)]
    [string]$user
    )
  $filter = "startname like '%$($user)%'"
  Write-Verbose -Message 'query WMI of services with filter'
  $service_ = Get-WmiObject win32_service -filter "$filter" -ComputerName $computer
  if ($service_) {
    Write-Verbose -Message 'return WMI of Services with filter'
    return $service_
    #New-Object -TypeName psobject -Property @{`
    #Server = $service_.Systemname;
    #Servicename = $service_.Name;
    #ServicePath =  $service_.Pathname;
    #ServiceDisplayName = $service_.Displayname;
    #StartUser = $service_.Startname;
    #ServiceState = $service_.state
    #}
  } # end function Search-ServiceUser
}
