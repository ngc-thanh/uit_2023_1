CREATE DATABASE QLTV;
USE QLTV;

-- DOCGIA --
CREATE TABLE DOCGIA
(
	MaDG char(5) PRIMARY KEY,
	HoTen varchar(30),
	NgaySinh smalldatetime,
	DiaChi varchar(30),
	SoDT varchar(15),
);

-- SACH --
CREATE TABLE SACH
(
	MaSach char(5) PRIMARY KEY,
	TenSach varchar(25),
	TheLoai varchar(25),
	NhaXuatBan varchar(30),
);

-- PHIEUMUON --
CREATE TABLE PHIEUMUON
(
	MaPM char(5) PRIMARY KEY,
	MaDG char(5) FOREIGN KEY REFERENCES DOCGIA(MaDG),
	NgayMuon smalldatetime,
	NgayTra smalldatetime,
	SoSachMuon int
);

-- CHITIET_PM --
CREATE TABLE CHITIET_PM
(
	MaPM char(5) FOREIGN KEY REFERENCES PHIEUMUON(MaPM),
	MaSach char(5) FOREIGN KEY REFERENCES SACH(MaSach),
	PRIMARY KEY (MaPM, MaSach)
);