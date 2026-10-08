# Debugging Provider dan State

Nama: Putu Tasya Putri Ayuni  
NIM: 2415051031

## 1. `notifyListeners()` tidak dipanggil

Saya mencoba menghapus sementara `notifyListeners()` dari method `toggleFavorite()` pada `CourseProvider`.

State favorite tetap berubah di dalam Provider, tetapi UI tidak langsung ikut berubah karena widget yang menggunakan `watch` atau `Consumer` tidak menerima notifikasi untuk melakukan rebuild.

**Solusi:**  
Pastikan setiap perubahan state yang perlu ditampilkan kembali pada UI diikuti dengan pemanggilan `notifyListeners()`.

---

## 2. Provider tidak ditemukan

Saya mencoba menjalankan aplikasi tanpa membungkus widget tree dengan `ChangeNotifierProvider`.

Widget yang memanggil:

```dart
context.watch<CourseProvider>()
```

tidak dapat menemukan `CourseProvider` pada ancestor widget tree dan menghasilkan `ProviderNotFoundException`.

**Solusi:**  
Pastikan Provider ditempatkan pada ancestor yang sesuai dan membungkus semua widget yang membutuhkan akses ke state tersebut.

Struktur yang benar:

```text
ChangeNotifierProvider
└── MyApp
    └── CourseExplorerPage
        └── context.watch<CourseProvider>()
```

---

## 3. Error pada data source

Saya mencoba mengganti sementara path asset menjadi file yang tidak ada.

Path yang benar:

```dart
'assets/data/student_data.json'
```

Diubah sementara menjadi:

```dart
'assets/data/student_data_error.json'
```

`CourseService` gagal membaca data dan error diteruskan sampai ke `CourseProvider`.

Provider kemudian menyimpan error tersebut pada state sehingga UI dapat menampilkan pesan gagal memuat data dan tombol **Coba Lagi**.

**Solusi:**  
Periksa kembali path asset atau data source yang digunakan dan pastikan error ditangani oleh Provider agar UI dapat menampilkan error state dengan jelas.

Alur error:

```text
CourseService
    ↓
Gagal membaca data
    ↓
CourseRepository
    ↓
CourseProvider
    ↓
error state
    ↓
UI menampilkan pesan error
```

---

## 4. Async dan `mounted`

Jika sebuah `StatefulWidget` melakukan operasi asynchronous kemudian menggunakan `setState()` atau `BuildContext` setelah `await`, widget tersebut mungkin sudah tidak berada pada widget tree.

Contoh:

```dart
Future<void> loadSomething() async {
  await someAsyncOperation();

  if (!mounted) return;

  setState(() {
    // update UI
  });
}
```

Jika menggunakan `BuildContext` setelah operasi async, pengecekan juga dapat dilakukan dengan:

```dart
await someAsyncOperation();

if (!context.mounted) return;

Navigator.pop(context);
```

Pada `CourseProvider` saat ini pengecekan `mounted` tidak diperlukan karena Provider tidak menggunakan `BuildContext` dan tidak memanggil `setState()`.

---

## Langkah pertama ketika data berubah tetapi UI tidak berubah

Langkah pertama yang saya lakukan adalah memeriksa apakah method yang mengubah state sudah memanggil `notifyListeners()`.

Setelah itu saya memeriksa apakah widget yang seharusnya berubah memang mendengarkan Provider menggunakan `watch` atau `Consumer`, serta memastikan widget tersebut berada di bawah Provider yang sesuai.

Secara sederhana:

```text
state berubah
     │
     ├── apakah notifyListeners() dipanggil?
     │
     └── apakah UI menjadi listener?
```

Jika salah satu tidak terpenuhi, state dapat berubah tetapi UI tidak langsung ikut diperbarui.