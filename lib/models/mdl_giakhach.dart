// ignore_for_file: non_constant_identifier_names

class GiaKhachModel {
  int? ID;
  int? KhachID;
  String MaKieu;
  double CoMN;
  double ChiaMN;
  double TyLeMN;
  double TrungMN;
  double CoMT;
  double ChiaMT;
  double TyLeMT;
  double TrungMT;
  double CoMB;
  double ChiaMB;
  double TyLeMB;
  double TrungMB;

  GiaKhachModel({
    this.ID,
    this.KhachID,
    this.MaKieu = '',
    this.CoMN = 0,
    this.TrungMN = 0,
    this.ChiaMN = 100,
    this.TyLeMN = 0,
    this.CoMT = 0,
    this.TrungMT = 0,
    this.ChiaMT = 100,
    this.TyLeMT = 0,
    this.CoMB = 0,
    this.TrungMB = 0,
    this.ChiaMB = 100,
    this.TyLeMB = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': ID,
      'KhachID': KhachID,
      'MaKieu': MaKieu,
      'CoMN': CoMN,
      'TrungMN': TrungMN,
      'ChiaMN': ChiaMN == 0 ? 100 : ChiaMN,
      'TyLeMN': CoMN / ChiaMN ,
      'CoMT': CoMT,
      'TrungMT': TrungMT,
      'ChiaMT': ChiaMT == 0 ? 100 : ChiaMT,
      'TyLeMT':   CoMT / ChiaMT ,
      'CoMB': CoMB,
      'TrungMB': TrungMB,
      'ChiaMB': ChiaMB == 0 ? 100 : ChiaMB,
      'TyLeMB':  CoMB / ChiaMB ,
    };
  }

  factory GiaKhachModel.fromMap(Map<String, dynamic> map) {
    return GiaKhachModel(
        ID: map["ID"],
        KhachID: map["KhachID"],
        MaKieu: map["MaKieu"],
        CoMN: map["CoMN"],
        TrungMN: map["TrungMN"],
        TyLeMN: map["TyLeMN"],
        CoMT: map["CoMT"],
        TrungMT: map["TrungMT"],
        TyLeMT: map["TyLeMT"],
        CoMB: map["CoMB"],
        TrungMB: map["TrungMB"],
        TyLeMB: map["TyLeMB"]
    );
  }
}
