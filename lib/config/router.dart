// ignore_for_file: camel_case_types, constant_identifier_names

import 'package:get/get.dart';
import 'package:sd_pmn/controllers/ctl_thaythetukhoa.dart';
import 'package:sd_pmn/controllers/clt_kqxs.dart';
import 'package:sd_pmn/controllers/ctl_baocao.dart';
import 'package:sd_pmn/controllers/ctl_khach.dart';
import 'package:sd_pmn/views/baocao/v_bc_tongtien.dart';
import 'package:sd_pmn/views/baocao/wgt_bc_tonghop/v_bc_chitiet.dart';
import 'package:sd_pmn/views/caidat/v_caidat.dart';
import 'package:sd_pmn/views/khach/v_lstkhach.dart';
import 'package:sd_pmn/views/khach/v_themkhach.dart';
import 'package:sd_pmn/views/kqxs/v_kqxs.dart';
import 'package:sd_pmn/views/quanlytin/v_qltin_ct.dart';
import 'package:sd_pmn/views/quanlytin/v_xemchitiet.dart';
import 'package:sd_pmn/views/thaythetukhoa/v_thaythetukhoa.dart';
import 'package:sd_pmn/views/user/v_kichhoat.dart';
import 'package:sd_pmn/views/user/v_login.dart';
import 'package:sd_pmn/views/xuly/v_tinsms.dart';
import 'package:sd_pmn/views/xuly/v_xuly.dart';
import 'package:sd_pmn/widgets/tab_pages.dart';

import '../controllers/ctl_quanlytin.dart';
import '../controllers/ctl_xuly.dart';


abstract class routerName{
  static const String v_init = "/";
  static const String v_xuly = "/v_xuly";
  static const String v_lstKhach = "/v_lstkhach";
  static const String v_kqxs = "/v_kqxs";
  static const String v_themkhach = "/v_themkhach";
  static const String v_thaythetukhoa = "/v_thaythetukhoa";
  static const String v_bcTongTien = "/v_bctongtien";
  static const String v_caidat = "/v_caidat";
  static const String v_qltin_ct = "/v_qltin_ct";
  static const String v_bcChiTiet = "/v_bc_chitiet";
  static const String v_login = "/v_login";
  static const String v_kichhoat = "/v_kichhoat";
  static const String v_tabPage = "/v_tabPage";
  static const String v_tinsms = "/v_tinsms";
  static const String v_xemchitiet = "/v_xemchitiet";

}



List<GetPage> getRouter(){
  return [
    GetPage(name: routerName.v_init, page: ()=>V_Login()),
    GetPage(name: routerName.v_tabPage, page: ()=> TabPage(),bindings: [
      BindingsBuilder(()=>Get.lazyPut(() => Ctl_Khach())),
      BindingsBuilder(()=>Get.lazyPut(() => Ctl_Xuly())),
      BindingsBuilder(()=>Get.lazyPut(() => Ctl_Quanlytin())),
      BindingsBuilder(()=>Get.lazyPut(() => Ctl_BaoCaoTongHop())),
    ]),
    GetPage(name: routerName.v_lstKhach, page: ()=>const V_LstKhach()),
    GetPage(name: routerName.v_kqxs, page: ()=>const V_Kqxs(),binding: BindingsBuilder(()=>Get.lazyPut(() => Ctl_Kqxs()))),
    GetPage(name: routerName.v_themkhach, page: ()=>V_ThemKhach()),
    GetPage(name: routerName.v_thaythetukhoa, page: ()=>const V_ThaytheTK(),binding: BindingsBuilder(()=>Get.lazyPut(() => Ctl_ThaytheTK()))),
    GetPage(name: routerName.v_bcTongTien, page: ()=>const V_BcTongTien(),binding: BindingsBuilder(()=>Get.lazyPut(() => Ctl_BaoCaoTongTien()))),
    GetPage(name: routerName.v_caidat, page: ()=> V_CaiDat()),
    GetPage(name: routerName.v_qltin_ct, page: ()=>const V_QLTin_CT()),
    GetPage(name: routerName.v_xuly, page: ()=> V_Xuly()),
    GetPage(name: routerName.v_bcChiTiet, page: ()=>const VBC_ChiTiet()),
    // GetPage(name: routerName.v_dangky, page: ()=>  V_DangKy()),
    GetPage(name: routerName.v_login, page: ()=>  V_Login()),
    GetPage(name: routerName.v_xemchitiet, page: ()=>  V_XemChiTiet()),
    GetPage(name: routerName.v_kichhoat, page: ()=>  V_KichHoat()),
    GetPage(name: routerName.v_tinsms, page: ()=>const V_TinSMS()),

  ];
}

