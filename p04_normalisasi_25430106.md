# Normalisasi Basis Data — Perpustakaan M MEDIA

Nama : Mufid Falih Huda

Kelas : D
 
NPM : 25430106

## F. Tugas Mandiri — Milestone Proyek 4

### F.1 Bentuk Tidak Ternormalisasi (UNF)

Dokumen sumber yang digunakan sebagai titik awal adalah **slip peminjaman** pada proyek Perpustakaan M MEDIA.

Berdasarkan elemen data pada dokumen kebutuhan, relasi awal dapat dituliskan sebagai berikut:

`PEMINJAMAN_UNF (no_peminjaman, tanggal_peminjaman, batas_pengembalian, no_anggota, nama_anggota, kode_petugas, nama_petugas, {kode_eksemplar, kode_buku, judul_buku})`

Keterangan:

- Data peminjaman memuat identitas anggota, petugas, dan tanggal peminjaman.
- Satu transaksi dapat memuat beberapa eksemplar buku. Kelompok `{kode_eksemplar, kode_buku, judul_buku}` merupakan kelompok data berulang.
- Data pengembalian dan denda dicatat pada dokumen sumber tersendiri, sehingga tidak langsung dimasukkan ke dalam relasi awal ini.

Relasi tersebut merupakan bentuk awal hasil penyusunan dari elemen data proyek, bukan salinan persis dari formulir yang sudah terisi.

### F.2 Dependensi Fungsional

Dependensi fungsional (DF) berikut disusun berdasarkan identitas data pada entitas kandidat. Kode AB yang dicantumkan menunjukkan aturan bisnis terkait, tetapi tidak semua aturan bisnis secara langsung membuktikan suatu dependensi fungsional.

| No. | Dependensi fungsional | Dasar |
|---|---|---|
| DF-01 | `no_anggota → NIM, nama, alamat, HP, email, status` | AB-01; data Anggota |
| DF-02 | `kode_buku → ISBN, judul, penulis, penerbit, tahun, kategori` | Data Buku |
| DF-03 | `kode_eksemplar → kode_buku, status_eksemplar` | Data Eksemplar |
| DF-04 | `kode_petugas → nama_petugas, peran` | Data Petugas |
| DF-05 | `no_peminjaman → no_anggota, kode_petugas, tanggal_peminjaman, batas_pengembalian` | AB-06; data Peminjaman |
| DF-06 | `(no_peminjaman, kode_eksemplar) → data detail peminjaman` | Data Detail Peminjaman |
| DF-07 | `no_pengembalian → no_peminjaman, tanggal_pengembalian` | AB-08; data Pengembalian |
| DF-08 | `no_denda → no_peminjaman, hari_terlambat, jumlah_denda` | AB-07; data Denda |

**Catatan:** DF-01 sampai DF-08 mengasumsikan kode atau nomor pada masing-masing entitas mengidentifikasi satu data. Keunikan nomor anggota secara eksplisit ditetapkan pada AB-01. Untuk kode dan nomor lainnya, keunikannya perlu dipastikan sebagai bagian dari rancangan kunci.

### F.3 Bentuk Normal Pertama (1NF)

Syarat 1NF adalah setiap atribut berisi satu nilai dan tidak terdapat kelompok atribut berulang dalam satu baris.

Kelompok eksemplar yang berulang dipisahkan menjadi baris-baris detail peminjaman.

Relasi setelah 1NF:

1. `PEMINJAMAN (no_peminjaman, tanggal_peminjaman, batas_pengembalian, no_anggota, nama_anggota, kode_petugas, nama_petugas)`
2. `DETAIL_PEMINJAMAN (no_peminjaman, kode_eksemplar, kode_buku, judul_buku)`

Setiap baris `DETAIL_PEMINJAMAN` mewakili satu eksemplar yang tercatat dalam satu transaksi peminjaman.

### F.4 Bentuk Normal Kedua (2NF)

Syarat 2NF adalah relasi sudah memenuhi 1NF dan setiap atribut nonkunci bergantung penuh pada kunci kandidat, bukan hanya sebagian dari kunci gabungan.

Pada `DETAIL_PEMINJAMAN`, kunci gabungan yang digunakan adalah `(no_peminjaman, kode_eksemplar)`. Informasi buku bergantung pada kode eksemplar atau kode buku, bukan pada keseluruhan kunci gabungan detail.

Pemisahan yang dilakukan:

1. `PEMINJAMAN (no_peminjaman, tanggal_peminjaman, batas_pengembalian, no_anggota, nama_anggota, kode_petugas, nama_petugas)`
2. `DETAIL_PEMINJAMAN (no_peminjaman, kode_eksemplar)`
3. `EKSEMPLAR (kode_eksemplar, kode_buku, status_eksemplar)`
4. `BUKU (kode_buku, ISBN, judul_buku, penulis_buku, penerbit_buku, tahun_terbit, kategori_buku)`

Dengan pemisahan ini, atribut buku disimpan pada entitas Buku dan informasi eksemplar disimpan pada entitas Eksemplar.

### F.5 Bentuk Normal Ketiga (3NF)

Syarat 3NF adalah relasi sudah memenuhi 2NF dan tidak memiliki ketergantungan transitif atribut nonkunci terhadap kunci.

Atribut nama anggota tidak perlu disimpan berulang di setiap transaksi peminjaman. Demikian pula nama petugas tidak perlu disimpan berulang dalam tabel Peminjaman.

Hasil relasi 3NF:

| Tabel | Atribut | Keterangan kunci |
|---|---|---|
| `ANGGOTA` | `no_anggota, NIM, nama, alamat, HP, email, tanggal_daftar, status` | PK: `no_anggota` |
| `BUKU` | `kode_buku, ISBN, judul_buku, penulis_buku, penerbit_buku, tahun_terbit, kategori_buku` | PK: `kode_buku` |
| `EKSEMPLAR` | `kode_eksemplar, kode_buku, status_eksemplar` | PK: `kode_eksemplar`; FK: `kode_buku` |
| `PETUGAS` | `kode_petugas, nama_petugas, peran` | PK: `kode_petugas` |
| `PEMINJAMAN` | `no_peminjaman, no_anggota, kode_petugas, tanggal_peminjaman, batas_pengembalian` | PK: `no_peminjaman`; FK: `no_anggota, kode_petugas` |
| `DETAIL_PEMINJAMAN` | `no_peminjaman, kode_eksemplar` | PK gabungan dan FK ke `PEMINJAMAN` serta `EKSEMPLAR` |
| `PENGEMBALIAN` | `no_pengembalian, no_peminjaman, tanggal_pengembalian` | PK: `no_pengembalian`; FK: `no_peminjaman` |
| `DENDA` | `no_denda, no_peminjaman, hari_terlambat, jumlah_denda` | PK: `no_denda`; FK: `no_peminjaman` |

Struktur ini mempertahankan entitas dan atribut yang sudah digunakan dalam proyek. Hubungan pengembalian tetap mengacu pada peminjaman sebagaimana AB-08. Dokumen kebutuhan belum menentukan apakah pengembalian dapat dicatat per eksemplar atau harus sekaligus, sehingga rancangan di atas tidak menyatakan salah satu aturan tersebut sebagai ketentuan bisnis.

### F.6 Pemeriksaan Boyce–Codd Normal Form (BCNF)

BCNF mengharuskan setiap penentu pada dependensi fungsional nontrivial merupakan kunci kandidat.

| Tabel | Hasil pemeriksaan |
|---|---|
| `ANGGOTA` | Memenuhi BCNF jika `no_anggota` merupakan kunci kandidat dan dependensi atribut anggota sesuai DF-01. |
| `BUKU` | Memenuhi BCNF jika `kode_buku` merupakan kunci kandidat dan tidak ada penentu lain yang bukan kunci kandidat. |
| `EKSEMPLAR` | Memenuhi BCNF jika `kode_eksemplar` merupakan kunci kandidat dan dependensi sesuai DF-03. |
| `PETUGAS` | Memenuhi BCNF jika `kode_petugas` merupakan kunci kandidat dan tidak ada dependensi lain yang melanggar BCNF. |
| `PEMINJAMAN` | Memenuhi BCNF jika `no_peminjaman` merupakan kunci kandidat dan dependensi sesuai DF-05. |
| `DETAIL_PEMINJAMAN` | Memenuhi BCNF jika pasangan `(no_peminjaman, kode_eksemplar)` merupakan kunci kandidat dan tidak terdapat penentu nonkunci. |
| `PENGEMBALIAN` | Memenuhi BCNF jika `no_pengembalian` merupakan kunci kandidat dan dependensi sesuai DF-07. |
| `DENDA` | Memenuhi BCNF jika `no_denda` merupakan kunci kandidat dan dependensi sesuai DF-08. |

Kesimpulan: pemeriksaan awal menunjukkan bahwa rancangan dapat memenuhi BCNF apabila asumsi kunci dan dependensi di atas benar. Kepastian akhir membutuhkan konfirmasi seluruh kunci kandidat serta aturan keunikan yang berlaku.

### F.7 Keputusan Penyimpanan Nilai Turunan

| Nilai | Keputusan | Alasan |
|---|---|---|
| `hari_terlambat` | Dapat dihitung dari tanggal pengembalian dan batas pengembalian. | Mengurangi risiko ketidaksesuaian dengan tanggal yang tercatat. |
| `jumlah_denda` | Dapat dihitung dari jumlah hari terlambat × Rp7.000. | Mengikuti AB-07. Jika disimpan, nilainya harus divalidasi terhadap perhitungan tersebut. |
| `status_eksemplar` | Disimpan sebagai status operasional. | Status ketersediaan diperlukan untuk memeriksa AB-04 dan AB-05 serta dapat berubah setelah transaksi. |
| Jumlah peminjaman dan pengembalian per periode | Dihitung dari data transaksi. | Merupakan kebutuhan laporan, bukan data pokok yang wajib disimpan sebagai atribut transaksi. |
| Status aktif anggota | Disimpan pada data Anggota. | Diperlukan untuk memeriksa kelayakan peminjaman berdasarkan AB-02. |

Untuk perhitungan keterlambatan, tanggal acuan yang digunakan ketika buku belum dikembalikan perlu ditetapkan oleh aturan operasional. Dokumen kebutuhan yang tersedia belum menjelaskan rincian tersebut.

### F.8 Penyesuaian ERD

Normalisasi menghasilkan struktur konseptual yang menggunakan delapan entitas: Anggota, Buku, Eksemplar, Petugas, Peminjaman, Detail Peminjaman, Pengembalian, dan Denda.

**ERD tidak diubah pada pengerjaan ini.** Struktur dan aturan pengembalian yang belum ditentukan tetap dibiarkan sesuai dokumen proyek saat ini. Jika ada perbedaan penulisan atribut dalam tabel hasil normalisasi dengan ERD, samakan nama atribut ketika menyiapkan DDL pada pertemuan berikutnya.

### Ringkasan Hasil

1. Kelompok eksemplar berulang pada bentuk UNF dipisahkan menjadi detail peminjaman.
2. Data Buku dan Eksemplar dipisahkan untuk menghindari pengulangan informasi judul buku.
3. Data Anggota dan Petugas dipisahkan dari transaksi peminjaman.
4. Relasi 3NF terdiri atas delapan tabel utama sesuai entitas proyek.
5. BCNF diperiksa berdasarkan asumsi kunci kandidat dan dependensi fungsional yang telah dicantumkan.
6. Nilai turunan ditinjau untuk menentukan apakah dihitung atau disimpan.
7. ERD yang sudah ada tidak diubah.


