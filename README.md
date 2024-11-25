# Aqua Adventure Bali - Mobile

## Anggota Kelompok
* Paima Ishak Melkisedek Purba - 2306275986
* William Alexander - 2306226914
* Reyvano Mario Sianturi - 2306275613
* Athaillah Sifa Tanudatar - 2306275683
* Aisyah Hastomo - 2306211780
* Rifqisyandi Khairurrizal - 2306152216

## Deskripsi Aplikasi
Aqua Adventure Bali adalah mobile aplikasi untuk mencari informasi mengenai peralatan snorkeling dan toko yang menjualnya di Bali. Kami mendapat inspirasi karena Bali merupakan salah satu destinasi wisata di Indonesia yang terkenal sampai ke mancanegara dan di Bali terdapat banyak sekali pantai yang menyediakan wisata untuk snorkeling. Aplikasi ini bermanfaat bagi para wisatawan ataupun warga lokal Bali yang memiliki minat dalam olahraga snorkeling untuk mencari informasi mengenai peralatan snorkeling serta tempat menjualnya.

## Daftar Modul yang Akan Diimplementasikan
* Product, Paima
* Ulasan, William
* Wishlist, Aisyah
* Forum, Atha
* Checkout, Mario
* Complain/Pengaduan, Rifqi

## Role Pengguna
1. **Pengguna Umum** hanya dapat melihat produk dan melihat forum.
2. **Pengguna Terdaftar** bisa memberikan rating, checkout, forum, wishlist.
3. **Admin** bisa menambah, menghapus, mengedit, dan mengonfirmasi order.

## Alur Integrasi Web Service
Setiap data yang berkaitan dengan modul (product, ulasan, wishlist, forum, checkout, complain, dan autentikasi) akan disimpan ke dalam database deployment [http://paima-ishak-aquaadventurebali.pbp.cs.ui.ac.id/](http://paima-ishak-aquaadventurebali.pbp.cs.ui.ac.id/) menggunakan mekanisme berikut:

### 1. Menginstall package django-cors-headers 
* Install pada aplikasi web yang sudah dibuat dengan menjalankan perintah pip install django-cors-headers, kemudian menambahkan ke INSTALLED_APPS di settings.py. Django-cors-headers adalah package Django yang bertujuan untuk menangani Cross-Origin Resource Sharing (CORS) dalam aplikasi web. Hal ini memungkinkan aplikasi mobile kita dapat meneruskan request ke aplikasi web kita. Tanpa ada django-cors-headers, browser akan memblokir request cross origin. 

### 2. Menambahkan middleware
* Tambahkan corsheaders.middleware.CorsMiddleware ke MIDDLEWARE di settings.py. Tanpa middleware ini, meskipun package django-cors-headers sudah diinstal, aplikasi tidak akan bisa menangani CORS dengan benar karena tidak ada yang memproses dan menambahkan header CORS yang diperlukan.

### 3. Menambahkan variabel variabel berikut untuk CORS 
CORS_ALLOW_ALL_ORIGINS = True
CORS_ALLOW_CREDENTIALS = True
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SAMESITE = 'None'
SESSION_COOKIE_SAMESITE = 'None'
ke settings.py

### 4. Penyimpanan Data ke Database
* Mengirimkan data dari Flutter atau API client ke backend django untuk disimpan dalam database.

#### a. Endpoint POST Request:
1. Flutter mengirim data melalui POST request ke endpoint tertentu (misalnya, `http://paima-ishak-aquaadventurebali.pbp.cs.ui.ac.id/create-flutter-module/` untuk modul produk).
2. Django memproses data yang diterima, melakukan validasi, dan memastikan data sesuai dengan skema database.
3. Data yang valid akan disimpan ke dalam database Django sesuai model di database.

#### b. Validasi Data
* Validasi input fields data dilakukan dalam Flutter.

#### c. Response dari Backend Django
* Setelah data berhasil disimpan, backend django akan mengirimkan response ke client berupa:
  - **Status:** HTTP 201 (Created) jika berhasil.
  - **Pesan:** Informasi sukses atau pesan kesalahan jika gagal.

### 5. Penggunaan Data dari Database
Data yang disimpan dalam database diakses melalui proses fetching.

#### a. Endpoint GET Request
* **Tujuan:** Mengambil data dari database sesuai dengan modul atau filter tertentu.
* Flutter client mengirim GET request ke endpoint spesifik (misalnya, `http://paima-ishak-aquaadventurebali.pbp.cs.ui.ac.id/json-module/` untuk modul produk).
* Django mengambil data dari database menggunakan query db.sqlite3
* Backend django memformat data dan mengirimkan response ke client.

#### b. Response dari Backend Django
* Response dari backend django akan berisi:
  - **Status:** HTTP 200 (OK) jika berhasil.
  - **Data:** Data yang diminta dalam bentuk JSON atau format lain yang disepakati.

