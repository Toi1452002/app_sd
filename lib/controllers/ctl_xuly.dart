// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sd_pmn/config/server.dart';
import 'package:sd_pmn/controllers/clt_kqxs.dart';
import 'package:sd_pmn/controllers/ctl_khach.dart';
import 'package:sd_pmn/controllers/ctl_quanlytin.dart';
import 'package:sd_pmn/database/db_connect.dart';
import 'package:flutter/material.dart';
import 'package:sd_pmn/function/md_kiemloi.dart';
import 'package:sd_pmn/function/md_tinhtoan.dart';
import 'package:sd_pmn/function/md_xuly.dart';
import 'package:sd_pmn/models/mdl_giakhach.dart';
import 'package:sd_pmn/models/mdl_khach.dart';
import 'package:sd_pmn/models/mdl_tinnhan_ptct.dart';
import 'package:sd_pmn/config/router.dart';
import 'package:sd_pmn/widgets/wgt_err_controller.dart';
import '../function/extension.dart';
import 'package:permission_handler/permission_handler.dart';

class Ctl_Xuly extends GetxController{
  ///Gọi hàm kết nối database
  ConnectDB db = ConnectDB();
  /// -----------------------------------------------------------------------------------------*
  final Rx<DateTime> _ngaylam = DateTime.now().obs;
  DateTime get ngaylam => _ngaylam.value;
  set ngaylam(DateTime date) => _ngaylam.value = date;
  /// -----------------------------------------------------------------------------------------*
  final Rx<String> _maKhach = "".obs;
  String get maKhach => _maKhach.value;
  set maKhach(String mk) => _maKhach.value = mk;
  /// -----------------------------------------------------------------------------------------*
  final Rx<String> _mien = "Nam".obs;
  String get mien => _mien.value;
  set mien(String m) => _mien.value = m;
  /// -----------------------------------------------------------------------------------------*
  final Rx<int> _matin = 0.obs;
  int get matin => _matin.value;
  /// -----------------------------------------------------------------------------------------*
  final Rx<TextEditingController> _tinController = ErrorController().obs;
  TextEditingController get tinController => _tinController.value;
  final RxString _txtErr = "".obs;
  String get txtErr => _txtErr.value;
  final RxBool _enableText = true.obs;
  bool get enableText => _enableText.value;
  /// -----------------------------------------------------------------------------------------*
  final RxBool _bUpdate = false.obs;
  bool get bUpdate => _bUpdate.value;

  final RxBool _bDaTinh = false.obs;
  bool get bDaTinh => _bDaTinh.value;

  /// -----------------------------------------------------------------------------------------*
  ///
  /// Tính toán *
  final RxBool _enableTinhToan = false.obs; /// ? Cho phép tính toán : Không cho
  bool get enableTinhToan => _enableTinhToan.value;
  /// -----------------------------------------------------------------------------------------*
  final RxDouble _tienXac = 0.0.obs;
  String get tienXac => NumberFormat('#,###').format(_tienXac.value).toString();

  final RxDouble _tienVon = 0.0.obs;
  String get tienVon => NumberFormat('#,###').format(_tienVon.value).toString();

  final RxDouble _tienTrung = 0.0.obs;
  String get tienTrung => NumberFormat('#,###').format(_tienTrung.value).toString();

  final RxDouble _thuBu = 0.0.obs;
  String get thuBu => NumberFormat('#,###').format(_thuBu.value).toString();
  /// -----------------------------------------------------------------------------------------*


  Ctl_Xuly get to => Get.find();
  @override
  onInit(){
    super.onInit();
    onLoadTinNhan();
  }

  onKiemLoi() async{
    if(_tinController.value.text.isEmpty) { EasyLoading.showInfo("Chưa có tin!"); return; }
    EasyLoading.show(status: 'Đang xử lý',dismissOnTap: false,maskType: EasyLoadingMaskType.black);

    try {
      /** Xử lý tin **/
      String tin = _tinController.value.text;
      tin = await hamXL(tin, _ngaylam.value, _mien.value[0]);
      tin = await hamXL(tin, _ngaylam.value, _mien.value[0]);
      /// -----------------------------------------------------------------------------------------*
      /** Kiểm lỗi **/
      bool bKiemLoi = await md_KiemLoi(MaTin: _matin.value,
          tin: tin, ngay: DateFormat("yyyy-MM-dd").format(_ngaylam.value),
          mien: _mien.value[0]);
      if(bKiemLoi)/// Có lỗi
      {
        List<String> lstTin = tin.split('.');
        int i = 0;
        for(String x in lstTin){
          if(gl_list_index_loi.contains(i)){
            lstTin[i] = ' $x';
          }
          i+=1;
        }
        tin = lstTin.join('.');
        _txtErr.value = gl_loitin;
        _enableTinhToan.value= false;
      }else{
        _txtErr.value = '';
        _enableTinhToan.value = true; /// Cho phép tính toán
      }



      /** Update tinXL **/
      await db.updateCell(tbName: 'TXL_TinNhanCT',field: 'TinXL',condition: "TinNhanID = ${_matin.value}",value: tin);
      EasyLoading.dismiss();
      // print(GetStorage().read('bDoiDauCach'));
      _tinController.value.text = GetStorage().read('bDoiDauCach')??false ? tin.replaceAll('.', ' ') : tin;
    }catch(e){
      EasyLoading.showInfo(e.toString());
    }

    update();
  }

  onLoadTinNhan()async{
    _bUpdate.value = false;
    _enableTinhToan.value = false;
    clear();
    List<Map<String, dynamic>> data = await db.loadData(sql: '''
      SELECT  tn.ID,tn.Ngay, tn.KhachID, tn.Mien,tn.DaTinh, k.MaKhach, tnct.TinXL
      From (TXL_TinNhan tn Left join TDM_Khach k on  tn.KhachID = k.ID) 
      Left join TXL_TinNhanCT tnct on tn.ID = tnct.TinNhanID
      Order by tn.ID desc
      Limit 1
    ''');

    if(data.isNotEmpty){
      _ngaylam.value = DateTime.parse(data[0]['Ngay'].toString());
      _mien.value = replaceMien(data[0]['Mien']);
      _maKhach.value = data[0]['MaKhach'];
      _matin.value = data[0]['ID'];
      if(GetStorage().read('bDoiDauCach')??false){
        _tinController.value.text = data[0]['TinXL'] == null  ? "" : data[0]['TinXL'].replaceAll('.', ' ');
      }else{
        _tinController.value.text = data[0]['TinXL'] ?? '';
      }
      _bDaTinh.value =data[0]['DaTinh'] == null ? false : data[0]['DaTinh'].toString().toBool;
      _enableText.value = true;

      /** Load tiền phiếu **/
      List<Map<String, dynamic>> tienphieu = await db.loadData(tbName: 'VXL_TongTienPhieu',condition: "ID = ${_matin.value}");
      if(tienphieu.isNotEmpty){
        _tienXac.value = tienphieu[0]['Xac']??0;
        _tienVon.value = tienphieu[0]['Von']??0;
        _tienTrung.value = tienphieu[0]['Trung']??0;
        _thuBu.value = tienphieu[0]['ThuBu']??0;

      }
    }else{
      _matin.value = 0;
      _maKhach.value = '';
      _enableText.value = false;
      _tinController.value.clear();
      _enableTinhToan.value = false;
    }
    Ctl_Quanlytin().to.onLoadDanhSachTin();
    update();
  }


  /// kieu ['ngay','makhach','mien','DaTinh']
  onChange(dynamic value, {String kieu = ''}) async{

    assert(['ngay','makhach','mien','DaTinh'].contains(kieu));

    _enableTinhToan.value = false;
    switch(kieu){
      case 'ngay':
        String strNgay = DateFormat("yyyy-MM-dd").format(_ngaylam.value);
        await db.updateCell(tbName: 'TXL_TinNhan',field: 'Ngay',value: strNgay,condition: "ID = '${_matin.value}'");
        break;
      case 'makhach':
        int KhachID = await db.dLookup('ID', 'TDM_Khach', "MaKhach = '$value'");
        await db.updateCell(tbName: 'TXL_TinNhan',field: 'KhachID',value: KhachID,condition: "ID = '${_matin.value}'");
        break;
      case 'mien':
        await db.updateCell(tbName: 'TXL_TinNhan',field: 'Mien',value: value[0],condition: "ID = '${_matin.value}'");
        break;
      case 'DaTinh':
        _bDaTinh.value = value;
        await db.updateCell(tbName: 'TXL_TinNhan',field: 'DaTinh',value: value ? 1 : 0,condition: 'ID = ${_matin.value}');
        break;
    }
    /// -----------------------------------------------------------------------------------------*
    /** Load lại danh sách tin **/
    Ctl_Quanlytin().to.onLoadDanhSachTin();
    /// -----------------------------------------------------------------------------------------*
  }

  onThemTin() async{
    String strNgay = DateFormat("yyyy-MM-dd").format(_ngaylam.value);
    if(Ctl_Khach().to.lstKhach.isEmpty){ EasyLoading.showInfo("Không có khách"); return;} /// Chưa có khách
    if(Ctl_Khach().to.lstKhach.isNotEmpty && _maKhach.value == "") _maKhach.value = Ctl_Khach().to.lstKhach.first.MaKhach;
    int KhachID = await db.dLookup('ID', 'TDM_Khach', "MaKhach = '${_maKhach.value}'");

    int MaTin = await db.insertRow(map: {'ID': null, 'Ngay': strNgay,'Mien': _mien.value[0], 'KhachID' : KhachID, 'DauTren' : 0}, tbName: 'TXL_TinNhan');
    if(MaTin!=0){
      _matin.value = MaTin;
      await db.insertRow(map: {'ID': null, 'TinNhanID': MaTin}, tbName: 'TXL_TinNhanCT');
    }
    /// -----------------------------------------------------------------------------------------*
    /** Load lại danh sách tin **/
    Ctl_Quanlytin().to.onLoadDanhSachTin();
    clear();
    _enableTinhToan.value = false;
    _enableText.value = true;
    /// -----------------------------------------------------------------------------------------*
    update();
  }


  ///Thay đổi textfield
  onUpdateTin(String value) async {
    _txtErr.value = '';
    _enableTinhToan.value = false;
    update();
    await db.updateCell(tbName: 'TXL_TinNhanCT',field: 'TinXL',condition: "TinNhanID = ${_matin.value}",value: value);
  }


  ///Sửa tin
  onEditTin({int ID = 0,int khachID = 0, String mien = '', required DateTime ngay,String tin = ''})async{
    if(ID!=0){
      _bDaTinh.value = false;
      _bUpdate.value = true;
      String maKhach = await db.dLookup('MaKhach', 'TDM_Khach', 'ID = $khachID');
      _maKhach.value = maKhach;
      _matin.value = ID;
      _mien.value = replaceMien(mien);
      _ngaylam.value = ngay;
      _tinController.value.text = GetStorage().read('bDoiDauCach')??false ? tin.replaceAll('.', ' ') : tin;
      /** Load tiền phiếu **/
      List<Map<String, dynamic>> tienphieu = await db.loadData(tbName: 'VXL_TongTienPhieu',condition: "ID = ${_matin.value}");
      if(tienphieu.isNotEmpty){
        _tienXac.value = tienphieu[0]['Xac']??0;
        _tienVon.value = tienphieu[0]['Von']??0;
        _tienTrung.value = tienphieu[0]['Trung']??0;
        _thuBu.value = tienphieu[0]['ThuBu']??0;
      }
    }
    _txtErr.value = '';
    _enableTinhToan.value = false;
    update();
  }


  onTinhToan() async { /** Button tính toán **/
    _enableTinhToan.value = false;

    String strNgay = DateFormat("yyyy-MM-dd").format(_ngaylam.value);
    List<Map<String,dynamic>> kqxs = await db.loadData(tbName: 'TXL_KQXS',condition: "Ngay = '$strNgay' AND Mien = '${_mien.value[0]}'");

    if(kqxs.isEmpty){ /** Chưa có kqxs **/
      Get.lazyPut(() => Ctl_Kqxs());
      Ctl_Kqxs().to.ngaylam = _ngaylam.value;
      Ctl_Kqxs().to.mien = _mien.value[0];
      await Ctl_Kqxs().to.onGetKqxs();
      kqxs = await db.loadData(tbName: 'TXL_KQXS',condition: "Ngay = '$strNgay' AND Mien = '${_mien.value[0]}'");
      Ctl_Kqxs().onClose();
    }

    if(Info_App.soNgayHetHan<1) {EasyLoading.showInfo('App đã hết hạn');return;}

    EasyLoading.show(status: "Đang tính toán...",dismissOnTap: false,maskType: EasyLoadingMaskType.black);
    MD_TinhToan tinhtoan = MD_TinhToan();

    try {
      tinhtoan.Ngay = strNgay;
      tinhtoan.Mien = _mien.value[0];
      int KhachID = await db.dLookup('ID', 'TDM_Khach', "MaKhach = '${_maKhach.value}'");
      Map<String, dynamic> k = await db.loadRow(tblName: 'TDM_Khach',Condition: "ID = $KhachID");
      List<Map<String, dynamic>> gk = await db.loadData(tbName: 'TDM_GiaKhach',condition: "KhachID = $KhachID");
      int TinCTID = await db.dLookup('ID', 'TXL_TinNhanCT', "TinNhanID = '${_matin.value}'");
      tinhtoan.khach = KhachModel.fromMap(k);
      tinhtoan.giaKhach = gk.map((e) => GiaKhachModel.fromMap(e)).toList();
      tinhtoan.TinCTID = TinCTID;
      tinhtoan.MaTin = _matin.value;
      String tin = GetStorage().read('bDoiDauCach')??false ? _tinController.value.text.replaceAll(' ', '.') : _tinController.value.text;
      String tinChuyen = await tinhtoan.chuyenTin(tin);
      /** Xóa TinPTCT cũ **/
      await db.deleteData(tbName: 'TXL_TinPhanTichCT', condition: "TinNhanCTID = '$TinCTID'");
      /// -----------------------------------------------------------------------------------------*

      List<TinNhanPTCTModel>  data =  await tinhtoan.phantich_ChuoiTin(tinChuyen).whenComplete(() async {
        _tienVon.value = tinhtoan.fvon;
        _tienXac.value = tinhtoan.fxac;
        _tienTrung.value = tinhtoan.ftrung;
        EasyLoading.dismiss();
      });
      await db.insertList(lstData: data.map((e) => e.toMap()).toList(), tbName: 'TXL_TinPhanTichCT',fieldToString: 'SoDanh').whenComplete((){
        capnhat_ThuBu();
      });
    }
    catch(e){
      throw Exception(e);
      EasyLoading.showInfo('Có lỗi khi tính toán');
    }
    if(kqxs.isEmpty)EasyLoading.showToast('Chưa có kết quả xổ số!', toastPosition: EasyLoadingToastPosition.center);

  }

  onEditMaKhach() async{
    Map<String,dynamic> data = await db.loadRow(tblName: 'TDM_Khach', Condition: "MaKhach = '${_maKhach.value}'");
    if(data.isNotEmpty){
      KhachModel k = KhachModel.fromMap(data);
      Ctl_Khach().to.onEdit(k,editXL: false);
      Get.toNamed(routerName.v_themkhach);
    }else{
      EasyLoading.showToast('Error', toastPosition: EasyLoadingToastPosition.center);
    }
  }

  capnhat_ThuBu()async{
    var laiLo = await db.dLookup('LaiLo', 'VXL_TinNhanCT', "TinNhanID = ${_matin.value}");
    var hoiTong = await db.dLookup('HoiTong', 'TDM_Khach', "MaKhach = '${_maKhach.value}'");
    var KDauTren = await db.dLookup('KDauTren', 'TDM_Khach', "MaKhach = '${_maKhach.value}'");
    if(hoiTong>0){
      if(laiLo>0) laiLo = laiLo*(100-hoiTong)/100;
    }else{
      var hoi2s = await db.dLookup('Hoi2s', 'TDM_Khach', "MaKhach = '${_maKhach.value}'");
      if(hoi2s>0){
        var lai2S = await db.dSum("tienvon-tientrung", "TXL_TinPhanTichCT", "MaTin = ${_matin.value} AND length(SoDanh) in (2,5)");
        if(lai2S!=null && lai2S>0   ) laiLo-=(lai2S*hoi2s)/100;
      }
      var hoi3s = await db.dLookup('Hoi3s', 'TDM_Khach', "MaKhach = '${_maKhach.value}'");
      if(hoi3s>0){
        var lai3S = await db.dSum("tienvon-tientrung", "TXL_TinPhanTichCT", "MaTin = ${_matin.value} AND length(SoDanh) in (3,4)");
        if(lai3S!=null && lai3S>0) laiLo-=(lai3S*hoi3s)/100;
      }
    }
    if(KDauTren==1) laiLo = laiLo * (-1);
    _thuBu.value = laiLo??0;
    await db.updateCell(tbName: 'TXL_TinNhan',field: 'TongTien',value: laiLo,condition: 'ID = ${_matin.value}');

    _bDaTinh.value = true;
    await db.updateCell(tbName: 'TXL_TinNhan',field: 'DaTinh',value: 1,condition: 'ID = ${_matin.value}');
  }



  onDeleteAllTin() async{
    EasyLoading.show(status: 'Đang xóa...',dismissOnTap: false);
    await db.deleteData(tbName: 'TXL_TinNhan');
    await db.deleteData(tbName: 'TXL_TinNhanCT');
    await db.deleteData(tbName: 'TXL_TinPhanTichCT');
    await db.updateCell(tbName: 'SQLITE_SEQUENCE',field: 'SEQ',value:0 ,condition: "NAME='TXL_TinNhan'");
    await db.updateCell(tbName: 'SQLITE_SEQUENCE',field: 'SEQ',value:0 ,condition: "NAME='TXL_TinNhanCT'");
    await db.updateCell(tbName: 'SQLITE_SEQUENCE',field: 'SEQ',value:0 ,condition: "NAME='TXL_TinPhanTichCT'");
    EasyLoading.showToast('Đã xóa xong');
    onLoadTinNhan();
  }


  final RxInt _soTin = 0.obs; int get soTin => _soTin.value;
  final RxList<Map<String, dynamic>> _lstSMS = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get lstSMS => _lstSMS.value;

  final RxString _typeSMS = 'All'.obs;
  String get typeSMS => _typeSMS.value;
  set typeSMS(String value)  {
    _typeSMS.value = value;
    getAllMessages();

  }

  Future getAllMessages() async {
    EasyLoading.show(status: 'Loading...',dismissOnTap: false,maskType: EasyLoadingMaskType.black);
    var status = await Permission.sms.status;
    SmsQuery query = SmsQuery();
    try{
      if(status.isGranted){
        _enableTinhToan.value= false;
        _lstSelectSMS.clear();
        String sdt = await db.dLookup('SDT', 'TDM_Khach', "MaKhach = '${_maKhach.value}'");
        if(sdt==''){
          EasyLoading.showInfo('Không có SDT');
          return;
        }
        if(sdt.length>8){
          sdt  = "+84${sdt.lastChars(9)}";
        }else{
          EasyLoading.showInfo('SDT không hợp lệ');
          return;
        }
        List<SmsMessage> messages = await query.querySms(
            address: sdt,
            kinds: [SmsQueryKind.inbox,SmsQueryKind.sent]
        );
        if(messages.isEmpty){
          messages = await query.getAllSms;
          messages = messages.where((e) =>e.address!.length>8  && e.address!.lastChars(9) == sdt.lastChars(9)).toList();
        }

        messages = messages.where((e) => DateFormat('dd/MM/yyyy').format(_ngaylam.value) == DateFormat('dd/MM/yyyy').format(e.date!)).toList();
        messages.sort((a,b)=>a.id!.compareTo(b.id!));
        List<SmsMessage> messLast = [];
        switch(_typeSMS.value){
          case 'All':
            messLast = messages;
            break;
          case 'Nhận':
            messLast = messages.where((e) => e.kind == SmsMessageKind.received).toList();
            break;
          case 'Gửi':
            messLast = messages.where((e) => e.kind == SmsMessageKind.sent).toList();
            break;
        }
        // for(var x in messages){
        //   print(x.kind == SmsMessageKind.sent);
        // }
        _soTin.value = messLast.length;
        _lstSMS.value = messLast.map((e) => {
          'ID': e.id,
          'Tin':e.body.toString(),
          'Date': DateFormat('dd/MM/yyyy HH:mm:ss').format(e.date!),
        }).toList();
        EasyLoading.dismiss();
      }else{

        print('=================================');
        await Permission.sms.request();
        EasyLoading.dismiss();
      }



    }catch(e){
      EasyLoading.showInfo('Không lấy được tin sms');
    }



  }

  final RxList<Map<String, dynamic>> _lstSelectSMS = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get lstSelectSMS => _lstSelectSMS.value;
  onChonSMS(Map<String, dynamic> map,bool value){
    if(value){
      _lstSelectSMS.add(map);
    }else{
      _lstSelectSMS.remove(map);
    }
    // print(_lstSelectSMS.value);
  }

  onChapNhanSMS(){
    _lstSelectSMS.value.sort((a,b)=>a['ID'].compareTo(b['ID']));
    if(_lstSelectSMS.value.isEmpty){
      EasyLoading.showInfo('Không có tin');
      return;
    }
    String tin = _lstSelectSMS.value.map((e) => e['Tin']).toList().join('\n');
    _tinController.value.text = tin;
    _txtErr.value = '';
    Get.back();
  }

  clear(){
    _tienVon.value = 0;
    _tienXac.value = 0;
    _tienTrung.value = 0;
    _thuBu.value = 0;
    _tinController.value.clear();
    _txtErr.value = '';
    _bDaTinh.value  =false;
  }
}


