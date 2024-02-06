// ignore_for_file: non_constant_identifier_names

class TinNhanPTCTModel {
  int? ID;
  int? TinNhanCTID;
  int? MaTin;
  String MaKieu;
  String MaDai;
  String SoDanh;
  double SoTien;
  dynamic SoLanTrung;
  double TienXac;
  double TienVon;
  double TienTrung;
  int SoDai;

  TinNhanPTCTModel(
      {this.ID,
        this.TinNhanCTID,
        this.MaTin,
        this.MaKieu = "",
        this.MaDai = "",
        this.SoDanh = "",
        this.SoTien = 0,
        this.SoLanTrung = 0,
        this.TienXac = 0,
        this.TienVon = 0,
        this.TienTrung = 0,
        this.SoDai = 0,
        });

  Map<String, dynamic> toMap() {
    return {
      "ID": ID,
      "TinNhanCTID": TinNhanCTID,
      "MaTin": MaTin,
      "MaKieu": MaKieu,
      "MaDai": MaDai,
      "SoDanh": SoDanh,
      "SoTien": SoTien,
      "SoLanTrung": SoLanTrung,
      "TienXac": TienXac,
      "TienVon": TienVon,
      "TienTrung": TienTrung,
      "SoDai": SoDai,
    };
  }
}
