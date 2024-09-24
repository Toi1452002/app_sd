// ignore_for_file: camel_case_types

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sd_pmn/function/extension.dart';
import '../database/db_connect.dart';

class Ctl_BaoCaoTongTien extends GetxController {
  ///Gọi hàm kết nối database
  ConnectDB db = ConnectDB();
  Ctl_BaoCaoTongTien get to => Get.find();
  /// -----------------------------------------------------------------------------------------*
  final Rx<DateTime> _tuNgay = DateTime.now().obs;
  String get tuNgayValue => DateFormat("dd/MM/yyyy").format(_tuNgay.value);
  DateTime get tuNgay => _tuNgay.value;
  set tuNgay(DateTime date) => _tuNgay.value = date;

  final Rx<DateTime> _denNgay = DateTime.now().obs;
  String get denNgayValue => DateFormat("dd/MM/yyyy").format(_denNgay.value);
  DateTime get denNgay => _denNgay.value;
  set denNgay(DateTime date) => _denNgay.value = date;
  /// -----------------------------------------------------------------------------------------*

  final RxString _maKhach = "".obs;
  String get maKhach => _maKhach.value;
  set maKhach(String mk) => _maKhach.value = mk;

  final RxList<String> _lstMaKhach = <String>[].obs;
  List<String> get lstMaKhach => _lstMaKhach.value;

  /// -----------------------------------------------------------------------------------------*
  final RxDouble _tongTien = 0.0.obs; String get tongTien => NumberFormat('#,###').format(_tongTien.value).toString();
  final RxDouble _tongN = 0.0.obs; String get tongN => NumberFormat('#,###').format(_tongN.value).toString();
  final RxDouble _tongT = 0.0.obs; String get tongT => NumberFormat('#,###').format(_tongT.value).toString();
  final RxDouble _tongB = 0.0.obs; String get tongB => NumberFormat('#,###').format(_tongB.value).toString();

  /// -----------------------------------------------------------------------------------------*
  final RxList<Map<String, dynamic>> _lstBCLoad = <Map<String,dynamic>>[].obs;
  List<Map<String, dynamic>> get lstBCLoad  => _lstBCLoad.value;

  List<Map<String, dynamic>> lstBaoCao = [];
  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  loadData()async{
    _lstBCLoad.clear();_tongTien.value = 0; _tongN.value=0;_tongT.value = 0;_tongB.value = 0;
    if(_lstMaKhach.isNotEmpty) _maKhach.value = _lstMaKhach.first;
    
    lstBaoCao = await db.loadData(sql: '''
      Select * From VBC_TongTienKhach Where Ngay BETWEEN '${DateFormat('yyyy-MM-dd').format(_tuNgay.value)}' AND '${DateFormat('yyyy-MM-dd').format(_denNgay.value)}' 
      ORDER BY Khách
    ''');

    /** Load lại Table **/
    onChangeData(lstBaoCao);

    /** Load combobox makhach **/
    _lstMaKhach.value = lstBaoCao.map((e) => e['Khách'].toString()).toSet().toList();
    _lstMaKhach.sort((a,b)=>a.compareTo(b));

    if(_lstMaKhach.isNotEmpty)_lstMaKhach.insert(0, 'Tất cả');

  }

  onChangeMaKhach(){
    if(_maKhach.value == 'Tất cả'){
      loadData();
    }else{
      _lstBCLoad.clear();_tongTien.value = 0; _tongN.value=0;_tongT.value = 0;_tongB.value = 0;
      List<Map<String, dynamic>> data = lstBaoCao.where((e) => e['Khách']==_maKhach.value).toList();

      /** Load lại Table **/
      onChangeData(data);
    }
  }

  onChangeData(List<Map<String, dynamic>> data){
    for(var x in data){
      _tongTien.value  += x['Thu Bù']??0;
      _tongN.value +=  x['Nam']??0;
      _tongT.value += x['Trung']??0;
      _tongB.value += x['Bắc']??0;
    }
    /// -----------------------------------------------------------------------------------------*
    /** Chèn ngày vào giữa **/
    List<String> lstNgay = data.map((e) => e['Ngay'].toString()).toSet().toList();
    lstNgay.sort((a,b)=>a.compareTo(b));
    for(String x in lstNgay){
      _lstBCLoad.add({'ID': 'title', 'Ngay': DateFormat("dd/MM/yyyy").format(DateTime.parse(x))});
      _lstBCLoad.addAll(data.where((e) => e['Ngay']==x));
    }
    /// -----------------------------------------------------------------------------------------*
  }
}

class Ctl_BaoCaoTongHop extends GetxController{
  ///Gọi hàm kết nối database
  ConnectDB db = ConnectDB();
  final RxList<Map<String, dynamic>> _lstBaoCao = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get lstBaoCao => _lstBaoCao.value;
  /// -----------------------------------------------------------------------------------------*
  final Rx<DateTime> _ngay = DateTime.now().obs;
  String get ngayValue => DateFormat("dd/MM/yyyy").format(_ngay.value);
  DateTime get ngay => _ngay.value;
  set ngay(DateTime date) => _ngay.value = date;
  /// -----------------------------------------------------------------------------------------*
  final RxString _mien = ''.obs;
  String get mien => _mien.value;
  set mien(String m) => _mien.value = m;
  /// -----------------------------------------------------------------------------------------*
  final RxList<String> _lstMaKhach = <String>[].obs;
  List<String> get lstMaKhach => _lstMaKhach.value;

  final RxString _maKhach = ''.obs;
  String get maKhach => _maKhach.value;
  set maKhach(String mk) => _maKhach.value = mk;
  /// -----------------------------------------------------------------------------------------*
  final RxDouble _tongXac = 0.0.obs; String get tongXac => NumberFormat('#,###').format(_tongXac.value).toString();
  final RxDouble _tongVon = 0.0.obs; String get tongVon => NumberFormat('#,###').format(_tongVon.value).toString();
  final RxDouble _tongTrung = 0.0.obs; String get tongTrung => NumberFormat('#,###').format(_tongTrung.value).toString();
  final RxDouble _tongTien = 0.0.obs; String get tongTien => NumberFormat('#,###').format(_tongTien.value).toString();
  final RxDouble _tongXac2 = 0.0.obs; String get tongXac2 => NumberFormat('#,###').format(_tongXac2.value).toString();
  final RxDouble _tongXac3 = 0.0.obs; String get tongXac3 => NumberFormat('#,###').format(_tongXac3.value).toString();
  final RxDouble _tongTrung2s = 0.0.obs; String get tongTrung2s => _tongTrung2s.value.toString().formatDouble;
  final RxDouble _tongTrung3s = 0.0.obs; String get tongTrung3s => _tongTrung3s.value.toString().formatDouble;
  final RxDouble _tongTrung4s = 0.0.obs; String get tongTrung4s => _tongTrung4s.value.toString().formatDouble;
  final RxDouble _tongTrungDt = 0.0.obs; String get tongTrungDt => _tongTrungDt.value.toString().formatDouble;
  final RxDouble _tongTrungDx = 0.0.obs; String get tongTrungDx => _tongTrungDx.value.toString().formatDouble;

  /// -----------------------------------------------------------------------------------------*
  Ctl_BaoCaoTongHop get to => Get.find();
  List<Map<String, dynamic>> baocao = [];
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    onLoadBaoCao();
  }
  Map<String, String> dieuKien = {
    'Khach':'',
    'Mien': ''
  };
  onLoadBaoCao()async {
    dieuKien = {
      'Khach':'',
      'Mien': ''
    };
    baocao = await db.loadData(sql: '''
      SELECT Khách Khach, Ngay, Miền Mien,Sum([Tiền xác]) Xac,Sum([Tiền vốn]) Von,Sum([Tiền trúng]) Trung,Sum([Đầu dưới]) thubu,
      Sum([Xác 2s]) Xac2s,Sum([Xác 3s]) Xac3s,Sum([Trung2s]) Trung2s,Sum([Trung3s]) Trung3s,Sum([Trung4s]) Trung4s,Sum([TrungDt]) TrungDt,Sum([TrungDx]) TrungDx,
      Case Miền When 'N' Then 1 
      When 'T' Then 2
      ELSE 3 END ttMien
      FROM VBC_TongHop_k1 
      WHERE Ngay = '${DateFormat('yyyy-MM-dd').format(_ngay.value)}'
      Group by Khách, Ngay, Miền
    ''');

    onChangeData(baocao);
    /** Load combobox makhach **/
    _lstMaKhach.value = baocao.map((e) => e['Khach'].toString()).toSet().toList();
    _lstMaKhach.sort((a,b)=>a.compareTo(b));
    /// -----------------------------------------------------------------------------------------*
    _mien.value = '';
    _maKhach.value = '';
  }

  /// kieu = ['Khach','Mien']
  onFilter(String kieu,String value){ /** Lọc Khách, Miền **/
    dieuKien[kieu] = value;
    List<Map<String, dynamic>> data = baocao;
    dieuKien.forEach((key, value) {
      if(value!=''){
        data = data.where((e) => e[key] == value).toList();
      }
    });
    onChangeData(data);
  }

  onChangeData(List<Map<String, dynamic>> data){
    _tongXac.value = 0;_tongVon.value=0;_tongTrung.value=0;_tongTien.value = 0;_lstBaoCao.clear();
    _tongXac2.value = 0;_tongXac3.value = 0;_tongTrung2s.value = 0;_tongTrung3s.value = 0;
    _tongTrung4s.value = 0;_tongTrungDt.value = 0;_tongTrungDx.value = 0;

    List<String> lstMakhach = data.map((e) => e['Khach'].toString()).toSet().toList();
    lstMakhach.sort((a,b)=>a.compareTo(b));
    for(String x in lstMakhach){
      _lstBaoCao.add({'Khach': x,'ttMien':0});

      List<Map<String, dynamic>> dataKhach = data.where((e) => e['Khach']==x).toList();
      dataKhach.sort((a,b)=>a['ttMien'].compareTo(b['ttMien']));/** Sắp xếp lại miền [N,T,B] **/

      dataKhach = dataKhach.map((e) =>{
        'Khach': e['Khach'],
        'Ngay' : DateFormat('dd/MM/yyyy').format(DateTime.parse(e['Ngay'])),
        'Mien': e['Mien'],
        'Xac': NumberFormat('#,###').format(e['Xac']??0).toString(),
        'Von': NumberFormat('#,###').format(e['Von']??0).toString(),
        'Trung':e['Trung']==0.0?'': NumberFormat('#,###').format(e['Trung']??0).toString(),
        'thubu': NumberFormat('#,###').format(e['thubu']??0).toString(),
        'Xac2s':e['Xac2s']==null ? '' : NumberFormat('#,###').format(e['Xac2s']).toString(),
        'Xac3s':e['Xac3s']==null ? '': NumberFormat('#,###').format(e['Xac3s']).toString(),
        'Trung2s':e['Trung2s']==null ? '0': e['Trung2s'].toString().formatDouble,
        'Trung3s':e['Trung3s']==null ? '0': e['Trung3s'].toString().formatDouble,
        'Trung4s':e['Trung4s']==null ? '0': e['Trung4s'].toString().formatDouble,
        'TrungDt':e['TrungDt']==null ? '0': e['TrungDt'].toString().formatDouble,
        'TrungDx':e['TrungDx']==null ? '0': e['TrungDx'].toString().formatDouble,
      }).toList();
      _lstBaoCao.addAll(dataKhach);
    }
    /// -----------------------------------------------------------------------------------------*
    /// Tính tổng
    for(var x in data){
      _tongXac.value += x['Xac']??0;
      _tongVon.value += x['Von']??0;
      _tongTrung.value += x['Trung']??0;
      _tongTien.value += x['thubu']??0;
      _tongXac2.value += x['Xac2s']??0;
      _tongXac3.value += x['Xac3s']??0;
      _tongTrung2s.value += x['Trung2s']??0;
      _tongTrung3s.value += x['Trung3s']??0;
      _tongTrung4s.value += x['Trung4s']??0;
      _tongTrungDt.value += x['TrungDt']??0;
      _tongTrungDx.value += x['TrungDx']??0;

    }

  }
}

class Ctl_BaoCaoChiTiet extends GetxController{
  ///Gọi hàm kết nối database
  ConnectDB db = ConnectDB();
  final RxString _kieuBC = "Báo cáo 1".obs;
  String get kieuBC => _kieuBC.value; set kieuBC(String value)=> _kieuBC.value = value;

  Ctl_BaoCaoChiTiet get to => Get.find();
  String tenKhach = '';
  String Mien = '';
  RxList<Map<String, dynamic>> dataLoad1 = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> dataLoad2 = <Map<String, dynamic>>[].obs;

  onLoadBCCT(DateTime ngay, String khach, String mien)async{
    tenKhach = khach;
    Mien = mien;
    EasyLoading.show(status: 'Loading...');
    String strNgay = DateFormat('yyyy-MM-dd').format(ngay);
    int KhachID = await db.dLookup('ID', 'TDM_Khach', "MaKhach = '$khach'");
    
    List<Map<String, dynamic>> data = await db.loadData(sql: '''
      SELECT tn.ID,tn.KhachID,tn.TongTien as tongtien, bc.*,
      ctd.[Điểm AB],ctd.[Tiền AB],ctd.[Điểm XC],ctd.[Tiền XC],ctd.[Điểm Dt],ctd.[Tiền Dt],ctd.[Điểm Dx],ctd.[Tiền Dx]
      ,ctd.[Điểm lô 2],ctd.[Tiền lô 2],ctd.[Điểm lô 3],ctd.[Tiền lô 3],ctd.[Điểm lô 4],ctd.[Tiền lô 4]
      From TXL_TinNhan tn Left Join VBC_ChiTiet_k1 bc on tn.ID = bc.TinNhanID 
      left Join VBC_ChiTiet_diem ctd on  tn.ID = ctd.TinNhanID
      WHERE tn.Ngay ='$strNgay' AND KhachID = $KhachID AND Mien = '$mien'
    ''');
    dataLoad1.value = data.map((e) => {
      'TinXL': e['TinXL'],
      'Xac': NumberFormat('#,###').format(e['Xac']??0),
      'Von': NumberFormat('#,###').format(e['Von']??0),
      'Trung': NumberFormat('#,###').format(e['Trung']??0),
      'LaiLo': NumberFormat('#,###').format(e['tongtien']??0),
      'SoTrung2s':e['SoTrung2s'] ?? '',
      'DiemTrung2s':e['DiemTrung2s']==null ? '' :  e['DiemTrung2s'].toString().formatDouble,
      'TienTrung2s':e['TienTrung2s']==null ? '' :  NumberFormat('#,###').format(e['TienTrung2s']),
      'SoTrung3s':e['SoTrung3s']??'',
      'DiemTrung3s':e['DiemTrung3s']==null ? '' :  e['DiemTrung3s'].toString().formatDouble,
      'TienTrung3s':e['TienTrung3s']==null ? '' :  NumberFormat('#,###').format(e['TienTrung3s']),
      'SoTrung4s':e['SoTrung4s']??'',
      'DiemTrung4s':e['DiemTrung4s']==null ? '' :  e['DiemTrung4s'].toString().formatDouble,
      'TienTrung4s':e['TienTrung4s']==null ? '' :  NumberFormat('#,###').format(e['TienTrung4s']),
      'SoTrungDt':e['SoTrungDt']??'',
      'DiemTrungDt':e['DiemTrungDt']==null ? '' :  e['DiemTrungDt'].toString().formatDouble,
      'TienTrungDt':e['TienTrungDt']==null ? '' :  NumberFormat('#,###').format(e['TienTrungDt']),
      'SoTrungDx':e['SoTrungDx']??'',
      'DiemTrungDx':e['DiemTrungDa']==null ? '' :  e['DiemTrungDa'].toString().formatDouble,
      'TienTrungDx':e['TienTrungDa']==null ? '' :  NumberFormat('#,###').format(e['TienTrungDa']),
      'DiemAB':e['Điểm AB']==null ? '' :  e['Điểm AB'].toString().formatDouble,
      'TienAB':e['Tiền AB']==null ? '' :  NumberFormat('#,###').format(e['Tiền AB']),
      'DiemXC':e['Điểm XC']==null ? '' :  e['Điểm XC'].toString().formatDouble,
      'TienXC':e['Tiền XC']==null ? '' :  NumberFormat('#,###').format(e['Tiền XC']),
      'DiemDt':e['Điểm Dt']==null ? '' :  e['Điểm Dt'].toString().formatDouble,
      'TienDt':e['Tiền Dt']==null ? '' :  NumberFormat('#,###').format(e['Tiền Dt']),
      'DiemDx':e['Điểm Dx']==null ? '' :  e['Điểm Dx'].toString().formatDouble,
      'TienDx':e['Tiền Dx']==null ? '' :  NumberFormat('#,###').format(e['Tiền Dx']),
      'Diemlo2':e['Điểm lô 2']==null ? '' :  e['Điểm lô 2'].toString().formatDouble,
      'Tienlo2':e['Tiền lô 2']==null ? '' :  NumberFormat('#,###').format(e['Tiền lô 2']),
      'Diemlo3':e['Điểm lô 3']==null ? '' :  e['Điểm lô 3'].toString().formatDouble,
      'Tienlo3':e['Tiền lô 3']==null ? '' :  NumberFormat('#,###').format(e['Tiền lô 3']),
      'Diemlo4':e['Điểm lô 4']==null ? '' :  e['Điểm lô 4'].toString().formatDouble,
      'Tienlo4':e['Tiền lô 4']==null ? '' :  NumberFormat('#,###').format(e['Tiền lô 4']),
    }).toList();
    EasyLoading.dismiss();
  }
}



