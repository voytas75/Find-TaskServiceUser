#Get files.
$files  = @( Get-ChildItem -Path $PSScriptRoot\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($import in @($files))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import file $($import.fullname): $_"
    }
}

# Here I might...
# Read in or create an initial config file and variable
# Export Public functions ($Public.BaseName) for WIP modules
# Set variables visible to the module and its functions only

#Export-ModuleMember -Function $Public.Basename