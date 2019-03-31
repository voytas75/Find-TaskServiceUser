# Find-TaskServiceUser

It is a powershell module for finding scheduled tasks and system services on a local or remote computer that are created or run as a given user.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Install module

Copy and Paste the following command to install this package using PowerShellGet.

```
Install-Module -Name Find-TaskServiceUser
```

### Examples:

1. Find system services and scheduled tasks on "WSRV00" for user "BobbyK" with logging output to a file:
```
Find-TaskServiceUser -Computer "WSRV00" -User "BobbyK" -Service -Task -Log
```

2. Find system services and scheduled tasks on computers "WSRV01", "WSRV02" for user "Administrator":
```
"WSRV01","WSRV02" | Find-TaskServiceUser -Service -Task
```

3. Find system services and scheduled tasks on computers "WSRV01", "WSRV02", "WSRV03" for user "BobbyK":
```
@("WSRV01","WSRV02"), "WSRV03" | Find-TaskServiceUser -Task - User "BobbyK"
```

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/voytas75/Find-TaskServiceUser/tags). 

## Icon

Module icon made by [Freepik](https://www.freepik.com/) from [Flaticon](https://www.flaticon.com/) is licensed [CC 3.0 BY](http://creativecommons.org/licenses/by/3.0/)

## Authors

* **Wojciech Napierała** - *Initial work* - [Voytas75](https://github.com/voytas75)

See also the list of [contributors](https://github.com/voytas75/Find-TaskServiceUser/graphs/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/voytas75/Find-TaskServiceUser/blob/master/LICENSE) file for details