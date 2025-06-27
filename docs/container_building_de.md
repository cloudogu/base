# Containerbau

Dieses Container-Image bildet die Grundlage für viele Dogu-Container-Images.
Unter anderem ist die Hilfsbinärdatei `doguctl` ein wesentlicher Bestandteil dieses Images.

## Anleitung zum Bauen und Bereitstellen

Auf einem Entwicklungs-Branch:

1. Aktualisiere die `Makefile` Felder `ALPINE_VERSION`, `ALPINE_VER_SHA`, `CHANGE_COUNTER`, `DOGUCTL_VERSION` und `DOGUCTL_VER_SHA` entsprechend.
2. PR/Merge den Entwicklungs-Branch in den Ziel-Branch.

In der Jenkins Pipeline sind folgende Parameter verfügbar:
- `PublishRelease`
- `PublishPrerelease`

Werden diese Parameter aktiviert, wird das gebaute Image anschließend veröffentlicht.

Mit aktiviertem `PublishRelease` Parameter wird das Image im Namespace `registry.cloudogu.com/official/` veröffentlicht.

Mit aktiviertem `PublishPrerelease` Parameter wird das Image im Namespace `registry.cloudogu.com/prerelease_official/` veröffentlicht.

Um ältere Varianten des Images erneut zu bauen und zu veröffentlichen, stehen
Branches zu Verfügung, für welche der Build- & Release-Prozess mittels
Parameter analog zum Haupt-Branch gestartet werden kann.

## Anleitung zum lokalen Bauen

1. Aktualisiere die `Makefile` Felder `ALPINE_VERSION`, `ALPINE_VER_SHA`, `CHANGE_COUNTER` und `DOGUCTL_VERSION` entsprechend
2. Wechseln Sie in eine Umgebung, in der ein Download des Binärprogramms `doguctl` möglich ist (Sie benötigen private Repo-Berechtigungen)
   1. Laden Sie die aktuellste Version von `doguctl` von der [doguctl Release-Seite](https://github.com/cloudogu/doguctl/releases) herunter
   2. Platzieren Sie das Binary in `packages/`
3. Führen Sie `make build` aus
