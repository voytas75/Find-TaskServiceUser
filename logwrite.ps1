function LogWrite {
    param([string]$logstring)
    if ($Log) {
      Write-Verbose -Message "Append ""$logstring"" to log file: ""$logfile"""
      Add-Content $logfile -Value $logstring
    }
  }
