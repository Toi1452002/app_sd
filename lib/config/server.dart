// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/models.dart';

Rx<InfoUser> infoUser = InfoUser(userName: '').obs;

class Sv_Color {
  static const main  = Colors.blueGrey;
  static const main_1  = Colors.teal;
}

class InfoApp{
  static String version = "";
  static String idDevice = "";
  // static String ngayHetHan = "";
  // static int soNgayHetHan = 0;
  static int API_DEVICE = 0;
  // static String MaKH = '';
  // static String Username = "";
  static String maSP = "fa-n";
  static String pathData = "D:/data_access/DataSDN_1.db";
  static String nameData = "DataSDN_1.db";


  static String fileName(String verSion){
    return 'appSD_$verSion.apk';
  }
}

class Sv_String{
  static String noHasNetwork = "Không có Internet";
  static String deleteItem = "Có chắc muốn xóa?";
}

// class API{
//   static String pathDB = "http://rgb.com.vn/web/php/connectDb.php";
//   static String pathJson = "http://rgb.com.vn/web/php/wfile.php";
  // static String pathDB = "http://192.168.1.7:8000/pmn_quanly/connectDb.php";
  // static String pathJson = "http://192.168.1.7:8000/pmn_quanly/wfile.php";
// }

// class TypeAPI{
//   static String read = 'read';
//   static String insert = 'insert';
//   static String delete = 'delete';
//   static String update = 'update';
//
// }