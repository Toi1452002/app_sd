import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/function/function.dart';
import '../config/config.dart';

class Wgt_Drawer extends StatelessWidget {
  const Wgt_Drawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0)
        ),
        // backgroundColor: Colors.blue,

        child: Column(
          // padding: EdgeInsets.zero,
          mainAxisSize: MainAxisSize.max,
          children:  [
             SizedBox(
             height: 120,
              width: Get.width,
              child: DrawerHeader(decoration: const BoxDecoration(
                color: Sv_Color.main
              ),child: Obx((){
                final iUser = infoUser.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Mã HD: ${iUser.maHD}',style: TextStyle(color: Colors.white)),
                    Text("Ngày HH: ${Helper.dMy(iUser.ngayHetHan)} (Còn ${iUser.soNgayCon})",style: TextStyle(color: Colors.white),),
                    Spacer(),
                    Text("Phiên bản: ${InfoApp.version}",style: const TextStyle(color: Colors.white60,fontSize: 12),)
                  ],
                );
              }),),
            ),
            item(icon: const Icon(Icons.perm_contact_cal_rounded), title: "Danh sách khách",onTap: (){
              Get.back();
              Get.toNamed(routerName.v_lstKhach);
            }),
            item(icon: const Icon(Icons.table_chart), title: "Kết quả xổ số",onTap: (){
              Get.back();
              Get.toNamed(routerName.v_kqxs);
            }),
            item(icon: const Icon(Icons.change_circle), title: "Thay thế từ khóa",onTap: (){
              Get.back();
              Get.toNamed(routerName.v_thaythetukhoa);
            }),
            item(icon: const Icon(Icons.monetization_on_outlined), title: "Báo cáo tổng tiền",onTap: (){
              Get.back();
              Get.toNamed(routerName.v_bcTongTien);
            }),
            item(icon: const Icon(Icons.settings), title: "Cài đặt",onTap: (){
              Get.back();
              Get.toNamed(routerName.v_caidat);
            }),
            Spacer(),
            item(icon: const Icon(Icons.logout,color: Colors.red,), title: "Thoát",colors: Colors.red,onTap: (){
              // SystemNavigator.pop();
              exit(0);
            }),
          ],
        ),
      ),
    );
  }
}


ListTile item({
  required Icon icon,
  required String title,
  void Function()? onTap,
  Color? colors
}){
  return ListTile(
    leading: icon,
    title: Text(title,style: TextStyle(color: colors),),
    onTap: onTap,
  );
}