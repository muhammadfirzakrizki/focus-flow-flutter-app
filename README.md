# 🌊 FocusFlow

FocusFlow adalah aplikasi manajemen tugas (task management) minimalis yang dibangun menggunakan Flutter dengan standar Material 3. Aplikasi ini dirancang untuk menunjukkan implementasi dasar pengembangan aplikasi mobile profesional, mulai dari UI/UX hingga penyimpanan data lokal.

---

## ✨ Fitur Utama

- **Full CRUD** — Menambah, melihat, dan menghapus tugas secara dinamis.
- **Local Persistence** — Data tetap tersimpan menggunakan `shared_preferences` (data tidak hilang saat aplikasi ditutup).
- **Modern Interaction** — Fitur Swipe-to-Delete untuk menghapus tugas dengan gestur geser.
- **Material 3 UI** — Menggunakan komponen desain terbaru dari Google dan Google Fonts (Plus Jakarta Sans).

---

## 🛠 Tech Stack

| Kategori  | Teknologi              |
|-----------|------------------------|
| Framework | Flutter                |
| Language  | Dart                   |
| Storage   | Shared Preferences     |
| UI        | Material 3 & Google Fonts |

---

## 🏗 Struktur Folder

Proyek ini menggunakan struktur yang terorganisir agar mudah dikelola:

```
lib/
├── data/               # Logika penyimpanan dan model data
├── presentation/       # Semua komponen UI (Screens & Widgets)
└── main.dart           # Titik masuk utama aplikasi
```

---

## 🚀 Cara Menjalankan Proyek

Bagi Anda yang ingin mencoba menjalankan proyek ini di lingkungan lokal, ikuti langkah-langkah berikut:

### Persyaratan

Pastikan Anda sudah menginstal **Flutter SDK** dan memiliki editor seperti **VS Code** atau **Android Studio**.

### Langkah-langkah

1. **Clone Repositori**
   ```bash
   git clone https://github.com/muhammadfirzakrizki/focus_flow.git
   ```

2. **Masuk ke Direktori**
   ```bash
   cd focus_flow
   ```

3. **Instal Dependencies**
   ```bash
   flutter pub get
   ```

4. **Jalankan Aplikasi**

   Hubungkan HP (lewat kabel/wireless debugging) atau buka Emulator, lalu jalankan:
   ```bash
   flutter run
   ```

---

<p align="center">
  Dibuat oleh <b>Muhammad Firzak Rizki</b><br>
  Software Developer | Bogor, Indonesia
</p>