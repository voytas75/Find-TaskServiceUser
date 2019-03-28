function LogWrite {
    param([string]$logstring)
    if ($Log) {
      Write-Debug -Message "Append ""$logstring"" to log file: ""$logfile"""
      Add-Content $logfile -Value $logstring
    }
  }
