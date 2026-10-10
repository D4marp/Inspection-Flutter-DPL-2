# DPL Inspection — Hari 2

Checkpoint mandiri hasil `flutter create` untuk architecture, REST API, token,
ChangeNotifier, cache, error handling, dan form POST.

## Toolchain

- Flutter 3.44.8 stable; Dart 3.12.2
- Simulator uji: iPhone 16, iOS 18.0
- Dependencies dikunci dalam `pubspec.lock`

## Menjalankan dengan hosted API

Backend utama kelas disiapkan menggunakan Express, Swagger/OpenAPI, dan Docker.
Periksa `/health` serta Swagger UI terlebih dahulu, lalu jalankan:

```sh
fvm flutter pub get
fvm flutter run -d "iPhone 16" \
  --dart-define=API_BASE_URL=https://HOST_API_TRAINING
```

Kontrak endpoint dan checklist backend–Flutter berada di
`../../materi_pendamping/API_HANDOFF_EXPRESS_SWAGGER_DOCKER.md`.

## Fallback mock lokal

Dari root paket, jalankan mock API di terminal pertama bila hosted API belum
tersedia:

```sh
python3 materi_pendamping/praktik/mock_api/mock_api.py --host 127.0.0.1 --port 8000
```

Lalu dari folder proyek ini:

```sh
fvm flutter pub get
fvm flutter run -d "iPhone 16" \
  --dart-define=API_BASE_URL=http://localhost:8000
```

Login demo: `trainer` / `training123`. Untuk screenshot otomatis trainer boleh
menambahkan `--dart-define=AUTO_LOGIN=true`. Jangan gunakan auto login atau
credential dummy ini untuk production.

Android Emulator memakai `http://10.0.2.2:8000`. Physical device memakai IP LAN
host pada jaringan kelas tepercaya. HTTP hanya untuk mock API lokal; gunakan
HTTPS untuk staging/production.

## Quality gate dan GitHub

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
git init
git add .
git commit -m "Complete Flutter day 2 API and storage"
git branch -M main
git remote add origin https://github.com/USERNAME/dpl-inspection-day-2.git
git push -u origin main
```

Jangan commit token, `.env`, signing key, atau data operasional.
