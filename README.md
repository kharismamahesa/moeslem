# Moeslem

Aplikasi utilitas Islami berbasis Flutter: jadwal shalat, arah kiblat, dan Alquran.

## Fitur

- **Jadwal Shalat** — waktu Subuh, Dzuhur, Ashar, Maghrib, dan Isya, serta Imsak dan Syuruq. Menggunakan metode Kementerian Agama RI (method 20) dari [AlAdhan API](https://aladhan.com/prayer-times-api). Lokasi bisa diambil dari GPS perangkat atau dicari berdasarkan nama kota; lokasi awal adalah Pekanbaru.
- **Shalat berikutnya** — kartu yang menampilkan waktu shalat terdekat dan hitung mundur secara langsung.
- **Arah Kiblat** — kompas perhitungan lokal bearing menuju Ka'bah, disertai label arah mata angin dalam bahasa Indonesia.
- **Alquran** — daftar surah, teks Utsmani dan terjemahan bahasa Indonesia dari [AlQuran Cloud API](https://alquran.cloud/api), pencarian surah, serta bookmark surah dan ayah yang disimpan secara lokal.
- **Profil** — halaman placeholder untuk integrasi akun.

> **Catatan:** saat ini aplikasi **belum** mengirim notifikasi atau suara adzan otomatis. Hitung mundur hanya berjalan saat aplikasi dibuka.

## Teknologi

- Flutter / Dart (`sdk: ^3.12.2`)
- `provider` untuk state management
- `http` untuk konsumsi REST API
- `geolocator` untuk lokasi perangkat
- `shared_preferences` untuk penyimpanan bookmark
- `intl` untuk format tanggal dan waktu
- `flutter_lints` untuk analisis statis

## Struktur proyek

```text
lib/
├── core/
│   ├── constants/      # konstanta API, metode shalat, dan key penyimpanan
│   ├── location/       # layanan GPS dan lokasi default
│   ├── network/        # HTTP client
│   └── theme/          # tema aplikasi
├── features/
│   ├── prayer/         # jadwal shalat: model, API, provider, UI
│   ├── qibla/          # kalkulator dan kompas kiblat
│   ├── quran/          # surah, pencarian, bookmark, UI
│   ├── profile/        # halaman profil
│   └── shell/          # navigasi tab utama
└── shared/widgets/     # widget yang dipakai bersama
test/                   # pengujian unit dan widget
```

## Persyaratan

- Flutter SDK dengan Dart `^3.12.2`
- Android Studio (Android SDK) dan/atau Xcode (iOS)
- Perangkat atau emulator untuk menjalankan aplikasi
- Koneksi internet untuk data shalat dan Alquran

## Menjalankan proyek

```bash
flutter pub get
flutter run
```

## Pengujian dan analisis

```bash
flutter test
flutter analyze
```

## Rencana pengembangan

- [ ] Notifikasi jadwal shalat/adzan beserta suara adzan
- [ ] Pengaturan pengingat sebelum shalat dan waktu iqomah
- [ ] Pilihan metode perhitungan shalat
- [ ] Penyelesaian halaman profil

## Sumber data

- [AlAdhan API](https://aladhan.com/prayer-times-api) — jadwal shalat
- [AlQuran Cloud API](https://alquran.cloud/api) — teks dan terjemahan Alquran
