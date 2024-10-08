// ignore_for_file: constant_identifier_names

const String INSERT_T00_TuyChon = '''
  INSERT INTO T00_TuyChon(Ma, GiaTri, MoTa) VALUES
  ('pb', 0, '0: Tieu chuan(từng tin), 1: 1 tin 1 lượt; 2: 3 miền 1 lượt; 3: Thu cong'),
  ('nt', 4, '1: SMS(Itune & sms bck rst); 2-T copytran ; 3-CSV Nokia; 4-Excel: Thu cong'),
  ('nLB', 1, 'bao N lo MB(0::gdb,g1,g2,g3; 1:Gdb,g7,g6,g5)'),
  ('nLN', 1, 'bao N lo MN(0:gdb,g1,g2,g3; 1:Gdb,g8,g7,g6)'),
  ('kxc', 1, '1234b1.b1.xc1.dd1=1234b1.234b1.234.xc1.34dd1'),
  ('kx3', 1, 'đá xiên 3 - miền bắc'),
  ('4dd', 0, 'khong cho phep dd 4 so'),
  ('/', 1, 'ngan cach cap da thang'),
  ('t', 1, 'Không cho phép t=dau'),
  ('au', 0, 'an ủi: vd. st.15b10, nếu ra 14 hoặc 16 thi Giatri = Tỷ lệ thưởng'),
  ('dv5', 1, 'đá vòng 5: 0102030405=010203.030405-0104.0105.0204.0205'),
  ('rpt', 1, '1: 2s,3s; 2:ab,xc; 3:theo kieu ty le'),
  ('nxl', 0, 'hiển thị nút xử lý tin'),
  ('xsMN', 0, '0: Kqxs Hom Nay, 1: Kqxs MinhNGoc')
''';


const String INSERT_T00_User = '''
INSERT INTO T00_User (MaKH, UserName, PassWord, MaKichHoat, NgayHetHan) VALUES 
( '', 'pmn', 'pmn79', '', ''),
( '', '1', '1', '', '')
''';

const String INSERT_T01_Giai = '''
  INSERT INTO T01_Giai (ID, MaGiai, MoTaGiai, SoGiai, SoCon) VALUES 
   (1, 'BDB', 'Giải đặc biệt', 1, 5),
 (2, 'BG1', 'Giải 1', 1, 5),
 (3, 'BG2', 'Giải 2', 2, 5),
 (4, 'BG3', 'Giải 3', 6, 5),
 (5, 'BG4', 'Giải 4', 4, 4),
 (6, 'BG5', 'Giải 5', 6, 4),
 (7, 'BG6', 'Giải 6', 3, 3),
 (8, 'BG7', 'Giải 7', 4, 2),
 (9, 'NG8', 'Giải 8', 1, 2),
 (10, 'NG7', 'Giải 7', 1, 3),
 (11, 'NG6', 'Giải 6', 3, 4),
 (12, 'NG5', 'Giải 5', 1, 4),
 (13, 'NG4', 'Giải 4', 7, 5),
 (14, 'NG3', 'Giải 3', 2, 5),
 (15, 'NG2', 'Giải 2', 1, 5),
 (16, 'NG1', 'Giải 1', 1, 5),
 (17, 'NDB', 'Giải đặc biệt', 1, 6),
 (18, 'TG8', 'Giải 8', 1, 2),
 (19, 'TG7', 'Giải 7', 1, 3),
 (20, 'TG6', 'Giải 6', 3, 4),
 (21, 'TG5', 'Giải 5', 1, 4),
 (22, 'TG4', 'Giải 4', 7, 5),
 (23, 'TG3', 'Giải 3', 2, 5),
 (24, 'TG2', 'Giải 2', 1, 5),
 (25, 'TG1', 'Giải 1', 1, 5),
 (26, 'TDB', 'Giải đặc biệt', 1, 6)
''';

const String INSERT_T01_KieuChoi = '''
INSERT INTO T01_KieuChoi (ID, Kieu, MoTaKieu, Nhom, TyLe) VALUES
(1, '2s', '2 số', 1, 70.0),
(2, '3s', '3 số', 1, 70.0),
(3, '4s', '4 số', 1, 70.0),
(4, 'ab', 'đầu đuôi 2 số', 2, 12.6),
(5, 'xc', 'đầu đuôi 3 số', 2, 12.6),
(6, 'b2', 'bao 2 số (lô 2)', 2, 12.6),
(7, 'b3', 'bao 3 số (lô 3)', 2, 12.6),
(8, 'b4', 'bao 4 số (lô 4)', 2, 12.6),
(10, 'dt', 'đá thẳng', 0, 70.0),
(11, 'dx', 'đá xiên', 0, 70.0),
(12, 'dz', 'xiên 3 mb', 0, 70.0),
(13, 'd4', 'đầu đuôi 4 số', 0, 70.0)
''';

const String INSERT_T01_MaDai = '''
INSERT INTO T01_MaDai (ID, MaDai, MoTa, Mien, Thu, TT, NghiXoSo) VALUES
 (1, 'ag', 'An Giang', 'N', '3', '2', 0),
 (2, 'bd', 'Bình Dương', 'N', '4', '2', 0),
 (3, 'bdi', 'Bình Định', 'T', '3', '1', 0),
 (4, 'bl', 'Bạc Liêu', 'N', '1', '3', 0),
 (5, 'bp', 'Bình Phước', 'N', '5', '3', 0),
 (6, 'bth', 'Bình Thuận', 'N', '3', '3', 0),
 (7, 'bt', 'Bến Tre', 'N', '1', '1', 0),
 (8, 'cm', 'Cà Mau', 'N', '0', '3', 0),
 (9, 'ct', 'Cần Thơ', 'N', '2', '2', 0),
 (10, 'dl', 'Đà Lạt', 'N', '6', '3', 0),
 (11, 'dlk', 'Đăk Lăk', 'T', '1', '1', 0),
 (12, 'dn', 'Đồng Nai', 'N', '2', '1', 0),
 (13, 'dng', 'Đà Nẵng', 'T', '2.5', '1.1', 0),
 (14, 'dno', 'Đăk Nông', 'T', '5', '3', 0),
 (15, 'dt', 'Đồng Tháp', 'N', '0', '2', 0),
 (16, 'gl', 'Gia Lai', 'T', '4', '1', 0),
 (17, 'hg', 'Hậu Giang', 'N', '5', '4', 0),
 (18, 'kg', 'Kiên Giang', 'N', '6', '2', 0),
 (19, 'kh', 'Khánh Hoà', 'T', '2.6', '2.2', 0),
 (20, 'kt', 'Kon Tum', 'T', '6', '1', 0),
 (21, 'la', 'Long An', 'N', '5', '2', 0),
 (22, 'mb', 'Miền Bắc', 'B', '0', NULL, 0),
 (23, 'nt', 'Ninh Thuận', 'T', '4', '2', 0),
 (24, 'py', 'Phú Yên', 'T', '0', '2', 0),
 (25, 'qb', 'Quảng Bình', 'T', '3', '3', 0),
 (26, 'qng', 'Quãng Ngãi', 'T', '5', '2', 0),
 (27, 'qnm', 'Quảng Nam', 'T', '1', '2', 0),
 (28, 'qt', 'Quảng Trị', 'T', '3', '2', 0),
 (29, 'st', 'Sóc Trăng', 'N', '2', '3', 0),
 (30, 'tg', 'Tiền Giang', 'N', '6', '1', 0),
 (31, 'tn', 'Tây Ninh', 'N', '3', '1', 0),
 (32, 'tp', 'TP.HCM', 'N', '0.5', '1.1', 0),
 (33, 'tth', 'Thừa Thiên Huế', 'T', '0.6', '1.3', 0),
 (34, 'tv', 'Trà Vinh', 'N', '4', '3', 0),
 (35, 'vl', 'Vĩnh Long', 'N', '4', '1', 0),
 (36, 'vt', 'Vũng Tàu', 'N', '1', '2', 0)
''';

const String INSERT_T01_MaKieu = '''
INSERT INTO T01_MaKieu (ID, Ma, MoTa) VALUES
(1, 't', 'dau'),
(2, 's', 'dui'),
(3, 'b', 'bao'),
(4, 'dd', 'dd'),
(5, 'dt', 'thang'),
(6, 'dx', 'xien'),
(7, 'dz', 'xien 3 mb')
''';

const String INSERT_T01_TuKhoa = '''
  INSERT INTO T01_TuKhoa (ID, CumTu, ThayThe, SoDanhHang) VALUES
   (1, '₫', 'd', 0),
 (3, '×', 'x', 0),
 (5, 'xchu', 'xc', 0),
 (6, 'dav', 'da', 0),
 (7, 'dxv', 'dx', 0),
 (8, 'dxien', 'dx', 0),
 (9, 'xien', 'dx', 0),
 (10, 'xcdao', 'dxc', 0),
 (11, 'daoxc', 'dxc', 0),
 (12, 'daodd', 'dxc', 0),
 (13, 'daob', 'db', 0),
 (14, 'b dao', 'db', 0),
 (15, 'hanoi', 'mb', 0),
 (17, 'xiu', '00.01.02.03.04.05.06.07.08.09.10.11.12.13.14.15.16.17.18.19.20.21.22.23.24.25.26.27.28.29.30.31.32.33.34.35.36.37.38.39.40.41.42.43.44.45.46.47.48.49', 1),
 (18, 'tai', '50.51.52.53.54.55.56.57.58.59.60.61.62.63.64.65.66.67.68.69.70.71.72.73.74.75.76.77.78.79.80.81.82.83.84.85.86.87.88.89.90.91.92.93.94.95.96.97.98.99', 1),
 (19, 'chan', '00.02.04.06.08.10.12.14.16.18.20.22.24.26.28.30.32.34.36.38.40.42.44.46.48.50.52.54.56.58.60.62.64.66.68.70.72.74.76.78.80.82.84.86.88.90.92.94.96.98', 1),
 (20, 'le', '01.03.05.07.09.11.13.15.17.19.21.23.25.27.29.31.33.35.37.39.41.43.45.47.49.51.53.55.57.59.61.63.65.67.69.71.73.75.77.79.81.83.85.87.89.91.93.95.97.99', 1),
 (21, 'chanchan', '00.02.04.06.08.20.22.24.26.28.40.42.44.46.48.60.62.64.66.68.80.82.84.86.88', 1),
 (22, 'lele', '11.13.15.17.19.31.33.35.37.39.51.53.55.57.59.71.73.75.77.79.91.93.95.97.99', 1),
 (23, 'chanle', '01.03.05.07.09.21.23.25.27.29.41.43.45.47.49.61.63.65.67.69.81.83.85.87.89', 1),
 (24, 'lechan', '10.12.14.16.18.30.32.34.36.38.50.52.54.56.58.70.72.74.76.78.90.92.94.96.98', 1),
 (25, '12giap', '15.55.95.09.49.89.06.46.86.18.58.98.14.54.94.10.50.90.26.66.32.72.12.52.92.35.75.23.63.28.68.11.51.91.07.47.87', 1),
 (27, 'congiap', '15.55.95.09.49.89.06.46.86.18.58.98.14.54.94.10.50.90.26.66.32.72.12.52.92.35.75.23.63.28.68.11.51.91.07.47.87', 1),
 (28, 'bogiap', '00.01.02.03.04.05.08.13.16.17.19.20.21.22.24.25.27.29.30.31.33.34.36.37.38.39.40.41.42.43.44.45.48.53.56.57.59.60.61.62.64.65.67.69.70.71.73.74.76.77.78.79.80.81.82.83.84.85.88.93.96.97.99', 1),
 (29, 'dath', 'dt', 0),
 (30, '2dai', '2d', 0),
 (31, '3dai', '3d', 0),
 (32, '4dai', '4d', 0),
 (34, 'duoi', 'dui', 0),
 (35, 'toi', 'den', 0),
 (38, '⁩&#10,', '.', 0),
 (39, '⁨', '.', 0),
 (40, 'cangiap', '05.08.13.16.17.19.22.24.25.27.29.31.33.34.36.45.48.53.56.57.59.62.64.65.67.69.71.73.74.76.85.88.93.96.97.99', 1),
 (41, 'se', '00.01.02.03.04.20.21.30.37.38.39.40.41.42.43.44.60.61.70.77.78.79.80.81.82.83.84', 1),
 (42, 'letruoc', '10.11.12.13.14.15.16.17.18.19.30.31.32.33.34.35.36.37.38.39.50.51.52.53.54.55.56.57.58.59.70.71.72.73.74.75.76.77.78.79.90.91.92.93.94.95.96.97.98.99', 1),
 (43, 'lengoai', '10.11.12.13.14.15.16.17.18.19.30.31.32.33.34.35.36.37.38.39.50.51.52.53.54.55.56.57.58.59.70.71.72.73.74.75.76.77.78.79.90.91.92.93.94.95.96.97.98.99', 1),
 (44, 'channgoai', '00.01.02.03.04.05.06.07.08.09.20.21.22.23.24.25.26.27.28.29.40.41.42.43.44.45.46.47.48.49.60.61.62.63.64.65.66.67.68.69.80.81.82.83.84.85.86.87.88.89', 1),
 (45, 'chantruoc', '00.01.02.03.04.05.06.07.08.09.20.21.22.23.24.25.26.27.28.29.40.41.42.43.44.45.46.47.48.49.60.61.62.63.64.65.66.67.68.69.80.81.82.83.84.85.86.87.88.89', 1),
 (46, 'taingoai', '05.06.07.08.09.15.16.17.18.19.25.26.27.28.29.35.36.37.38.39.45.46.47.48.49.55.56.57.58.59.65.66.67.68.69.75.76.77.78.79.85.86.87.88.89.95.96.97.98.99', 1),
 (48, 'xiungoai', '05.06.07.08.09.15.16.17.18.19.25.26.27.28.29.35.36.37.38.39.45.46.47.48.49.55.56.57.58.59.65.66.67.68.69.75.76.77.78.79.85.86.87.88.89.95.96.97.98.99', 1),
 (50, 'dbao', 'db', 0),
 (53, 'bdao', 'db', 0),
 (84, 'mt', '.', 0),
 (85, 'mn', '.', 0),
 (86, 'xc.dao', 'dxc', 0),
 (87, 'bao.dao', 'db', 0),
 (111, 'da.vong', 'dv', 0),
 (113, 'daxv', 'dx', 0),
 (114, 'dax', 'dx', 0)
 
''';