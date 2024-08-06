# base Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.15.11-2]
### Changed
- [#40] Update doguctl to v0.12.1

### Security
- this release closes CVE-2024-41110

## [3.15.11-1] - 2024-07-03
### Changed
- [#38] Update doguctl to v0.12.0

### Security
- this release closes the following CVEs
  - doguctl
     - CVE-2024-24788
     - CVE-2024-24789
     - CVE-2024-24790
  - diverse openssl CVEs

## [3.15.8-1] - 2023-04-21
### Changed
- Upgrade to alpine 3.15.8 (#16)
- Remove wget and curl
 
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
