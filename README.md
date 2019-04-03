# ![https://www.freepik.com/](https://raw.githubusercontent.com/voytas75/Find-TaskServiceUser/master/Find-TaskServiceUser.png)  Find-TaskServiceUser

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/6ffd84e783c64ef2abe47b34a2326b51)](https://www.codacy.com/app/VoytasTeam/Find-TaskServiceUser?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=voytas75/Find-TaskServiceUser&amp;utm_campaign=Badge_Grade)

It is a powershell module for finding scheduled tasks and system services on a local or remote computer that are created or run as a given user.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Install module

Copy and Paste the following command to install this package using PowerShellGet.

```powershell
Install-Module -Name Find-TaskServiceUser
```

### Examples

1.  Find system services and scheduled tasks on "WSRV00" for user "BobbyK" with logging output to a file:
```powershell
Find-TaskServiceUser -Computer "WSRV00" -User "BobbyK" -Service -Task -Log
```
2.  Find system services and scheduled tasks on computers "WSRV01", "WSRV02" for user "Administrator":
```powershell
"WSRV01","WSRV02" | Find-TaskServiceUser -Service -Task
```
3.  Find system services and scheduled tasks on computers "WSRV01", "WSRV02", "WSRV03" for user "BobbyK":
```powershell
@("WSRV01","WSRV02"), "WSRV03" | Find-TaskServiceUser -Task -User "BobbyK"
```
4.  Find tasks and services on server "WSRV04" for "SYSTEM" user and return as a minimalistic result in `$object` variable:
```powershell
$object = Find-TaskServiceUser -Task -Service -Server "WSRV04" -User "SYSTEM" -Minimal
$object
```

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/voytas75/Find-TaskServiceUser/tags). 

## Icon

Module icon made by [Freepik](https://www.freepik.com/) from [Flaticon](https://www.flaticon.com/) is licensed [CC 3.0 BY](http://creativecommons.org/licenses/by/3.0/)

## Authors

*   **Wojciech Napierała** - *Initial work* - [Voytas75](https://github.com/voytas75)

See also the list of [contributors](https://github.com/voytas75/Find-TaskServiceUser/graphs/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/voytas75/Find-TaskServiceUser/blob/master/LICENSE) file for details
