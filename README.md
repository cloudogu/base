[![GitHub license](https://img.shields.io/github/license/cloudogu/base.svg)](https://github.com/cloudogu/base/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/cloudogu/base.svg)](https://github.com/cloudogu/base/releases)

# Base Dogu Docker image

## How to Publish

### PreRelease

Run the [Pipeline](https://ecosystem.cloudogu.com/jenkins/job/cloudogu-github/job/base) with parameter `PublishPrerelease` enabled,
to build and publish a prerelease image to the `prerelease_official` namespace (to `registry.cloudogu.com`).

### Release

The [Pipeline](https://ecosystem.cloudogu.com/jenkins/job/cloudogu-github/job/base) will build and publish a release image on every main-branch commit.

## How to Build locally

    make build


NOTE: _alpine linux version_ see FROM statement in Dockerfile

NOTE: _cloudogu revision_ see CHANGE_COUNTER in Makefile

More detailed instructions about building the base image can be found in [container_building.en.md](docs/container_building_en.md).

## Why is there a branch called alpine3.5?

Some Dogus need Alpine 3.5 as their base, therefore, a base Dogu version with Alpine 3.5 must be maintained as well as one with a more recent Alpine.

## Additional packages for base not included in alpine repository

### doguctl

When the image is built without the [Pipeline](https://ecosystem.cloudogu.com/jenkins/job/cloudogu-github/job/base),
the doguctl package must be supplied manually. The package can be found in the [latest release](https://github.com/cloudogu/doguctl/releases/latest) assets.

---
## What is the Cloudogu EcoSystem?
The Cloudogu EcoSystem is an open platform, which lets you choose how and where your team creates great software. Each service or tool is delivered as a Dogu, a Docker container. Each Dogu can easily be integrated in your environment just by pulling it from our registry.

We have a growing number of ready-to-use Dogus, e.g. SCM-Manager, Jenkins, Nexus Repository, SonarQube, Redmine and many more. Every Dogu can be tailored to your specific needs. Take advantage of a central authentication service, a dynamic navigation, that lets you easily switch between the web UIs and a smart configuration magic, which automatically detects and responds to dependencies between Dogus.

The Cloudogu EcoSystem is open source and it runs either on-premises or in the cloud. The Cloudogu EcoSystem is developed by Cloudogu GmbH under [AGPL-3.0-only](https://spdx.org/licenses/AGPL-3.0-only.html).

## License
Copyright © 2020 - present Cloudogu GmbH
This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
You should have received a copy of the GNU Affero General Public License along with this program. If not, see https://www.gnu.org/licenses/.
See [LICENSE](LICENSE) for details.


---
MADE WITH :heart:&nbsp;FOR DEV ADDICTS. [Legal notice / Imprint](https://cloudogu.com/en/imprint/?mtm_campaign=ecosystem&mtm_kwd=imprint&mtm_source=github&mtm_medium=link)
