# Konfigurasi environment

File JSON di folder ini dipasok ke compile-time lewat
`--dart-define-from-file`. Hanya nilai **non-rahasia** (URL publik, limit,
timeout) yang boleh masuk Git. Secret/token wajib berada di backend atau
secure storage, bukan di sini.

```sh
fvm flutter run --dart-define-from-file=env/dev.json
fvm flutter build apk --dart-define-from-file=env/prod.json
```

Override personal: salin ke `env/local.json` (diabaikan Git).
