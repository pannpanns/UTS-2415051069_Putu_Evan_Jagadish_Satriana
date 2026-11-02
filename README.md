# TuntasKuliah — Academic Task Manager

TuntasKuliah adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu mahasiswa mengelola tugas perkuliahan secara lebih terstruktur. Aplikasi ini menyediakan fitur pengelolaan tugas, mata kuliah, deadline, prioritas, dan status pengerjaan, serta dashboard untuk memantau progres penyelesaian tugas.

## Identitas Pengembang

| Informasi | Keterangan |
|---|---|
| Nama | Putu Evan Jagadish Satriana|
| NIM | 2415051069 |
| Kelas | PTI 5B |
| Mata Kuliah | Pemrograman Mobile |
| Project | TuntasKuliah |

## Fitur Aplikasi

### 1. Dashboard (Home)
- Menampilkan total tugas.
- Menampilkan jumlah tugas yang selesai.
- Menampilkan jumlah tugas yang sedang dikerjakan.
- Menampilkan jumlah tugas yang belum dimulai.
- Menampilkan persentase penyelesaian tugas.
- Menampilkan daftar tugas minggu ini.

### 2. Manajemen Tugas
- Menambahkan tugas baru.
- Melihat daftar tugas.
- Melihat detail tugas.
- Mengedit informasi tugas.
- Menghapus tugas dengan konfirmasi.
- Mengatur deadline tugas.
- Mengatur prioritas tugas.

### 3. Status Pengerjaan
Pengguna dapat mengubah status tugas melalui halaman Detail Tugas:
- Belum Mulai
- Dikerjakan
- Selesai

### 4. Manajemen Mata Kuliah
- Menambahkan mata kuliah.
- Melihat daftar mata kuliah.
- Mengedit mata kuliah.
- Menghapus mata kuliah.
- Mengatur kode mata kuliah.
- Mengatur jumlah SKS.
- Mengatur status mata kuliah.

### 5. Interaksi Pengguna
- Navigasi melalui Bottom Navigation.
- Navigasi dari kartu tugas menuju Detail Tugas.
- Dropdown pemilihan mata kuliah.
- Date Picker untuk memilih deadline.
- Dropdown prioritas dan status.
- Form validation.
- Dialog konfirmasi penghapusan.
- SnackBar sebagai feedback operasi.

### 6. Error Handling
- Loading indicator.
- Error message.
- Empty state.
- Tombol retry.
- Penanganan kesalahan koneksi.
- Penanganan kesalahan database.

### 7. Responsive Layout
- Mendukung orientasi portrait.
- Mendukung orientasi landscape.
- Penyesuaian layout berdasarkan ukuran layar.

## Tech Stack

| Teknologi | Kegunaan |
|---|---|
| Flutter | Framework pengembangan aplikasi |
| Dart | Bahasa pemrograman |
| Provider | State management |
| ChangeNotifier | Pengelolaan perubahan state |
| Supabase | Backend dan database |
| PostgreSQL | Relational database |
| HTTP | HTTP request untuk REST API |
| flutter_dotenv | Pengelolaan environment variables |
| Material 3 | Desain antarmuka aplikasi |

## REST API Integration

Aplikasi memiliki implementasi integrasi REST API menggunakan Course API.

**API Endpoint:**

https://course-api-pearl.vercel.app/courses

**HTTP Method:** GET

**Implementasi API:**
- Mengambil data mata kuliah menggunakan HTTP GET.
- Menggunakan JSON decoding untuk membaca response.
- Mengonversi response JSON menjadi objek Dart Model Course.
- Menggunakan timeout selama 15 detik.
- Menangani kesalahan koneksi dan format response.

**File implementasi:**
- `lib/services/course_api_service.dart`
- `lib/models/course.dart`

**Catatan implementasi:** CourseApiService tersedia dalam source code. Pada konfigurasi `main.dart` saat ini, sumber data aktif untuk mata kuliah adalah Supabase melalui CourseSupabaseService. CourseApiService belum dihubungkan sebagai sumber data aktif aplikasi.

## Backend & Database

Aplikasi menggunakan Supabase sebagai backend dengan PostgreSQL sebagai sistem database.

Supabase digunakan untuk menyimpan, mengambil, memperbarui, dan menghapus data tugas serta mata kuliah.

### Database Tables

**1. courses**

| Field | Keterangan |
|---|---|
| id | Primary key |
| code | Kode mata kuliah |
| title | Nama mata kuliah |
| credits | Jumlah SKS |
| status | Status mata kuliah |

**2. tasks**

| Field | Keterangan |
|---|---|
| id | Primary key |
| title | Nama tugas |
| course_id | Relasi ke mata kuliah |
| deadline | Tanggal deadline |
| priority | Prioritas tugas |
| status | Status pengerjaan |

### Database Operations

Aplikasi menerapkan operasi CRUD pada kedua tabel:

- Create: Menambahkan tugas dan mata kuliah.
- Read: Mengambil dan menampilkan data.
- Update: Memperbarui informasi tugas dan mata kuliah.
- Delete: Menghapus data dengan konfirmasi pengguna.

## State Management

Aplikasi menggunakan Provider dan ChangeNotifier untuk mengelola shared application state.

Provider yang digunakan:

- `TaskProvider`: Mengelola data tugas, loading, error, dan operasi CRUD tugas.
- `CourseProvider`: Mengelola data mata kuliah, loading, error, dan operasi CRUD mata kuliah.

Pemisahan ini membantu menjaga sinkronisasi data antara halaman Home, Daftar Tugas, Detail Tugas, dan Mata Kuliah.

## Application Architecture

Project menggunakan pendekatan layered architecture dengan pemisahan tanggung jawab antara UI, state management, repository, dan data source.

### Architecture Flow

```text
Screens / UI
     |
     v
Providers
     |
     v
Repositories
     |
     v
Services / Data Sources
     |
     v
Supabase / REST API
     |
     v
PostgreSQL Database
```

### Project Structure

```text
lib/
|
├── models/
|   ├── course.dart
|   └── task.dart
|
├── providers/
|   ├── course_provider.dart
|   └── task_provider.dart
|
├── repositories/
|   ├── course_repository.dart
|   └── task_repository.dart
|
├── screens/
|   ├── home_screen.dart
|   ├── task_list_screen.dart
|   ├── task_detail_screen.dart
|   ├── add_task_screen.dart
|   ├── edit_task_screen.dart
|   ├── course_screen.dart
|   ├── add_course_screen.dart
|   ├── edit_course_screen.dart
|   └── main_navigation_screen.dart
|
├── services/
|   ├── course_api_service.dart
|   ├── course_data_source.dart
|   ├── course_supabase_service.dart
|   ├── task_data_source.dart
|   └── task_supabase_service.dart
|
├── utils/
|   └── app_error_message.dart
|
├── widgets/
|   ├── confirm_delete_dialog.dart
|   ├── error_view.dart
|   ├── priority_badge.dart
|   ├── summary_card.dart
|   └── task_card.dart
|
└── main.dart
```

## Application Screenshots

### 1. Home / Dashboard
![Home Dashboard](docs/screenshots/home.png)

### 2. Daftar Tugas
![Daftar Tugas](docs/screenshots/task_list.png)

### 3. Detail Tugas
![Detail Tugas](docs/screenshots/task_detail.png)

### 4. Tambah Tugas
![Tambah Tugas](docs/screenshots/add_task.png)

### 5. Edit Tugas
![Edit Tugas](docs/screenshots/edit_task.png)

### 6. Mata Kuliah
![Mata Kuliah](docs/screenshots/course_list.png)

### 7. Responsive Layout
![Responsive Layout](docs/screenshots/responsive.png)

### 8. REST API
![REST API](docs/screenshots/api_data.png)

### 9. Supabase Database
![Supabase Database](docs/screenshots/database.png)

## Installation & Setup

### Requirements
- Flutter SDK
- Dart SDK
- Android Studio atau Visual Studio Code
- Android Emulator atau perangkat Android
- Supabase Account

### 1. Clone Repository

```bash
git clone [URL_GITHUB_REPOSITORY]
```

### 2. Masuk ke Project Directory

```bash
cd TuntasKuliah
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Configure Environment Variables

Buat file `.env` pada root project:

```env
SUPABASE_URL=your_supabase_url
SUPABASE_PUBLISHABLE_KEY=your_supabase_publishable_key
```

Isi dengan konfigurasi Supabase milik project.

### 5. Run Application

```bash
flutter run
```

## Testing

Untuk memeriksa kualitas kode dan menjalankan pengujian:

```bash
dart format lib
flutter analyze
flutter test
```

## Build APK

Untuk membuat APK release:

```bash
flutter build apk --release
```

File APK akan tersedia di:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Development Milestones

Project dikembangkan melalui tahapan implementasi yang terdokumentasi menggunakan Git dan GitHub:

1. Project Initialization
2. Architecture
3. Basic UI
4. Responsive Layout
5. Navigation
6. Models
7. State Management
8. REST API
9. Database
10. Create
11. Update
12. Delete
13. Interaction
14. Error Handling
15. UI Refinement
16. Final

## Conclusion

TuntasKuliah dikembangkan sebagai aplikasi mobile untuk membantu mahasiswa mengelola tugas dan mata kuliah secara terstruktur.

Melalui project ini, diterapkan berbagai konsep pengembangan aplikasi mobile menggunakan Flutter, mulai dari UI, responsive layout, navigation, state management, layered architecture, REST API, database integration, CRUD, hingga error handling.

Project ini merupakan implementasi pembelajaran mata kuliah Pemrograman Mobile.