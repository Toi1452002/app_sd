// ignore_for_file: camel_case_types, constant_identifier_names

import 'package:get/get.dart';
import 'package:sd_pmn/controllers/clt_kqxs.dart';
import 'package:sd_pmn/controllers/ctl_khach.dart';
import 'package:sd_pmn/views/baocao/v_bc_tongtien.dart';
import 'package:sd_pmn/views/caidat/v_caidat.dart';
import 'package:sd_pmn/views/khach/v_lstkhach.dart';
import 'package:sd_pmn/views/khach/v_themkhach.dart';
import 'package:sd_pmn/views/kqxs/v_kqxs.dart';
import 'package:sd_pmn/views/quanlytin/v_qltin_ct.dart';
import 'package:sd_pmn/views/thaythetukhoa/v_thaythetukhoa.dart';
import 'package:sd_pmn/views/xuly/v_xuly.dart';
import 'package:sd_pmn/widgets/tab_pages.dart';


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

}



List<GetPage> getRouter(){
  return [
    GetPage(name: routerName.v_init, page: ()=> TabPage()),
    GetPage(name: routerName.v_lstKhach, page: ()=>const V_LstKhach()),
    GetPage(name: routerName.v_kqxs, page: ()=>const V_Kqxs(),binding: BindingsBuilder(()=>Get.lazyPut(() => Ctl_Kqxs()))),
    GetPage(name: routerName.v_themkhach, page: ()=>V_ThemKhach(),binding: BindingsBuilder(()=>Get.lazyPut(() => Ctl_GiaKhach()))),
    GetPage(name: routerName.v_thaythetukhoa, page: ()=>const V_ThaytheTK()),
    GetPage(name: routerName.v_bcTongTien, page: ()=>const V_BcTongTien()),
    GetPage(name: routerName.v_caidat, page: ()=>const V_CaiDat()),
    GetPage(name: routerName.v_qltin_ct, page: ()=>const V_QLTin_CT()),
    GetPage(name: routerName.v_xuly, page: ()=>const V_Xuly()),
  ];
}

