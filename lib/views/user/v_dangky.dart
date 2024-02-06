// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sd_pmn/controllers/ctl_user.dart';
//
// import '../../config/server.dart';
// import '../../widgets/wgt_button.dart';
// import '../../widgets/wgt_textfiled.dart';
//
// class V_DangKy extends StatelessWidget {
//     V_DangKy({super.key});
//   Ctl_User controller = Get.put(Ctl_User());
//   @override
//   Widget build(BuildContext context) {
//     RxBool b_xemMk = false.obs;
//     RxBool b_xemMk1 = false.obs;
//     return GestureDetector(
//       onTap: ()=>FocusScope.of(context).requestFocus(FocusNode()),
//       child: Scaffold(
//         backgroundColor: Sv_Color.main_1[100],
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               height: 500,
//               decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.blueGrey,
//                         blurRadius: 10,
//                         offset: Offset(3, 3))
//                   ]),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   const Text(
//                     "Đăng ký tài khoản",
//                     style: TextStyle(color: Colors.blue, fontSize: 25,fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(
//                     height: 40,
//                   ),
//
//                   Wgt_TextField(
//                     labelText: "Họ và tên",
//                     icon: const Icon(Icons.person),
//                     controller: Ctl_User().to.hovatenCTL,
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Wgt_TextField(
//                     labelText: "Số điện thoại",
//                     textInputType: TextInputType.phone,
//                     icon: const Icon(Icons.phone),
//                       controller: Ctl_User().to.sdtCTL
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Wgt_TextField(
//                     labelText: "Tên đăng nhập",
//                     icon: const Icon(Icons.perm_contact_cal),
//                       controller: Ctl_User().to.tenDangNhapCTL
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Obx(() => Wgt_TextField(
//                     labelText: "Mật khẩu",
//                     icon: const Icon(Icons.lock_outline),
//                     controller: Ctl_User().to.matkhauCTL,
//                     obscureText: b_xemMk.value ? false : true,
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.remove_red_eye_outlined),
//                       onPressed: (){
//                         b_xemMk.value = !b_xemMk.value;
//                       },
//                     ),
//                   )),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Obx(() => Wgt_TextField(
//                     labelText: "Xác nhận mật khẩu",
//                     icon: const Icon(Icons.lock),
//                     controller: Ctl_User().to.xacnhanmatkhauCTL,
//                     obscureText: b_xemMk1.value ? false : true,
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.remove_red_eye_outlined),
//                       onPressed: (){
//                         b_xemMk1.value = !b_xemMk1.value;
//                       },
//                     ),
//                   )),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Wgt_button(
//                       height: 50,
//                       onPressed: () {
//                         Ctl_User().to.onDangKy();
//                       },
//                       text: "Đăng ký"),
//                   // SizedBox(height: 10,),
//                   // TextButton(onPressed: (){}, child: Text("Đăng ký tài khoản"))
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
