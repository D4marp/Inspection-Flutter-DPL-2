# DPL Inspection — Hari 2

Proyek Flutter Hari 2 memakai API publik open-source
[JSONPlaceholder](https://jsonplaceholder.typicode.com) sehingga peserta dapat
langsung menjalankan latihan tanpa membuat akun, API key, atau server
lokal.

## Area latihan

- **Public CRUD API:** GET, POST, PUT, DELETE pada resource `/posts`.
- **Domain adapter:** schema post dipetakan menjadi model inspection.
- **UI Dasar:** `Scaffold`, `AppBar`, `Row`, `Column`, `Form`, dan validation.
- **Picker:** image preview dan file metadata lokal.
- **AI Setup:** OpenCode, `/connect`, `/models`, dan keamanan API key.

## Penting: write hanya simulasi

JSONPlaceholder mengembalikan response sukses untuk POST, PUT, dan DELETE,
tetapi tidak menyimpan perubahan secara permanen. Aplikasi mengubah state lokal
agar peserta dapat melihat hasil CRUD. Ketika menekan refresh/reset, daftar akan
kembali ke data public API.

Banner pada tab CRUD selalu menjelaskan batas ini. Jangan menyatakan create,
update, atau delete sebagai persistence production.

## Menjalankan

```sh
fvm flutter pub get
fvm flutter analyze
fvm flutter test
fvm flutter run
```

Base URL default sudah public:

```text
https://jsonplaceholder.typicode.com
```

Tidak ada login karena JSONPlaceholder tidak memerlukan authentication. Jika
ingin mengganti mirror HTTPS yang kompatibel:

```sh
fvm flutter run \
  --dart-define=API_BASE_URL=https://HOST-YANG-KOMPATIBEL
```

## Endpoint latihan

| Intent | Method | Endpoint | Status |
|---|---|---|---:|
| Read | GET | `/posts?_limit=20` | 200 |
| Create simulasi | POST | `/posts` | 201 |
| Update simulasi | PUT | `/posts/{id}` | 200 |
| Delete simulasi | DELETE | `/posts/{id}` | 200 |

## Tutorial pembuatan per file

Ikuti [docs/JSONPLACEHOLDER_PER_FILE.md](docs/JSONPLACEHOLDER_PER_FILE.md).
Dokumen tersebut menjelaskan urutan pembuatan dan tanggung jawab setiap file:

1. `pubspec.yaml`
2. `models/inspection.dart`
3. `data/json_placeholder_mapper.dart`
4. `data/crud/read_inspections.dart`
5. `data/crud/create_inspection.dart`
6. `data/crud/update_inspection.dart`
7. `data/crud/delete_inspection.dart`
8. `data/api_client.dart` sebagai facade
9. `data/inspection_repository.dart`
10. `controllers/inspection_controller.dart`
11. `app.dart` dan screens
12. test mapper/API/UI

Empat file CRUD dapat dibedah dan diuji satu per satu. Aplikasi tetap memakai
`ApiClient` sebagai facade sehingga pemanggilan dari repository tetap ringkas.

## Picker dan OpenCode

Lampiran pada form hanya preview/metadata lokal dan belum dikirim ke API.
Panduan OpenCode berada di
[docs/OPENCODE_AI_SETUP.md](docs/OPENCODE_AI_SETUP.md). API key provider AI
tidak boleh dimasukkan ke source Flutter, asset, `dart-define`, APK, atau Git.

## Quality gate

```sh
fvm dart format --output=none --set-exit-if-changed lib test
fvm flutter analyze
fvm flutter test
fvm flutter build apk --debug
```

Seluruh demo network Hari 2 memakai JSONPlaceholder agar kelas dapat langsung
berjalan tanpa deployment tambahan.
