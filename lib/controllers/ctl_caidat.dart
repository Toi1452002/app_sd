import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sd_pmn/config/server.dart';
import 'package:sd_pmn/controllers/ctl_khach.dart';
import 'package:sd_pmn/function/extension.dart';
import 'package:http/http.dart' as http;
import 'package:sd_pmn/widgets/wgt_dialog.dart';
import '../database/connect_dbw.dart';
import '../database/db_connect.dart';
import 'package:open_filex/open_filex.dart';
class Ctl_CaiDat extends GetxController {
  ///Gọi hàm kết nối database
  ConnectDB db = ConnectDB();
  ConnectDBW dbw = ConnectDBW();

  final RxBool _kXc = false.obs;

  bool get kXc => _kXc.value;

  set kXc(bool b) => _kXc.value = b;
  final txt_Anui = TextEditingController();

  Ctl_CaiDat get to => Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    onLoadTuyChon();
    super.onInit();
  }

  onLoadTuyChon() async {
    List<Map<String, dynamic>> data = await db.loadData(
        tbName: 'T00_TuyChon', condition: "Ma in  ('kxc','au')");
    for (var x in data) {
      if (x['Ma'] == 'kxc') _kXc.value = x['GiaTri'].toString().toBool;
      if (x['Ma'] == 'au') txt_Anui.text = x['GiaTri'].toString();
    }
  }

  onUpdateTuyChon(String Ma, var value) async {
    await db.updateCell(
        tbName: 'T00_TuyChon',
        condition: "Ma = '$Ma'",
        field: 'GiaTri',
        value: value);
  }

  onSaoLuu() async {
    if (!await hasNetwork()) {
      EasyLoading.showToast(Sv_String.noHasNetwork);
      return;
    }
    EasyLoading.show(status: "Loading...", dismissOnTap: false);
    try{
      List<Map<String, dynamic>> khach = await db.loadData(tbName: 'TDM_Khach');
      List<Map<String, dynamic>> giaKhach = await db.loadData(tbName: 'TDM_GiaKhach');
      if(khach.isEmpty){
        EasyLoading.showInfo('Không có khách');
      }else{
        String fileName =  Info_App.MaKH;
        var url = Uri.parse(API.pathJson);
        final response = await http.post(url, body: {
          'FileName': fileName,
          'Status': 'saoluu',
          'Data': jsonEncode({
            "khach": khach,
            "giakhach": giaKhach,
          })
        });
        if (response.statusCode == 200) {
          Future.delayed(const Duration(seconds: 2),
                  () => EasyLoading.showSuccess("Sao lưu thành công"));
        } else {
          EasyLoading.showInfo("Sao lưu thất bại!");
        }
      }

    }catch(e){
      EasyLoading.showInfo(e.toString());
    }
    Get.back();

  }

  onKhoiPhuc() async {
    if (!await hasNetwork()) {
      EasyLoading.showToast(Sv_String.noHasNetwork);
      return;
    }
    EasyLoading.show(status: 'Loading...', dismissOnTap: false);
    var url = Uri.parse(API.pathJson);
    String fileName = Info_App.MaKH;
    try{
      final response = await http.post(url,
          body: {'FileName': fileName, 'Status': 'khoiphuc', 'Data': ""});
      if (response.statusCode == 200) {
        if(response.body != 'false'){
          Map data = jsonDecode(jsonDecode(response.body));
          List<dynamic> jsonKhach = data["khach"];
          List<dynamic> jsonGiaKhach = data["giakhach"];

          List<Map<String, dynamic>> khach =
          jsonKhach.map((e) => e as Map<String, dynamic>).toList();
          List<Map<String, dynamic>> giaKhach =
          jsonGiaKhach.map((e) => e as Map<String, dynamic>).toList();

          await db.deleteData(tbName: 'TDM_Khach');
          await db.deleteData(tbName: 'TDM_GiaKhach');

          if (khach.isNotEmpty) {
            await db.insertList(lstData: khach, tbName: 'TDM_Khach',fieldToString: 'SDT');
            await db.insertList(lstData: giaKhach, tbName: 'TDM_GiaKhach');
          }

          Ctl_Khach().to.onLoadData();
          EasyLoading.showSuccess("Khôi phục thành công");
        }
        else{
          EasyLoading.showInfo('Không có dữ liệu');
        }

      } else {
        EasyLoading.showInfo("Khôi phục thất bại");
      }
    }catch(e){
      EasyLoading.showInfo(e.toString());
    }

    Get.back();
  }


  onCapNhat() async {
    if (!await hasNetwork()) {
      EasyLoading.showToast(Sv_String.noHasNetwork);
      return;
    }

    var status = await Permission.manageExternalStorage.status;
    if(status.isDenied){
      await Permission.manageExternalStorage.request();
      // return;
    }
    try{
      Map<String, dynamic> data = await dbw.loadRow(tblName: 'PHANMEM', condition: "MaSP = '${Info_App.maSP}'");
      if(data.isNotEmpty &&  data['Version']!=Info_App.version){
        Wgt_Dialog(title: 'Cập nhật', text: 'Đã có phiên bản ${data['Version']}', onConfirm: (){
          downloadFile("http://rgb.com.vn/flutterApp", data['FileName'], '/storage/emulated/0/Download');
        });
      }else{
        EasyLoading.showToast('Không có bản cập nhật nào');
      }
    }catch(e){
      EasyLoading.showInfo('Lỗi mở file $e');
    }

  }

  Future<void> downloadFile(String url, String fileName, String dir) async {
    Get.back();
    EasyLoading.show(status: 'Đang cập nhật',dismissOnTap: false);
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';
    try {
      myUrl = '$url/$fileName';
      // print(myUrl);
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var status = await Permission.storage.isDenied;
      if(status){
        await Permission.storage.request();
      }
      var response = await request.close();
      if(response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
        await OpenFilex.open(filePath);
      }
      else {
        EasyLoading.showInfo('Không tìm thấy ứng dụng!');
      }
    }
    catch(ex){
      EasyLoading.showInfo('Lỗi tải file $ex!');
    }
    EasyLoading.dismiss();
  }


  final taikhoanCTL = TextEditingController();
  final matkhaumoiCTl = TextEditingController();
  final xn_matkhaumoiCTl = TextEditingController();
  onChangePassword() async {
    if(matkhaumoiCTl.text.trim()=='') {EasyLoading.showInfo('Mật khẩu không được bỏ trống'); return;}
    if(taikhoanCTL.text == 'pmn') {EasyLoading.showInfo('Tên tài khoản đã tồn tại');return;}
    if(xn_matkhaumoiCTl.text!= matkhaumoiCTl.text)  {EasyLoading.showInfo('Mật khẩu không trùng khớp'); return;}
    try{
      await db.updateCell(tbName: 'T00_User',field: 'UserName',value: taikhoanCTL.text,condition: "ID != 1");
      await db.updateCell(tbName: 'T00_User',field: 'Password',value: xn_matkhaumoiCTl.text,condition: "ID != 1").whenComplete((){
        Info_App.Username = taikhoanCTL.text;
        Get.back();
        EasyLoading.showSuccess("Đổi mật khẩu thành công");
      });

    }
    catch(e){
      EasyLoading.showInfo("Lỗi $e");
    }
  }

  RxString username = ''.obs;
  RxString password = ''.obs;

  onOpenDialogPMN()async{
    Map<String, dynamic> data = await db.loadRow(tblName: 'T00_User',Condition: 'ID = 2');
    username.value = data['UserName'];
    password.value = data['PassWord'];
  }

  clearTextChangePassword(){
    matkhaumoiCTl.clear();
    taikhoanCTL.clear();
    xn_matkhaumoiCTl.clear();
  }
}
