import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/config/router.dart';

import '../config/server.dart';

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
              ),child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Mã khách: ${Info_App.MaKH}',style: TextStyle(color: Colors.white)),
                  Text("Ngày HH: ${Info_App.ngayHetHan} (Còn ${Info_App.soNgayHetHan})",style: TextStyle(color: Colors.white),),
                  Spacer(),
                  Text("Phiên bản: ${Info_App.version}",style: const TextStyle(color: Colors.white60,fontSize: 12),)
                ],
              ),),
            ),
            item(icon: const Icon(Icons.perm_contact_cal_rounded), title: "Danh sách khách hàng",onTap: (){
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
              SystemNavigator.pop();
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