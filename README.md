# Flutter UI Fundamentals - Worksheet 7

Praktikum Integrasi REST API, Service Layer, dan State Management.

## Endpoint REST API
- **GET /courses**: Mengambil daftar seluruh course
- **POST /courses**: Menambahkan course baru
- **PUT /courses/{id}**: Memperbarui data course berdasarkan ID
- **DELETE /courses/{id}**: Menghapus course berdasarkan ID

## Perubahan Kode
- Menambahkan package `http: ^1.2.0` pada `pubspec.yaml`
- Membuat `CourseApiService` untuk memisahkan logika HTTP dari UI
- Mengatur penanganan state `Loading`, `Success`, `Empty`, dan `Error`