[![GitHub license](https://img.shields.io/github/license/cloudogu/base.svg)](https://github.com/cloudogu/base/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/cloudogu/base.svg)](https://github.com/cloudogu/base/releases)

# Base Dogu Docker image

## How to Build

    docker build -t official/base:<alpine linux version>-<cloudogu revision> .

example

    docker build -t official/base:3.6-1 .


NOTE: _alpine linux version_ see FROM statement in Dockerfile

NOTE: _alpine linux version_ and _cloudogu revision_ should be mentioned on the first line in Dockerfile

## Why is there a branch called alpine3.5?

Some Dogus need Alpine 3.5 as their base, therefore, a base Dogu version with Alpine 3.5 must be maintained as well as one with a more recent Alpine (currently Alpine 3.10.3)

## Additional packages for base not included in alpine repository

### doguctl

origin is https://github.com/cloudogu/doguctl/releases/download/v0.3.0/doguctl-0.3.0.tar.gz
cached in packages directory to avoid download
