# Build & Release

Nimm deine Änderungen vor, z.B.:

1. Aktualisiere in `Makefile` die Felder `*_VERSION` und `CHANGE_COUNTER`.
2. Lege im `CHANGELOG.md` einen Abschnitt für die neue Version an.

### Lokal bauen

1. [`doguctl`](https://github.com/cloudogu/doguctl/releases) Release passend zu `DOGUCTL_VERSION` herunterladen.
2. Als `packages/doguctl.tar.gz` ablegen.
3. Bauen mit `make build`.
4. Testen mit `make unit-test-shell-local`.

### Release veröffentlichen

PR/Merge den Entwicklungsstand in den jeweiligen Haupt-Branch (`alpine3.23`, `alpine3.24`, ...).

Nutze den Pipeline-Parameter `PublishPrerelease`, um ein Prerelease-Image im Namespace `registry.cloudogu.com/prerelease_official/` zu veröffentlichen.

Nutze den Pipeline-Parameter `PublishRelease`, um ein Image im Namespace `registry.cloudogu.com/official/` zu veröffentlichen und ein GitHub-Release zu erstellen.
Der Release-Tag wird automatisch aus den `Makefile`-Variablen erzeugt.
