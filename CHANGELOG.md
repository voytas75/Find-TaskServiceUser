# Find-TaskServiceUser Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## 1.4.0 - 2019.04.
### Added
- Created release notes file and add `ReleaseNotes` Uri.
### Changed
- `LicenseUri` in manifest module file,
- The lack of `-Task` and `-Service` parameters does not cause the syntax to be displayed, but only starts searching for tasks and services. `Find-TaskServiceUser` gives the same results as `Find-TaskServiceUser -Task -Service`.
- No found tasks and services were not correctly interpreted as `0` but as `null`
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
