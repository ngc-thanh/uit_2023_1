-- DE 1 --
CREATE DATABASE DEMOT;
USE DEMOT;

CREATE TABLE TACGIA
(
	MaTG char(5) PRIMARY KEY,
	HoTen varchar(20),
	DiaChi varchar(50),
	NgSinh smalldatetime,
	SoDT varchar(15)
)

CREATE TABLE SACH
(
	MaSach char(5) PRIMARY KEY,
	TenSach varchar(25),
	TheLoai varchar(25)
)

CREATE TABLE TACGIA_SACH
(
	MaTG char(5) FOREIGN KEY REFERENCES TACGIA(MaTG),
	MaSach char(5) FOREIGN KEY REFERENCES SACH(MaSach),
	PRIMARY KEY (MaTG, MaSach)
)

CREATE TABLE PHATHANH
(
	MaPH char(5) PRIMARY KEY,
	NaSach char(5) FOREIGN KEY REFERENCES SACH(MaSach),
	NgayPH smalldatetime,
	SoLuong int,
	NhaXuatBan varchar(20)
)

-- 2.1 --
-- Ngày phát hành sách phải lớn hơn ngày sinh của tác giả.
ALTER TABLE PHATHANH
ADD CONSTRAINT CheckPublishDate CHECK (
    NOT EXISTS (
        SELECT 1
        FROM TACGIA_SACH ts
        JOIN TACGIA t ON ts.MaTG = t.MaTG
        WHERE ts.MaSach = PHATHANH.NaSach AND PHATHANH.NgayPH <= t.NgSinh
    )
);


-- 2.2 --
-- Sách thuộc thể loại “Giáo khoa” chỉ do nhà xuất bản “Giáo dục” phát hành.
ALTER TABLE SACH
ADD CONSTRAINT CheckTextbookPublisher CHECK (
    (TheLoai = 'Giáo khoa' AND NhaXuatBan = 'Giáo dục')
    OR TheLoai <> 'Giáo khoa'
);

-- 3.1 --
-- Tìm tác giả (MaTG,HoTen,SoDT) của những quyển sách thuộc thể loại “Văn học”
-- do nhà xuất bản Trẻ phát hành.
SELECT DISTINCT TG.MaTG, TG.HoTen, TG.SoDT
FROM TACGIA TG
JOIN TACGIA_SACH TS ON TG.MaTG = TS.MaTG
JOIN SACH S ON TS.MaSach = S.MaSach
JOIN PHATHANH PH ON S.MaSach = PH.NaSach
WHERE S.TheLoai = 'Văn học' AND PH.NhaXuatBan = 'Trẻ';

-- 3.2 --
-- Tìm nhà xuất bản phát hành nhiều thể loại sách nhất.
SELECT TOP 1 PH.NhaXuatBan, S.TheLoai, COUNT(*) AS SoLuongTheLoai
FROM PHATHANH PH
JOIN SACH S ON PH.NaSach = S.MaSach
GROUP BY PH.NhaXuatBan, S.TheLoai
ORDER BY SoLuongTheLoai DESC;

-- 3.3 --
-- Trong mỗi nhà xuất bản, tìm tác giả (MaTG,HoTen) có số lần phát hành nhiều sách
-- nhất.
SELECT PH.NhaXuatBan, TG.MaTG, TG.HoTen, COUNT(*) AS SoLanPhatHanh
FROM PHATHANH PH
JOIN SACH S ON PH.NaSach = S.MaSach
JOIN TACGIA_SACH TS ON S.MaSach = TS.MaSach
JOIN TACGIA TG ON TS.MaTG = TG.MaTG
GROUP BY PH.NhaXuatBan, TG.MaTG, TG.HoTen
HAVING COUNT(*) = (
    SELECT TOP 1 COUNT(*)
    FROM PHATHANH PH1
    JOIN SACH S1 ON PH1.NaSach = S1.MaSach
    JOIN TACGIA_SACH TS1 ON S1.MaSach = TS1.MaSach
    WHERE PH1.NhaXuatBan = PH.NhaXuatBan
    GROUP BY TS1.MaTG
    ORDER BY COUNT(*) DESC
)
ORDER BY PH.NhaXuatBan, SoLanPhatHanh DESC;
