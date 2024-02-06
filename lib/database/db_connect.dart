// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:sd_pmn/database/create_database/create_table.dart';
import 'package:sd_pmn/database/create_database/create_view.dart';
import 'package:sd_pmn/database/create_database/insert_table.dart';
import 'package:sd_pmn/function/extension.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

///Windown
//app
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';

///
import '../config/server.dart';

class ConnectDB {
  // Windown
  Future<Database?> init() async {
    if (Platform.isWindows) {
      try {
        if (await File(Info_App.pathData).exists()) {
          Database? db = await databaseFactory.openDatabase(Info_App.pathData);
          return db;
        } else {
          print("Database không tồn tại");
        }
      } catch (e) {
        print("Lỗi kết nối: $e");
      }
    } else {
      // Android
      var dbPath = await getDatabasesPath();
      var path = join(dbPath, Info_App.nameData);
      var exist = await databaseExists(path);
      if (exist) {
        // print('Đã có data');
        return await openDatabase(path);
      } else {
        print('Chưa có data');
        if (Info_App.API_DEVICE >= 30) {
          print("Creating new copy from asset API >= 30");
          try {
            await Directory(dirname(path)).create(recursive: true);
          } catch (_) {}
          ByteData data =
              await rootBundle.load(join("assets", Info_App.nameData));
          List<int> bytes =
              data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
          await File(path).writeAsBytes(bytes, flush: true);
          return await openDatabase(path);
        } else {
          print('API < 30');
          return await openDatabase(path, version: 2, onCreate: (db, vs) async {
            await db.execute(T00_TuyChon); await db.rawInsert(INSERT_T00_TuyChon);
            await db.execute(T00_User);await db.rawInsert(INSERT_T00_User);
            await db.execute(T01_Giai);await db.rawInsert(INSERT_T01_Giai);
            await db.execute(T01_KieuChoi);await db.rawInsert(INSERT_T01_KieuChoi);
            await db.execute(T01_MaDai);await db.rawInsert(INSERT_T01_MaDai);
            await db.execute(T01_MaKieu);await db.rawInsert(INSERT_T01_MaKieu);
            await db.execute(T01_TuKhoa);await db.rawInsert(INSERT_T01_TuKhoa);
            await db.execute(TDM_GiaKhach);
            await db.execute(TDM_Khach);
            await db.execute(TXL_KQXS);
            await db.execute(TXL_TinNhan);
            await db.execute(TXL_TinNhanCT);
            await db.execute(TXL_TinPhanTichCT);

            //Tạo view
            await db.execute(V_Trung_k1);
            await db.execute(V_Trung_k2);
            await db.execute(VBC_ChiTiet_diem);
            await db.execute(VBC_ChiTiet_k1);
            await db.execute(VBC_ChiTiet_k2);
            await db.execute(VBC_ChiTiet_k3);
            await db.execute(VBC_PtChiTiet_1);
            await db.execute(VBC_PtChiTiet_2);
            await db.execute(VBC_PtTongHop_k1);
            await db.execute(VBC_TongHop);
            await db.execute(VBC_TongHop_k1);
            await db.execute(VBC_TongHop_k2);
            await db.execute(VBC_TongHopTien);
            await db.execute(VBC_TongTienKhach);
            await db.execute(VBC_XuongNac);
            await db.execute(VBC_XuongNacCT);
            await db.execute(VBC_XuongNacTH);
            await db.execute(VDM_GiaKhach);
            await db.execute(VDM_GiaKhachMoi);
            await db.execute(VDM_Khach);
            await db.execute(VXL_MaDai);
            await db.execute(VXL_TinNhanCT);
            await db.execute(VXL_TongTienPhieu);

          });
        }
      }
    }
  }

  Future<List<Map<String, dynamic>>> loadData(
      {String tbName = '', String condition = '', String sql = ""}) async {
    Database? cnn = await init();
    List<Map<String, dynamic>> result = [];
    if (sql != '') {
      result = await cnn!.rawQuery(sql);
    } else if (condition == '') {
      result = await cnn!.query(tbName);
    } else {
      result = await cnn!.rawQuery('''
        SELECT * FROM $tbName WHERE $condition
      ''');
    }

    // cnn.close();
    return result;
  }

  Future<void> deleteData(
      {String tbName = '', String condition = "", String sql = ''}) async {
    Database? cnn = await init();
    if (sql != '') {
      await cnn!.rawDelete(sql);
    } else if (condition == '') {
      await cnn!.delete(tbName);
    } else {
      await cnn!.rawDelete('''
        DELETE FROM $tbName WHERE $condition
      ''');
    }
    // cnn.close();
  }

  dLookup(String FieldName, String TableName, String Condition) async {
    Database? cnn = await init();
    List<Map> x = await cnn!
        .rawQuery("SELECT $FieldName FROM $TableName WHERE $Condition");
    // cnn.close();
    return x.isNotEmpty ? x[0][FieldName] : '';
  }

  dSum(String FieldName, String TableName, String Condition) async {
    Database? cnn = await init();
    List<Map> x = await cnn!
        .rawQuery("SELECT SUM($FieldName) FROM $TableName WHERE $Condition");
    // cnn.close();
    return x[0].values.first;
  }

  Future<Map<String, dynamic>> loadRow(
      {String tblName = '', String Condition = '', String sql = ''}) async {
    Database? cnn = await init();
    List<Map<String, dynamic>> x = [];

    if (sql == '') {
      x = await cnn!.rawQuery("SELECT * FROM $tblName WHERE $Condition");
    } else {
      x = await cnn!.rawQuery(sql);
    }
    // cnn.close();
    return x.isEmpty ? {} : x[0];
  }

  Future<void> insertList(
      {required List<Map<String, dynamic>> lstData,
      required String tbName,
      String fieldToString = ''}) async {
    Database? cnn = await init();
    var lstField = lstData[0].keys.join(",");
    int i = 0;
    var lstValue = lstData.map((e) {
      e.forEach((key, value) {
        if (fieldToString != '' && key == fieldToString)
          lstData[i][key] = "'$value'";
        if (!value.toString().isNumeric && value.toString() != 'null')
          lstData[i][key] = "'$value'";
      });
      i += 1;
      return e.values.toList();
    }).toList();
    String str_value =
        lstValue.join(",").replaceAll("[", "(").replaceAll(']', ')');
    String sql = '''
      INSERT INTO $tbName($lstField) VALUES $str_value
    ''';

    await cnn!.rawInsert(sql);
    cnn.close();
  }

  Future<int> insertRow(
      {required Map<String, dynamic> map, required String tbName}) async {
    Database? cnn = await init();
    int ID = await cnn!.insert(tbName, map);
    cnn.close();
    return ID;
  }

  Future<void> updateCell(
      {String tbName = '',
      String field = '',
      var value,
      String condition = ''}) async {
    Database? cnn = await init();
    String sql = "Update $tbName Set $field = '$value'";
    if (condition != '') sql += "Where $condition";
    await cnn!.rawUpdate(sql);
    // cnn.close();
  }

  Future<void> updateRow(
      {String tbName = '', required Map<String, dynamic> map}) async {
    Database? cnn = await init();
    await cnn!.update(tbName, map, where: 'ID = ?', whereArgs: [map['ID']]);
    cnn.close();
  }

  dCount(String TableName, {String Condition = ''}) async {
    Database? cnn = await init();
    final x;
    if (Condition == '') {
      x = await cnn!.rawQuery('SELECT COUNT(*) FROM $TableName');
    } else {
      x = await cnn!
          .rawQuery("SELECT COUNT(*) FROM $TableName WHERE $Condition");
    }
    cnn.close();
    return x[0]['COUNT(*)'];
  }

  Future<bool> ktra_tontai(
      {String tbName = '', String condition = '', int boquaID = 0}) async {
    Database? cnn = await init();

    bool b = false;
    List<Map> row = await cnn!.rawQuery('''
      SELECT ID FROM $tbName WHERE $condition
    ''');
    if (row.isNotEmpty && boquaID == 0) b = true;
    if (row.isNotEmpty && boquaID != 0 && row[0]["ID"] != boquaID) b = true;
    cnn.close();
    return b;
  }
}
