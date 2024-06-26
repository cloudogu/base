# base Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.20.1-2] - 2024-06-26
### Changed
- [#28] Update doguctl to v0.12.0

### Security
- this release closes the following CVEs
    - CVE-2024-24788
    - CVE-2024-24789
    - CVE-2024-24790

## [3.20.1-1] - 2024-06-24
### Changed
- Update to alpine 3.20.1
- [#25] Update doguctl to v0.11.0

### Security
- This release fixes these CVEs against alpine 3.20.0
  - CVE-2024-4741
  - CVE-2023-42364
  - CVE-2023-42365

## [3.19.1-2] - 2024-06-06
### Changed
- [#25] Update doguctl to v0.10.0

## [3.19.1-1] - 2024-05-16
### Changed
- Upgrade to alpine 3.19.1 (#23)

## [3.18.6-1] - 2024-04-17
### Changed
- Upgrade to alpine 3.18.6 (#20)

## [3.18.3-1] - 2023-09-20
### Changed
- Upgrade to alpine 3.18.3 (#19)

## [3.17.3-2] - 2023-04-21
### Changed
- Remove curl and wget (#16)

## [3.17.3-1] - 2023-04-21
### Changed
- Upgrade to alpine 3.17.3 (#14)

## [3.17.1-1] - 2023-02-06
### Changed
- Upgrade to alpine 3.17.1 (#11)

## [3.15.3-1] - 2022-03-30
### Changed
- Upgrade to alpine 3.15.3 (#9)

## [3.15.2-1] - 2022-03-29
### Changed
- Upgrade to alpine 3.15.2 (#7)

## [3.15.0-1] - 2022-02-08
### Changed
- Upgrade to alpine 3.15.0


## [3.14.3-1] - 2022-02-04
### Changed
- Upgrade to alpine 3.14.3

## [3.12.4-2] - 2022-01-10

Re-release of the 3.12 branch for fresh alpine packages, no further changes

## [3.14.2-3] - 2021-10-19

This is just a technical re-release, no changes

## [3.14.2-2] - 2021-09-16
### Added
- Add support for additional certificates (#2)
   - see the [operations docs](docs/operations_en.md) for more information

### Changed
- Verify `doguctl` binary during image building
- Update Alpine packages

## [3.14.2-1]
### Changed
- update base image to Alpine 3.14.2

## [3.11.6-3]
## Changed
- Nominal dogu change counter changed for reasons of external side effects
- Updates Alpine packages

## [3.11.6-2]
### Changed
- Updates `doguctl` to v0.7.0
- Updates Alpine packages

## [3.11.6-1]
### Changed
- Updates Alpine base to 3.11.6 and all used packages
- Updates `doguctl` to v0.6.0

## [3.11.5-1]
### Changed
- Updates Alpine base to 3.11.5 and all used packages

## [3.10.3-2]
### Changed
- Updates `doguctl` to v0.5.0
- Updates Alpine packages

## [3.10.3-1]
### Changed3.10.3
- Updates Alpine base to 3.10.3 and all used packages

## [3.9.4-1]
### Changed
- Updates Alpine base to 3.9.4 and all used packages
