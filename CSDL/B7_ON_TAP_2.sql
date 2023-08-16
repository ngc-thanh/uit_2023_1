-- DE 2 --
CREATE DATABASE DEHAI;
USE DEHAI;

CREATE TABLE NHANVIEN
(
	MaNV char(5) PRIMARY KEY,
	HoTen varchar(20),
	NgayVL smalldatetime,
	HSLuong numeric(4,2),
	MaPhong char(5)
)

CREATE TABLE PHONGBAN
(
	MaPhong char(5) PRIMARY KEY,
	TenPhong varchar(25),
	TruongPhong char(5) FOREIGN KEY REFERENCES NHANVIEN(MaNV)
)

CREATE TABLE XE
(
	MaXe char(5) PRIMARY KEY,
	LoaiXe varchar(20),
	SoChoNgoi int,
	NamSX int
)

CREATE TABLE PHANCONG
(
	MaPC char(5) PRIMARY KEY,
	MaNV char(5) FOREIGN KEY REFERENCES NHANVIEN(MaNV),
	MaXe char(5) FOREIGN KEY REFERENCES XE(MaXe),
	NgayDi smalldatetime,
	NgayVe smalldatetime,
	NoiDen varchar(25)
)

-- 2.1 --
-- Năm sản xuất của xe loại Toyota phải từ năm 2006 trở về sau.
ALTER TABLE XE
ADD CONSTRAINT CheckToyotaYear CHECK (
    (LoaiXe = 'Toyota' AND NamSX >= 2006)
    OR LoaiXe <> 'Toyota'
);

-- 2.2 --
-- Nhân viên thuộc phòng lái xe “Ngoại thành” chỉ được phân công lái xe loại Toyota.
ALTER TABLE PHANCONG
ADD CONSTRAINT CheckAssignment CHECK (
    NOT EXISTS (
        SELECT 1
        FROM NHANVIEN NV
        JOIN PHONGBAN PB ON NV.MaPhong = PB.MaPhong
        JOIN XE X ON PHANCONG.MaXe = X.MaXe
        WHERE NV.MaNV = PHANCONG.MaNV
        AND PB.TenPhong = 'Ngoại thành'
        AND X.LoaiXe <> 'Toyota'
    )
);

-- 3.1 --
-- Tìm nhân viên (MaNV,HoTen) thuộc phòng lái xe “Nội thành” được phân công lái
-- loại xe Toyota có số chỗ ngồi là 4.
SELECT NV.MaNV, NV.HoTen
FROM NHANVIEN NV
JOIN PHONGBAN PB ON NV.MaPhong = PB.MaPhong
JOIN PHANCONG PC ON NV.MaNV = PC.MaNV
JOIN XE X ON PC.MaXe = X.MaXe
WHERE PB.TenPhong = 'Nội thành' AND X.LoaiXe = 'Toyota' AND X.SoChoNgoi = 4;


-- 3.2 --
-- Tìm nhân viên(MANV,HoTen) là trưởng phòng được phân công lái tất cả các loại
-- xe.
SELECT NV.MaNV, NV.HoTen
FROM NHANVIEN NV
JOIN PHONGBAN PB ON NV.MaPhong = PB.MaPhong
WHERE PB.TruongPhong = NV.MaNV
AND NOT EXISTS (
    SELECT X.MaXe
    FROM XE X
    WHERE NOT EXISTS (
        SELECT 1
        FROM PHANCONG PC
        WHERE PC.MaNV = NV.MaNV AND PC.MaXe = X.MaXe
    )
);

-- 3.3 --
-- Trong mỗi phòng ban,tìm nhân viên (MaNV,HoTen) được phân công lái ít nhất loại
-- xe Toyota.
SELECT NV.MaNV, NV.HoTen
FROM NHANVIEN NV
JOIN PHONGBAN PB ON NV.MaPhong = PB.MaPhong
WHERE NOT EXISTS (
    SELECT X.MaXe
    FROM XE X
    WHERE X.LoaiXe = 'Toyota'
    AND NOT EXISTS (
        SELECT 1
        FROM PHANCONG PC
        WHERE PC.MaNV = NV.MaNV AND PC.MaXe = X.MaXe
    )
)
GROUP BY NV.MaNV, NV.HoTen, PB.MaPhong
HAVING COUNT(DISTINCT X.LoaiXe) <= (
    SELECT COUNT(DISTINCT X.MaXe)
    FROM XE X
    WHERE X.LoaiXe = 'Toyota'
);