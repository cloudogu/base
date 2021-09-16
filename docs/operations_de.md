# Funktionen des Cloudogu-Basis-Images

## Zusätzliche Zertifikate

Zusätzliche Zertifikate können über zwei `etcd`-Schlüssel angesprochen werden:
- `/config/_global/certificate/additional/toc`
  - dieser Schlüssel enthält das Inhaltsverzeichnis der Aliasnamen über zusätzliche Zertifikate
  - einzelne Aliase werden durch Leerzeichen getrennt
- `/config/_global/certificate/additional/$alias`
  - diese Schlüssel enthalten die gewünschten Zertifikate
  - wenn dieses Zertifikat angesprochen werden soll, muss der Schlüsselname im obigen Inhaltsverzeichnis erscheinen
  - diese Schlüssel müssen Zeilenumbrüche mit `\n` einschließen

Beispielkonfiguration in `etcd`:

```
config/
└─ _global/
   └─ certificate/
      └─ additional/
         ├─ toc          -> "example.com localserver2 server3"
         ├─ example.com  -> "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"
         ├─ localserver2 -> "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"
         └─ server3      -> "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"
```
