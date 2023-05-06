# ![https://www.freepik.com/](https://raw.githubusercontent.com/voytas75/Find-TaskServiceUser/master/Find-TaskServiceUser.png) Find-TaskServiceUser

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/A0A6KYBUS)

![Version](https://img.shields.io/badge/version-1.7.0-green) [![Codacy Badge](https://app.codacy.com/project/badge/Grade/6ffd84e783c64ef2abe47b34a2326b51)](https://app.codacy.com/gh/voytas75/Find-TaskServiceUser/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade) [![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/find-taskserviceuser)](https://www.powershellgallery.com/packages/Find-TaskServiceUser)

It is a powershell module for finding scheduled tasks and system services on a local or remote computer that are created or run as a given user.

## Getting Started

These instructions will get you a copy of the project up and running on your local computer for development and testing purposes.

### Install module

Copy and Paste the following command to install this package using PowerShellGet:

```powershell
Install-Module -Name Find-TaskServiceUser
```

Command to install in current user's directory, `$home\Documents\PowerShell\Modules`:

```powershell
Install-Module -Name Find-TaskServiceUser -Scope CurrentUser
```

### Examples

#### Example 1

Find system services and scheduled tasks on "WSRV00" for user "BobbyK" with logging output to a file:

```powershell
PS> Find-TaskServiceUser -Computer "WSRV00" -User "BobbyK" -Service -Task -Log
```

#### Example 2

Find system services and scheduled tasks on computers "WSRV01", "WSRV02" for user "Administrator":

```powershell
PS> "WSRV01","WSRV02" | Find-TaskServiceUser -Service -Task
```

#### Example 3

Find system services and scheduled tasks on computers "WSRV01", "WSRV02", "WSRV03" for user "BobbyK":

```powershell
PS> @("WSRV01","WSRV02"), "WSRV03" | Find-TaskServiceUser -Task -User "BobbyK"
```

#### Example 4

Find tasks and services on conputer "WSRV04" for "SYSTEM" user and return a minimalistic result as custom object `$data`:

```powershell
PS> $data = Find-TaskServiceUser -Task -Service -Server "WSRV04" -User "SYSTEM" -Minimal
PS> $data
```

#### Example 5

Find tasks and services on computer "WSRV04" for "JohnK" user. Display results and save it as object in XML file. Import object data from XML and display tasks and services separately:

```powershell
PS> Find-TaskServiceUser -Task -Service -Server "WSRV04" -User "JohnK" -Export
PS> $object = Import-Clixml "D:\dane\voytas\Dokumenty\Find-TaskServiceUser.XML"
PS> $object.Tasks
PS> $object.Services
```

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/voytas75/Find-TaskServiceUser/tags). 

## Icon

Module icon made by [Freepik](https://www.freepik.com/) from [Flaticon](https://www.flaticon.com/) is licensed [CC 3.0 BY](http://creativecommons.org/licenses/by/3.0/)

## Authors

**Wojciech Napierała** - *Initial work* - [Voytas75](https://github.com/voytas75)

See also the list of [contributors](https://github.com/voytas75/Find-TaskServiceUser/graphs/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/voytas75/Find-TaskServiceUser/blob/master/LICENSE) file for details
