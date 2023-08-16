-- Nguyen Chi thanh - 23210067 --
-- PHAN 1 --
CREATE DATABASE QLBH;
USE QLBH;
--- 1.	Tạo các quan hệ và khai báo các khóa chính, khóa ngoại của quan hệ ---
-- TAO BANG KHACHHANG --
CREATE TABLE KHACHHANG
(
	MAKH char(4) NOT NULL PRIMARY KEY,
	HOTEN varchar(40),
	DCHI varchar(50),
	SODT varchar(20),
	NGSINH smalldatetime,
	DOANHSO money,
	NGDK smalldatetime
)

-- TAO BANG NHANVIEN --
CREATE TABLE NHANVIEN
(
	MANV char(4) NOT NULL PRIMARY KEY,
	HOTEN varchar(40),
	SODT varchar(20),
	NGVL smalldatetime
)

-- TAO BANG SANPHAM --
CREATE TABLE SANPHAM
(
	MASP char(4) NOT NULL PRIMARY KEY,
	TENSP varchar(40),
	DVT varchar(20),
	NUOCSX varchar(40),
	GIA money
)

-- TAO BANG HOADON --
CREATE TABLE HOADON
(
	SOHD int NOT NULL PRIMARY KEY,
	NGHD smalldatetime,
	MAKH char(4) NOT NULL FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH),
	MANV char(4) NOT NULL FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV),
	TRIGIA money
)

-- TAO BANG CHITIETHOADON --
CREATE TABLE CTHD
(
	SOHD int,
	MASP char(4) NOT NULL FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP),
	SL int,
)


-- Tao DB
CREATE DATABASE QLGV;
USE QLGV;
-- KHOA --
CREATE TABLE KHOA
(
	MAKHOA varchar(4) PRIMARY KEY,
	TENKHOA varchar(40),
	NGTLAP smalldatetime,
	TRGKHOA char(4)
);
-- MONHOC --
CREATE TABLE MONHOC (
	MAMH varchar(10) PRIMARY KEY,
	TENMH varchar(40),
	TCLT tinyint,
	TCTH tinyint,
	MAKHOA varchar(4) FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)
);

-- DIEUKIEN -- 
CREATE TABLE DIEUKIEN
(
	MAMH varchar(10) FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
	MAMH_TRUOC varchar(10) FOREIGN KEY (MAMH_TRUOC) REFERENCES MONHOC(MAMH)
);

-- GIAOVIEN --
CREATE TABLE GIAOVIEN
(
	MAGV char(4) PRIMARY KEY,
	HOTEN varchar(40),
	HOCVI varchar(10),
	HOCHAM varchar(10),
	GIOITINH varchar(3),
	NGSINH smalldatetime,
	NGVL smalldatetime,
	HESO numeric(4,2),
	MUCLUONG money,
	MAKHOA varchar(4) FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)
);
-- LOP --
CREATE TABLE LOP
(
	MALOP char(3) PRIMARY KEY,
	TENLOP varchar(40),
	TRGLOP char(5),
	SISO tinyint,
	MAGVCN char(4)  FOREIGN KEY (MAGVCN) REFERENCES GIAOVIEN(MAGV)
)
-- HOCVIEN --
CREATE TABLE HOCVIEN
(
	MAHV char(5) PRIMARY KEY,
	HO varchar(40),
	TEN varchar(10),
	NGSINH smalldatetime,
	GIOITINH varchar(3),
	NOISINH varchar(40),
	MALOP char(3) FOREIGN KEY(MALOP) REFERENCES LOP(MALOP)
);
-- GIANGDAY --
CREATE TABLE GIANGDAY
(
	MALOP char(3) FOREIGN KEY(MALOP) REFERENCES LOP(MALOP),
	MAMH varchar(10) FOREIGN KEY(MAMH) REFERENCES MONHOC(MAMH),
	HOCKY tinyint,
	NAM smallint,
	TUNGAY smalldatetime,
	DENNGAY smalldatetime,
);
-- KETQUATHI --
CREATE TABLE KETQUATHI
(
	MAHV char(5) FOREIGN KEY(MAHV) REFERENCES HOCVIEN(MAHV),
	MAMH varchar(10) FOREIGN KEY(MAMH) REFERENCES MONHOC(MAMH),
	LANTHI tinyint,
	NGTHI smalldatetime,
	DIEM numeric(4,2)
	KQUA varchar(10)
)



-- 2.	Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM.--
ALTER TABLE SANPHAM
ADD GHICHU varchar(20);

-- 3.	Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG.--
ALTER TABLE KHACHHANG
ADD LOAIKH tinyint;

-- 4.	Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100).--
ALTER TABLE SANPHAM
ALTER COLUMN GHICHU varchar(100);

-- 5.	Xóa thuộc tính GHICHU trong quan hệ SANPHAM. --
ALTER TABLE SANPHAM
DROP COLUMN GHICHU;