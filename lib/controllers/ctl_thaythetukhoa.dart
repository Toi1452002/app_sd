// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/models/mdl_tukhoa.dart';

import '../database/db_connect.dart';


class Ctl_ThaytheTK extends GetxController{
  ///Gọi hàm kết nối database
  ConnectDB db = ConnectDB();

  ///-------------------------------------------

  final RxList<TuKhoaModel> _lstTuKhoa = <TuKhoaModel>[].obs;
  List<TuKhoaModel> get lstTuKhoa => _lstTuKhoa.value;

  ///-------------------------------------------

  final RxString _motaErr = "".obs;
  String get motaErr => _motaErr.value;
  set motaErr(String x)=> _motaErr.value = x;

  ///-------------------------------------------

  TextEditingController motaController = TextEditingController();
  TextEditingController tukhoaController = TextEditingController();

  Ctl_ThaytheTK get to => Get.find();

  int idUpdate = 0;

  @override
  void onInit() {
    // TODO: implement onInit
    onLoadData();
    super.onInit();
  }


  onLoadData() async{
    List<Map<String, dynamic>> data = await db.loadData(tbName: 'T01_TuKhoa',condition: "SoDanhHang = 0");
    _lstTuKhoa.value = data.map((e) => TuKhoaModel.fromMap(e)).toList();
    update();
  }

  onDeleteData(int ID)async{
    _lstTuKhoa.removeWhere((e) => e.ID==ID);
    await db.deleteData(tbName: 'T01_TuKhoa',condition: 'ID = $ID');
    Get.back();
    update();
  }

  onThemTuKhoa() async{
    if(motaController.text.isEmpty){_motaErr.value = "Không được bỏ trống";return;}
    if(await db.ktra_tontai(tbName: 'T01_TuKhoa',condition: "CumTu = '${motaController.text}'")){_motaErr.value = "Đã tồn tại";return;}
    TuKhoaModel tk = TuKhoaModel(CumTu: motaController.text, ThayThe:tukhoaController.text);
    int id = await db.insertRow(map: tk.toMap(), tbName: 'T01_TuKhoa');
    tk.ID = id;
    _lstTuKhoa.add(tk);
    Get.back();
    EasyLoading.showSuccess("Thêm thành công");
    update();
  }

  onEdit(TuKhoaModel tuKhoaModel){
    motaController.text = tuKhoaModel.CumTu;
    tukhoaController.text = tuKhoaModel.ThayThe;
    idUpdate = tuKhoaModel.ID!;
  }

  onUpdate()async{
    if(motaController.text.isEmpty){_motaErr.value = "Không được bỏ trống";return;}
    if(await db.ktra_tontai(tbName: 'T01_TuKhoa',boquaID: idUpdate,condition: "CumTu = '${motaController.text}'")){_motaErr.value = "Đã tồn tại";return;}

    TuKhoaModel tk = TuKhoaModel(ID: idUpdate, CumTu: motaController.text, ThayThe:  tukhoaController.text);
    await db.updateRow(map: tk.toMap(),tbName: 'T01_TuKhoa');

    int indexUpdate = _lstTuKhoa.indexWhere((e) => e.ID==idUpdate);
    _lstTuKhoa.removeAt(indexUpdate);
    _lstTuKhoa.insert(indexUpdate,tk);
    update();
    Get.back();

  }

  ResetText(){
    motaController.clear();
    tukhoaController.clear();
    _motaErr.value = "";
    update();
  }


}