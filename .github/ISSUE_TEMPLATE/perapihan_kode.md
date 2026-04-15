---
name: "🚀 Kualitas Kode: Implementasi Linting Ketat"
about: Meningkatkan konsistensi kode dan memperbaiki peringatan analisis statis.
title: "[TASK] Implementasi Strict Linting & Pembersihan Kode"
labels: peningkatan, maintenance
assignees: muhammadfirzakrizki
---

## 📌 Latar Belakang
Untuk menjaga standar kode skala profesional, sangat penting untuk mengikuti pedoman gaya (style guide) resmi Dart dan Flutter. Saat ini, proyek memerlukan konfigurasi linting yang seragam untuk mencegah kesalahan umum dan memastikan kode mudah dibaca oleh pengembang lain.

## 🎯 Tujuan
- [ ] Mengonfigurasi `analysis_options.yaml` dengan aturan yang ketat.
- [ ] Menyelesaikan semua peringatan (warnings) yang muncul saat menjalankan `flutter analyze`.
- [ ] Menstandarisasi konvensi penamaan dan struktur widget.

## 🛠️ Langkah-langkah Pengerjaan
1. **Konfigurasi Linter**: Pastikan file `analysis_options.yaml` menggunakan `package:flutter_lints/recommended.yaml` dan aktifkan aturan tambahan seperti `prefer_final_locals` serta penghapusan `avoid_print`.
2. **Perbaikan Otomatis**: Jalankan perintah `dart fix --apply` di terminal untuk menangani tugas repetitif seperti penambahan kata kunci `const`.
3. **Pembersihan Manual**: 
    - Hapus import yang tidak digunakan (*unused imports*).
    - Pastikan semua widget menggunakan constructor `const` jika memungkinkan.
    - Perbaiki penamaan variabel agar sesuai dengan standar *camelCase*.

## 🧪 Rencana Verifikasi
- Jalankan perintah `flutter analyze` di terminal.
- **Hasil yang Diharapkan**: `No issues found! (0 warnings, 0 errors)`

## 🔗 Referensi
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Dokumentasi Flutter Lints](https://pub.dev/packages/flutter_lints)