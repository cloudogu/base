# Entwicklung des Cloudogu EcoSystem Alpine Base Image

## Shell-Tests mit BATS

Sie können Bash-Tests im Verzeichnis `unitTests` erstellen und ändern. Das Make-Target `unit-test-shell` unterstützt Sie mit einer verallgemeinerten Bash-Testumgebung.

```bash
make unit-test-shell
```

BATS ist so konfiguriert, dass es JUnit-kompatible Berichte in `target/shell_test_reports/` hinterlässt.

Um testbare Shell-Skripte zu schreiben, sollten diese Aspekte beachtet werden:

### Allgemeine Struktur von Skripten-unter-Tests

Es ist eher unüblich, ein _Script-under-test_ wie `startup.sh` ganz alleine auszuführen. Effektive Unit-Tests werden höchstwahrscheinlich zu einem Albtraum, wenn keine angemessene Skriptstruktur vorhanden ist. Da diese Skripte sich gegenseitig quellen _und_ Code ausführen, muss **alles** vorher eingerichtet werden: globale Variablen, Mocks von jedem einzelnen aufgerufenen Binary... und so weiter. Letztendlich würden die Tests eher auf einer End-to-End-Testebene als auf einer Unit-Test-Ebene stattfinden.

Die gute Nachricht ist, dass das Testen einzelner Funktionen mit diesen kleinen Teilen möglich ist:

1. Sourcing-Ausführungsgarantien verwenden
1. Führen Sie Binärdateien und logischen Code nur innerhalb von Funktionen aus
1. Sourcen mit (dynamischen, aber fixierten) Umgebungsvariablen

#### Sourcing-Ausführungsgarantien verwenden

Ermöglichen Sie Sourcing mit _sourcing execution guards_ wie diesem:

```bash
# yourscript.sh
function runTheThing() {
    echo "hello world"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  runTheThing
fi
```

Die folgende `if`-Bedingung wird ausgeführt, wenn das Skript durch einen Aufruf über die Shell ausgeführt wird, aber nicht, wenn es von einer Quelle kommt:

```bash
$ ./yourscript.sh
hello world
$ source yourscript.sh
$ runTheThing
hello world
$
```

Sourcing Execution Guards funktionieren auch mit Parametern:

```bash
# yourscript.sh
function runTheThing() {
    echo "${1} ${2}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  runTheThingWithParameters "$@"
fi
```

Man beachte die korrekte Argumentübergabe mit `"$@"`, die auch Argumente mit Leerzeichen und dergleichen zulässt.

```bash
$ ./yourscript.sh hello world
hello world
$ source yourscript.sh
$ runTheThing hello bash
hello bash
$
```

#### Binärdateien und Logikcode nur innerhalb von Funktionen ausführen

Umgebungsvariablen und Konstanten sind in Ordnung, aber sobald Logik außerhalb einer Funktion läuft, wird sie während des Skript-Sourcings ausgeführt.
