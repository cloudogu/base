# Container building

Dieses Container-Image bildet die Grundlage für viele Dogu-Container-Images.
Unter anderem ist die Hilfsbinärdatei `doguctl` ein wesentlicher Bestandteil dieses Images.

## Instructions for building and deploying

Auf einem Entwicklungs-Branch:

1. Aktualisiere die `Makefile` Felder `ALPINE_VER`, `ALPINE_VER_SHA`, `CHANGE_COUNTER` und `DOGUCTL_VERSION` entsprechend
2. PR/Merge den Entwicklungs-Branch in den Haupt-Branch `main`.

## Instructions for building locally

1. Aktualisiere die `Makefile` Felder `ALPINE_VER`, `ALPINE_VER_SHA`, `CHANGE_COUNTER` und `DOGUCTL_VERSION` entsprechend
2. Wechseln Sie in eine Umgebung, in der ein Download des Binärprogramms `doguctl` möglich ist (Sie benötigen private Repo-Berechtigungen)
   1. Laden Sie die aktuellste Version von `doguctl` von der [doguctl Release-Seite](https://github.com/cloudogu/doguctl/releases) herunter
   2. Platzieren Sie das Binary in `packages/`
3. Führen Sie `make build` aus
