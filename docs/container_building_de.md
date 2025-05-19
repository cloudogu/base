# Container building

Dieses Container-Image bildet die Grundlage für viele Dogu-Container-Images.
Unter anderem ist die Hilfsbinärdatei `doguctl` ein wesentlicher Bestandteil dieses Images.

## Instructions for building and deploying

Auf einem Entwicklungs-Branch:

1. Aktualisiere die `Dockerfile` Felder `ALPINE_VER` and `ALPINE_VER_SHA` entsprechend
2. Aktualisiere das `Makefile` Feld `CHANGE_COUNTER` entsprechend
3. Aktualisiere das `Makefile` Feld `DOGUCTL_VERSION` entsprechend

PR/Merge den Entwicklungs-Branch in den Haupt-Branch.

## Instructions for building locally

1. Aktualisiere die `Dockerfile` Felder `ALPINE_VER` and `ALPINE_VER_SHA` entsprechend
2. Aktualisiere das `Makefile` Feld `CHANGE_COUNTER` entsprechend
3. Aktualisiere das `Makefile` Feld `DOGUCTL_VERSION` entsprechend
4. Wechseln Sie in eine Umgebung, in der ein Download des Binärprogramms `doguctl` möglich ist (Sie benötigen private Repo-Berechtigungen)
   1. Laden Sie die aktuellste Version von `doguctl` von der [doguctl Release-Seite](https://github.com/cloudogu/doguctl/releases) herunter.
   2. Platzieren Sie das Binary in `packages/`
5. Führen Sie `make build` aus
