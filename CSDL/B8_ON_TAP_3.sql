-- DE 3 --
CREATE DATABASE DEBA;
USE DEBA;

CREATE TABLE DOCGIA
(
	MaDG char(5) PRIMARY KEY,
	HoTen varchar(30),
	NgaySinh smalldatetime,
	DiaChi varchar(30),
	SoDT varchar(15)
)

CREATE TABLE SACH
(
	MaSach char(5) PRIMARY KEY,
	TenSach varchar(25),
	TheLoai varchar(25),
	NhaXuatBan varchar(30)
)

CREATE TABLE PHIEUTHUE
(
	MaPT char(5) PRIMARY KEY,
	MaDG char(5) FOREIGN KEY REFERENCES DOCGIA(MaDG),
	NgayThue smalldatetime,
	NgayTra smalldatetime,
	SoSachThue int
)

CREATE TABLE CHITIET_PM
(
	MaPT char(5) FOREIGN KEY REFERENCES PHIEUTHUE(MaPT),
	MaSach char(5) FOREIGN KEY REFERENCES SACH(MaSach),
	PRIMARY KEY (MaPT, MaSach)
)

-- 2.1 --
-- Mỗi lần thuê sách, độc giả không được thuê quá 10 ngày.
ALTER TABLE PHIEUTHUE
ADD CONSTRAINT CheckMaxThueDays CHECK (
    DATEDIFF(day, NgayThue, NgayTra) <= 10
);


-- 2.2 --
-- Số sách thuê trong bảng phiếu thuê bằng tổng số lần thuê sách có trong bảng chi tiết
-- phiếu thuê.
CREATE TRIGGER UpdateSoSachThue
ON CHITIET_PM
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE PHIEUTHUE
    SET SoSachThue = (
        SELECT SUM(SoSachThue)
        FROM CHITIET_PM
        WHERE CHITIET_PM.MaPT = PHIEUTHUE.MaPT
    )
    WHERE PHIEUTHUE.MaPT IN (
        SELECT DISTINCT MaPT
        FROM inserted
    );
END;


-- 3.1 --
-- Tìm các độc giả (MaDG,HoTen) đã thuê sách thuộc thể loại “Tin học” trong năm
-- 2007.
SELECT DG.MaDG, DG.HoTen
FROM DOCGIA DG
JOIN PHIEUTHUE PT ON DG.MaDG = PT.MaDG
JOIN CHITIET_PM CTP ON PT.MaPT = CTP.MaPT
JOIN SACH S ON CTP.MaSach = S.MaSach
WHERE S.TheLoai = 'Tin học'
    AND YEAR(PT.NgayThue) = 2007;

-- 3.2 --
-- Tìm các độc giả (MaDG,HoTen) đã thuê nhiều thể loại sách nhất.
SELECT TOP 1 DG.MaDG, DG.HoTen
FROM DOCGIA DG
JOIN PHIEUTHUE PT ON DG.MaDG = PT.MaDG
JOIN CHITIET_PM CTP ON PT.MaPT = CTP.MaPT
JOIN SACH S ON CTP.MaSach = S.MaSach
GROUP BY DG.MaDG, DG.HoTen
ORDER BY COUNT(DISTINCT S.TheLoai) DESC;

-- 3.3 --
-- Trong mỗi thể loại sách, cho biết tên sách được thuê nhiều nhất.
SELECT T.TheLoai, S.TenSach
FROM (
    SELECT S.TheLoai, MAX(CountSach) AS MaxCount
    FROM (
        SELECT S.TheLoai, CTP.MaSach, COUNT(CTP.MaSach) AS CountSach
        FROM CHITIET_PM CTP
        JOIN SACH S ON CTP.MaSach = S.MaSach
        GROUP BY S.TheLoai, CTP.MaSach
    ) AS Tmp
    GROUP BY S.TheLoai
) AS T
JOIN (
    SELECT S.TheLoai, CTP.MaSach, COUNT(CTP.MaSach) AS CountSach
    FROM CHITIET_PM CTP
    JOIN SACH S ON CTP.MaSach = S.MaSach
    GROUP BY S.TheLoai, CTP.MaSach
) AS S ON T.TheLoai = S.TheLoai AND T.MaxCount = S.CountSach;