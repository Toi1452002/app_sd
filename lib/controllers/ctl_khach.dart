// ignore_for_file: non_constant_identifier_names, camel_case_types, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/controllers/ctl_xuly.dart';
import 'package:sd_pmn/function/extension.dart';
import 'package:sd_pmn/models/mdl_khach.dart';

import '../database/db_connect.dart';
import '../models/mdl_giakhach.dart';

class Ctl_Khach extends GetxController{
  ///Gọi hàm kết nối database
  ConnectDB db = ConnectDB();

  RxBool b_2dx = true.obs;    ///  ? 2d-dx : 2d-dt
  RxBool b_dautren = false.obs;
  RxBool b_tkAB = false.obs;

  final RxInt _kieutyle = 1.obs;
  int get kieutyle => _kieutyle.value;
  set kieutyle(int value){
    _kieutyle.value = value;
    Ctl_GiaKhach().to.changeKieuGia(value);
  }



  /// -----------------------------------------------------------------------------------------*
  TextEditingController makhachController = TextEditingController();
  final RxBool _enableMaKhach = false.obs;
  bool get enableMaKhach => _enableMaKhach.value;


  final sdtController = TextEditingController();
  final hoiTongController = TextEditingController();
  final hoi2SoController = TextEditingController();
  final hoi3SoController = TextEditingController();
  final sdtCTL = TextEditingController();
  ///-------------------------------------------

  final RxList<KhachModel> _lstKhach = <KhachModel>[].obs;
  List<KhachModel> get lstKhach => _lstKhach.value;

  ///-------------------------------------------
  KhachModel khachUpdate = KhachModel();

  Ctl_Khach get to => Get.find();


  @override
  onInit(){
    super.onInit();
    onLoadData();

  }
  /// -----------------------------------------------------------------------------------------*
  ///
  onLoadData() async{
    List<Map<String, dynamic>> data = await db.loadData(tbName: 'TDM_Khach');
    _lstKhach.value = data.map((e) => KhachModel.fromMap(e)).toList();
    _lstKhach.sort((a,b)=>a.MaKhach.compareTo(b.MaKhach));
    update();
  }
  /// -----------------------------------------------------------------------------------------*
  ///
  onSave() async{
    if(makhachController.text.isEmpty){ EasyLoading.showInfo('Tên khách không được bỏ trống'); return; }
    if(await db.ktra_tontai(tbName: 'TDM_Khach',boquaID: khachUpdate.ID??0,condition: "MaKhach = '${makhachController.text}'")){  EasyLoading.showInfo("Tên khách đã tồn tại!"); return ;  }
    if([null,0].contains(khachUpdate.ID) || khachUpdate.copy){ /** Insert **/
      KhachModel data = KhachModel(
        ID: null,
        tkDa: b_2dx.value ? 1 : 0,
        KDauTren: b_dautren.value ? 1 : 0,
        MaKhach: makhachController.text.trim(),
        KieuTyLe: _kieutyle.value,
        tkAB: b_tkAB.value ? 1 : 0,
        ThuongMN: Ctl_GiaKhach().to.ck_thuongMN.value ? 1 : 0,
        ThemChiMN: Ctl_GiaKhach().to.ck_themchiMN.value ? 1 : 0,
        ThuongMT: Ctl_GiaKhach().to.ck_thuongMT.value ? 1 : 0,
        ThemChiMT: Ctl_GiaKhach().to.ck_themchiMT.value ? 1 : 0,
        ThuongMB: Ctl_GiaKhach().to.ck_thuongMB.value ? 1 : 0,
        ThemChiMB: Ctl_GiaKhach().to.ck_themchiMB.value ? 1 : 0,
        Hoi2s: hoi2SoController.text.isEmpty?0: double.parse(hoi2SoController.text),
        Hoi3s: hoi3SoController.text.isEmpty?0:double.parse(hoi3SoController.text),
        HoiTong:hoiTongController.text.isEmpty?0: double.parse(hoiTongController.text),
        SDT: sdtCTL.text
      );
      int idInsert = await db.insertRow(map: data.toMap(), tbName: 'TDM_Khach');
      if(idInsert!=0){
        List<Map<String, dynamic>> giaData = Ctl_GiaKhach().to.lstGiaKhach.map((e){
          e.KhachID = idInsert;
          e.ID = null;
          return e.toMap();
        }).toList();
        await db.insertList(lstData: giaData, tbName: 'TDM_GiaKhach');
      }
    }else{  /** Update **/
      KhachModel data = KhachModel(
        ID: khachUpdate.ID,
        tkDa: b_2dx.value ? 1 : 0,
        tkAB: b_tkAB.value ? 1 : 0,
        KDauTren: b_dautren.value ? 1 : 0,
        MaKhach: makhachController.text.trim(),
        KieuTyLe: _kieutyle.value,
        ThuongMN: Ctl_GiaKhach().to.ck_thuongMN.value ? 1 : 0,
        ThemChiMN: Ctl_GiaKhach().to.ck_themchiMN.value ? 1 : 0,
        ThuongMT: Ctl_GiaKhach().to.ck_thuongMT.value ? 1 : 0,
        ThemChiMT: Ctl_GiaKhach().to.ck_themchiMT.value ? 1 : 0,
        ThuongMB: Ctl_GiaKhach().to.ck_thuongMB.value ? 1 : 0,
        ThemChiMB: Ctl_GiaKhach().to.ck_themchiMB.value ? 1 : 0,
        Hoi2s: hoi2SoController.text.isEmpty?0: double.parse(hoi2SoController.text),
        Hoi3s: hoi3SoController.text.isEmpty?0:double.parse(hoi3SoController.text),
        HoiTong:hoiTongController.text.isEmpty?0: double.parse(hoiTongController.text),
        SDT: sdtCTL.text
      );

      await db.updateRow(map: data.toMap(),tbName: 'TDM_Khach');
      await db.deleteData(tbName: 'TDM_GiaKhach',condition: 'KhachID = ${khachUpdate.ID}');
      List<Map<String, dynamic>> giaData = Ctl_GiaKhach().to.lstGiaKhach.map((e){
        e.ID = null;
        e.KhachID = khachUpdate.ID;
        // print(e.toMap());
        return e.toMap();
      }).toList();

      await db.insertList(lstData: giaData, tbName: 'TDM_GiaKhach');

    }
    onLoadData();
    Get.back();
  }

  ///-------------------------------------------
  ///
  onDeleteKhach(int ID) async{
    _lstKhach.removeWhere((e) => e.ID == ID); update(); Get.back();



    String khach = await db.dLookup('MaKhach', 'TDM_Khach', 'ID = $ID');
    await db.deleteData(tbName: 'TDM_Khach',condition: 'ID = $ID');
    // await db.deleteData(tbName: 'TDM_SoDT',condition: 'KhachID = $ID');
    await db.deleteData(tbName: 'TDM_GiaKhach',condition: 'KhachID = $ID');

    List<Map<String, dynamic>> tn = await db.loadData(tbName:'TXL_TinNhan',condition: "KhachID = $ID" );
    List maTin = tn.map((e) => e['ID']).toList();

    await db.deleteData(tbName: 'TXL_TinNhan',condition: "KhachID = $ID");

    if(maTin.isNotEmpty){
      for(var x in maTin){
        await db.deleteData(tbName: 'TXL_TinNhanCT',condition: "TinNhaniD = $x");
        await db.deleteData(tbName: 'TXL_TinPhanTichCT',condition: "MaTin = $x");
      }
    }

    if(khach==Ctl_Xuly().to.maKhach) await Ctl_Xuly().to.onLoadTinNhan();
    EasyLoading.showToast('Xóa thành công');

  }
  ///-------------------------------------------
  ///
  onEdit(KhachModel k,{bool copy = false,bool editXL = true}) async{
    _enableMaKhach.value = editXL;
    k.copy = copy;
    khachUpdate = k;
    makhachController.text = copy ? "" : k.MaKhach;
    hoiTongController.text = k.HoiTong.toStringAsFixed(0);
    hoi2SoController.text = k.Hoi2s.toStringAsFixed(0);
    hoi3SoController.text = k.Hoi3s.toStringAsFixed(0);
    b_2dx.value = k.tkDa.toString().toBool;
    b_dautren.value = k.KDauTren.toString().toBool;
    b_tkAB.value = k.tkAB.toString().toBool;
    _kieutyle.value = k.KieuTyLe;
    sdtCTL.text = k.SDT;
    update();
  }
  ResetText(){
    khachUpdate = KhachModel();
    _kieutyle.value = 1;
    makhachController.clear();
    hoi3SoController.clear();
    hoi2SoController.clear();
    hoiTongController.clear();
    sdtCTL.clear();
    b_tkAB.value = false;
    _enableMaKhach.value = true;
    update();
  }
}




class Ctl_GiaKhach extends GetxController{
  ///Gọi hàm kết nối database
  ConnectDB db = ConnectDB();
  ///-------------------------------------------

  List<GiaKhachModel> gia_ban_dau_k1 = [
    GiaKhachModel(MaKieu: "2s", CoMN: 70, TrungMN: 70, CoMT: 70, TrungMT: 70, CoMB: 70, TrungMB: 70),
    GiaKhachModel(MaKieu: "3s", CoMN: 70, TrungMN: 600, CoMT: 70, TrungMT: 600, CoMB: 70, TrungMB: 600),
    GiaKhachModel(MaKieu: "4s", CoMN: 70, TrungMN: 5000, CoMT: 70, TrungMT: 5000, CoMB: 70, TrungMB: 5000),
    GiaKhachModel(MaKieu: "dt", CoMN: 70, TrungMN: 500, CoMT: 70, TrungMT: 500, CoMB: 70, TrungMB: 500),
    GiaKhachModel(MaKieu: "dx", CoMN: 70, TrungMN: 500, CoMT: 70, TrungMT: 500, CoMB: 0, TrungMB: 0),
  ];

  List<GiaKhachModel> gia_ban_dau_k2 = [
    GiaKhachModel(MaKieu: "ab", CoMN: 70, TrungMN: 70, CoMT: 70, TrungMT: 70, CoMB: 70, TrungMB: 70),
    GiaKhachModel(MaKieu: "xc", CoMN: 70, TrungMN: 600, CoMT: 70, TrungMT: 600, CoMB: 70, TrungMB: 600),
    GiaKhachModel(MaKieu: "b2", CoMN: 70, TrungMN: 70, CoMT: 70, TrungMT: 70, CoMB: 70, TrungMB: 70),
    GiaKhachModel(MaKieu: "b3", CoMN: 60, TrungMN: 600, CoMT: 60, TrungMT: 600, CoMB: 60, TrungMB: 600),
    GiaKhachModel(MaKieu: "b4", CoMN: 60, TrungMN: 5000, CoMT: 60, TrungMT: 5000, CoMB: 60, TrungMB: 5000),
    GiaKhachModel(MaKieu: "dt", CoMN: 70, TrungMN: 500, CoMT: 70, TrungMT: 500, CoMB: 70, TrungMB: 500),
    GiaKhachModel(MaKieu: "dx", CoMN: 70, TrungMN: 500, CoMT: 70, TrungMT: 500, CoMB: 70, TrungMB: 500),
    GiaKhachModel(MaKieu: "d4", CoMN: 70, TrungMN: 5000, CoMT: 70, TrungMT: 5000, CoMB: 70, TrungMB: 5000),
  ];
  ///
  ///-------------------------------------------
  RxBool ck_thuongMN = false.obs;
  RxBool ck_themchiMN = false.obs;
  RxBool ck_thuongMB = false.obs;
  RxBool ck_themchiMB = false.obs;
  RxBool ck_thuongMT = false.obs;
  RxBool ck_themchiMT = false.obs;
  ///-------------------------------------------
  ///
  ///
  final RxList<GiaKhachModel> _lstGiaKhach = <GiaKhachModel>[].obs;
  Ctl_GiaKhach get to => Get.find();
  List<GiaKhachModel> get lstGiaKhach =>  _lstGiaKhach.value;

  void changeKieuGia(int kieutyle){
    if(kieutyle==1){
      _lstGiaKhach.value = gia_ban_dau_k1;
    }else{
      _lstGiaKhach.value = gia_ban_dau_k2;
    }
  }

  @override
  void onInit() {
    if([0,null].contains(Ctl_Khach().to.khachUpdate.ID)){
      _lstGiaKhach.value = gia_ban_dau_k1;
    }else{
      onLoadGia();
    }

    update();
    super.onInit();
  }
  ///
  ///-------------------------------------------
  thay_doi_thuongDT(bool value, String mien){
    if(mien=="N"){
      if(!value)ck_themchiMN.value = false;
      ck_thuongMN.value = value;
    }else if(mien=="T"){
      if(!value)ck_themchiMT.value = false;
      ck_thuongMT.value = value;
    }else{
      if(!value)ck_themchiMB.value = false;
      ck_thuongMB.value = value;
    }
    update();
  }

  thay_doi_themchi(bool value, String mien){
    if(mien=="N"){
      ck_themchiMN.value = value;
    }else if(mien=="T"){
      ck_themchiMT.value = value;
    }else{
      ck_themchiMB.value = value;
    }
    update();
  }
  ///-------------------------------------------
  ///

  onLoadGia()async {
    KhachModel k = Ctl_Khach().to.khachUpdate;
    List<Map<String, dynamic>> giaData = await db.loadData(tbName: 'TDM_GiaKhach',condition: "KhachID = ${k.ID}");
    _lstGiaKhach.value = giaData.map((e) => GiaKhachModel.fromMap(e)).toList();
    ck_thuongMN.value = k.ThuongMN.toString().toBool ;
    ck_themchiMN.value = k.ThemChiMN.toString().toBool;
    ck_thuongMT.value = k.ThuongMT.toString().toBool;
    ck_themchiMT.value = k.ThemChiMT.toString().toBool;
    ck_thuongMB.value = k.ThuongMB.toString().toBool;
    ck_themchiMB.value = k.ThemChiMB.toString().toBool;
    update();
  }
  @override
  void onClose() {
    _lstGiaKhach.close();
    super.onClose();
  }
}