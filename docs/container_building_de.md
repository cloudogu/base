# Containerbau

Dieses Container-Image bildet die Basis für viele dogu-Container-Images. Neben anderen Bestandteilen ist das Hilfsprogramm `doguctl` ein wichtiger Teil dieses Images.

## Anleitung zum Bauen und Bereitstellen

1. Wechseln Sie in eine Umgebung, in der ein Download des Binärprogramms `doguctl` möglich ist (Sie benötigen private Repo-Berechtigungen)
   1. Laden Sie die aktuellste Version von `doguctl` von [der doguctl Release-Seite](https://github.com/cloudogu/doguctl/releases)
   1. Platzieren Sie das Binary in `packages/`
   1. Aktualisieren Sie die SHA256-Prüfsumme von `doguctl`, wenn sich die Version geändert hat
2. Wechseln Sie zu einer laufenden CES-Instanz
   1. Aktualisieren Sie die `Makefile` Felder `ALPINE_VERSION` und `CHANGE_COUNTER` entsprechend
   2. Erstellen Sie das Basis-Dogu-Image mit `make` oder `make build`.
   3. Verteilen Sie das Basis-Dogu-Image mit `make deploy`.
