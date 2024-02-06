// ignore_for_file: non_constant_identifier_names

class KqxsModel {
  int? ID;
  final String Ngay;
  final String Mien;
  final String MaDai;
  final String MaGiai;
  final int TT;
  final String KqSo;
  final String MoTa;
  KqxsModel(
      {this.ID,
        this.Ngay = "",
        this.Mien = "",
        this.MaDai = "",
        this.MaGiai = "",
        this.TT = 0,
        this.MoTa = "",
        this.KqSo = ""});

  Map<String, dynamic> toMap() {
    return {
      "ID": ID,
      "Ngay": Ngay,
      "Mien": Mien,
      "MaDai": MaDai,
      "MaGiai": MaGiai,
      "TT": TT,
      "KQso": KqSo
    };
  }

  factory KqxsModel.fromMap(Map<String, dynamic> map){
    return KqxsModel(
      ID: map["ID"],
      Ngay: map["Ngay"],
      Mien: map["Mien"],
      KqSo: map["KQso"],
      MaDai: map["MaDai"],
      MaGiai: map["MaGiai"],
      TT: int.parse(map["TT"].toString()),
      MoTa: map["MoTa"]
    );
  }
}
