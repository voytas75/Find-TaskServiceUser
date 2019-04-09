function Write-Log {
    param([string]$logstring)
    Write-Debug -Message "Append ""$logstring"" to log file: ""$logfile"""
    Add-Content $logfile -Value $logstring
}
