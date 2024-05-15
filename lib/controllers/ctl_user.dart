import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sd_pmn/database/connect_dbw.dart';
import 'package:sd_pmn/widgets/wgt_dialog.dart';
import '../config/config.dart';
import '../database/db_connect.dart';
import '../function/extension.dart';

class CtlUser extends GetxController{
  ///Gọi hàm kết nối database
  ConnectDB db = ConnectDB();
  ConnectDBW dbw = ConnectDBW();

  CtlUser get to => Get.find();

  final pathCTl = TextEditingController();


  @override
  void onInit() async{

    // List<Map> row = await db.loadData(tbName: 'T00_User');
    // if((row.last['MaKichHoat'] == null || row.last['MaKichHoat']=='' )){
    //   Get.offAllNamed(routerName.v_kichhoat);
    // }
    super.onInit();
  }



/// -----------------------------------------------------------------------------------------*
/// -----------------------------------------------------------------------------------------*
/// -----------------------------------------------------------------------------------------*
/// Nhập mã kích hoạt
  final makichhoatCTL = TextEditingController();
  onKichHoat() async {
    if(!await hasNetwork()) {EasyLoading.showToast(Sv_String.noHasNetwork);return;}
    if(makichhoatCTL.text.isEmpty || !makichhoatCTL.text.contains('-')){
      EasyLoading.showInfo('Mã không hợp lệ');
      return;
    }
    EasyLoading.show(status: 'Loading...',dismissOnTap: false);


    try{
      String makh = makichhoatCTL.text.substring(makichhoatCTL.text.lastIndexOf('-')+1);
      String mathietbi = makichhoatCTL.text.substring(0,makichhoatCTL.text.lastIndexOf('-'));
      if(mathietbi!=Info_App.idDevice || makichhoatCTL.text==Info_App.idDevice){
        EasyLoading.showInfo('Mã không hợp lệ');
        return;
      }
      Map<String, dynamic> data = await dbw.loadRow(tblName: 'KHACH_SD', condition: "MaKH= '$makh' AND MaKichHoat = '${makichhoatCTL.text}' AND TrangThai = 0 AND DaXoa = 0");
      if(data.isEmpty){
        EasyLoading.showInfo('Mã không hợp lệ');
        return;
      }
      await dbw.updateData(tbName: 'KHACH_SD',field: 'TrangThai',value: 1,condition: "MaKH = '$makh'").whenComplete(() async {
        await db.updateCell(field: 'MaKichHoat',value: makichhoatCTL.text,tbName: 'T00_User');
        await db.updateCell(field: 'MaKH',value: makh,tbName: 'T00_User');
        EasyLoading.showSuccess('Kích hoạt thành công');
        Future.delayed(const Duration(seconds: 2),()=>Get.offAndToNamed(routerName.v_login));
      }).catchError((e){
        EasyLoading.showInfo("Lỗi $e");
      });
    }catch(e){
      EasyLoading.showToast('Lỗi kích hoạt: $e');
    }

  }
/// -----------------------------------------------------------------------------------------*
/// -----------------------------------------------------------------------------------------*
/// -----------------------------------------------------------------------------------------*
/// Đăng nhập
  final tenDNCTL = TextEditingController();
  final matkhauDNCTL = TextEditingController();
  onLogin() async{
    EasyLoading.show(status: 'Loading...');
    try{
      Map<String, dynamic> user = await db.loadRow(tblName: 'T00_User',Condition:  "UserName = '${tenDNCTL.text.trim()}' AND PassWord = '${matkhauDNCTL.text.trim()}'");
      if(user.isNotEmpty){
        if(user['VinhVien'] == 1){
          if(!await hasNetwork()){///Nếu sài vĩnh viễn không có mạng thì vẫn đăng nhập được
            onUpdateServer('#', 0, user['MaKH'], tenDNCTL.text);
          }else{///Nếu có mạng thì cập nhật ngày làm lên data
            Map<String, dynamic> data = await dbw.loadRow(tblName: 'KHACH_SD', condition: "MaKH = '${user['MaKH']}' AND MaKichHoat = '${user['MaKichHoat']}' AND TrangThai = 1 AND DaXoa = 0");
            if(data.isNotEmpty){
              if(int.parse(data['HinhThuc'].toString())!=2){
                await db.updateCell(tbName: 'T00_User',field: 'VinhVien',value: 0);
                await db.updateCell(tbName: 'T00_User',field: 'NgayHetHan',value: data['NgayHetHan']);
                await dbw.updateData(tbName: 'KHACH_SD', field: 'NgayLamViec',value: DateFormat('yyyy-MM-dd').format(DateTime.now()),condition: "MaKH ='${data['MaKH']}'").whenComplete((){
                  DateTime ngayhethan = DateTime.parse(data['NgayHetHan']);
                  DateTime ngaylamviec = DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
                  int soNgayHetHan = ngayhethan.difference(ngaylamviec).inDays;
                  onUpdateServer(DateFormat('dd/MM/yyyy').format(DateTime.parse(data['NgayHetHan'])),
                      soNgayHetHan, data['MaKH'], tenDNCTL.text);

                }).catchError((e){
                  EasyLoading.showInfo('Lỗi $e');
                });
              }else{
                await dbw.updateData(tbName: 'KHACH_SD', field: 'NgayLamViec',value: DateFormat('yyyy-MM-dd').format(DateTime.now()),condition: "MaKH ='${data['MaKH']}'");
                onUpdateServer('#', 0,  user['MaKH'], tenDNCTL.text);
              }
            }else{//Không tìm thấy tài khoản
              EasyLoading.dismiss();
              WgtDialog(title: 'Thông báo', text: 'Không tìm thấy thiết bị, vui lòng kích hoạt ứng dụng!', onConfirm: () async {
                await db.updateCell(tbName: 'T00_User',field: 'MaKichHoat',value: '',condition: "ID = 1");
                await db.updateCell(tbName: 'T00_User',field: 'MaKichHoat',value: '',condition: "ID = 2").whenComplete((){
                  Get.offAndToNamed(routerName.v_kichhoat);
                });
              });
            }


          }
        }
        else{///Không sài vĩnh viễn
          if(!await hasNetwork()) {EasyLoading.showToast(Sv_String.noHasNetwork);return;}


          Map<String, dynamic> data = await dbw.loadRow(tblName: 'KHACH_SD', condition: "MaKH = '${user['MaKH']}' AND MaKichHoat = '${user['MaKichHoat']}' AND TrangThai = 1 AND DaXoa = 0");
          if(data.isNotEmpty){
            await db.updateCell(tbName: 'T00_User',field: 'NgayHetHan',value: data['NgayHetHan']);
            if(int.parse(data['HinhThuc'].toString())==2){
              await db.updateCell(tbName: 'T00_User',field: 'VinhVien',value: 1);
              await dbw.updateData(tbName: 'KHACH_SD', field: 'NgayLamViec',value: DateFormat('yyyy-MM-dd').format(DateTime.now()),condition: "MaKH ='${data['MaKH']}'");
              onUpdateServer('#', 0, user['MaKH'], tenDNCTL.text);
            }else{
              await db.updateCell(tbName: 'T00_User',field: 'VinhVien',value: 0);
              await dbw.updateData(tbName: 'KHACH_SD', field: 'NgayLamViec',value: DateFormat('yyyy-MM-dd').format(DateTime.now()),condition: "MaKH ='${data['MaKH']}'").whenComplete((){
                DateTime ngayhethan = DateTime.parse(data['NgayHetHan']);
                DateTime ngaylamviec = DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
                int soNgayHetHan = ngayhethan.difference(ngaylamviec).inDays;
                onUpdateServer(
                    DateFormat('dd/MM/yyyy').format(DateTime.parse(data['NgayHetHan'])),
                    soNgayHetHan,
                    data['MaKH'],
                    tenDNCTL.text
                );

              }).catchError((e){
                EasyLoading.showInfo('Lỗi $e');
              });
            }


        }
          else{//Nếu không tìm thấy trên web thì kích hoạt lại
            EasyLoading.dismiss();
            WgtDialog(title: 'Thông báo', text: 'Không tìm thấy thiết bị, vui lòng kích hoạt ứng dụng!', onConfirm: () async {
              await db.updateCell(tbName: 'T00_User',field: 'MaKichHoat',value: '',condition: "ID = 1");
              await db.updateCell(tbName: 'T00_User',field: 'MaKichHoat',value: '',condition: "ID = 2").whenComplete((){
                Get.offAndToNamed(routerName.v_kichhoat);
              });
            });

          }
        }
      }else{
        EasyLoading.showInfo('Tên đăng nhập hoặc mật khẩu không đúng');
      }
    }catch(e){
      EasyLoading.showInfo('Lỗi đăng nhập: $e');
    }
  }


  onUpdateServer(String ngayhethan, int soNgayHetHan, String MaKH, String Username){
    Info_App.ngayHetHan = ngayhethan;
    Info_App.soNgayHetHan = soNgayHetHan;
    Info_App.MaKH =  MaKH;
    Info_App.Username = Username;
    Get.offAndToNamed(routerName.v_tabPage);
    EasyLoading.dismiss();
    onClose();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    Get.delete<CtlUser>();
  }



}