import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sd_pmn/config/router.dart';
import 'package:sd_pmn/config/server.dart';
import 'package:sd_pmn/controllers/ctl_user.dart';

import '../../widgets/wgt_button.dart';
import '../../widgets/wgt_textfiled.dart';

class V_Login extends StatelessWidget {
    V_Login({super.key});
  Ctl_User controller = Get.put(Ctl_User());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Sv_Color.main_1[100],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              // height: 300,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blueGrey,
                        blurRadius: 2,
                        offset: Offset(2, 2))
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [

                  const SizedBox(
                    height: 10,
                  ),
                  Wgt_TextField(
                    labelText: "Tài khoản",
                    icon: const Icon(Icons.person),
                    controller: controller.tenDNCTL,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wgt_TextField(
                    labelText: "Mật khẩu",
                    icon: const Icon(Icons.lock_outline),
                    controller: controller.matkhauDNCTL,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Wgt_button(
                      height: 40,
                      onPressed: () {
                        controller.onLogin();
                      },
                      text: "Đăng nhập"),
                  SizedBox(height: 10,)
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
}
