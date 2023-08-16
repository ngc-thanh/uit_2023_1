CREATE DATABASE QLBACD;
USE QLBACD;

-- BENHNHAN
CREATE TABLE BENHNHAN (
    MABN CHAR(10) PRIMARY KEY,
    HOTEN NVARCHAR(50),
    NGSINH DATE,
    CMND VARCHAR(20),
    DIACHI NVARCHAR(100),
    DOITUONG NVARCHAR(20),
    SLPT INT
);

-- KHAMBENH
CREATE TABLE KHAMBENH (
    MAKB CHAR(10) PRIMARY KEY,
    MABN CHAR(10) FOREIGN KEY REFERENCES BENHNHAN(MABN),
	BENH NVARCHAR(100),
    BENHKT NVARCHAR(100),
    BATDAU SMALLDATETIME,
    KETTHUC SMALLDATETIME,
    KETLUAN NVARCHAR(200),
    TAIKHAM SMALLDATETIME
);

-- PHAUTHUAT
CREATE TABLE PHAUTHUAT (
    MAPT CHAR(10) PRIMARY KEY,
    MAKB CHAR(10) FOREIGN KEY REFERENCES KHAMBENH(MAKB),
    BOPHANPT NVARCHAR(50),
    LOAIPT NVARCHAR(50),
    KETQUA NVARCHAR(200)
);

-- BACSI
CREATE TABLE BACSI (
    MABS CHAR(10) PRIMARY KEY,
    HOTEN NVARCHAR(50),
    NAMSINH DATE,
    CHUYENMON NVARCHAR(50),
    KHOA NVARCHAR(50),
    BENHVIEN NVARCHAR(100)
);

-- PHUTRACH
CREATE TABLE PHUTRACH (
    MABS CHAR(10) FOREIGN KEY REFERENCES BACSI(MABS),
    MAKB CHAR(10) FOREIGN KEY REFERENCES KHAMBENH(MAKB),
    BATDAUPT SMALLDATETIME,
    KETTHUCPT SMALLDATETIME,
    PRIMARY KEY (MABS, MAKB)
);

-- a. 
-- Cho biết thông tin bệnh nhân (HOTEN, CMND) thuộc đối tượng BHYT’
-- hoặc có địa chỉ ở Đồng Nai . Kết quả được sắp xếp theo số lần phẫu thuật giảm dần. 
SELECT BN.HOTEN, BN.CMND
FROM BENHNHAN BN
WHERE BN.DOITUONG = N'BHYT' OR BN.DIACHI LIKE N'%Đồng Nai%'
ORDER BY BN.SLPT DESC;

-- b. 
-- Cho biết thông tin (MAKB, MABN, HOTEN) 
-- của những bệnh nhân sinh sau năm 2020 có khám bệnh chính là ‘Tim mạch ’. 
SELECT KB.MAKB, KB.MABN, BN.HOTEN
FROM KHAMBENH KB
JOIN BENHNHAN BN ON KB.MABN = BN.MABN
WHERE YEAR(BN.NGSINH) > 2020 AND KB.BENH = N'Tim mạch';

-- c. 
-- Cho biết số lần khám bệnh của từng bệnh nhân trong năm 2020. 
-- Thông tin hiển thị gồm: MABN, HOTEN và SL.
SELECT KB.MABN, BN.HOTEN, COUNT(*) AS SL
FROM KHAMBENH KB
JOIN BENHNHAN BN ON KB.MABN = BN.MABN
WHERE YEAR(KB.BATDAU) = 2020
GROUP BY KB.MABN, BN.HOTEN;

-- d. 
-- Cho biết thông tin những bác sĩ (MABS, HOTEN) có chuyên môn ‘Tai-Mũi-Họng’ 
-- chưa được phụ trách khám bệnh trong năm 2020 (BATDAUPT). 
SELECT BS.MABS, BS.HOTEN
FROM BACSI BS
LEFT JOIN PHUTRACH PT ON BS.MABS = PT.MABS
WHERE BS.CHUYENMON = N'Tai-Mũi-Họng' AND (PT.BATDAUPT IS NULL OR YEAR(PT.BATDAUPT) <> 2020);

-- e. 
-- Cho biết thông tin (MABS, HOTEN) của những bác sĩ chuyên môn Hồi sức - Cấp cứu’ 
-- tham gia tất cả các mã khám bệnh của bệnh nhân Nguyễn Văn A.
SELECT BS.MABS, BS.HOTEN
FROM BACSI BS
JOIN PHUTRACH PT ON BS.MABS = PT.MABS
JOIN KHAMBENH KB ON PT.MAKB = KB.MAKB
JOIN BENHNHAN BN ON KB.MABN = BN.MABN
WHERE BS.CHUYENMON = N'Hồi sức - Cấp cứu' AND BN.HOTEN = N'Nguyễn Văn A'
GROUP BY BS.MABS, BS.HOTEN
HAVING COUNT(DISTINCT KB.MAKB) = (SELECT COUNT(*) FROM KHAMBENH WHERE MABN = 'BN0001');

-- f. 
-- Cho biết thông tin bác sĩ (MABS, HOTEN) có số lần phụ trách khám bệnh nhiều nhất. 
SELECT TOP 1 BS.MABS, BS.HOTEN
FROM BACSI BS
JOIN PHUTRACH PT ON BS.MABS = PT.MABS
GROUP BY BS.MABS, BS.HOTEN
ORDER BY COUNT(PT.MAKB) DESC;


-- INSERT DATA
-- INSERT INTO BENHNHAN
INSERT INTO BENHNHAN (MABN, HOTEN, NGSINH, CMND, DIACHI, DOITUONG, SLPT)
VALUES
    ('BN0001', N'Nguyễn Văn A', '1990-01-15', '123456789', N'Hà Nội', N'Bảo hiểm', 2),
    ('BN0002', N'Trần Thị B', '1985-05-20', '987654321', N'Hồ Chí Minh', N'Tự trả', 1),
    ('BN0003', N'Lê Thị E', '1995-03-20', '567890123', N'Đồng Nai', N'BHYT', 3),
    ('BN0004', N'Phạm Văn F', '2021-05-10', '345678901', N'Hà Nội', N'BHYT', 0),
    ('BN0005', N'Trần Văn G', '2019-11-28', '789012345', N'Đồng Nai', N'Bảo hiểm', 1);

-- INSERT INTO KHAMBENH
INSERT INTO KHAMBENH (MAKB, MABN, BENH, BENHKT, BATDAU, KETTHUC, KETLUAN, TAIKHAM)
VALUES
    ('KB0001', 'BN0001', N'Cảm cúm', N'Đau họng', '2023-08-09 08:00', '2023-08-09 09:30', N'Bình thường', '2023-08-15 10:00'),
    ('KB0002', 'BN0002', N'Sốt', NULL, '2023-08-10 14:30', '2023-08-10 15:45', N'Không có ghi chú', NULL),
    ('KB0003', 'BN0003', N'Đau đầu', NULL, '2020-08-09 10:30', '2023-08-09 11:45', N'Bình thường', '2023-08-16 08:30'),
    ('KB0004', 'BN0004', N'Tim mạch', N'Đau thắt ngực', '2023-08-10 09:15', '2023-08-10 10:30', N'Cần theo dõi', '2023-08-17 09:30'),
    ('KB0005', 'BN0005', N'Cảm cúm', N'Đau họng', '2020-08-11 14:00', '2023-08-11 15:15', N'Bình thường', NULL),
    ('KB0006', 'BN0001', N'Sốt', NULL, '2023-08-10 14:30', '2023-08-10 15:45', N'Không có ghi chú', NULL);

-- INSERT INTO PHAUTHUAT
INSERT INTO PHAUTHUAT (MAPT, MAKB, BOPHANPT, LOAIPT, KETQUA)
VALUES
    ('PT0001', 'KB0001', N'Đầu', N'Phẫu thuật nhỏ', N'Phẫu thuật thành công'),
    ('PT0002', 'KB0001', N'Chân', N'Phẫu thuật lớn', N'Phẫu thuật thành công'),
    ('PT0003', 'KB0003', N'Đầu', N'Phẫu thuật nhỏ', N'Phẫu thuật thành công'),
    ('PT0004', 'KB0004', N'Tim', N'Phẫu thuật lớn', N'Phẫu thuật thành công'),
    ('PT0005', 'KB0005', N'Đầu', N'Phẫu thuật nhỏ', N'Phẫu thuật không thành công');

-- INSERT INTO BACSI
INSERT INTO BACSI (MABS, HOTEN, NAMSINH, CHUYENMON, KHOA, BENHVIEN)
VALUES
    ('BS0001', N'Nguyễn Thị C', '1978-03-10', N'Nội khoa', N'Khoa Nội tổng hợp', N'Bệnh viện A'),
    ('BS0002', N'Trần Văn D', '1982-09-25', N'Ngoại khoa', N'Khoa Ngoại tổng hợp', N'Bệnh viện B'),
    ('BS0003', N'Phạm Thị H', '1986-07-12', N'Tai-Mũi-Họng', N'Khoa Tai-Mũi-Họng', N'Bệnh viện C'),
    ('BS0004', N'Lê Văn I', '1990-04-05', N'Hồi sức - Cấp cứu', N'Khoa Hồi sức - Cấp cứu', N'Bệnh viện D'),
    ('BS0005', N'Hoàng Văn K', '1982-12-15', N'Hồi sức - Cấp cứu', N'Khoa Hồi sức - Cấp cứu', N'Bệnh viện E');

-- INSERT INTO PHUTRACH
INSERT INTO PHUTRACH (MABS, MAKB, BATDAUPT, KETTHUCPT)
VALUES
	('BS0005', 'KB0001', '2023-08-09 10:30', '2023-08-09 11:45'),
	('BS0002', 'KB0002', '2023-08-09 10:30', '2023-08-09 11:45'),
    ('BS0003', 'KB0003', '2023-08-09 10:30', '2023-08-09 11:45'),
    ('BS0004', 'KB0004', '2023-08-10 09:15', '2023-08-10 10:30'),
    ('BS0005', 'KB0005', '2023-08-11 14:00', '2023-08-11 15:15'),
    ('BS0005', 'KB0006', '2023-08-11 14:00', '2023-08-11 15:15'),
	('BS0004', 'KB0001', '2023-08-11 14:00', '2023-08-11 15:15');
