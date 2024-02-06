// ignore_for_file: constant_identifier_names

const String V_Trung_k1 = '''
CREATE VIEW V_Trung_k1 AS
    SELECT c.ID,
           c.TinNhanID,
           DauTren,
           SUM(CASE WHEN LENGTH(SoDanh) = 2 OR 
                         LENGTH(SoDanh) = 5 THEN TienXac END) AS Xac2s,
           SUM(CASE WHEN LENGTH(SoDanh) = 3 OR 
                         LENGTH(SoDanh) = 4 THEN TienXac END) AS Xac3s,
           SUM(CASE WHEN LENGTH(SoDanh) = 2 THEN SoTien * SoLanTrung END) AS Trung2s,
           SUM(CASE WHEN LENGTH(SoDanh) = 3 THEN SoTien * SoLanTrung END) AS Trung3s,
           SUM(CASE WHEN LENGTH(SoDanh) = 4 THEN SoTien * SoLanTrung END) AS Trung4s,
           SUM(CASE WHEN MaKieu = 'dt' THEN SoTien * SoLanTrung END) AS Trungdt,
           SUM(CASE WHEN MaKieu = 'dx' THEN SoTien * SoLanTrung END) AS Trungdx
      FROM TXL_TinNhanCT c
           JOIN
           TXL_TinPhanTichCT p ON c.ID = p.TinNhanCTID
           JOIN
           TXL_TinNhan k ON k.ID = c.TinNhanID
     GROUP BY c.ID
''';

const String V_Trung_k2 = '''
CREATE VIEW V_Trung_k2 AS
    SELECT c.ID,
           c.TinNhanID,
           SUM(CASE WHEN (MaKieu = 'dd' OR 
                          MaKieu = 't' OR 
                          MaKieu = 's') AND 
                         LENGTH(SoDanh) = 2 THEN SoTien * SoLanTrung END) AS TrungAB,
           SUM(CASE WHEN (MaKieu = 'dd' OR 
                          MaKieu = 't' OR 
                          MaKieu = 's') AND 
                         LENGTH(SoDanh) = 3 THEN SoTien * SoLanTrung END) AS TrungXC,
           SUM(CASE WHEN MaKieu = 'dt' OR 
                         MaKieu = 'dx' THEN SoTien * SoLanTrung END) AS TrungDA,
           SUM(CASE WHEN (INSTR(MaKieu, 'b') = 1) AND 
                         LENGTH(SoDanh) = 2 THEN SoTien * SoLanTrung END) AS TrungL2,
           SUM(CASE WHEN (INSTR(MaKieu, 'b') = 1) AND 
                         LENGTH(SoDanh) = 3 THEN SoTien * SoLanTrung END) AS TrungL3,
           SUM(CASE WHEN LENGTH(SoDanh) = 4 THEN SoTien * SoLanTrung END) AS Trung4
      FROM TXL_TinNhanCT c
           JOIN
           TXL_TinPhanTichCT p ON c.ID = p.TinNhanCTID
     GROUP BY c.ID;

''';

const String VBC_ChiTiet_diem= '''
CREATE VIEW VBC_ChiTiet_diem AS
    SELECT TinNhanID,
           TinXL,
           Xac,
           Von,
           (
               SELECT SUM(TienXac) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      LENGTH(SoDanh) = 2 AND 
                      (MaKieu = 'dd' OR 
                       MaKieu = 't' OR 
                       MaKieu = 's') 
           )
           [Điểm AB],
           (
               SELECT ROUND(SUM(TienVon) ) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      LENGTH(SoDanh) = 2 AND 
                      (MaKieu = 'dd' OR 
                       MaKieu = 't' OR 
                       MaKieu = 's') 
           )
           [Tiền AB],
           (
               SELECT SUM(TienXac) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      LENGTH(SoDanh) = 3 AND 
                      (MaKieu = 'dd' OR 
                       MaKieu = 't' OR 
                       MaKieu = 's') 
           )
           [Điểm XC],
           (
               SELECT ROUND(SUM(TienVon) ) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      LENGTH(SoDanh) = 3 AND 
                      (MaKieu = 'dd' OR 
                       MaKieu = 't' OR 
                       MaKieu = 's') 
           )
           [Tiền XC],
           (
               SELECT SUM(SoTien) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      MaKieu = 'dt'
           )
           [Điểm Dt],
           (
               SELECT ROUND(SUM(TienVon) ) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      MaKieu = 'dt'
           )
           [Tiền Dt],
           (
               SELECT SUM(SoTien) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      MaKieu = 'dx'
           )
           [Điểm Dx],
           (
               SELECT ROUND(SUM(TienVon) ) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      MaKieu = 'dx'
           )
           [Tiền Dx],
           (
               SELECT SUM(SoTien * SoDai) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      LENGTH(SoDanh) = 2 AND 
                      INSTR(MaKieu, 'b') = 1
           )
           [Điểm lô 2],
           (
               SELECT ROUND(SUM(TienVon) ) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      LENGTH(SoDanh) = 2 AND 
                      INSTR(MaKieu, 'b') = 1
           )
           [Tiền lô 2],
           (
               SELECT SUM(SoTien * SoDai) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      LENGTH(SoDanh) = 3 AND 
                      INSTR(MaKieu, 'b') = 1
           )
           [Điểm lô 3],
           (
               SELECT ROUND(SUM(TienVon) ) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      LENGTH(SoDanh) = 3 AND 
                      INSTR(MaKieu, 'b') = 1
           )
           [Tiền lô 3],
           (
               SELECT SUM(SoTien * SoDai) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      LENGTH(SoDanh) = 4 AND 
                      INSTR(MaKieu, 'b') = 1
           )
           [Điểm lô 4],
           (
               SELECT ROUND(SUM(TienVon) ) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      LENGTH(SoDanh) = 4 AND 
                      INSTR(MaKieu, 'b') = 1
           )
           [Tiền lô 4]
      FROM VXL_TinNhanCT c;

''';

const String VBC_ChiTiet_k1= '''
CREATE VIEW VBC_ChiTiet_k1 AS
    SELECT TinNhanID,
           TinXL,
           Xac,
           Von,
           Trung,
           LaiLo,
           (
               SELECT GROUP_CONCAT(SoDanh, ',') 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 2
           )
           SoTrung2s,
           (
               SELECT SUM(SoTien * SoLanTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 2
           )
           DiemTrung2s,
           (
               SELECT SUM(TienTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 2
           )
           TienTrung2s,
           (
               SELECT GROUP_CONCAT(SoDanh, ',') 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 3
           )
           SoTrung3s,
           (
               SELECT SUM(SoTien * SoLanTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 3
           )
           DiemTrung3s,
           (
               SELECT SUM(TienTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 3
           )
           TienTrung3s,
           (
               SELECT GROUP_CONCAT(SoDanh, ',') 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 4
           )
           SoTrung4s,
           (
               SELECT SUM(SoTien * SoLanTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 4
           )
           DiemTrung4s,
           (
               SELECT SUM(TienTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 4
           )
           TienTrung4s,
           (
               SELECT GROUP_CONCAT(SoDanh, ',') 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      MaKieu = 'dt'
           )
           SoTrungDt,
           (
               SELECT SUM(SoTien * SoLanTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      MaKieu = 'dt'
           )
           DiemTrungDt,
           (
               SELECT SUM(TienTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      MaKieu = 'dt'
           )
           TienTrungDt,
           (
               SELECT GROUP_CONCAT(SoDanh, ',') 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      MaKieu = 'dx'
           )
           SoTrungDx,
           (
               SELECT SUM(SoTien * SoLanTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      MaKieu = 'dx'
           )
           DiemTrungDa,
           (
               SELECT SUM(TienTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      MaKieu = 'dx'
           )
           TienTrungDa
      FROM VXL_TinNhanCT c;

''';

const String VBC_ChiTiet_k2 = '''
CREATE VIEW VBC_ChiTiet_k2 AS
    SELECT TinNhanID,
           TinXL,
           Xac,
           Von,
           Trung,
           LaiLo,
           (
               SELECT GROUP_CONCAT(SoDanh, ',') 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 2 AND 
                      (MaKieu = 'dd' OR 
                       MaKieu = 't' OR 
                       MaKieu = 's') 
           )
           SoTrungAB,
           (
               SELECT SUM(SoTien * SoLanTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 2 AND 
                      (MaKieu = 'dd' OR 
                       MaKieu = 't' OR 
                       MaKieu = 's') 
           )
           DiemTrungAB,
           (
               SELECT SUM(TienTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 2 AND 
                      (MaKieu = 'dd' OR 
                       MaKieu = 't' OR 
                       MaKieu = 's') 
           )
           TienTrungAB,
           (
               SELECT GROUP_CONCAT(SoDanh, ',') 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 3 AND 
                      (MaKieu = 'dd' OR 
                       MaKieu = 't' OR 
                       MaKieu = 's') 
           )
           SoTrungXC,
           (
               SELECT SUM(SoTien * SoLanTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 3 AND 
                      (MaKieu = 'dd' OR 
                       MaKieu = 't' OR 
                       MaKieu = 's') 
           )
           DiemTrungXC,
           (
               SELECT SUM(TienTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 3 AND 
                      (MaKieu = 'dd' OR 
                       MaKieu = 't' OR 
                       MaKieu = 's') 
           )
           TienTrungXC,
           (
               SELECT GROUP_CONCAT(SoDanh, ',') 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      (MaKieu = 'dt' OR 
                       MaKieu = 'dx') 
           )
           SoTrungDA,
           (
               SELECT SUM(SoTien * SoLanTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      (MaKieu = 'dt' OR 
                       MaKieu = 'dx') 
           )
           DiemTrungDA,
           (
               SELECT SUM(TienTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      (MaKieu = 'dt' OR 
                       MaKieu = 'dx') 
           )
           TienTrungDA,
           (
               SELECT GROUP_CONCAT(SoDanh, ',') 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 2 AND 
                      (INSTR(MaKieu, 'b') = 1) 
           )
           SoTrungL2,
           (
               SELECT SUM(SoTien * SoLanTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 2 AND 
                      (INSTR(MaKieu, 'b') = 1) 
           )
           DiemTrungL2,
           (
               SELECT SUM(TienTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 2 AND 
                      (INSTR(MaKieu, 'b') = 1) 
           )
           TienTrungL2,
           (
               SELECT GROUP_CONCAT(SoDanh, ',') 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 3 AND 
                      (INSTR(MaKieu, 'b') = 1) 
           )
           SoTrungL3,
           (
               SELECT SUM(SoTien * SoLanTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 3 AND 
                      (INSTR(MaKieu, 'b') = 1) 
           )
           DiemTrungL3,
           (
               SELECT SUM(TienTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 3 AND 
                      (INSTR(MaKieu, 'b') = 1) 
           )
           TienTrungL3,
           (
               SELECT GROUP_CONCAT(SoDanh, ',') 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 4
           )
           SoTrung4,
           (
               SELECT SUM(SoTien * SoLanTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 4
           )
           DiemTrung4,
           (
               SELECT SUM(TienTrung) 
                 FROM TXL_TinPhanTichCT p
                WHERE c.ID = p.TinNhanCTID AND 
                      SoLanTrung > 0 AND 
                      LENGTH(SoDanh) = 4
           )
           TienTrung4
      FROM VXL_TinNhanCT c;

''';


const String VBC_ChiTiet_k3 = '''
CREATE VIEW VBC_ChiTiet_k3 AS
    SELECT TinNhanID,
           TinXL,
           Mien,
           SUM(TienXac) AS Xac,
           ROUND(SUM(TienVon) ) AS Von,
           SUM(TienTrung) AS Trung,
           ROUND(SUM(TienVon - TienTrung) ) AS LaiLo,
           SUM(CASE WHEN LENGTH(SoDanh) = 2 AND 
                         (MaKieu = 't' OR 
                          MaKieu = 's') THEN SoTien ELSE (CASE WHEN LENGTH(SoDanh) = 2 AND 
                                                                    (MaKieu = 'dd') THEN SoTien * 2 END) END) AS AB,
           SUM(CASE WHEN LENGTH(SoDanh) = 3 AND 
                         (MaKieu = 't' OR 
                          MaKieu = 's') THEN SoTien ELSE (CASE WHEN LENGTH(SoDanh) = 3 AND 
                                                                    (MaKieu = 'dd') THEN SoTien * 2 END) END) AS XC,
           SUM(CASE WHEN MaKieu = 'dt' THEN SoTien * 2 END) AS Dt,
           SUM(CASE WHEN MaKieu = 'dx' THEN SoTien * 2 END) AS Dx,
           SUM(CASE WHEN LENGTH(SoDanh) = 2 AND 
                         MaKieu = 'b' THEN SoTien END) AS [Lô 2],
           SUM(CASE WHEN LENGTH(SoDanh) = 3 AND 
                         MaKieu = 'b' THEN SoTien END) AS [Lô 3]
      FROM TXL_TinNhanCT
           LEFT JOIN
           TXL_TinPhanTichCT ON TXL_TinNhanCT.ID = TXL_TinPhanTichCT.TinNhanCTID
     GROUP BY TXL_TinNhanCT.TinNhanID,
              Mien;

''';

const String VBC_PtChiTiet_1= '''
CREATE VIEW VBC_PtChiTiet_1 AS
    SELECT MaTin,
           TinNhanCTID,
           Ngay,
           KhachID,
           Mien,
           MaDai,
           (CASE WHEN INSTR(MaKieu, 'b') = 1 THEN 'b' || SUBSTR(MaKieu, 2, 1) || 'l' ELSE (CASE WHEN INSTR(MaKieu, 'g') = 1 THEN 'giai' ELSE (CASE WHEN SUBSTR(MaKieu, 1, 2) = 'dd' AND 
                                                                                                                                                        LENGTH(SoDanh) = 3 THEN 'xc' ELSE (CASE WHEN MaKieu = 't' AND 
                                                                                                                                                                                                     LENGTH(SoDanh) = 3 THEN 'xdau' ELSE (CASE WHEN MaKieu = 's' AND 
                                                                                                                                                                                                                                                    LENGTH(SoDanh) = 3 THEN 'xdui' ELSE Mota END) END) END) END) END) AS Kieu,
           SoDanh,
           SoTien,
           TienXac AS ThanhTien,
           TienVon AS NhanVe,
           TienTrung,
           SoLanTrung
      FROM (
               TXL_TinNhan c
               JOIN
               TXL_TinPhanTichCT p ON c.ID = p.MaTin
           )
           LEFT JOIN
           T01_MaKieu q ON p.MaKieu = q.Ma;

''';

const String VBC_PtChiTiet_2 = '''
CREATE VIEW VBC_PtChiTiet_2 AS
    SELECT MaTin,
           TinNhanCTID,
           Ngay,
           KhachID,
           Mien,
           MaDai,
           (CASE WHEN INSTR(MaKieu, 'b') = 1 THEN 'b' || SUBSTR(MaKieu, 2, 1) || 'l' ELSE (CASE WHEN INSTR(MaKieu, 'g') = 1 THEN 'giai' ELSE (CASE WHEN SUBSTR(MaKieu, 1, 2) = 'dd' AND 
                                                                                                                                                        LENGTH(SoDanh) = 3 THEN 'xc' ELSE (CASE WHEN MaKieu = 't' AND 
                                                                                                                                                                                                     LENGTH(SoDanh) = 3 THEN 'xdau' ELSE (CASE WHEN MaKieu = 's' AND 
                                                                                                                                                                                                                                                    LENGTH(SoDanh) = 3 THEN 'xdui' ELSE Mota END) END) END) END) END) AS Kieu,
           SoDanh,
           SUM(SoTien) AS SoTien,
           SUM(TienXac) AS ThanhTien,
           ROUND(SUM(TienVon), 1) AS NhanVe,
           SUM(CASE WHEN SoLanTrung > 0 THEN SoLanTrung * SoTien END) AS DiemTrung,
           SUM(TienTrung) AS TienTrung
      FROM (
               TXL_TinNhan c
               JOIN
               TXL_TinPhanTichCT p ON c.ID = p.MaTin
           )
           LEFT JOIN
           T01_MaKieu q ON p.MaKieu = q.Ma
     GROUP BY TinNhanCTID,
              MaDai,
              Kieu,
              SoDanh;

''';

const String VBC_PtTongHop_k1 = '''
CREATE VIEW VBC_PtTongHop_k1 AS
    SELECT TinNhanCTID AS Tin,
           KhachID,
           Ngay,
           MaKhach,
           Mien,
           (CASE WHEN Kieu = 'bl' AND 
                      LENGTH(SoDanh) = 2 THEN '18lo' ELSE CASE WHEN Kieu = 'bl' AND 
                                                                    LENGTH(SoDanh) = 3 THEN '17lo' ELSE CASE WHEN Kieu = 'b7l' THEN '7lo' ELSE CASE WHEN Kieu = 'thang' THEN 'Dt' ELSE CASE WHEN Kieu = 'xien' THEN 'Dx' ELSE CASE WHEN (Kieu = 'dd' OR 
                                                                                                                                                                                                                                         Kieu = 'dau' OR 
                                                                                                                                                                                                                                         Kieu = 'dui') AND 
                                                                                                                                                                                                                                        LENGTH(SoDanh) = 2 THEN 'DD' ELSE 'XC' END END END END END END) AS KieuDanh,
           SUM(SoTien) AS Xac,
           SUM(NhanVe) AS TienVon,
           SUM(CASE WHEN SoLanTrung > 0 THEN SoTien * SoLanTrung END) AS Trung,
           SUM(TienTrung) AS TienTrung
      FROM VBC_PtChiTiet_1 c
           JOIN
           TDM_Khach p ON c.KhachID = p.ID
     GROUP BY Tin,
              KhachID,
              Ngay,
              MaKhach,
              Mien,
              KieuDanh;

''';


const String VBC_TongHop= '''
CREATE VIEW VBC_TongHop AS
    SELECT c.ID,
           c.KhachID,
           Ngay,
           MaKhach AS Khách,
           Mien AS Miền,
           Xac AS Tổng,
           Trung AS Thưởng,
           ThuBu AS [Thu/bù]
      FROM (
               VXL_TongTienPhieu c
               LEFT JOIN
               V_Trung_k1 p ON c.ID = p.TinNhanID
           )
           JOIN
           TDM_Khach q ON c.KhachID = q.ID
     GROUP BY c.ID;
''';

const String VBC_TongHop_k1= '''
CREATE VIEW VBC_TongHop_k1 AS
    SELECT c.ID,
           c.KhachID,
           Ngay,
           MaKhach AS Khách,
           Mien AS Miền,
           Xac AS [Tiền xác],
           Von AS [Tiền vốn],
           Trung AS [Tiền trúng],
           LaiLo AS [Lãi lỗ],
           (CASE WHEN DauTren = 0 THEN ThuBu END) AS [Đầu dưới],
           (CASE WHEN DauTren = 1 THEN -1 * ThuBu END) AS [Đầu trên],
           ROUND(SUM(Xac2S) ) AS [Xác 2s],
           ROUND(SUM(Xac3s) ) AS [Xác 3s],
           SUM(Trung2s) AS Trung2s,
           SUM(Trung3s) AS Trung3s,
           SUM(Trung4s) AS Trung4s,
           SUM(Trungdt) AS TrungDt,
           SUM(Trungdx) AS TrungDx
      FROM (
               VXL_TongTienPhieu c
               LEFT JOIN
               V_Trung_k1 p ON c.ID = p.TinNhanID
           )
           JOIN
           TDM_Khach q ON c.KhachID = q.ID
     GROUP BY c.ID;
''';

const String VBC_TongHop_k2= '''
CREATE VIEW VBC_TongHop_k2 AS
    SELECT c.ID,
           c.KhachID,
           Ngay,
           MaKhach,
           Mien,
           Xac,
           Von,
           Trung,
           LaiLo,
           ThuBu,
           SUM(TrungAB) AS TrungAB,
           SUM(TrungXC) AS TrungXC,
           SUM(TrungDA) AS TrungDA,
           SUM(TrungL2) AS TrungL2,
           SUM(TrungL3) AS TrungL3,
           SUM(Trung4) AS Trung4
      FROM (
               VXL_TongTienPhieu c
               JOIN
               V_Trung_k2 p ON c.ID = p.TinNhanID
           )
           JOIN
           TDM_Khach q ON c.KhachID = q.ID
     GROUP BY c.ID;
''';


const String VBC_TongHopTien= '''
CREATE VIEW VBC_TongHopTien AS
    SELECT c.ID,
           c.KhachID,
           Ngay,
           MaKhach AS Khách,
           Mien AS Miền,
           Xac AS Tổng,
           Trung AS Thưởng,
           (CASE WHEN DauTren = 0 THEN ThuBu ELSE -1 * ThuBu END) AS [Thu/bù]
      FROM (
               VXL_TongTienPhieu c
               LEFT JOIN
               V_Trung_k1 p ON c.ID = p.TinNhanID
           )
           JOIN
           TDM_Khach q ON c.KhachID = q.ID
     GROUP BY c.ID;
''';


const String VBC_TongTienKhach= '''
CREATE VIEW VBC_TongTienKhach AS
    SELECT c.ID,
           KhachID,
           Ngay,
           MaKhach AS Khách,
           SUM(CASE WHEN Mien = 'N' THEN TongTien END) AS Nam,
           SUM(CASE WHEN Mien = 'T' THEN TongTien END) AS Trung,
           SUM(CASE WHEN Mien = 'B' THEN TongTien END) AS Bắc,
           SUM(TongTien) AS [Thu Bù]
      FROM TXL_TinNhan c
           JOIN
           TDM_Khach p ON c.KhachID = p.ID
     GROUP BY KhachID,
              Ngay;

''';

const String VBC_XuongNac= '''
CREATE VIEW VBC_XuongNac AS
    SELECT c.ID,
           c.TinNhanID,
           TinXL,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 2 AND 
                                (MaKieu = 'dd' OR 
                                 MaKieu = 't' OR 
                                 MaKieu = 's') THEN TienXac END), 0) AS xAB,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 2 AND 
                                (MaKieu = 'dd' OR 
                                 MaKieu = 't' OR 
                                 MaKieu = 's') THEN TienVon END), 0) AS vAB,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 2 AND 
                                (MaKieu = 'dd' OR 
                                 MaKieu = 't' OR 
                                 MaKieu = 's') AND 
                                SoLanTrung > 0 THEN SoTien * SoLanTrung END), 0) AS tAB,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 2 AND 
                                (MaKieu = 'dd' OR 
                                 MaKieu = 't' OR 
                                 MaKieu = 's') AND 
                                SoLanTrung > 0 THEN TienTrung END), 0) AS ttAB,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 3 AND 
                                (MaKieu = 'dd' OR 
                                 MaKieu = 't' OR 
                                 MaKieu = 's') THEN TienXac END), 0) AS xXC,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 3 AND 
                                (MaKieu = 'dd' OR 
                                 MaKieu = 't' OR 
                                 MaKieu = 's') THEN TienVon END), 0) AS vXC,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 3 AND 
                                (MaKieu = 'dd' OR 
                                 MaKieu = 't' OR 
                                 MaKieu = 's') AND 
                                SoLanTrung > 0 THEN SoTien * SoLanTrung END), 0) AS tXC,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 3 AND 
                                (MaKieu = 'dd' OR 
                                 MaKieu = 't' OR 
                                 MaKieu = 's') AND 
                                SoLanTrung > 0 THEN TienTrung END), 0) AS ttXC,
           IFNULL(SUM(CASE WHEN MaKieu = 'dt' THEN TienXac END), 0) AS xDt,
           IFNULL(SUM(CASE WHEN MaKieu = 'dt' THEN TienVon END), 0) AS vDt,
           IFNULL(SUM(CASE WHEN MaKieu = 'dt' AND 
                                SoLanTrung > 0 THEN SoTien * SoLanTrung END), 0) AS tDt,
           IFNULL(SUM(CASE WHEN MaKieu = 'dt' AND 
                                SoLanTrung > 0 THEN TienTrung END), 0) AS ttDt,
           IFNULL(SUM(CASE WHEN MaKieu = 'dx' THEN TienXac END), 0) AS xDx,
           IFNULL(SUM(CASE WHEN MaKieu = 'dx' THEN TienVon END), 0) AS vDx,
           IFNULL(SUM(CASE WHEN MaKieu = 'dx' AND 
                                SoLanTrung > 0 THEN SoTien * SoLanTrung END), 0) AS tDx,
           IFNULL(SUM(CASE WHEN MaKieu = 'dx' AND 
                                SoLanTrung > 0 THEN TienTrung END), 0) AS ttDx,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 2 AND 
                                INSTR(MaKieu, 'b') = 1 THEN TienXac END), 0) AS xB2,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 2 AND 
                                INSTR(MaKieu, 'b') = 1 THEN TienVon END), 0) AS vB2,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 2 AND 
                                INSTR(MaKieu, 'b') = 1 AND 
                                SoLanTrung > 0 THEN SoTien * SoLanTrung END), 0) AS tB2,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 2 AND 
                                INSTR(MaKieu, 'b') = 1 AND 
                                SoLanTrung > 0 THEN TienTrung END), 0) AS ttB2,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 3 AND 
                                INSTR(MaKieu, 'b') = 1 THEN TienXac END), 0) AS xB3,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 3 AND 
                                INSTR(MaKieu, 'b') = 1 THEN TienVon END), 0) AS vB3,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 3 AND 
                                INSTR(MaKieu, 'b') = 1 AND 
                                SoLanTrung > 0 THEN SoTien * SoLanTrung END), 0) AS tB3,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 3 AND 
                                INSTR(MaKieu, 'b') = 1 AND 
                                SoLanTrung > 0 THEN TienTrung END), 0) AS ttB3,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 4 THEN TienXac END), 0) AS xB4,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 4 THEN TienVon END), 0) AS vB4,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 4 AND 
                                SoLanTrung > 0 THEN SoTien * SoLanTrung END), 0) AS tB4,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 4 AND 
                                SoLanTrung > 0 THEN TienTrung END), 0) AS ttB4,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 4 AND 
                                (MaKieu = 'dd' OR 
                                 MaKieu = 't' OR 
                                 MaKieu = 's') THEN TienXac END), 0) AS xDD4,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 4 AND 
                                (MaKieu = 'dd' OR 
                                 MaKieu = 't' OR 
                                 MaKieu = 's') THEN TienVon END), 0) AS vDD4,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 4 AND 
                                (MaKieu = 'dd' OR 
                                 MaKieu = 't' OR 
                                 MaKieu = 's') AND 
                                SoLanTrung > 0 THEN SoTien * SoLanTrung END), 0) AS tDD4,
           IFNULL(SUM(CASE WHEN LENGTH(SoDanh) = 4 AND 
                                (MaKieu = 'dd' OR 
                                 MaKieu = 't' OR 
                                 MaKieu = 's') AND 
                                SoLanTrung > 0 THEN TienTrung END), 0) AS ttDD4
      FROM TXL_TinNhanCT c
           JOIN
           TXL_TinPhanTichCT p ON c.ID = p.TinNhanCTID
     GROUP BY c.ID;

''';

const String VBC_XuongNacCT= '''
CREATE VIEW VBC_XuongNacCT AS
    SELECT TinNhanID,
           TinXL,
           ROUND(SUM(xAB + xXC + xDt + xDx + xB2 + xB3 + xB4) ) AS Xác,
           ROUND(SUM(vAB + vXC + vDt + vDx + vB2 + vB3 + vB4) ) AS Vốn,
           ROUND(SUM(xAB + xB2) ) AS [Xác 2s],
           ROUND(SUM(xXC + xB3) ) AS [Xác 3s],
           ROUND(SUM(xB4 + xDD4) ) AS [Xác 4s],
           ROUND(SUM(xDt) ) AS [Xác dt],
           ROUND(SUM(xDx) ) AS [Xác dx],
           ROUND(SUM(xAB + xDt + xDx + xB2) ) AS Xương,
           ROUND(SUM(xXC + xB3 + xB4 + xDD4) ) AS Nạc,
           SUM(tAB + tB2) AS [Trúng 2s],
           SUM(tXC + tB3) AS [Trúng 3s],
           SUM(tDD4 + tB4) AS [Trúng 4s],
           SUM(tdt) AS [Trúng dt],
           SUM(tdx) AS [Trúng dx]
      FROM VBC_XuongNac
     GROUP BY ID;

''';


const String VBC_XuongNacTH= '''
CREATE VIEW VBC_XuongNacTH AS
    SELECT c.ID,
           KhachID,
           Ngay,
           MaKhach,
           Mien,
           TongTien AS [Thu bù],
           ROUND(SUM(xAB + xXC + xDt + xDx + xB2 + xB3 + xB4 + xDD4) ) AS Xác,
           ROUND(SUM(vAB + vXC + vDt + vDx + vB2 + vB3 + vB4 + vDD4) ) AS Vốn,
           ROUND(SUM(xAB + xB2) ) AS [Xác 2s],
           ROUND(SUM(xXC + xB3) ) AS [Xác 3s],
           ROUND(SUM(xB4 + xdd4) ) AS [Xác 4s],
           ROUND(SUM(xDt) ) AS [Xác dt],
           ROUND(SUM(xDx) ) AS [Xác dx],
           ROUND(SUM(xAB + xDt + xDx + xB2) ) AS Xương,
           ROUND(SUM(xXC + xB3 + xB4) ) AS Nạc
      FROM (
               TXL_TinNhan c
               JOIN
               VBC_XuongNac p ON c.ID = p.TinNhanID
           )
           JOIN
           TDM_Khach k ON c.KhachID = k.ID
     GROUP BY c.ID;

''';

const String VDM_GiaKhach = '''
CREATE VIEW VDM_GiaKhach AS
    SELECT c.ID,
           KhachID,
           MaKieu,
           MoTaKieu,
           CoMN,
           ChiaMN,
           TyLeMN,
           TrungMN,
           CoMB,
           ChiaMB,
           TyLeMB,
           TrungMB,
           CoMT,
           ChiaMT,
           TyLeMT,
           TrungMT
      FROM TDM_GiaKhach c
           JOIN
           T01_KieuChoi p ON c.MaKieu = p.Kieu;

''';

const String VDM_GiaKhachMoi= '''
CREATE VIEW VDM_GiaKhachMoi AS
    SELECT ID,
           Nhom,
           Kieu AS MaKieu,
           MoTaKieu,
           (CASE WHEN Kieu IN ('2s', '3s', '4s', 'dt', 'dx', 'dz', 'd4') THEN 70 ELSE (CASE WHEN Kieu IN ('ab', 'xc', 'b2') THEN 12.6 ELSE (CASE WHEN Kieu = 'b3' THEN 11.9 ELSE 11.2 END) END) END) AS CoMN,
           (CASE WHEN Kieu IN ('2s', '3s', '4s', 'dt', 'dx', 'dz', 'd4') THEN 100 ELSE (CASE WHEN Kieu IN ('ab', 'xc', 'b2') THEN 18 ELSE (CASE WHEN Kieu = 'b3' THEN 17 ELSE 16 END) END) END) AS ChiaChoN,
           0.7 AS TyLeMN,
           (CASE WHEN Kieu IN ('2s', 'ab', 'b2') THEN 70 ELSE (CASE WHEN Kieu IN ('3s', 'xc', 'b3', 'da') THEN 600 ELSE (CASE WHEN Kieu IN ('4s', 'b4', 'd4') THEN 5000 ELSE 500 END) END) END) AS TrungMN,
           (CASE WHEN Kieu IN ('2s', '3s', '4s', 'dt', 'dx', 'dz', 'd4') THEN 70 ELSE (CASE WHEN Kieu IN ('ab', 'xc', 'b2') THEN 18.9 ELSE (CASE WHEN Kieu = 'b3' THEN 16.1 ELSE 14 END) END) END) AS CoMB,
           (CASE WHEN Kieu IN ('2s', '3s', '4s', 'dt', 'dx', 'dz', 'd4') THEN 100 ELSE (CASE WHEN Kieu IN ('ab', 'xc', 'b2') THEN 27 ELSE (CASE WHEN Kieu = 'b3' THEN 23 ELSE 20 END) END) END) AS ChiaChoB,
           0.7 AS TyLeMB,
           (CASE WHEN Kieu IN ('2s', 'ab', 'b2') THEN 70 ELSE (CASE WHEN Kieu IN ('3s', 'xc', 'b3', 'da') THEN 600 ELSE (CASE WHEN Kieu IN ('4s', 'b4', 'd4') THEN 5000 ELSE 500 END) END) END) AS TrungMB,
           (CASE WHEN Kieu IN ('2s', '3s', '4s', 'dt', 'dx', 'dz', 'd4') THEN 70 ELSE (CASE WHEN Kieu IN ('ab', 'xc', 'b2') THEN 12.6 ELSE (CASE WHEN Kieu = 'b3' THEN 11.9 ELSE 11.2 END) END) END) AS CoMT,
           (CASE WHEN Kieu IN ('2s', '3s', '4s', 'dt', 'dx', 'dz', 'd4') THEN 100 ELSE (CASE WHEN Kieu IN ('ab', 'xc', 'b2') THEN 18 ELSE (CASE WHEN Kieu = 'b3' THEN 17 ELSE 16 END) END) END) AS ChiaChoT,
           0.7 AS TyLeMT,
           (CASE WHEN Kieu IN ('2s', 'ab', 'b2') THEN 70 ELSE (CASE WHEN Kieu IN ('3s', 'xc', 'b3', 'da') THEN 600 ELSE (CASE WHEN Kieu IN ('4s', 'b4', 'd4') THEN 5000 ELSE 500 END) END) END) AS TrungMT
      FROM T01_KieuChoi;

''';

const String VDM_Khach= '''
CREATE VIEW VDM_Khach AS
    SELECT ID,
           MaKhach,
           TenKhach,
           (CASE WHEN KieuTyLe = 1 THEN 'Kiểu 1-70/100' ELSE 'Kiểu 2-12.6/18' END) AS KieuTyLe,
           HoiTong,
           Hoi2s,
           Hoi3s,
           (CASE WHEN ThuongMN = 1 THEN 'Có' ELSE '' END) AS ThuongMN,
           (CASE WHEN ThuongMT = 1 THEN 'Có' ELSE '' END) AS ThuongMT,
           (CASE WHEN ThuongMB = 1 THEN 'Có' ELSE '' END) AS ThuongMB,
           (CASE WHEN KDauTren = 1 THEN 'Đầu trên' ELSE 'Đầu dưới' END) AS DauTren,
           (CASE WHEN TheoDoi = 1 THEN 'Còn' ELSE 'Nghỉ' END) AS TheoDoi
      FROM TDM_Khach
     ORDER BY MaKhach;

''';


const String VXL_MaDai= '''
CREATE VIEW VXL_MaDai AS
    SELECT c.MaDai,
           MoTa,
           Ngay,
           c.Mien
      FROM TXL_KQXS c
           JOIN
           T01_MaDai p ON c.MaDai = p.MaDai
     GROUP BY Ngay,
              c.MaDai
     ORDER BY c.ID;

''';

const String VXL_TinNhanCT= '''
CREATE VIEW VXL_TinNhanCT AS
    SELECT TXL_TinNhanCT.ID,
           TXL_TinNhanCT.TinNhanID,
           DauSoDT,
           GioGui,
           TinXL,
           SUM(TienXac) AS Xac,
           ROUND(SUM(TienVon) ) AS Von,
           SUM(TienTrung) AS Trung,
           ROUND(SUM(TienVon - TienTrung) ) AS LaiLo,
           NULL AS SoT2s,
           SUM(CASE WHEN LENGTH(SoDanh) = 2 AND 
                         SoLanTrung > 0 THEN SoTien * SoLanTrung END) AS DiemT2s,
           NULL AS SoT3s,
           SUM(CASE WHEN LENGTH(SoDanh) = 3 OR 
                         LENGTH(SoDanh) = 4 AND 
                         SoLanTrung > 0 THEN SoTien * SoLanTrung END) AS DiemT3s,
           NULL AS SoDaTh,
           SUM(CASE WHEN MaKieu = 'dt' AND 
                         LENGTH(SoDanh) = 5 AND 
                         SoLanTrung > 0 THEN SoTien * SoLanTrung END) AS DiemDaTh,
           NULL AS SoDaXi,
           SUM(CASE WHEN MaKieu = 'dx' AND 
                         LENGTH(SoDanh) = 5 AND 
                         SoLanTrung > 0 THEN SoTien * SoLanTrung END) AS DiemDaXi,
           SUM(CASE WHEN LENGTH(SoDanh) = 2 OR 
                         LENGTH(SoDanh) = 5 THEN TienXac END) AS Xac2s,
           SUM(CASE WHEN LENGTH(SoDanh) = 3 OR 
                         LENGTH(SoDanh) = 4 THEN TienXac END) AS Xac3s
      FROM TXL_TinNhanCT
           LEFT JOIN
           TXL_TinPhanTichCT ON TXL_TinNhanCT.ID = TXL_TinPhanTichCT.TinNhanCTID
     GROUP BY TXL_TinNhanCT.ID;

''';


const String VXL_TongTienPhieu= '''
CREATE VIEW VXL_TongTienPhieu AS
    SELECT c.ID,
           Ngay,
           KhachID,
           c.Mien,
           ROUND(SUM(TienXac) ) AS Xac,
           ROUND(SUM(TienVon) ) AS Von,
           SUM(TienTrung) AS Trung,
           ROUND(SUM(TienVon - TienTrung) ) AS LaiLo,
           (CASE WHEN DauTren = 1 THEN -1 * TongTien ELSE TongTien END) AS ThuBu
      FROM (
               TXL_TinNhan c
               LEFT JOIN
               TXL_TinPhanTichCT p ON c.ID = p.MaTin
           )
     GROUP BY c.ID;

''';