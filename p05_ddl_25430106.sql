
-- ============================================================
-- PROYEK BASIS DATA: PERPUSTAKAAN M MEDIA
-- NIM  : 25430106
-- File : p05_ddl_25430106.sql
-- Modul: Pertemuan 5 - DDL dan Constraint
--
-- PERHATIAN:
-- Skrip ini menghapus tabel lama dalam perpus_106 sebelum
-- membuat ulang. Data lama dalam tabel tersebut akan hilang.
-- ============================================================

CREATE DATABASE IF NOT EXISTS perpus_106
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE perpus_106;

-- Hapus tabel dari anak ke induk agar dapat dibuat ulang
DROP TABLE IF EXISTS denda;
DROP TABLE IF EXISTS pengembalian;
DROP TABLE IF EXISTS detail_peminjaman;
DROP TABLE IF EXISTS peminjaman;
DROP TABLE IF EXISTS eksemplar;
DROP TABLE IF EXISTS petugas;
DROP TABLE IF EXISTS buku;
DROP TABLE IF EXISTS anggota;

-- ============================================================
-- 1. ANGGOTA
-- AB-01: Nomor anggota harus unik.
-- ============================================================
CREATE TABLE anggota (
    id_anggota INT UNSIGNED AUTO_INCREMENT,
    no_anggota VARCHAR(20) NOT NULL,
    nim_anggota VARCHAR(20) NOT NULL,
    nama_anggota VARCHAR(100) NOT NULL,
    alamat_anggota TEXT,
    no_hp_anggota VARCHAR(20),
    email_anggota VARCHAR(100),
    tanggal_daftar DATE NOT NULL,
    status_anggota ENUM('aktif', 'nonaktif')
        NOT NULL DEFAULT 'aktif',

    CONSTRAINT pk_anggota PRIMARY KEY (id_anggota),
    CONSTRAINT uq_anggota_no UNIQUE (no_anggota),
    CONSTRAINT uq_anggota_nim UNIQUE (nim_anggota)
);

-- ============================================================
-- 2. BUKU
-- ============================================================
CREATE TABLE buku (
    id_buku INT UNSIGNED AUTO_INCREMENT,
    kode_buku VARCHAR(20) NOT NULL,
    isbn_buku VARCHAR(20),
    judul_buku VARCHAR(200) NOT NULL,
    penulis_buku VARCHAR(150),
    penerbit_buku VARCHAR(150),
    tahun_terbit YEAR,
    kategori_buku VARCHAR(100),

    CONSTRAINT pk_buku PRIMARY KEY (id_buku),
    CONSTRAINT uq_buku_kode UNIQUE (kode_buku)
);

-- ============================================================
-- 3. PETUGAS
-- ============================================================
CREATE TABLE petugas (
    id_petugas INT UNSIGNED AUTO_INCREMENT,
    kode_petugas VARCHAR(20) NOT NULL,
    nama_petugas VARCHAR(100) NOT NULL,
    peran_petugas ENUM('petugas', 'pengelola') NOT NULL,

    CONSTRAINT pk_petugas PRIMARY KEY (id_petugas),
    CONSTRAINT uq_petugas_kode UNIQUE (kode_petugas)
);

-- ============================================================
-- 4. EKSEMPLAR
-- Satu buku dapat memiliki banyak eksemplar.
-- ============================================================
CREATE TABLE eksemplar (
    kode_eksemplar VARCHAR(30) NOT NULL,
    id_buku INT UNSIGNED NOT NULL,
    status_eksemplar
        ENUM('tersedia', 'dipinjam', 'rusak', 'hilang')
        NOT NULL DEFAULT 'tersedia',

    CONSTRAINT pk_eksemplar PRIMARY KEY (kode_eksemplar),
    CONSTRAINT fk_eksemplar_buku
        FOREIGN KEY (id_buku)
        REFERENCES buku(id_buku)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================================
-- 5. PEMINJAMAN
-- AB-02: Hanya anggota aktif yang boleh meminjam.
-- AB-06: Setiap peminjaman memiliki batas pengembalian.
-- ============================================================
CREATE TABLE peminjaman (
    no_peminjaman INT UNSIGNED AUTO_INCREMENT,
    id_anggota INT UNSIGNED NOT NULL,
    id_petugas INT UNSIGNED NOT NULL,
    tanggal_peminjaman DATE NOT NULL,
    batas_pengembalian DATE NOT NULL,

    CONSTRAINT pk_peminjaman PRIMARY KEY (no_peminjaman),
    CONSTRAINT fk_peminjaman_anggota
        FOREIGN KEY (id_anggota)
        REFERENCES anggota(id_anggota)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_peminjaman_petugas
        FOREIGN KEY (id_petugas)
        REFERENCES petugas(id_petugas)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT ck_peminjaman_tanggal
        CHECK (batas_pengembalian >= tanggal_peminjaman)
);

-- ============================================================
-- 6. DETAIL PEMINJAMAN
-- PK gabungan: satu eksemplar tidak boleh tercatat dua kali
-- dalam transaksi peminjaman yang sama.
--
-- AB-03: Maksimal 9 buku per transaksi.
-- Batas lintas-baris perlu divalidasi pada proses transaksi.
-- AB-04/AB-05: Status ketersediaan perlu divalidasi saat pinjam.
-- ============================================================
CREATE TABLE detail_peminjaman (
    no_peminjaman INT UNSIGNED NOT NULL,
    kode_eksemplar VARCHAR(30) NOT NULL,

    CONSTRAINT pk_detail_peminjaman
        PRIMARY KEY (no_peminjaman, kode_eksemplar),
    CONSTRAINT fk_detail_peminjaman_peminjaman
        FOREIGN KEY (no_peminjaman)
        REFERENCES peminjaman(no_peminjaman)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_detail_peminjaman_eksemplar
        FOREIGN KEY (kode_eksemplar)
        REFERENCES eksemplar(kode_eksemplar)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================================
-- 7. PENGEMBALIAN
-- Satu baris untuk setiap eksemplar yang dikembalikan.
-- Dengan demikian, pengembalian dapat dilakukan bertahap.
-- AB-08: Pengembalian harus mengacu pada detail peminjaman.
-- ============================================================
CREATE TABLE pengembalian (
    no_pengembalian INT UNSIGNED AUTO_INCREMENT,
    no_peminjaman INT UNSIGNED NOT NULL,
    kode_eksemplar VARCHAR(30) NOT NULL,
    tanggal_pengembalian DATE NOT NULL,

    CONSTRAINT pk_pengembalian PRIMARY KEY (no_pengembalian),
    CONSTRAINT uq_pengembalian_detail
        UNIQUE (no_peminjaman, kode_eksemplar),
    CONSTRAINT fk_pengembalian_detail
        FOREIGN KEY (no_peminjaman, kode_eksemplar)
        REFERENCES detail_peminjaman
            (no_peminjaman, kode_eksemplar)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================================
-- 8. DENDA
-- Denda dicatat per eksemplar yang dikembalikan.
-- AB-07: Rp7.000 per hari keterlambatan.
-- ============================================================
CREATE TABLE denda (
    no_denda INT UNSIGNED AUTO_INCREMENT,
    no_pengembalian INT UNSIGNED NOT NULL,
    hari_terlambat INT UNSIGNED NOT NULL DEFAULT 0,
    jumlah_denda DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    CONSTRAINT pk_denda PRIMARY KEY (no_denda),
    CONSTRAINT uq_denda_pengembalian
        UNIQUE (no_pengembalian),
    CONSTRAINT fk_denda_pengembalian
        FOREIGN KEY (no_pengembalian)
        REFERENCES pengembalian(no_pengembalian)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT ck_denda_hari
        CHECK (hari_terlambat >= 0),
    CONSTRAINT ck_denda_jumlah
        CHECK (jumlah_denda >= 0)
);

-- ============================================================
-- VERIFIKASI STRUKTUR
-- ============================================================
SHOW TABLES;

DESCRIBE anggota;
DESCRIBE buku;
DESCRIBE eksemplar;
DESCRIBE petugas;
DESCRIBE peminjaman;
DESCRIBE detail_peminjaman;
DESCRIBE pengembalian;
DESCRIBE denda;
