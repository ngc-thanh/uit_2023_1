-- DE 4 --
CREATE DATABASE DEBON;
USE DEBON;

CREATE TABLE KHACHHANG
(
	MaKH char(5) PRIMARY KEY,
	HoTen varchar(30),
	DiaChi varchar(30),
	SoDT varchar(15),
	LoaiKH varchar(10)
)

CREATE TABLE BANG_DIA
(
	MaBD char(5) PRIMARY KEY,
	TenBD varchar(25),
	TheLoai varchar(25)
)

CREATE TABLE PHIEUTHUE
(
	MaPT char(5) PRIMARY KEY,
	MaKH char(5) FOREIGN KEY REFERENCES KHACHHANG(MaKH),
	NgayThue smalldatetime,
	NgayTra smalldatetime,
	SoluongThue int
)

CREATE TABLE CHITIET_PM
(
	MaPT char(5) FOREIGN KEY REFERENCES PHIEUTHUE(MaPT),
	MaBD char(5) FOREIGN KEY REFERENCES BANG_DIA(MaBD),
	PRIMARY KEY (MaPT, MaBD)
)

-- 2.1 --
-- Thể loại băng đĩa chỉ thuộc các thể loại sau “ca nhạc”, “phim hành động”, “phim tình
-- cảm”, “phim hoạt hình”.
ALTER TABLE BANG_DIA
ADD CONSTRAINT CK_BANGDIA_TheLoai
CHECK (TheLoai IN ('ca nhạc', 'phim hành động', 'phim tình cảm', 'phim hoạt hình'));

-- 2.2 --
-- Chỉ những khách hàng thuộc loại VIP mới được thuê với số lượng băng đĩa trên 5.
ALTER TABLE PHIEUTHUE
ADD CONSTRAINT CK_PHIEUTHUE_SoLuongThue
CHECK (
    LoaiKH = 'VIP' AND SoluongThue > 5
    OR LoaiKH != 'VIP'
);

-- 3.1 --
-- Tìm các khách hàng (MaDG,HoTen) đã thuê băng đĩa thuộc thể loại phim “Tình
-- cảm” có số lượng thuê lớn hơn 3.
SELECT K.MaKH, K.HoTen
FROM KHACHHANG K
JOIN PHIEUTHUE PT ON K.MaKH = PT.MaKH
JOIN CHITIET_PM CTP ON PT.MaPT = CTP.MaPT
JOIN BANG_DIA BD ON CTP.MaBD = BD.MaBD
WHERE BD.TheLoai = 'phim tình cảm' AND PT.SoluongThue > 3;

-- 3.2 --
-- Tìm các khách hàng(MaDG,HoTen) thuộc loại VIP đã thuê nhiều băng đĩa nhất.
SELECT TOP 1 K.MaKH, K.HoTen
FROM KHACHHANG K
JOIN PHIEUTHUE PT ON K.MaKH = PT.MaKH
WHERE K.LoaiKH = 'VIP'
GROUP BY K.MaKH, K.HoTen
ORDER BY SUM(PT.SoluongThue) DESC;


-- 3.3 --
-- Trong mỗi thể loại băng đĩa, cho biết tên khách hàng nào đã thuê nhiều băng đĩa nhất.
SELECT DISTINCT BD.TheLoai, 
    FIRST_VALUE(K.HoTen) OVER (PARTITION BY BD.TheLoai ORDER BY SUM(PT.SoluongThue) DESC) AS TenKhachHang
FROM BANG_DIA BD
JOIN CHITIET_PM CTP ON BD.MaBD = CTP.MaBD
JOIN PHIEUTHUE PT ON CTP.MaPT = PT.MaPT
JOIN KHACHHANG K ON PT.MaKH = K.MaKH
GROUP BY BD.TheLoai, K.HoTen;
