import 'dart:async';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:sd_pmn/config/config.dart';

import 'db_connect.dart';

class AuthData{
  String get login => 'khach-login';
  String get kichHoat => 'khach-kich-hoat';

  final _db = ConnectDB();
  final _server = ConfigServer();
  Future<String> checkLogin(String userName, String passWord) async{
        Map<String, dynamic> user = await _db.loadRow(
            tblName: 'T00_User',
            Condition:
                "UserName = '$userName' AND PassWord = '$passWord'");
        return user.isNotEmpty ? user['MaKichHoat'] : 'empty';
  }

  Future<String> getNgayHetHan() async{
    return await _db.dLookup('NgayHetHan', 'T00_User', 'ID = 1');
  }

  Future<void> updateNgayHetHan(String date) async{
    await _db.updateCell(tbName: 'T00_User',value: date,field: 'NgayHetHan');
  }

  Future<void> updateMaKichHoat(String maKichHoat) async{
    await _db.updateCell(tbName: 'T00_User',value: maKichHoat,field: 'MaKichHoat');
  }

  Future<Response> xacThuc(String maKichHoat) async{
     return await _server.getData(path: _server.auth, type: login, data: {
      'MaKichHoat': maKichHoat
    });
  }

  int getSoNgayConLai(String date){
    DateTime now = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    DateTime thoiHan  = DateTime.parse(date);
    return thoiHan.difference(now).inDays;
  }
}

