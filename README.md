# Course Explorer v2

Aplikasi Flutter untuk praktikum **State Management dan Mobile Application Architecture**.

## Identitas

- Nama: Putu Tasya Putri Ayuni
- NIM: 2415051031
- Semester: Semester 5

## State Management

Aplikasi menggunakan **Provider** dengan `ChangeNotifier` sebagai shared state management.

`CourseProvider` mengelola:

- daftar course
- loading state
- error state
- favorite course

Local state tetap digunakan untuk state yang hanya dibutuhkan oleh satu widget, seperti menampilkan atau menyembunyikan detail profil.

## Architecture

Dependency direction aplikasi:

```text
Screen / Widget
      ↓
Provider
      ↓
Repository
      ↓
Service / Data Source
      ↓
Asset JSON
```

Arsitektur tersebut membuat setiap layer memiliki tanggung jawab yang berbeda.

## Model

Folder:

```text
lib/models/
```

Model bertugas merepresentasikan struktur data aplikasi.

Model utama yang digunakan adalah:

```text
Course
```

`Course` memiliki beberapa property:

- `code`
- `title`
- `credits`
- `status`

Parsing JSON dilakukan melalui:

```dart
Course.fromJson()
```

Model tidak bertanggung jawab terhadap pengambilan data maupun tampilan UI.

## Service

Folder:

```text
lib/services/
```

Service bertanggung jawab terhadap data source.

`CourseService` melakukan:

- membaca asset JSON menggunakan `rootBundle`
- melakukan decoding menggunakan `jsonDecode`
- mengambil daftar course dari JSON
- mengubah data JSON menjadi `List<Course>`

Contoh alur:

```text
assets/data/student_data.json
        ↓
rootBundle
        ↓
jsonDecode
        ↓
Course.fromJson()
        ↓
List<Course>
```

UI tidak membaca file JSON secara langsung.

## Repository

Folder:

```text
lib/repositories/
```

Repository menjadi abstraction layer antara Provider dan sumber data.

`CourseRepository` menyediakan method:

```dart
getCourses()
```

Alurnya:

```text
CourseProvider
      ↓
CourseRepository
      ↓
CourseService
```

Dengan repository, Provider tidak perlu mengetahui bagaimana data sebenarnya diperoleh.

Jika sumber data nantinya berubah dari asset JSON menjadi REST API, layer UI tidak perlu mengetahui detail perubahan tersebut.

## Provider

Folder:

```text
lib/providers/
```

`CourseProvider` bertanggung jawab terhadap application state.

State yang dikelola antara lain:

```text
courses
isLoading
error
favorites
```

Provider juga menyediakan beberapa operasi seperti:

```dart
loadCourses()
toggleFavorite()
isFavorite()
```

Provider tidak menggunakan `BuildContext` dan tidak mengandung widget UI.

Saat state berubah, Provider memanggil:

```dart
notifyListeners();
```

Widget yang menggunakan `watch` atau `Consumer` kemudian dapat melakukan rebuild.

## Screens

Folder:

```text
lib/screens/
```

Screen bertanggung jawab terhadap tampilan halaman dan interaksi pengguna.

Screen utama aplikasi terdiri dari:

- `CourseExplorerPage`
- `DashboardPage`
- `CoursesPage`
- `CourseDetailPage`
- `FavoritesPage`

Screen membaca shared state dari `CourseProvider`.

Screen tidak melakukan:

```text
rootBundle
jsonDecode
CourseService
```

secara langsung.

## Widgets

Folder:

```text
lib/widgets/
```

Widget berisi reusable presentation component.

Contoh widget:

```text
CourseCard
SummaryCard
```

Widget digunakan agar komponen UI dapat digunakan kembali dan kode pada screen tidak terlalu besar.

Widget tidak bertanggung jawab terhadap data source.

## Responsive Navigation

Course Explorer v2 menggunakan navigation yang menyesuaikan ukuran layar.

Pada layar kecil digunakan:

```dart
NavigationBar
```

Pada layar lebar digunakan:

```dart
NavigationRail
```

Breakpoint yang digunakan:

```dart
constraints.maxWidth >= 720
```

Alurnya:

```text
Width < 720
    ↓
NavigationBar

Width >= 720
    ↓
NavigationRail
```

Dengan demikian aplikasi tetap dapat digunakan pada tampilan mobile maupun layar yang lebih lebar.

## Shared Favorite State

Favorite course disimpan di dalam:

```text
CourseProvider
```

State favorite yang sama digunakan pada beberapa screen:

```text
Courses
   ↓
Course Detail
   ↓
Favorites
```

Jika favorite diubah pada salah satu screen, screen lain akan membaca state terbaru dari Provider.

Contoh:

```text
Courses
   ↓
Toggle Favorite
   ↓
CourseProvider
   ↓
notifyListeners()
   ↓
Course Detail dan Favorites ikut berubah
```

Dengan cara ini tidak terdapat salinan favorite state yang terpisah pada masing-masing screen.

## Async State

Proses loading course dikelola oleh `CourseProvider`.

Provider memiliki tiga kondisi utama:

```text
Loading
   ↓
Success
```

atau:

```text
Loading
   ↓
Error
```

Ketika proses sedang berjalan:

```dart
isLoading == true
```

UI menampilkan:

```dart
CircularProgressIndicator()
```

Jika data berhasil dimuat:

```dart
courses
```

akan berisi daftar course.

Jika terjadi kegagalan:

```dart
error
```

akan berisi informasi error.

UI kemudian menampilkan:

```text
Gagal memuat data

[Coba Lagi]
```

Tombol **Coba Lagi** menjalankan ulang:

```dart
provider.loadCourses()
```

## Local State dan Shared State

Aplikasi menggunakan dua jenis state.

### Local State

Contoh:

```dart
bool showProfileDetails = true;
```

State ini hanya digunakan oleh `DashboardPage`.

Perubahannya cukup menggunakan:

```dart
setState()
```

### Shared State

Contoh:

```text
courses
favorites
loading
error
```

State tersebut digunakan oleh beberapa bagian aplikasi sehingga dikelola menggunakan:

```text
Provider + ChangeNotifier
```

## Data Flow

Alur pengambilan data course:

```text
UI
 ↓
CourseProvider
 ↓
CourseRepository
 ↓
CourseService
 ↓
student_data.json
```

Data kemudian kembali ke arah UI:

```text
student_data.json
       ↓
CourseService
       ↓
List<Course>
       ↓
CourseRepository
       ↓
CourseProvider
       ↓
Screen / Widget
```

## Dependency Direction

Dependency utama aplikasi:

```text
Screen / Widget
      ↓
Provider
      ↓
Repository
      ↓
Service
      ↓
Data Source
```

Model dapat digunakan sebagai representasi data oleh beberapa layer:

```text
             Model
            ↙     ↘
     Repository   Provider
          ↑          ↑
        Service      UI
```

`main.dart` berfungsi sebagai composition root untuk menyusun dependency:

```dart
CourseProvider(
  CourseRepository(
    CourseService(),
  ),
)
```

## Separation of Concerns

Hasil audit arsitektur:

- Screen dan Widget tidak menggunakan `rootBundle`.
- Screen dan Widget tidak menggunakan `jsonDecode`.
- Screen dan Widget tidak mengambil data langsung melalui `CourseService`.
- Provider tidak menggunakan `BuildContext`.
- Provider tidak mengandung Widget.
- Repository menjadi penghubung antara Provider dan Service.
- Service bertanggung jawab terhadap data source.
- Parsing JSON dilakukan pada Service.
- Model merepresentasikan struktur data.
- UI bertanggung jawab terhadap presentation dan interaction.

Dependency final:

```text
UI
 ↓
Provider
 ↓
Repository
 ↓
Service
 ↓
Data Source
```

## Project Structure

Struktur utama folder:

```text
lib/
├── main.dart
│
├── models/
│   └── course.dart
│
├── providers/
│   └── course_provider.dart
│
├── repositories/
│   └── course_repository.dart
│
├── screens/
│   ├── course_explorer_page.dart
│   ├── dashboard_page.dart
│   ├── courses_page.dart
│   ├── course_detail_page.dart
│   └── favorites_page.dart
│
├── services/
│   └── course_service.dart
│
└── widgets/
    ├── course_card.dart
    └── summary_card.dart
```

## Final Architecture

Course Explorer v2 menggunakan kombinasi:

```text
Flutter UI
+
Provider
+
ChangeNotifier
+
Repository Pattern
+
Service Layer
+
Model
+
Responsive Navigation
```

Arah dependency akhir:

```text
Screen / Widget
      ↓
CourseProvider
      ↓
CourseRepository
      ↓
CourseService
      ↓
Asset JSON
```

Struktur ini membuat aplikasi lebih mudah dipelihara, diuji, dan dikembangkan jika sumber data atau kebutuhan aplikasi berubah di kemudian hari.

## Status Praktikum

Worksheet **State Management & Mobile Application Architecture** telah diselesaikan sampai Tahap 17.

- Nama: Putu Tasya Putri Ayuni
- NIM: 2415051031
- Aplikasi: Course Explorer v2
- State Management: Provider + ChangeNotifier
- Architecture: Provider → Repository → Service
- Responsive Navigation: NavigationBar + NavigationRail
- Status: Selesai