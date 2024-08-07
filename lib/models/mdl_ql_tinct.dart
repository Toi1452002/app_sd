class QliTinCTModel{
  int? ID;
  String Mien;
  int? KhachID;
  String TinXL;
  double? TongTien;

  QliTinCTModel({
    this.ID,
    required this.Mien,
    this.KhachID,
    required this.TinXL,
    required this.TongTien,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'ID': this.ID,
  //     'Mien': this.Mien,
  //     'KhachID': this.KhachID,
  //     'TinXL': this.TinXL,
  //     'TongTien': this.TongTien,
  //   };
  // }

  factory QliTinCTModel.fromMap(Map<String, dynamic> map) {
    return QliTinCTModel(
      ID: map['ID'],
      Mien: map['Mien'] ,
      KhachID: map['KhachID']??0,
      TinXL: map['TinXL']??'',
      TongTien: map['TongTien'],
    );
  }
}