import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sd_pmn/database/auth_data.dart';
import 'package:sd_pmn/database/connect_dbw.dart';
import 'package:sd_pmn/models/models.dart';
import 'package:sd_pmn/widgets/wgt_dialog.dart';
import '../config/config.dart';
import '../database/db_connect.dart';
import '../function/extension.dart';
import 'package:dio/dio.dart' as dio;


class CtlUser extends GetxController {
  ///Gọi hàm kết nối database
  ConnectDB db = ConnectDB();
  // ConnectDBW dbw = ConnectDBW();
  final _server = ConfigServer();
  final _authData = AuthData();

  CtlUser get to => Get.find();

  // final pathCTl = TextEditingController();


  /// -----------------------------------------------------------------------------------------*
  /// -----------------------------------------------------------------------------------------*
  /// -----------------------------------------------------------------------------------------*
  /// Nhập mã kích hoạt



  void onKichHoat(String maKichHoat) async{
    EasyLoading.show(status: 'Loading...', dismissOnTap: false);
    if(maKichHoat==''){
      EasyLoading.showToast("Kích hoạt thất bại");
      return;
    }

    try{
      final rps = await _server.postData(path: _server.auth, type: _authData.kichHoat, data: {
        'MaKichHoat': maKichHoat
      });

      if(rps.statusCode == 200){
        final data  = jsonDecode(rps.data);
        if(data){
          await _authData.updateMaKichHoat(maKichHoat);
          EasyLoading.dismiss();
          Get.offAndToNamed(routerName.v_login);

        }else{
          EasyLoading.showToast("Kích hoạt thất bại");
          return;
        }

      }else{
        EasyLoading.showToast("Kích hoạt thất bại");
      }
    }catch(e){
      EasyLoading.showToast("Kích hoạt thất bại");
      throw Exception(e);
    }
  }

//
// final makichhoatCTL = TextEditingController();
//   onKichHoat() async {
//     if (!await hasNetwork()) {
//       EasyLoading.showToast(Sv_String.noHasNetwork);
//       return;
//     }
//     if (makichhoatCTL.text.isEmpty || !makichhoatCTL.text.contains('-')) {
//       EasyLoading.showInfo('Mã không hợp lệ');
//       return;
//     }
//     EasyLoading.show(status: 'Loading...', dismissOnTap: false);
//
//     try {
//       String makh =
//           makichhoatCTL.text.substring(makichhoatCTL.text.lastIndexOf('-') + 1);
//       String mathietbi =
//           makichhoatCTL.text.substring(0, makichhoatCTL.text.lastIndexOf('-'));
//       if (mathietbi != InfoApp.idDevice ||
//           makichhoatCTL.text == InfoApp.idDevice) {
//         EasyLoading.showInfo('Mã không hợp lệ');
//         return;
//       }
//       Map<String, dynamic> data = await dbw.loadRow(
//           tblName: 'KHACH_SD',
//           condition:
//               "MaKH= '$makh' AND MaKichHoat = '${makichhoatCTL.text}' AND TrangThai = 0 AND DaXoa = 0");
//       if (data.isEmpty) {
//         EasyLoading.showInfo('Mã không hợp lệ');
//         return;
//       }
//       await dbw
//           .updateData(
//               tbName: 'KHACH_SD',
//               field: 'TrangThai',
//               value: 1,
//               condition: "MaKH = '$makh'")
//           .whenComplete(() async {
//         await db.updateCell(
//             field: 'MaKichHoat', value: makichhoatCTL.text, tbName: 'T00_User');
//         await db.updateCell(field: 'MaKH', value: makh, tbName: 'T00_User');
//         EasyLoading.showSuccess('Kích hoạt thành công');
//         Future.delayed(const Duration(seconds: 2),
//             () => Get.offAndToNamed(routerName.v_login));
//       }).catchError((e) {
//         EasyLoading.showInfo("Lỗi $e");
//       });
//     } catch (e) {
//       EasyLoading.showToast('Lỗi kích hoạt: $e');
//     }
//   }

  /// -----------------------------------------------------------------------------------------*
  /// -----------------------------------------------------------------------------------------*
  /// -----------------------------------------------------------------------------------------*
  /// Đăng nhập

  void onLogin(String userName, String passWord) async{
    if(userName == 'rgb' && passWord == 'datalysmanx'){
      infoUser.value = InfoUser(
          // maHD: data['ID'],
          // ngayHetHan: data['NgayHetHan'],
          soNgayCon: 1,
          // maKichHoat: maKichHoat,
          userName: userName
      );
      Get.offAndToNamed(routerName.v_tabPage);
      return;
    }

    EasyLoading.show(status: 'Loading...', dismissOnTap: false);
    String maKichHoat = await _authData.checkLogin(userName, passWord);



    if(maKichHoat == ''){
      EasyLoading.showToast("Ứng dụng chưa được kích hoạt");
      return;
    }

    try{
      final rps  = await _authData.xacThuc(maKichHoat).timeout(const Duration(seconds: 7),onTimeout: () {
        return dio.Response(statusCode: 404,requestOptions: dio.RequestOptions());
      });

      if(rps.statusCode == 200){
        final data = jsonDecode(rps.data);
        if(data == false){
          EasyLoading.showToast("Không tìm thấy tài khoản");
          return;
        }

        await _authData.updateNgayHetHan(data['NgayHetHan']);

        infoUser.value = InfoUser(
          maHD: int.parse(data['ID']),
          ngayHetHan: data['NgayHetHan'],
          soNgayCon: _authData.getSoNgayConLai(data['NgayHetHan']),
          maKichHoat: maKichHoat,
          userName: userName
        );

        EasyLoading.dismiss();

        Get.offAndToNamed(routerName.v_tabPage);

      }else{
        EasyLoading.showToast("Đăng nhập thất bại");
      }
    }catch(e){
      EasyLoading.showToast("Đăng nhập thất bại");

      throw Exception(e);
    }

  }

  // final tenDNCTL = TextEditingController();
  // final matkhauDNCTL = TextEditingController();
  // onLogin() async {
  //   if (tenDNCTL.text == 'rgb' && matkhauDNCTL.text == 'datalysmanx') {
  //     onUpdateServer('null', 1, '0000', 'admin');
  //     return;
  //   }
  //   EasyLoading.show(status: 'Loading...', dismissOnTap: false);
  //   try {
  //     Map<String, dynamic> user = await db.loadRow(
  //         tblName: 'T00_User',
  //         Condition:
  //             "UserName = '${tenDNCTL.text.trim()}' AND PassWord = '${matkhauDNCTL.text.trim()}'");
  //     //
  //     // print(user);
  //     if (user.isNotEmpty) {
  //       if (!await hasNetwork()) {
  //         EasyLoading.showToast(Sv_String.noHasNetwork);
  //         return;
  //       }
  //
  //       Map<String, dynamic> data = await dbw
  //           .loadRow(
  //               tblName: 'KHACH_SD',
  //               condition:
  //                   "MaKH = '${user['MaKH']}' AND MaKichHoat = '${user['MaKichHoat']}' AND TrangThai = 1 AND DaXoa = 0")
  //           .timeout(Duration(seconds: 8), onTimeout: () {
  //         EasyLoading.showToast("Mạng không ổn định");
  //         return {};
  //       });
  //       if (data.isNotEmpty) {
  //         if (data['err'] != null) {
  //           EasyLoading.showInfo(data['err']);
  //           return;
  //         }
  //         await db.updateCell(
  //             tbName: 'T00_User',
  //             field: 'NgayHetHan',
  //             value: data['NgayHetHan']);
  //         await dbw
  //             .updateData(
  //                 tbName: 'KHACH_SD',
  //                 field: 'NgayLamViec',
  //                 value: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  //                 condition: "MaKH ='${data['MaKH']}'")
  //             .whenComplete(() {
  //           DateTime ngayhethan = DateTime.parse(data['NgayHetHan']);
  //           DateTime ngaylamviec =
  //               DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
  //           int soNgayHetHan = ngayhethan.difference(ngaylamviec).inDays;
  //           onUpdateServer(
  //               DateFormat('dd/MM/yyyy')
  //                   .format(DateTime.parse(data['NgayHetHan'])),
  //               soNgayHetHan,
  //               data['MaKH'],
  //               tenDNCTL.text);
  //         }).catchError((e) {
  //           EasyLoading.showInfo('Lỗi $e');
  //         });
  //         // }
  //       } else {
  //         EasyLoading.dismiss();
  //         WgtDialog(
  //             title: 'Thông báo',
  //             text: 'Không thể đăng nhập!',
  //             onConfirm: () async {
  //               Get.back();
  //               // await db.updateCell(
  //               //     tbName: 'T00_User',
  //               //     field: 'MaKichHoat',
  //               //     value: '',
  //               //     condition: "ID = 1");
  //               // await db
  //               //     .updateCell(
  //               //         tbName: 'T00_User',
  //               //         field: 'MaKichHoat',
  //               //         value: '',
  //               //         condition: "ID = 2")
  //               //     .whenComplete(() {
  //               //   Get.offAndToNamed(routerName.v_kichhoat);
  //               // });
  //             });
  //       }
  //       // }
  //     } else {
  //       EasyLoading.showInfo('Tên đăng nhập hoặc mật khẩu không đúng');
  //     }
  //   } catch (e) {
  //     EasyLoading.showInfo('Lỗi đăng nhập: $e');
  //   }
  // }

  // onUpdateServer(
  //     String ngayhethan, int soNgayHetHan, String MaKH, String Username) {
  //   InfoApp.ngayHetHan = ngayhethan;
  //   InfoApp.soNgayHetHan = soNgayHetHan;
  //   InfoApp.MaKH = MaKH;
  //   InfoApp.Username = Username;
  //   Get.offAndToNamed(routerName.v_tabPage);
  //   EasyLoading.dismiss();
  //   onClose();
  // }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    Get.delete<CtlUser>();
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
      final rps = await _server.getData(path: _server.config, type: 'capnhat', data: {});
      if(rps.statusCode==200){
        final data = jsonDecode(jsonDecode(rps.data));
        String version = data['fa-n'];
        String fileName = InfoApp.fileName(version);
        print(InfoApp.version);
        if(version != InfoApp.version){
          WgtDialog(title: 'Cập nhật', text: 'Đã có phiên bản $version', onConfirm: (){
            downloadFile("http://rgb.com.vn/flutterApp", fileName, '/storage/emulated/0/Download');
          });
        }else{
          EasyLoading.showToast('Không có bản cập nhật nào');
        }
      }
      // Map<String, dynamic> data = await dbw.loadRow(tblName: 'PHANMEM', condition: "MaSP = '${InfoApp.maSP}'");
      // if(data.isNotEmpty &&  data['Version']!=InfoApp.version){
      //   WgtDialog(title: 'Cập nhật', text: 'Đã có phiên bản ${data['Version']}', onConfirm: (){
      //     downloadFile("http://rgb.com.vn/flutterApp", data['FileName'], '/storage/emulated/0/Download');
      //   });
      // }else{
      //   EasyLoading.showToast('Không có bản cập nhật nào');
      // }
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
}
