# Course Data Manager

Course Data Manager adalah aplikasi Flutter untuk mengelola data course secara dinamis menggunakan Supabase sebagai backend database. Aplikasi ini merupakan pengembangan Course Explorer v2 dan mempertahankan responsive navigation, halaman detail, favorites, serta identitas mahasiswa.

Identitas mahasiswa:

- Nama: Putu Tasya Putri Ayuni
- NIM: 2415051031

## Fitur

- SELECT, INSERT, UPDATE, dan DELETE data course melalui Supabase.
- Loading, success, empty, error state, retry, dan refresh.
- Validasi code, title, credits, dan status.
- Responsive GridView, NavigationBar, dan NavigationRail.
- Detail course dan favorites.

## Menjalankan project

```bash
flutter pub get
flutter run
```

Konfigurasi Supabase berada di `lib/main.dart` dan menggunakan publishable key untuk client Flutter. Jangan gunakan `service_role` key atau secret key pada aplikasi.

## Database Supabase

Migration tersedia di `supabase/migrations/20261031000000_create_courses.sql`.

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint identity | Primary key |
| `code` | text | Kode course |
| `title` | text | Judul course |
| `credits` | integer | Harus lebih dari 0 |
| `status` | text | `planned`, `active`, atau `done` |
| `created_at` | timestamptz | Waktu pembuatan |

Migration mengaktifkan RLS dan policy CRUD permisif untuk praktikum anonim. Policy ini bukan pola produksi; aplikasi produksi sebaiknya memakai autentikasi dan policy berbasis kepemilikan data.

## Arsitektur

```text
Supabase / REST API
        ↓
CourseSupabaseService / CourseApiService
        ↓
CourseDataSource → CourseRepository → CourseProvider → UI
```

Sumber data dapat diganti melalui wiring di `lib/main.dart` tanpa mengubah screen, provider, atau repository.

## Struktur penting

- `lib/models/course.dart`: model dan JSON mapping.
- `lib/services/course_data_source.dart`: kontrak operasi data.
- `lib/services/course_supabase_service.dart`: operasi Supabase.
- `lib/services/course_api_service.dart`: implementasi REST JSONPlaceholder.
- `lib/repositories/course_repository.dart`: abstraction sumber data.
- `lib/providers/course_provider.dart`: state, CRUD, dan favorites.
- `lib/screens/course_explorer_page.dart`: shell responsive, loading, dan error retry.
- `lib/screens/courses_page.dart`: daftar, form CRUD, refresh, dan empty state.
- `lib/widgets/error_view.dart`: tampilan error dan retry.

## Pemeriksaan keamanan

- Tidak menggunakan `service_role` key, password, atau token rahasia.
- File `.env` dan environment lokal di-ignore Git.
- Publishable key hanya digunakan sebagai client key.
- RLS tetap aktif pada tabel `courses`.
- Validasi UI tidak menggantikan authorization backend.

## Pemeriksaan Git

Branch implementasi adalah `api`.

```bash
git log --oneline -12
git status
```

Commit Tahap 18:

```text
Finalisasi README dan bukti pengumpulan pertemuan 7
```

Panduan screenshot dan worksheet disimpan lokal untuk bukti praktikum, tetapi tidak dilacak atau dipush ke repository.
