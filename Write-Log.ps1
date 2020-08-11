function Write-Log {
    param([string]$logstring)
    Write-Debug -Message "Append ""$logstring"" to log file: ""$logfile"""
    #35
    $logstring | Out-File $Logfile -Append -Encoding utf8
}
