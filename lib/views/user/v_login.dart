import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/config/config.dart';
import 'package:sd_pmn/controllers/ctl_user.dart';
import '../../widgets/widgets.dart';

class V_Login extends StatelessWidget {
    V_Login({super.key});
  CtlUser controller = Get.put(CtlUser());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Sv_Color.main_1[100],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Đăng nhập vào ứng dụng',style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey
                ),),
                const SizedBox(
                  height: 10,
                ),
                WgtTextField(
                  labelText: "Tài khoản",
                  // hasBoder: false,
                  fillColor: Colors.white.withOpacity(.8),
                  icon: const Icon(Icons.person),
                  controller: controller.tenDNCTL,
                ),
                const SizedBox(
                  height: 10,
                ),
                WgtTextField(
                  labelText: "Mật khẩu",
                  icon: const Icon(Icons.lock_outline),
                  fillColor: Colors.white.withOpacity(.8),
                  controller: controller.matkhauDNCTL,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                Wgt_button(
                    height: 40,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      controller.onLogin();
                    },
                    text: "Đăng nhập"),
                const SizedBox(height: 20,),
                TextButton(onPressed: (){
                  Get.toNamed(routerName.v_kichhoat);
                }, child: const Text('Kích hoạt ứng dụng',style: TextStyle(
                  decoration: TextDecoration.underline
                ),))
              ],
            ),
          ),
        ),
      ),
    );

  }
}
