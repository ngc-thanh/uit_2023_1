-- 1. Yêu cầu lý thuyết
-- Sinh viên đã được trang bị kiến thức:
-- o Khai báo các RBTV có bối cảnh 1 quan hệ (Null, Not Null, Rule,
-- Check)

-- 2. Nội dung
--  Ôn lại các kiến thức về RBTV có bối cảnh một quan hệ
-- o Ôn lại cách khai báo đã được thực hành ở các bài thực hành trước.
--  Tìm hiểu các kiến thức về RBTV có bối cảnh trên nhiều quan hệ
-- o Khai báo RBTV có bối cảnh trên nhiều quan hệ.
-- o Tìm hiểu về kiểu dữ liệu Cursor.
--  Thực hiện được các bài tập sau
-- o Sử dụng các câu lệnh khai báo RBTV có bối cảnh nhiều quan hệ trên
-- CSDL Quản lý bán hàng và Quản lý giáo vụ.

-- BAI TAP 1
-- Sinh viên hoàn thành Phần I bài tập QuanLyBanHang từ câu 11 đến 15.
-- 11 --
ALTER TABLE HOADON
ADD CONSTRAINT CK_NgayMuaHang CHECK (NGHD >= (SELECT NGDK FROM KHACHHANG WHERE MAKH = HOADON.MAKH));

-- 12 --
ALTER TABLE HOADON
ADD CONSTRAINT CK_NgayBanHang CHECK (NGHD >= (SELECT NGVL FROM NHANVIEN WHERE MANV = HOADON.MANV));


-- 13 --
ALTER TABLE CTHD
ADD CONSTRAINT FK_HOADON_CTHD FOREIGN KEY (SOHD) REFERENCES HOADON (SOHD);


-- 14 --
CREATE TRIGGER TRG_TinhTrigiaHoaDon
AFTER INSERT, UPDATE ON CTHD
FOR EACH ROW
BEGIN
  UPDATE HOADON
  SET TRIGIA = (SELECT SUM(SL * GIA) FROM CTHD WHERE CTHD.SOHD = HOADON.SOHD)
  WHERE SOHD = NEW.SOHD;
END;


-- 15 --
CREATE TRIGGER TRG_TinhDoanhSoKhachHang
AFTER INSERT, UPDATE ON HOADON
FOR EACH ROW
BEGIN
  UPDATE KHACHHANG
  SET DOANHSO = (SELECT SUM(TRIGIA) FROM HOADON WHERE HOADON.MAKH = KHACHHANG.MAKH)
  WHERE MAKH = NEW.MAKH;
END;


-- BAI TAP 2
-- Sinh viên hoàn thành Phần I bài tập QuanLyGiaoVu câu 9, 10 và từ câu 15
-- đến câu 24.
-- 9 --
ALTER TABLE LOP
ADD CONSTRAINT FK_LopTruong FOREIGN KEY (LOPTRG) REFERENCES HOCVIEN (MAHV);

-- 10 --
ALTER TABLE KHOA
ADD CONSTRAINT FK_TruongKhoa FOREIGN KEY (TRGKHOA) REFERENCES GIAOVIEN (MAGV)
  CHECK (GIAOVIEN.HOCHAM IN ('TS', 'PTS'));

-- 15 --
CREATE TRIGGER Trg_CheckMonHocDaHocXong
ON KETQUATHI
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM KETQUATHI AS kt
        JOIN LOP AS l ON kt.MALOP = l.MALOP
        WHERE kt.MAMH = l.MAMH_TRUOC AND kt.KQUA = 'Khong dat'
    )
    BEGIN
        RAISERROR('Học viên chỉ được thi môn học nào đã được học xong trong lớp!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;


-- 16 --
CREATE TRIGGER Trg_CheckSoMonHocTrenLop
ON GIANGDAY
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT MALOP, HOCKY, NAM, COUNT(*) AS SoMonHoc
        FROM GIANGDAY
        GROUP BY MALOP, HOCKY, NAM
        HAVING COUNT(*) > 3
    )
    BEGIN
        RAISERROR('Mỗi lớp chỉ được học tối đa 3 môn trong mỗi học kỳ của năm học!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;

-- 17 --
CREATE TRIGGER Trg_CheckSiSoLop
ON HOCVIEN
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT LOP.MALOP
        FROM LOP
        JOIN (SELECT MALOP, COUNT(*) AS SoLuongHocVien
              FROM HOCVIEN
              GROUP BY MALOP) AS SoLuongHocVienTheoLop ON LOP.MALOP = SoLuongHocVienTheoLop.MALOP
        WHERE LOP.SISO <> SoLuongHocVienTheoLop.SoLuongHocVien
    )
    BEGIN
        RAISERROR('Sỉ số của lớp không bằng với số lượng học viên thuộc lớp đó!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;

-- 18 --
CREATE TRIGGER Trg_CheckDIEUKIEN
ON DIEUKIEN
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM DIEUKIEN
        WHERE MAMH = MAMH_TRUOC
    )
    BEGIN
        RAISERROR('Giá trị của thuộc tính MAMH và MAMH_TRUOC không được giống nhau trong cùng một bộ!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF EXISTS (
        SELECT *
        FROM DIEUKIEN AS D1
        WHERE EXISTS (
            SELECT *
            FROM DIEUKIEN AS D2
            WHERE D1.MAMH = 'A' AND D1.MAMH_TRUOC = 'B' AND D1.MAMH = D2.MAMH_TRUOC AND D1.MAMH_TRUOC = D2.MAMH
        )
    )
    BEGIN
        RAISERROR('Không tồn tại hai bộ ("A", "B") và ("B", "A")!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;


-- 19 --
CREATE TRIGGER Trg_EqualSalary
ON GIAOVIEN
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE GIAOVIEN
    SET MUCLUONG = (
        SELECT AVG(MUCLUONG)
        FROM GIAOVIEN
        WHERE HOCVI = (SELECT HOCVI FROM INSERTED) AND HOCHAM = (SELECT HOCHAM FROM INSERTED) AND HESO = (SELECT HESO FROM INSERTED)
    )
    WHERE MAGV IN (
        SELECT MAGV
        FROM GIAOVIEN
        WHERE HOCVI = (SELECT HOCVI FROM INSERTED) AND HOCHAM = (SELECT HOCHAM FROM INSERTED) AND HESO = (SELECT HESO FROM INSERTED)
    )
END;

-- 20 --
CREATE TRIGGER Trg_CheckThiLai
ON KETQUATHI
AFTER UPDATE
AS
BEGIN
    -- Kiểm tra học viên chỉ được thi lại khi điểm lần thi trước dưới 5
    IF EXISTS (
        SELECT *
        FROM KETQUATHI AS KQ1
        JOIN KETQUATHI AS KQ2 ON KQ1.MAHV = KQ2.MAHV AND KQ1.MAMH = KQ2.MAMH AND KQ1.LANTHI = KQ2.LANTHI + 1
        WHERE KQ1.DIEM >= 5 AND KQ2.DIEM >= 5
    )
    BEGIN
        RAISERROR('Học viên chỉ được thi lại khi điểm lần thi trước dưới 5!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;

-- 21 --
CREATE TRIGGER Trg_CheckNgayThiSau
ON KETQUATHI
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM KETQUATHI AS kt1
        JOIN KETQUATHI AS kt2 ON kt1.MAHV = kt2.MAHV AND kt1.MAMH = kt2.MAMH
        WHERE kt1.SOLANTHI < kt2.SOLANTHI AND kt1.NGTHI >= kt2.NGTHI
    )
    BEGIN
        RAISERROR('Ngày thi của lần thi sau phải lớn hơn ngày thi của lần thi trước!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;



-- 22 --
CREATE TRIGGER Trg_CheckHocVienThiMonHoc
ON GIANGDAY
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM HOCVIEN AS HV
        JOIN MONHOC AS MH ON HV.MALOP = (SELECT MALOP FROM INSERTED) AND MH.MAKHOA = HV.MAKHOA
        WHERE MH.MAMH NOT IN (
            SELECT MAMH
            FROM GIANGDAY
            WHERE MALOP = (SELECT MALOP FROM INSERTED)
        )
    )
    BEGIN
        RAISERROR('Học viên chỉ được thi những môn mà lớp đã học xong!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;



-- 23 --
CREATE TRIGGER Trg_CheckPhanCongGiangDay
ON GIANGDAY
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM GIANGDAY AS GD
        JOIN MONHOC AS MH1 ON GD.MAMH = MH1.MAMH
        JOIN MONHOC AS MH2 ON MH1.STT >= MH2.STT
        WHERE GD.MALOP = (SELECT MALOP FROM INSERTED)
        AND MH1.STT <> MH2.STT
    )
    BEGIN
        RAISERROR('Môn học được phân công giảng dạy không tuân theo thứ tự học tập!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;



-- 24 --
CREATE TRIGGER Trg_CheckPhanCongGiangDay
ON GIANGDAY
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM GIANGDAY AS GD
        JOIN GIAOVIEN AS GV ON GD.MAGV = GV.MAGV
        JOIN MONHOC AS MH ON GD.MAMH = MH.MAMH AND MH.MAKHOA <> GV.MAKHOA
    )
    BEGIN
        RAISERROR('Giáo viên chỉ được phân công dạy những môn thuộc khoa mà giáo viên phụ trách!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
