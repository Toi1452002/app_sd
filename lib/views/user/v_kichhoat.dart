import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/controllers/ctl_user.dart';


import '../../config/server.dart';
import '../../widgets/wgt_button.dart';
import '../../widgets/wgt_textfield.dart';

class V_KichHoat extends StatelessWidget {
  V_KichHoat({super.key});
  CtlUser controller = Get.put(CtlUser());
  final txtMaKichHoat = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Sv_Color.main_1[100],
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              // height: 300,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blueGrey,
                        blurRadius: 5,
                        offset: Offset(2, 2))
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10,),
                  // WgtTextField(
                  //   enable: false,
                  //   textAlign: TextAlign.center,
                  //   controller: TextEditingController(text: InfoApp.idDevice),
                  // ),
                  // const SizedBox(height: 10,),
                  // Wgt_button(onPressed: (){
                  //   Clipboard.setData(ClipboardData(text: InfoApp.idDevice));
                  //   EasyLoading.showToast('Đã sao chép');
                  // }, text: 'Copy',height: 40,),
                  // const SizedBox(height: 40,),
                  WgtTextField(
                    hintText: 'Nhập mã kích hoạt',
                    controller: txtMaKichHoat,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10,),
                  Wgt_button(onPressed: (){
                    controller.onKichHoat(txtMaKichHoat.text);
                  }, text: 'Kích hoạt',height: 40),
                  const SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }
}
