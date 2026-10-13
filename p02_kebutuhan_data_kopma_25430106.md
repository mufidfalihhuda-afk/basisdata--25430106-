# Dokumen Kebutuhan Data - KOPMA

## 1. Latar belakang dan aktivitas organisasi
Koperasi Mahasiswa (Kopma) adalah organisasi yang menyediakan layanan penjualan barang kepada anggota dan pelanggan. Kopma menjual alat tulis, makanan ringan, dan minuman di lingkungan kampus. Pembeli adalah seorang anggota atau umum. Mahasiswa yang ingin mendaftar sebagai anggota menggunakan nama, NPM, prodi, dan nomor HP. Setelah itu mmendapat nomor anggota dengan format A-xxxx dan anggota aktif mendapat diskon 5% setiap pembelian.

Aktivitas utama Kopma meliputi pendaftaran dan pengelolaan data anggota, pengelolaan barang dan pemasok, penerimaan barang, pengelolaan stok, serta transaksi penjualan. Data dari aktivitas tersebut perlu dikelola agar informasi operasional dapat diperoleh secara konsisten dan dapat digunakan oleh pihak yang membutuhkan.

## 2. Aktor dan proses bisnis  
Aktor yang terlibat dalam kegiatan operasional Kopma antara lain ketua/pengelola, kasir, petugas gudang, dan anggota atau pelanggan.


| Kode   | Proses bisnis                | Aktor                               | Pemicu                            |
|--------|------------------------------|-------------------------------------|-----------------------------------|
| PB-01  | Mendaftar anggota            | Kasir (atas permintaan mahasiswa)   | Mahasiswa ingin menjadi anggota   |
| PB-02  | Mencatat penjualan           | Kasir                               |  Pembeli membayar di kasir        |
| PB-03  | Memesan barang ke pemasok    | Petugas gudang                      | Stok dibawah batas minimum        |
| PB-04  | Menerima barang dari pemasok | Petugas gudang                      | Barang datang bersama faktur      |
| PB-05  | Menyusun laporan bulanan     | Ketua koprasi                       | Awal bulan                        |

## 3. Dokumen sumber yang dianalisis
Dokumen sumber yang digunakan untuk memahami kebutuhan data Kopma antara lain:
1. Formulir pendaftaran anggota.
2. Nota penjualan.
3. Dokumen penerimaan barang.
4. Catatan stok barang.
5. Data pemasok.
6. Laporan transaksi penjualan.


## 4. Entitas kandidat dan elemen data

| Entitas kandidat        | Elemen data utama                                               | Sumber                |
| ----------------------- | --------------------------------------------------------------- | --------------------- |
| Anggota | nomor anggota, NIM, nama, program studi, nomor HP, status aktif, poin_loyalitas | Formulir pendaftaran dan catatan transaksi penjualan |
| Barang                  | kode, nama, kategori, harga jual, stok, batas minimum stok      | Daftar barang, faktur |
| Penjualan               | nomor nota, tanggal-jam, kasir, anggota (opsional), bayar       | Nota penjualan        |
| Detail penjualan        | nomor nota, barang, qty, harga saat transaksi                   | Nota penjualan        |
| Petugas                 | kode petugas, nama, peran (kasir/gudang/ketua)                  | Wawancara             |
| Pemasok                 | kode, nama, telepon, alamat                                     | Faktur pemasok        |
| Pembelian dan detailnya | nomor faktur, tanggal, pemasok, barang, qty, harga beli         | Faktur pemasok        |



## 5. Aturan bisnis

| Kode  | Aturan bisnis                                                                                                     |
| ----- | ----------------------------------------------------------------------------------------------------------------- |
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang.                                                    |
| AB-02 | Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%. |
| AB-03 | Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia.                               |
| AB-04 | Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik.          |
| AB-05 | NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM.                                 |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut.                                     |
| AB-07 | Setiap kelipatan Rp10.000 dari belanja anggota menghasilkan 1 poin loyalitas.                                     |
| AB-08 | Setiap 50 poin loyalitas dapat ditukar dengan potongan harga sebesar Rp5.000.                                     |
| AB-09 | Penukaran poin hanya dapat dilakukan jika saldo poin anggota mencukupi, dan saldo poin tidak boleh menjadi negatif. |

## 6. Kebutuhan informasi

| Kode  | Kebutuhan informasi                               | Data yang diperlukan                 |
| ----- | ------------------------------------------------- | ------------------------------------ |
| KI-01 | Omzet dan jumlah nota per hari dan per bulan      | Penjualan, detail penjualan          |
| KI-02 | Lima barang terlaris per bulan berdasarkan qty    | Detail penjualan, barang             |
| KI-03 | Barang dengan stok di bawah batas minimum         | Barang                               |
| KI-04 | Sepuluh anggota dengan belanja terbesar per bulan | Penjualan, detail penjualan, anggota |
| KI-05 | Saldo poin loyalitas setiap anggota               | Anggota |
| KI-06 | Riwayat perolehan dan penukaran poin loyalitas anggota | Anggota, Penjualan |

## 7. Matriks CRUD

Keterangan:

* **C** = Create / membuat data
* **R** = Read / membaca data
* **U** = Update / mengubah data
* **D** = Delete / menghapus data

| Proses | Anggota | Barang | Penjualan | Detail Penjualan | Pemasok | Pembelian |
|---|---|---|---|---|---|---|
| PB-01 Daftar anggota | C | | | | | |
| PB-02 Catat penjualan | R, U | R, U | C | C | | |
| PB-03 Pesan ke pemasok | | R | | | R | C |
| PB-04 Terima barang | | U | | | R | U |
| PB-05 Laporan bulanan | R | R | R | R | R | |

## 8. Kamus data awal

| Elemen                          | Arti                      | Contoh       | Aturan                          | Penanggung jawab |
| ------------------------------- | ------------------------- | ------------ | ------------------------------- | ---------------- |
| `no_anggota`                    | Nomor anggota koperasi    | A-0457       | Unik, format A-4 digit          | Ketua            |
| `nim_anggota`                   | NIM anggota               | 2301010123   | Unik, 10 digit                  | Ketua            |
| `no_hp_anggota`                 | Nomor HP anggota          | 0812xxxx     | Data pribadi, akses terbatas    | Ketua            |
| `no_nota_penjualan`             | Nomor nota penjualan      | PJ-2609-0142 | Unik per nota                   | Kasir            |
| `harga_satuan_detail_penjualan` | Harga jual saat transaksi | 4000         | Bilangan bulat ≥ 0 (rupiah)     | Kasir            |
| `stok_barang`                   | Jumlah barang tersedia    | 35           | Bilangan bulat ≥ 0 sesuai AB-03 | Petugas gudang   |
| `poin_loyalitas`                | Saldo poin loyalitas anggota | 75 | Bilangan bulat ≥ 0; bertambah berdasarkan AB-07 dan berkurang 50 poin setiap penukaran yang berhasil sesuai AB-08 | Ketua |

## 9. Kebutuhan non-fungsional data

Kebutuhan non-fungsional data Kopma meliputi:

1. Perkiraan volume transaksi adalah sekitar **±150 nota per hari**.
2. Data transaksi disimpan minimal selama **lima tahun**.
3. Nomor HP anggota merupakan **data pribadi** dan hanya boleh dilihat oleh **ketua koperasi**.
4. Data stok harus dikelola sehingga tidak menghasilkan stok negatif sesuai AB-03.

Parameter kebutuhan volume, retensi, dan privasi tersebut menjadi bagian dari kebutuhan non-fungsional pengelolaan data Kopma.

## 10. Isu kualitas data yang diantisipasi

Beberapa isu kualitas data yang perlu diperhatikan adalah:

1. **Harga historis**

   * Harga barang dapat berubah. Oleh karena itu, harga jual yang digunakan pada saat transaksi harus tetap tersimpan pada detail penjualan agar nota lama tetap dapat diperiksa.

2. **Stok negatif**

   * Catatan stok dapat mengalami nilai negatif. Hal ini harus dicegah karena stok barang tidak boleh negatif sesuai AB-03.

3. **Identifikasi anggota**

   * Anggota dapat lupa membawa kartu, sehingga pencarian anggota perlu dapat dilakukan menggunakan NIM. NIM juga harus bersifat unik sesuai AB-05.

4. **Kelengkapan transaksi**

   * Setiap nota harus mempunyai nomor unik dan minimal satu baris barang sesuai AB-01.

5. **Perlindungan data pribadi**

   * Nomor HP anggota merupakan data pribadi sehingga akses terhadap data tersebut harus dibatasi.

6. **Data pemasok**

   * Matriks CRUD menunjukkan bahwa entitas Pemasok belum memiliki proses yang melakukan Create. Hal ini menunjukkan bahwa proses pemeliharaan data pemasok belum tercantum dalam daftar proses bisnis dan perlu diperhatikan pada tahap analisis berikutnya.

**## 11. Perbaikan Kebutuhan Kabur**

Tiga pernyataan kebutuhan kabur diperbaiki agar mempunyai kriteria yang jelas dan dapat diuji.

**1. Keamanan data anggota**

- Sebelum: “Data anggota harus aman.”
- Sesudah: “Nomor HP anggota hanya boleh dilihat oleh ketua koperasi. Pengguna selain ketua koperasi tidak boleh dapat melihat nomor HP anggota.”

Kebutuhan ini dapat diuji dengan mengakses data anggota menggunakan akun ketua koperasi dan akun pengguna lain, kemudian memastikan hanya akun ketua koperasi yang dapat melihat nomor HP.

**2. Kecepatan pencarian barang**

- Sebelum: “Sistem harus cepat mencari barang.”
- Sesudah: “Sistem harus dapat menampilkan hasil pencarian barang berdasarkan kode barang atau nama barang dalam waktu maksimal 2 detik untuk basis data yang berisi sampai dengan 10.000 barang.”

Kebutuhan ini dapat diuji dengan melakukan pencarian menggunakan kode barang dan nama barang, lalu mengukur waktu sampai hasil ditampilkan.

**3. Keakuratan laporan stok**

- Sebelum: “Laporan stok harus akurat.”
- Sesudah: “Jumlah stok yang ditampilkan dalam laporan harus sama dengan saldo stok pada data barang setelah seluruh transaksi penerimaan dan penjualan yang berhasil diproses diperhitungkan.”

Kebutuhan ini dapat diuji dengan membandingkan jumlah stok dalam laporan dengan saldo stok pada data barang setelah transaksi selesai diproses.