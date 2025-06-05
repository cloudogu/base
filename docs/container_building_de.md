# Containerbau

Dieses Container-Image bildet die Grundlage für viele Dogu-Container-Images.
Unter anderem ist die Hilfsbinärdatei `doguctl` ein wesentlicher Bestandteil dieses Images.

## Anleitung zum Bauen und Bereitstellen

Auf einem Entwicklungs-Branch:

1. Aktualisiere die `Makefile` Felder `ALPINE_VERSION`, `ALPINE_VER_SHA`, `CHANGE_COUNTER` und `DOGUCTL_VERSION` entsprechend
2. PR/Merge den Entwicklungs-Branch in den Haupt-Branch `main`.

## Anleitung zum lokalen Bauen

1. Aktualisiere die `Makefile` Felder `ALPINE_VERSION`, `ALPINE_VER_SHA`, `CHANGE_COUNTER` und `DOGUCTL_VERSION` entsprechend
2. Wechseln Sie in eine Umgebung, in der ein Download des Binärprogramms `doguctl` möglich ist (Sie benötigen private Repo-Berechtigungen)
   1. Laden Sie die aktuellste Version von `doguctl` von der [doguctl Release-Seite](https://github.com/cloudogu/doguctl/releases) herunter
   2. Platzieren Sie das Binary in `packages/`
3. Führen Sie `make build` aus
