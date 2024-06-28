// ignore_for_file: non_constant_identifier_names

import 'package:sd_pmn/function/extension.dart';

class KhachModel {
  int? ID;
  String MaKhach;
  // bool TheoDoi;
  int ThuongMN;
  int ThemChiMN;
  int ThuongMT;
  int ThemChiMT;
  int ThuongMB;
  int ThemChiMB;
  int KDauTren;
  double HoiTong;
  double Hoi2s;
  double Hoi3s;
  int KieuTyLe;
  int tkDa;
  int tkAB;
  String SDT;
  bool copy;
  KhachModel({
    this.ID,
    this.MaKhach = "",
    // this.TheoDoi = true,
    this.tkAB = 0,
    this.ThuongMN = 0,
    this.ThemChiMN = 0,
    this.ThuongMT = 0,
    this.ThemChiMT = 0,
    this.ThuongMB = 0,
    this.ThemChiMB = 0,
    this.KDauTren = 0,
    this.KieuTyLe = 1,
    this.tkDa = 1,
    this.HoiTong = 0,
    this.Hoi2s = 0,
    this.copy = false,
    this.SDT = '',
    this.Hoi3s = 0});

  Map<String, dynamic> toMap() {
    return {
      "ID": ID,
      "MaKhach": MaKhach,
      'tkAB':tkAB,
      // "TheoDoi": TheoDoi,
      "KDauTren": KDauTren,
      "ThuongMN": ThuongMN,
      "ThemChiMN": ThemChiMN,
      "ThuongMT": ThuongMT,
      "ThemChiMT": ThemChiMT,
      "ThuongMB": ThuongMB,
      "ThemChiMB": ThemChiMB,
      "HoiTong": HoiTong,
      "Hoi2s": Hoi2s,
      "Hoi3s": Hoi3s,
      "KieuTyLe": KieuTyLe,
      "tkDa": tkDa,
      "SDT":SDT
    };
  }

  factory KhachModel.fromMap(Map<String, dynamic> map)=>
      KhachModel(
          ID: map["ID"],
          MaKhach: map["MaKhach"],
          tkDa: map["tkDa"]??0,
          tkAB: map["tkAB"]??0,
          KieuTyLe: map["KieuTyLe"],
          Hoi2s: map["Hoi2s"],
          Hoi3s: map["Hoi3s"],
          HoiTong: map["HoiTong"],
          ThuongMN: map["ThuongMN"],
          ThemChiMB: map["ThemChiMB"],
          ThemChiMN: map["ThemChiMN"],
          ThemChiMT: map["ThemChiMT"],
          ThuongMB: map["ThuongMB"],
          ThuongMT: map["ThuongMT"],
          SDT: map['SDT']??'',
        KDauTren: map['KDauTren']
      );
}
