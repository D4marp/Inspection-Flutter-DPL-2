# OpenCode dan API Key AI — Lab Hari 2

Dokumen ini memakai OpenCode 1 stable. Periksa halaman instalasi resmi sebelum
kelas, lalu catat versi yang benar-benar dipakai pada laptop trainer.

## 1. Instalasi

Pilih satu metode:

```sh
# macOS / Linux
curl -fsSL https://opencode.ai/install | bash

# atau Homebrew
brew install anomalyco/tap/opencode

# atau Node.js
npm install -g opencode-ai
```

Verifikasi:

```sh
opencode --version
```

Windows disarankan memakai WSL. Jangan mengeksekusi installer jaringan tanpa
meninjau sumber dan kebijakan perangkat organisasi.

## 2. Hubungkan provider

Dari root project jalankan `opencode`, lalu di dalam TUI:

```text
/connect
/models
/init
```

`/connect` meminta provider dan API key. Jangan menulis key pada prompt,
repository, slide, screenshot, atau log. Gunakan akun training dengan quota dan
retention policy yang telah disetujui. `/init` menganalisis project dan membuat
`AGENTS.md`; review file tersebut sebelum di-commit.

## 3. Batas keamanan

- API key OpenCode adalah credential tool developer, bukan credential aplikasi.
- Jangan menaruh key pada Dart constant, `--dart-define`, asset, atau APK/IPA.
- Integrasi AI runtime berada di luar scope kelas dan memerlukan arsitektur
  tepercaya yang menangani authentication, authorization, quota, redaction,
  dan audit.
- File `.env` diabaikan Git, tetapi environment variable tetap dapat bocor ke
  process list, shell history, crash report, atau log bila digunakan sembarangan.
- Cabut/rotate key segera bila pernah ter-commit.

## 4. Checkpoint kelas

1. `opencode --version` berhasil.
2. Provider muncul setelah `/connect`.
3. Model dipilih melalui `/models`.
4. `/init` menghasilkan `AGENTS.md` yang sudah direview.
5. Peserta meminta agent merangkum struktur `lib/src` tanpa melakukan edit.
6. Peserta memeriksa bahwa diff hanya berisi `AGENTS.md` yang disetujui dan
   tidak ada secret.

Rujukan resmi:

- <https://opencode.ai/docs>
- <https://opencode.ai/docs/providers>
- <https://opencode.ai/docs/skills>
