# NORMALISASI KOPMA

**Nama:** Mufid Falih Huda  
**Kelas:** D  
**NPM:** 25430106

---

## D.1 Mengubah UNF menjadi 1NF

Relasi awal yang belum dinormalisasi adalah:

`NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, {kode_barang, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan}, jumlah_penjualan, diskon_penjualan, total_penjualan)`

Relasi tersebut masih memiliki kelompok barang berulang dalam satu nota. Satu nota dapat berisi beberapa barang sehingga kelompok barang perlu diuraikan menjadi satu baris untuk setiap barang pada setiap nota.

Setelah diubah menjadi bentuk normal pertama (1NF), relasinya menjadi:

`NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan, total_penjualan)`

**Kunci primer komposit:** `(no_nota_penjualan, kode_barang)`.

**Hasil normalisasi 1NF:**

Setiap atribut menyimpan satu nilai pada setiap baris dan tidak ada lagi kelompok barang berulang. Namun, masih terdapat atribut yang bergantung pada sebagian kunci komposit serta ketergantungan transitif. Oleh karena itu, normalisasi dilanjutkan ke 2NF dan 3NF.

## D.2 Menuliskan Dependensi Fungsional

Dependensi fungsional diturunkan dari aturan bisnis Kopma, bukan hanya berdasarkan isi spreadsheet atau contoh data.

| Kode | Dependensi fungsional | Keterangan |
|---|---|---|
| FD1 | `no_nota_penjualan → tgl_penjualan, kode_petugas, no_anggota` | Satu nomor nota menentukan tanggal transaksi, petugas, dan anggota. Berdasarkan AB-01. |
| FD2 | `kode_petugas → nama_petugas` | Kode petugas menentukan nama petugas. |
| FD3 | `no_anggota → nama_anggota` | Nomor anggota menentukan nama anggota. Berdasarkan AB-05. |
| FD4 | `kode_barang → nama_barang` | Kode barang menentukan nama barang. |
| FD5 | `(no_nota_penjualan, kode_barang) → qty_detail_penjualan, harga_satuan_detail_penjualan` | Kombinasi nomor nota dan kode barang menentukan kuantitas serta harga satuan pada transaksi. Berdasarkan AB-04. |
| FD6 | `(qty_detail_penjualan, harga_satuan_detail_penjualan) → subtotal_detail_penjualan` | Subtotal merupakan nilai turunan dari kuantitas dikalikan harga satuan. |

## D.3 Menuju 2NF dan 3NF

### A. Tahap 2NF

Bentuk normal kedua (2NF) mensyaratkan bahwa relasi sudah memenuhi 1NF dan tidak memiliki atribut bukan kunci yang bergantung hanya pada sebagian kunci komposit.

Pada relasi `NOTA_1NF`, kunci kompositnya adalah `(no_nota_penjualan, kode_barang)`. Namun, tanggal penjualan hanya ditentukan oleh nomor nota, sedangkan nama barang hanya ditentukan oleh kode barang.

Dengan demikian, informasi penjualan dan informasi barang perlu dipisahkan dari detail transaksi.

Relasi hasil pemisahan menuju 2NF adalah:

**1. PENJUALAN**

`PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, jumlah_penjualan, diskon_penjualan, total_penjualan)`

Kunci primer: `no_nota_penjualan`.

**2. BARANG**

`BARANG (kode_barang, nama_barang)`

Kunci primer: `kode_barang`.

**3. DETAIL_PENJUALAN**

`DETAIL_PENJUALAN (no_nota_penjualan, kode_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan)`

Kunci primer komposit: `(no_nota_penjualan, kode_barang)`.

Pada tahap ini, ketergantungan pada sebagian kunci komposit telah dihilangkan. Akan tetapi, tabel `PENJUALAN` masih memiliki ketergantungan transitif karena `nama_petugas` ditentukan oleh `kode_petugas`, sedangkan `nama_anggota` ditentukan oleh `no_anggota`. Nilai turunan juga masih perlu dievaluasi sebelum menetapkan skema operasional akhir.

### B. Tahap 3NF

Bentuk normal ketiga (3NF) mensyaratkan bahwa relasi sudah memenuhi 2NF dan tidak memiliki ketergantungan transitif yang tidak diinginkan di antara atribut bukan kunci.

Pada tabel penjualan terdapat rantai dependensi:

`no_nota_penjualan → kode_petugas → nama_petugas`

Selain itu, terdapat rantai:

`no_nota_penjualan → no_anggota → nama_anggota`

Kedua rantai tersebut menunjukkan bahwa nama petugas dan nama anggota tidak perlu disimpan berulang dalam tabel penjualan. Informasi tersebut dipisahkan ke tabel masing-masing.

Relasi hasil normalisasi 3NF sesuai contoh dalam modul adalah:

**1. PENJUALAN**

`PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas*, no_anggota*, bayar_penjualan)`

**2. DETAIL_PENJUALAN**

`DETAIL_PENJUALAN (no_nota_penjualan*, kode_barang*, qty_detail_penjualan, harga_satuan_detail_penjualan)`

**3. BARANG**

`BARANG (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)`

**4. PETUGAS**

`PETUGAS (kode_petugas, nama_petugas, peran_petugas)`

**5. ANGGOTA**

`ANGGOTA (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)`

Keterangan:

- Atribut yang ditetapkan sebagai kunci primer mengidentifikasi setiap baris dalam relasinya.
- Tanda `*` menunjukkan kunci tamu atau referensi ke relasi lain.
- `no_nota_penjualan` menjadi kunci primer pada bentuk relasi hasil pemisahan awal. Pada skema kanonik D.4, kunci primer penjualan menggunakan `id_penjualan`, sedangkan nomor nota menjadi kunci unik.

### C. Keputusan Penyimpanan Nilai Turunan

Nilai turunan yang dibahas dalam normalisasi penjualan meliputi:

- `subtotal_detail_penjualan`
- `jumlah_penjualan`
- `diskon_penjualan`
- `total_penjualan`

Subtotal dihitung menggunakan rumus:

`subtotal_detail_penjualan = qty_detail_penjualan × harga_satuan_detail_penjualan`

Jumlah penjualan diperoleh dengan menjumlahkan subtotal seluruh barang dalam satu nota. Diskon ditentukan berdasarkan aturan bisnis yang berlaku, sedangkan total penjualan dihitung berdasarkan jumlah penjualan dan diskon.

Berdasarkan keputusan dalam modul, `subtotal_detail_penjualan`, `jumlah_penjualan`, dan `total_penjualan` tidak disimpan sebagai atribut tersendiri dalam tabel operasional karena nilainya dapat dihitung dari detail transaksi dan aturan yang berlaku. Hal ini mengurangi risiko ketidaksesuaian antara nilai yang disimpan dan hasil perhitungan.

Sementara itu, `bayar_penjualan` tetap dicatat karena merepresentasikan uang yang diterima dari pembeli. Nilai pembayaran aktual berbeda dari total belanja yang dihitung.

## D.4 Mencocokkan dengan Skema Kanonik

Skema kanonik Kopma menggunakan kunci pengganti (*surrogate key*) berupa atribut `id_*` sebagai kunci primer. Nomor atau kode alami tetap dipertahankan sebagai kunci unik apabila ditentukan dalam skema.

### Tabel Skema Kanonik Kopma

| Tabel | Kunci primer (PK) | Kunci unik (UQ) | Kunci tamu (FK) |
|---|---|---|---|
| `petugas` | `id_petugas` | `kode_petugas` | — |
| `anggota` | `id_anggota` | `no_anggota`, `nim_anggota` | — |
| `barang` | `id_barang` | `kode_barang` | — |
| `pemasok` | `id_pemasok` | — | — |
| `penjualan` | `id_penjualan` | `no_nota_penjualan` | `id_petugas`, `id_anggota` (boleh NULL) |
| `detail_penjualan` | `(id_penjualan, id_barang)` | — | `id_penjualan`, `id_barang` |
| `pembelian` | `id_pembelian` | — | `id_pemasok` |
| `detail_pembelian` | `(id_pembelian, id_barang)` | — | `id_pembelian`, `id_barang` |

Keterangan:

- **PK (*Primary Key*)** adalah kunci primer untuk mengidentifikasi setiap baris.
- **UQ (*Unique*)** memastikan nilai pada atribut yang ditetapkan unik tidak duplikat.
- **FK (*Foreign Key*)** menghubungkan suatu tabel dengan tabel lain.
- **NULL** menunjukkan bahwa suatu nilai boleh kosong sesuai aturan tabel.

Penggunaan kunci pengganti membuat identitas internal tabel tidak bergantung langsung pada nomor atau kode alami. Kunci unik tetap diperlukan agar nomor nota, kode petugas, kode barang, dan identitas alami lainnya tidak digunakan secara ganda.

### Pemeriksaan BCNF

BCNF (*Boyce–Codd Normal Form*) mensyaratkan bahwa setiap penentu pada dependensi fungsional nontrivial merupakan kunci kandidat. Pemeriksaan berikut didasarkan pada kunci dalam skema kanonik dan dependensi fungsional yang telah diidentifikasi. Kesimpulan akhir tetap perlu disesuaikan jika terdapat aturan bisnis lain yang menghasilkan dependensi tambahan.

| Tabel | Penentu yang diperiksa | Hasil pemeriksaan |
|---|---|---|
| `petugas` | `id_petugas`, `kode_petugas` | Kedua atribut merupakan kunci kandidat berdasarkan skema kanonik. Dependensi `kode_petugas → nama_petugas` tidak melanggar BCNF. |
| `anggota` | `id_anggota`, `no_anggota`, `nim_anggota` | Atribut-atribut tersebut ditetapkan sebagai kunci kandidat berdasarkan skema kanonik. Dependensi yang penentunya merupakan salah satu kunci kandidat tidak melanggar BCNF. |
| `barang` | `id_barang`, `kode_barang` | Kedua atribut merupakan kunci kandidat berdasarkan skema kanonik. Dependensi `kode_barang → nama_barang` tidak melanggar BCNF. |
| `pemasok` | `id_pemasok` | `id_pemasok` merupakan kunci primer. BCNF terpenuhi apabila tidak ada penentu lain yang bukan kunci kandidat. |
| `penjualan` | `id_penjualan`, `no_nota_penjualan` | Kedua atribut merupakan kunci kandidat berdasarkan skema kanonik. Dependensi yang diketahui tidak melanggar BCNF jika penentunya merupakan salah satu kunci kandidat tersebut. |
| `detail_penjualan` | `(id_penjualan, id_barang)` | Gabungan atribut merupakan kunci primer komposit. BCNF terpenuhi jika tidak terdapat penentu lain yang bukan kunci kandidat. |
| `pembelian` | `id_pembelian` | `id_pembelian` merupakan kunci primer. BCNF terpenuhi apabila tidak ada penentu lain yang bukan kunci kandidat. |
| `detail_pembelian` | `(id_pembelian, id_barang)` | Gabungan atribut merupakan kunci primer komposit. BCNF terpenuhi jika tidak terdapat penentu lain yang bukan kunci kandidat. |

Berdasarkan dependensi fungsional yang telah diidentifikasi, penentu yang merupakan kunci kandidat tidak melanggar BCNF. Pemeriksaan tetap harus mempertimbangkan seluruh dependensi yang berlaku pada setiap tabel. Penggunaan kunci pengganti saja tidak otomatis menjamin bahwa suatu relasi memenuhi BCNF.

## Kesimpulan

Normalisasi dilakukan untuk mengurangi pengulangan data, mencegah anomali ubah, sisip, dan hapus, serta menjaga konsistensi informasi. Tahap 1NF menghilangkan kelompok berulang, 2NF menghilangkan ketergantungan pada sebagian kunci komposit, dan 3NF menghilangkan ketergantungan transitif yang tidak diinginkan.

Selanjutnya, relasi hasil normalisasi dicocokkan dengan skema kanonik Kopma yang menggunakan kunci pengganti dan kunci unik. Pemeriksaan BCNF dilakukan berdasarkan dependensi fungsional serta kunci kandidat pada setiap tabel. Keputusan untuk menghitung nilai turunan, bukan menyimpannya dalam tabel operasional, juga membantu menjaga konsistensi hasil perhitungan transaksi.