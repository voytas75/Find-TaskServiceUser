# Find-TaskServiceUser Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## 1.7.0 - 2020

### Added

- Add `-OpenProjectSite` to open default browser with github project site,
- Add description `.PARAMETER` for missing parameters.

### Changed

- Fix problem with wrong results from services,
- Fixed handling remote computers,
- Minor changes.

## 1.6.0 - 2019.04.09

### Added

- Aliases `Count`, `CountOnly` for parameter `Minimal`,
- Export results to JSON file, parameter `ExportJSON` and `ExportJSONpath`,
- Search for the exact user name, parameter `Strict`.

### Changed

- Clearing and formatting the code,
- Minor changes.

## 1.5.3 - 2019.04.09

### Changed

- A patch to compare the version number in module root file.

## 1.5.2 - 2019.04.09

### Changed

- Fix for not displaying information when importing the module.

## 1.5.1 - 2019.04.09

### Changed

- Fix for scenario when there is no local and remote `get-scheduledtask`, added `invoke-SCHTasks`.

## 1.5.0 - 2019.04.07

### Added

- Added test connection to server,
- Result's sorting,
- Added more examples,
- Online checker module's version,
- Added progress bar.

### Changed

- Rebuild Find-TaskUser function,
- Move from `Write-Host` to `Write-Output`,
- Minor changes.

## 1.4.0 - 2019.04.04

### Added

- In the case of the `Get-ScheduledTask` error, the task search function has been added,
- An export function has been added to the result object file (`-Export`, `-ExportPath`),
- Search ability has been added for the user table.

### Changed

- Move string methods to private functions files,
- Changed `Get-WmiObject` to `Get-CimInstance`,
- Minor changes.

## 1.3.4 - 2019.04.02

### Added

- Created release notes file and add `ReleaseNotes` Uri.

### Changed

- fix: when remote computers are given, the task search is performed on the computer from which the module was started,
- `LicenseUri` in manifest module file,
- The lack of `-Task` and `-Service` parameters does not cause the syntax to be displayed, but only starts searching     for tasks and services. `Find-TaskServiceUser` gives the    same results as `Find-TaskServiceUser -Task -Service`,
- No found tasks and services were not correctly interpreted as `0` but as `null`.

### Removed

- Release notes from main module file.

## 1.3.3 - 2019.04.01

### Added

- Description of the `-Minimal` parameter.

## 1.3.2 - 2019.04.01

### Changed

- Minor fix for `iconuri` in manifest file.

## 1.3.1 - 2019.04.01

### Changed

- Minor fix for `iconuri`.

## 1.3.0 - 2019.04.01

### Added

- Added `-Minimal` switch parameter for minimalist object as results,
- Use `get-scheduletask` if available function,
- Added module icon (read ICON CREDITS).

### Changed

- Fix for change in grouping the results of tasks and services.

## 1.2.0 - 2019.03.30

### Changed

- Improved find of scheduled tasks,
- Change in grouping the results of tasks and services. 

## 1.1.0 - 2019.03.30

### Changed

- Changed private functions names.

## 1.0.1 - 2019.03.29

### Changed

- Minor bug fixes.

## 1.0.0 - 2019.03.27

### Added

- Created first build of module.
