// ignore_for_file: camel_case_types

import 'dart:convert';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sd_pmn/config/config.dart';
import 'package:sd_pmn/config/router.dart';
import 'package:sd_pmn/database/auth_data.dart';
import 'package:sd_pmn/database/connect_dbw.dart';
import 'package:sd_pmn/database/db_connect.dart';
import 'package:sd_pmn/function/extension.dart';
import 'package:sd_pmn/models/mdl_kqxs.dart';

import '../config/server.dart';
import '../function/hamchung.dart';
import '../function/md_laykqxs.dart';
import '../models/models.dart';

class Ctl_Kqxs extends GetxController {
  ///Gọi hàm kết nối database
  ConnectDB db = ConnectDB();
  // ConnectDBW dbw = ConnectDBW();

  ///-------------------------------------------
  final RxString _mien = "N".obs;

  String get mien => _mien.value;

  set mien(String m) {
    assert(m.length == 1);
    _mien.value = m;
  }

  RxBool disableBtn = false.obs;
  ///-------------------------------------------

  final Rx<DateTime> _ngaylam = DateTime.now().obs;

  DateTime get ngaylam => _ngaylam.value;
  set ngaylam(DateTime date) => _ngaylam.value = date;

  ///-------------------------------------------

  final RxString _thongbao = "".obs;
  String get thongbao => _thongbao.value;

  ///-------------------------------------------
  final RxBool _xsMn = false.obs;
  bool get xsMn => _xsMn.value;
  set xsMn(bool b) => _xsMn.value = b;

  ///-------------------------------------------
  final RxList<KqxsModel> _lstKqxs = <KqxsModel>[].obs;
  List<KqxsModel> get lstKqxs => _lstKqxs.value;
  Ctl_Kqxs get to => Get.find();

  @override
  onInit() async{
    int value = await db.dLookup("GiaTri", "T00_TuyChon", "Ma = 'xsMN'");
    _xsMn.value = value.toString().toBool; /// _xsMn ? Kqxs Minh Ngoc : Kqxs Hom Nay
    update();
    super.onInit();
  }

  onChangeXsMn(bool value)async{ ///Thay đổi giá trị xổ số Minh Ngọc
    await db.updateCell(tbName: 'T00_TuyChon', value: value ? 1: 0, field: 'GiaTri', condition: "Ma = 'xsMN'");
  }

  onDeleteKqxs() async { /// Xóa hết kết quả xổ số
    _lstKqxs.clear();
    await db.deleteData(tbName: "TXL_KQXS");
    Get.back();
    Get.back();
    update();
  }

  onGetKqxs() async {
    disableBtn.value = true;



    ///New
    final iUser = infoUser.value;
    final auth = AuthData();
    // final server = ConfigServer();

    if(!await hasNetwork()){//Khon co mang
      EasyLoading.showInfo(Sv_String.noHasNetwork);
      String ngayHH = await auth.getNgayHetHan();
      infoUser.value.soNgayCon = auth.getSoNgayConLai(ngayHH);
      // return;
    }else{
      try{
        final rps = await auth.xacThuc(iUser.maKichHoat);
        if(rps.statusCode == 200){
          final data = jsonDecode(rps.data);
          if(data!=false){
            await auth.updateNgayHetHan(data['NgayHetHan']);

            infoUser.value = InfoUser(
                maHD: int.parse(data['ID']),
                ngayHetHan: data['NgayHetHan'],
                soNgayCon: auth.getSoNgayConLai(data['NgayHetHan']),
                maKichHoat: iUser.maKichHoat,
                userName: iUser.userName
            );
          }
        }
      }catch(e){
        throw Exception(e);
      }
    }

    ////




    // if(!await hasNetwork()) { /// Nếu không có mạng
    //   Map<String,dynamic> user = await db.loadRow(tblName: 'T00_User',Condition: "ID = 2");
    //   DateTime ngaylam = DateTime.now();
    //   DateTime ngayhethan = DateTime.parse(user['NgayHetHan']);
    //   if(InfoApp.ngayHetHan!='#'){
    //     InfoApp.soNgayHetHan = ngayhethan.difference(ngaylam).inDays;/// Cập nhật số ngày hết hạn nếu không có mạng
    //   }
    //   EasyLoading.showInfo(Sv_String.noHasNetwork);
    //   return;
    // }else{
    //   ///Cập nhật User
    //   Map<String, dynamic> user = await dbw.loadRow(tblName: 'KHACH_SD', condition: "MaKH = '${InfoApp.MaKH}'  AND TrangThai = 1 AND DaXoa = 0");
    //   // print("======================================$user");
    //
    //   if(user.isNotEmpty){
    //     await db.updateCell(tbName: 'T00_User',field: 'NgayHetHan',value: user['NgayHetHan']);
    //     await dbw.updateData(tbName: 'KHACH_SD', field: 'NgayLamViec',value: DateFormat('yyyy-MM-dd').format(DateTime.now()),condition: "MaKH = '${user['MaKH']}'").whenComplete((){
    //       DateTime ngayhethan = DateTime.parse(user['NgayHetHan']);
    //       DateTime ngaylamviec = DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
    //       int soNgayHetHan = ngayhethan.difference(ngaylamviec).inDays;
    //       if(InfoApp.ngayHetHan!='#'){
    //         InfoApp.ngayHetHan = DateFormat('dd/MM/yyyy').format(DateTime.parse(user['NgayHetHan']));
    //         InfoApp.soNgayHetHan = soNgayHetHan;
    //       }
    //
    //       InfoApp.MaKH = user['MaKH'];
    //     }).catchError((e){
    //       EasyLoading.showInfo('Lỗi $e');
    //     });
    //
    //
    //   }
    //
    //   else{
    //     EasyLoading.showInfo('Không tìm thấy thiết bị');
    //     Future.delayed(const Duration(seconds: 2),(){
    //       Get.offAndToNamed(routerName.v_login);
    //     });
    //     Map<String,dynamic> user = await db.loadRow(tblName: 'T00_User',Condition: "ID = 2");
    //     DateTime ngaylam = DateTime.now();
    //     DateTime ngayhethan = DateTime.now();
    //     if(InfoApp.ngayHetHan=='null'){
    //       InfoApp.soNgayHetHan = 1;/// Cập nhật số ngày hết hạn nếu không có mạng
    //
    //     }
    //     else if(InfoApp.ngayHetHan!='#'){
    //       InfoApp.soNgayHetHan = ngayhethan.difference(ngaylam).inDays;/// Cập nhật số ngày hết hạn nếu không có mạng
    //     }
    //     return;
    //   }
    // }




    _thongbao.value = '';
    String strNgay = DateFormat("yyyy-MM-dd").format(_ngaylam.value);
    int thutrongtuan = _mien.value =="B" ? 0 : DateTime.parse(strNgay).weekday - 1;
    String sqlLoadKqxs = '''
      Select kqxs.*,md.MoTa as MoTa ,  substr(md.TT, INSTR(md.Thu,'$thutrongtuan'), 1) as indexTT
          From TXL_KQXS kqxs,T01_MaDai  md
          Where kqxs.Ngay = '$strNgay' 
          And kqxs.Mien = '${_mien.value}' 
          And kqxs.MaDai = md.MaDai
          And kqxs.MaDai = md.MaDai
          And md.Thu Like '%$thutrongtuan%'
          Order by indexTT
    ''';

    List<Map<String, dynamic>> row =  await db.loadData(sql: sqlLoadKqxs);
    if (row.isEmpty) {///Nếu trong db rỗng thì lấy kqxs trên web
      if (!await hasNetwork()) { ///Không có mạng
        EasyLoading.showInfo(Sv_String.noHasNetwork); return;
      } else {
        EasyLoading.show(status: 'Đang lấy kết quả xổ số...', maskType: EasyLoadingMaskType.black);
        try{
          Map<String, dynamic> kqxs = await getKqxs(_ngaylam.value, mien, xsMinhNgoc: _xsMn.value).timeout(const Duration(seconds: 15), onTimeout: () {
            EasyLoading.showError("Mạng không ổn định.\nKiểm tra lại Internet");
            return {};
          });

          int maSo = mien == "B" ? 27 : 18;
          int tt = 0;
          int selectedMaDai = 0;
          List<String> dsDaiHT = await ds_DaiHT(Ngay: strNgay, Mien: mien);
          if (kqxs["ngay"] == strNgay && dsDaiHT.length == kqxs["listDai"].length && kqxs["kqSo"].length == kqxs["listDai"].length * maSo) {
            /// Có KQXS
            List<String> listMaDai = (kqxs["listDai"]);
            List<KqxsModel> lstInsert = [];
            for (int i = 0; i < kqxs["kqSo"].length; i++) {

              tt++;
              if (mien == "B") {
                lstInsert.add(KqxsModel(Ngay: kqxs["ngay"], Mien: mien, MaDai: "mb", MaGiai: giaiMB(tt), TT: tt, KqSo: kqxs["kqSo"][i].toString()));
              } else {
                int stt = tt % 18 == 0 ? 18 : tt % 18;
                lstInsert.add(KqxsModel(Ngay: kqxs["ngay"], Mien: mien, MaDai: listMaDai[selectedMaDai], MaGiai: giaiMN(stt), TT: stt, KqSo: kqxs["kqSo"][i].toString()));

                if (tt % 18 == 0) {
                  selectedMaDai++;
                }
              }
            }
            List<Map<String, dynamic>> lstInsertJson = lstInsert.map((e) => e.toMap()).toList();
            if(await db.dCount('TXL_KQXS',Condition: "Ngay = '$strNgay' AND Mien = '${_mien.value}'") == 0 ){
              // log('---Insert KQXS----');
              await db.insertList(lstData: lstInsertJson, tbName: "TXL_KQXS",fieldToString: 'KQso');
            }

            List<Map<String, dynamic>> loadlai = await db.loadData(sql: sqlLoadKqxs);
            _lstKqxs.value =  loadlai.map((e) => KqxsModel.fromMap(e)).toList();

            EasyLoading.dismiss();
          } else {
            EasyLoading.dismiss();
            _thongbao.value = "Chưa có kết quả xổ số";
            _lstKqxs.clear();
          }
        }catch(e){
          EasyLoading.showInfo(e.toString());
        }

      }
    }
    else{
      _lstKqxs.value =  row.map((e) => KqxsModel.fromMap(e)).toList();
    }
    disableBtn.value = false;
    update();
  }

  ds_DaiHT({String Mien = 'N',required String Ngay}) async{///Lấy danh sách đài hiện tại
    String sThu=(Thu(Ngay)-1).toString();
    List<String> lstDaiHT = [];
    if(Mien!="B"){
      List<Map<String, dynamic>> lstDaiHienTai = await db.loadData(sql: '''
      Select MaDai,substr(TT, INSTR(Thu,'$sThu'), 1) as indexTT 
        From T01_MaDai 
        Where Mien = '$Mien' 
        And Thu LIKE '%$sThu%' 
        Order By indexTT
    ''');
      lstDaiHT = lstDaiHienTai.map((e) => e['MaDai'].toString()).toList();
    }else{
      lstDaiHT = ['mb'];
    }
    return lstDaiHT;
  }
  @override
  void onClose() {
    // TODO: implement
    Get.delete<Ctl_Kqxs>();
    super.onClose();
  }
}
