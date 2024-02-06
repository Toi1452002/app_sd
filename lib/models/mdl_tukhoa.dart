// ignore_for_file: non_constant_identifier_names

import 'package:sd_pmn/function/extension.dart';

class TuKhoaModel {
  int? ID;
  String CumTu;
  String ThayThe;
  bool SoDanhHang;

  TuKhoaModel(
      {this.ID, this.CumTu = "", this.ThayThe = "", this.SoDanhHang = false});

  Map<String, dynamic> toMap() {
    return {
      "ID": ID,
      "CumTu": CumTu,
      "ThayThe": ThayThe,
      "SoDanhHang": SoDanhHang ? 1 : 0
    };
  }

  factory TuKhoaModel.fromMap(Map<String, dynamic> map){
    return TuKhoaModel(
      ID: map['ID'],
      ThayThe: map['ThayThe'],
      CumTu: map['CumTu'],
      SoDanhHang: map['SoDanhHang'].toString().toBool
    );
  }



}
