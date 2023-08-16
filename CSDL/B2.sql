-- BAI TAP 1
-- Sinh viên tiến hành viết câu lệnh nhập dữ liệu cho CSDL QuanLyBanHang
-- (Phần II, câu 1 bài tập thực hành trang 4).


-- BAI TAP 2
-- Sinh viên tiến hành viết câu lệnh nhập dữ liệu cho CSDL QuanLyGiaoVu.


-- BAI TAP 3
-- Sinh viên hoàn thành Phần II bài tập QuanLyBanHang từ câu 2 đến câu 5.
INSERT INTO SANPHAM1 SELECT * FROM SANPHAM;
INSERT INTO KHACHHANG1 SELECT * FROM KHACHHANG;

-- 3.	Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ SANPHAM1) --
UPDATE SANPHAM1
SET GIA = GIA * 1.05
WHERE NUOCSX = 'Thai Lan';

-- 4.	Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ 10.000 trở xuống (cho quan hệ SANPHAM1).
UPDATE SANPHAM1 
SET GIA = GIA * 0.95
WHERE NUOCSX = 'Trung Quoc' AND GIA >= 10000;

-- 5.	Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước ngày 1/1/2007 có doanh số từ 10.000.000 trở lên hoặc khách hàng đăng ký thành viên từ 1/1/2007 trở về sau có doanh số từ 2.000.000 trở lên (cho quan hệ KHACHHANG1).
UPDATE KHACHHANG1
SET LOAIKH = 'Vip'
WHERE (NGDK < '2007-01-01' AND DOANHSO >= 10000000)
   OR (NGDK >= '2007-01-01' AND DOANHSO >= 2000000);

-- BAI TAP 4
-- Sinh viên hoàn thành Phần I bài tập QuanLyGiaoVu từ câu 11 đến câu 14.
-- 11 --
ALTER TABLE HOCVIEN
ADD CONSTRAINT CK_Tuoi CHECK (DATEDIFF(YEAR, NGSINH, GETDATE()) >= 18);

-- 12 --
ALTER TABLE GIANGDAY
ADD CONSTRAINT CK_ThoiGianGiangDay CHECK (TUNGAY < DENNGAY);

-- 13 --
ALTER TABLE GIAOVIEN
ADD CONSTRAINT CK_TuoiGiaoVien CHECK (DATEDIFF(YEAR, NGVL, GETDATE()) >= 22);

-- 14 --
CREATE TRIGGER Trg_CheckTinChiChenhLech
ON MONHOC
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM MONHOC AS mh
        WHERE ABS(mh.TCLT - mh.TCTH) > 3
    )
    BEGIN
        RAISERROR('Số tín chỉ lý thuyết và số tín chỉ thực hành không được chênh lệch quá 3!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;


-- BAI TAP 5
-- Sinh viên hoàn thành Phần III bài tập QuanLyBanHang từ câu 1 đến câu 11.
-- 1.	In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất. --
SELECT MASP, TENSP
FROM SANPHAM1
WHERE NUOCSX = 'Trung Quoc';

-- 2.	In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”. --
SELECT MASP, TENSP
FROM SANPHAM1
WHERE DONVITINH IN ('cay', 'quyen');

-- 3.	In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”. --
SELECT MASP, TENSP
FROM SANPHAM1
WHERE MASP LIKE 'B%01';

-- 4.	In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến 40.000. --
SELECT MASP, TENSP
FROM SANPHAM1
WHERE NUOCSX = 'Trung Quoc' AND GiaBan BETWEEN 30000 AND 40000;

-- 5.	In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ 30.000 đến 40.000. --
SELECT MASP, TENSP
FROM SANPHAM1
WHERE (NUOCSX = 'Trung Quoc' OR NUOCSX = 'Thai Lan') AND GiaBan BETWEEN 30000 AND 40000;

-- 6.	In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007. --
SELECT SOHD, TONGTIEN
FROM HOADON
WHERE NGAYBAN BETWEEN '2007-01-01' AND '2007-01-02';

-- 7.	In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần). --
SELECT SOHD, TONGTIEN
FROM HOADON
WHERE NGAYBAN BETWEEN '2007-01-01' AND '2007-01-31'
ORDER BY NGAYBAN ASC, TONGTIEN DESC;

-- 8.	In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007. -- 
SELECT DISTINCT KHACHHANG1.MAKH, KHACHHANG1.HOTEN
FROM KHACHHANG1
JOIN HOADON ON KHACHHANG1.MAKH = HOADON.MAKH
WHERE HOADON.NGAYBAN = '2007-01-01';

-- 9.	In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 28/10/2006. -- 
SELECT SOHD, TONGTIEN
FROM HOADON
WHERE NGAYLAP = '2006-10-28' AND MANV IN (
    SELECT MANV
    FROM NHANVIEN
    WHERE HOTEN = 'Nguyen Van B'
);

-- 10.	In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006. -- 
SELECT DISTINCT SANPHAM1.MASP, SANPHAM1.TENSP
FROM SANPHAM1
JOIN CTHD ON SANPHAM1.MASP = CTHD.MASP
JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
JOIN KHACHHANG1 ON HOADON.MAKH = KHACHHANG1.MAKH
WHERE KHACHHANG1.HOTEN = 'Nguyen Van A' AND HOADON.NGAYBAN BETWEEN '2006-10-01' AND '2006-10-31';

-- 11.	Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”. -- 
SELECT DISTINCT HOADON.SOHD
FROM HOADON
JOIN CTHD ON HOADON.SOHD = CTHD.SOHD
WHERE CTHD.MASP IN ('BB01', 'BB02');

-- BAI TAP 6
-- Sinh viên hoàn thành Phần III bài tập QuanLyGiaoVu từ câu 1 đến câu 5.
-- 1 --
SELECT HV.MAHV, HV.HO, HV.TEN, HV.NGSINH, HV.MALOP
FROM HOCVIEN HV
INNER JOIN LOP L ON HV.MAHV = L.TRGLOP;

-- 2 --
SELECT HV.MAHV, HV.HO, HV.TEN, KT.LANTHI, KT.DIEM
FROM HOCVIEN HV
INNER JOIN KETQUATHI KT ON HV.MAHV = KT.MAHV
INNER JOIN LOP L ON HV.MALOP = L.MALOP
INNER JOIN MONHOC MH ON KT.MAMH = MH.MAMH
WHERE L.TENLOP = 'K12' AND MH.TENMH = 'CTRR'
ORDER BY HV.HO, HV.TEN;

-- 3 --
SELECT HV.MAHV, HV.HO, HV.TEN
FROM HOCVIEN HV
INNER JOIN KETQUATHI KT ON HV.MAHV = KT.MAHV
WHERE KT.LANTHI = 1 AND KT.KQUA = 'Dat';

-- 4 --
SELECT HV.MAHV, HV.HO, HV.TEN
FROM HOCVIEN HV
INNER JOIN KETQUATHI KT ON HV.MAHV = KT.MAHV
INNER JOIN LOP L ON HV.MALOP = L.MALOP
INNER JOIN MONHOC MH ON KT.MAMH = MH.MAMH
WHERE L.TENLOP = 'K11' AND MH.TENMH = 'CTRR' AND KT.LANTHI = 1 AND KT.KQUA = 'Khong Dat';

-- 5 --
SELECT HV.MAHV, HV.HO, HV.TEN
FROM HOCVIEN HV
INNER JOIN LOP L ON HV.MALOP = L.MALOP
INNER JOIN MONHOC MH ON HV.MAMH = MH.MAMH
LEFT JOIN KETQUATHI KT ON HV.MAHV = KT.MAHV AND MH.MAMH = KT.MAMH
WHERE L.TENLOP LIKE 'K%' AND MH.TENMH = 'CTRR' AND (KT.KQUA IS NULL OR KT.KQUA = 'Khong Dat');

