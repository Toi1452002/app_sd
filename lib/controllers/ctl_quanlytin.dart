// ignore_for_file: camel_case_types

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sd_pmn/controllers/ctl_xuly.dart';
import 'package:sd_pmn/function/extension.dart';
import 'package:sd_pmn/models/mdl_ql_tinct.dart';

import '../database/db_connect.dart';

class Ctl_Quanlytin extends GetxController {
  ///Gọi hàm kết nối database
  ConnectDB db = ConnectDB();

  /// -----------------------------------------------------------------------------------------* -
  final Rx<DateTime> _ngaylam = DateTime.now().obs;

  DateTime get ngaylam => _ngaylam.value;

  set ngaylam(DateTime date) => _ngaylam.value = date;

  /// -----------------------------------------------------------------------------------------*

  final RxList<Map<String, dynamic>> _lstKhach = <Map<String, dynamic>>[].obs;

  List<Map<String, dynamic>> get lstKhach => _lstKhach.value;

  /// -----------------------------------------------------------------------------------------*
  final RxList<QliTinCTModel> _lstTinCT = <QliTinCTModel>[].obs;

  List<QliTinCTModel> get lstTinCT => _lstTinCT.value;

  Ctl_Quanlytin get to => Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    onLoadDanhSachTin();
    super.onInit();
  }

  onLoadDanhSachTin() async {
    String strNgay = DateFormat("yyyy-MM-dd").format(_ngaylam.value);
    _lstKhach.value = await db.loadData(sql: '''
      SELECT k.MaKhach ,k.ID , Count(tn.KhachID) sotin
      FROM TXL_TinNhan tn JOIN  TDM_Khach k ON tn.KhachID = k.ID 
      WHERE tn.Ngay = '$strNgay'
      GROUP BY k.MaKhach,k.ID
    ''');
    update();
  }

  onDeleteKhach(int KhachID) async {
    String strNgay = DateFormat("yyyy-MM-dd").format(_ngaylam.value);
    List<Map<String, dynamic>> tin = await db.loadData(
        tbName: 'TXL_TinNhan',
        condition: "KhachID = $KhachID AND Ngay = '$strNgay'");
    List<int> lstMaTin = tin.map((e) => int.parse(e['ID'].toString())).toList();
    if (lstMaTin.isNotEmpty) {
      await db.deleteData(
          tbName: 'TXL_TinNhan',
          condition: "KhachID = $KhachID AND Ngay = '$strNgay'");
      for (int x in lstMaTin) {
        await db.deleteData(
            tbName: 'TXL_TinNhanCT', condition: "TinNhanID = $x");
        await db.deleteData(
            tbName: 'TXL_TinPhanTichCT', condition: "MaTin = $x");
      }
      Get.back();
      EasyLoading.showToast('Xóa thành công');
      onLoadDanhSachTin();
      Ctl_Xuly().to.onLoadTinNhan();
    }
  }

  onLoadTinCT(String ID) async {
    String strNgay = DateFormat("yyyy-MM-dd").format(_ngaylam.value);
    List<Map<String, dynamic>> data = await db.loadData(sql: '''
      SELECT tn.ID, tn.Mien,tn.KhachID, tnct.TinXL, tn.TongTien
      FROM TXL_TinNhan tn Join TXL_TinNhanCT tnct on tn.ID = tnct.TinNhanID
      WHERE tn.KhachID = '$ID'  
      AND tn.Ngay = '$strNgay'
    ''');

    /// -----------------------------------------------------------------------------------------*
    // List<String> lstMien =
    //     data.map((e) => e['Mien'].toString()).toSet().toList();
    // lstMien = sortMien(lstMien);
    /** Sắp xếp lại miên [N, T, B] **/

    /// -----------------------------------------------------------------------------------------*
    // List<Map<String, dynamic>> tmp = [];
    // for (String x in lstMien) {
    //   // tmp.add({'ID': 0, 'Mien': x});
    //   tmp.addAll(data.where((e) => e['Mien'] == x));
    // }


    _lstTinCT.value = data.map((e)=>QliTinCTModel.fromMap(e)).toList();
    update();
  }

  onDeleteTin(int ID, int KhachID) async {
    await db.deleteData(tbName: 'TXL_TinNhan', condition: "ID = $ID");
    await db.deleteData(tbName: 'TXL_TinNhanCT', condition: "TinNhanID = $ID");
    await db.deleteData(tbName: 'TXL_TinPhanTichCT', condition: "MaTin = $ID");

    /// -----------------------------------------------------------------------------------------*
    /// Load lại sau khi xóa
    onLoadDanhSachTin();
    onLoadTinCT(KhachID.toString());
    if (ID == Ctl_Xuly().to.matin) Ctl_Xuly().to.onLoadTinNhan();

    /// Nếu xóa tin đang hiện thì load lại trang tính

    Get.back();
  }

  /// -----------------------------------------------------------------------------------------*
  /// Xem chi tiết tin
  RxList<Map<String, dynamic>> lstXemCT = <Map<String, dynamic>>[].obs;
  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  // List<TableRow> get lstXemCT => _lstXemCT.value;
  Rx<double> _tongST = 0.0.obs;

  String get tongST => NumberFormat('#,###').format(_tongST.value).toString();
  Rx<double> _tongXac = 0.0.obs;

  String get tongXac => NumberFormat('#,###').format(_tongXac.value).toString();
  Rx<double> _tongVon = 0.0.obs;

  String get tongVon => NumberFormat('#,###').format(_tongVon.value).toString();
  Rx<double> _tongTrung = 0.0.obs;

  String get tongTrung =>
      NumberFormat('#,###').format(_tongTrung.value).toString();
  RxString tin = ''.obs;

  xemchitiet(String matin) async {
    _isLoading.value = true;
    clearXemCT();
    String? _tin =
        await db.dLookup('TinXL', 'TXL_TinNhanCT', 'TinNhanID = $matin');

    if (_tin != null) {
      tin.value = _tin;
      List<Map<String, dynamic>> data = await db.loadData(sql: '''
      SELECT MaDai || '.' || SoDanh || '.' || Kieu  as Tin, SoTien, ThanhTien Xac, NhanVe Von, TienTrung, SoLanTrung
      FROM VBC_PtChiTiet_1 WHERE MaTin = $matin
    ''');
      if (data.isNotEmpty) {
        lstXemCT.value = data.map((e) {
          _tongST += e['SoTien'];
          _tongXac += e['Xac'];
          _tongVon += e['Von'];
          _tongTrung += e['TienTrung'];
          return {
            'Tin': e['Tin']
                    .toString()
                    .replaceFirst('thang', 'da')
                    .replaceFirst('xien', 'dx') +
                e['SoTien'].toString().formatDouble,
            'Xac': NumberFormat('#,###').format(e['Xac']).toString(),
            'Von': NumberFormat('#,###').format(e['Von']).toString(),
            'Trung': e['TienTrung'] == 0.0
                ? ''
                : NumberFormat('#,###').format(e['TienTrung']).toString(),
            'SLT': e['SoLanTrung'] == 0.0
                ? ''
                : e['SoLanTrung'].toString().formatDouble,
            // 'i':e['i']??0
          };
        }).toList();
      }
    }

    Future.delayed(const Duration(seconds: 1), () {
      _isLoading.value = false;
      update();
    });
    update();
  }

  clearXemCT() {
    _tongST.value = 0.0;
    _tongXac.value = 0.0;
    _tongVon.value = 0.0;
    _tongTrung.value = 0.0;
    tin.value = '';
    lstXemCT.clear();
  }

  /// -----------------------------------------------------------------------------------------*
}

List<String> sortMien(List sort) {
  List<String> result = [];
  if (sort.contains('N')) result.add('N');
  if (sort.contains('T')) result.add('T');
  if (sort.contains('B')) result.add('B');
  return result;
}
