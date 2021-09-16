# Operating Cloudogu base image features

## Additional certificates

Additional certificates can be addressed using two `etcd` keys:
- `/config/_global/certificate/additional/toc`.
   - this key contains the table of contents of aliases over additional certificates
   - single aliases are separated by spaces
- `/config/_global/certificate/additional/$alias`
   - these keys contain the desired certificates
   - if this certificate is to be addressed, the key name must appear in the above table of contents
   - these keys must wrap line breaks with `\n`

Example configuration in `etcd`:

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
