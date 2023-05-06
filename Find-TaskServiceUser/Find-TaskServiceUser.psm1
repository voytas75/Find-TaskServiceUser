#Get files.
$files = @( Get-ChildItem -Path $PSScriptRoot\functions\*.ps1 -ErrorAction SilentlyContinue )
#Dot source the files
Foreach ($import in @($files)) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import file $($import.fullname): $_"
    }
}

$oldProtocol = [Net.ServicePointManager]::SecurityProtocol
# We switch to using TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Get the name of the current module
$ModuleName = "Find-TaskServiceUser"

# Get the installed version of the module
$ModuleVersion = [version]"2.1.0"

$LatestModule = Find-Module -Name $ModuleName -Repository PSGallery

$InstalledModule = Get-Module Find-TaskServiceUser -ListAvailable | Sort-Object version -Descending | Select-Object -First 1

if ($ModuleVersion -lt $LatestModule.Version) {
    $message = @"
An update is available for ${ModuleName}. Installed version: $($InstalledModule.Version). Latest version: $($LatestModule.Version).
Run 'Update-Module -Name ${ModuleName}' to update to the latest version.
"@
Write-Information $message -InformationAction Continue

} 
[Net.ServicePointManager]::SecurityProtocol = $oldProtocol

#region Best Practise
<# 
Use approved verbs: Use approved PowerShell verbs to name your functions. This helps ensure that your function names are consistent with other PowerShell cmdlets, making them easier to remember and reducing the likelihood of naming conflicts. You can use the Get-Verb cmdlet to see a list of approved verbs.
Use a module manifest: Use a module manifest (*.psd1) file to define metadata about your module, such as the module name, version, author, and other properties. This makes it easier to manage your module, load it into PowerShell, and publish it to a repository.
Use a functions folder: Store your module's functions in a subdirectory named "Functions" within your module folder. This helps keep your module organized and makes it easier to find and manage your functions.
Use script-based functions: Use script-based functions instead of binary cmdlets whenever possible. Script-based functions are easier to develop and test, and they can be easily modified and updated.
Use a consistent naming convention: Use a consistent naming convention for your functions and other resources, such as variables and aliases. This makes it easier to understand your code and reduces the likelihood of naming conflicts.
Use proper error handling: Use proper error handling techniques in your functions to ensure that errors are reported accurately and clearly. Use the Throw statement to throw exceptions when errors occur, and use the Write-Error cmdlet to report non-terminating errors.
Use proper documentation: Use proper documentation in your functions to describe what they do and how to use them. Use the Comment-Based Help syntax to add help content to your functions.
#>
#endregion Best Practise
