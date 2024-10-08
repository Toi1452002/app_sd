// import 'dart:convert';
//
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http/http.dart' as http;
// import '../config/server.dart';
// class ConnectDBW{
//   var url = Uri.parse(API.pathDB);
//
//   Future<List<Map<String, dynamic>>> loadData({String sql = '', String tblName = '', String condition = ''}) async {
//     List<Map<String, dynamic>> data = [];
//     String loadSql = '';
//     if(sql!='') {
//       loadSql = sql;
//     } else if(tblName!=''){
//       loadSql = "SELECT * FROM $tblName";
//       if(condition != '') loadSql += "Where $condition";
//     }
//     try{
//       final response = await http.post(url,
//           body: {
//             "Type":  TypeAPI.read,
//             "SQL": loadSql
//           }
//       );
//       if(response.statusCode==200){
//         List<dynamic> row = jsonDecode(response.body);
//         if(row[0]!=false) data = row.map((e) => e as Map<String, dynamic>).toList();
//       }else{
//         EasyLoading.showError("Đường truyền lỗi!");
//       }
//     }catch(e){
//       print(e);
//     }
//     return data;
//   }
//
//   Future<Map<String, dynamic>> loadRow({required String tblName,required String condition}) async{
//     Map<String, dynamic> data = {};
//     try{
//       final response = await http.post(url,
//           body: {
//             "Type":  TypeAPI.read,
//             "SQL": "SELECT * FROM $tblName WHERE $condition"
//           }
//       );
//       if(response.statusCode==200){
//         List<dynamic> row = jsonDecode(response.body);
//         if(row.isNotEmpty &&  row[0]!=false) data = row.map((e) => e as Map<String, dynamic>).toList().first;
//
//       }else{
//         data = {'err':'Mạng không ổn định'};
//         EasyLoading.showError("Đường truyền lỗi!");
//       }
//     }catch(e){
//       print(e);
//     }
//     return data;
//   }
//
//   // dLookup({required String fieldName, required String tblName, required String condition}) async{
//   //   var result;
//   //   try{
//   //     final response = await http.post(url,
//   //         body: {
//   //           "Type":  TypeAPI.read,
//   //           "SQL": "SELECT $fieldName FROM $tblName WHERE $condition"
//   //         }
//   //     );
//   //     if(response.statusCode==200){
//   //       List<dynamic> row = jsonDecode(response.body) ;
//   //       if(row.isNotEmpty && row[0]!=false) result = row.map((e) => e as Map<String, dynamic>).toList().first[fieldName];
//   //
//   //     }else{
//   //       EasyLoading.showError("Đường truyền lỗi!");
//   //     }
//   //   }catch(e){
//   //     print(e);
//   //   }
//   //   return result;
//   // }
//
//   // Future<int> insertRow({required Map<String, dynamic> data, required String tblName, List<String>? fieldNumber}) async{
//   //   int ID = 0;
//   //   List<dynamic> value = [];
//   //   data.forEach((k, v) {
//   //     if(fieldNumber!=null && fieldNumber.contains(k)){
//   //       value.add(v);
//   //     }else if(v.toString()!='null'){
//   //        value.add("'$v'");
//   //     }else{
//   //       value.add(v);
//   //     }
//   //   });
//   //   String strValue = "(${value.join(',')})";
//   //   String fileds = "(${data.keys.toList().join(',')})";
//   //   String sql = "INSERT INTO $tblName$fileds VALUES $strValue";
//   //   try{
//   //     final response = await http.post(url,
//   //         body: {
//   //           "Type":  TypeAPI.insert,
//   //           "SQL": sql
//   //         }
//   //     );
//   //     if(response.statusCode==200){
//   //       ID = jsonDecode(response.body);
//   //     }else{
//   //       EasyLoading.showError("Đường truyền lỗi!");
//   //     }
//   //   }catch(e){
//   //     print(e);
//   //   }
//   //   return ID;
//   // }
//
//   // Future<void> deleteData({String tbName = '', String condition = "", String sql = ''}) async {
//   //
//   //   String tmp = '';
//   //   if(sql!='') {
//   //     tmp = sql;
//   //   }else if(tbName!=''){
//   //     tmp = 'DELETE * FROM $tbName';
//   //     if(condition != '') tmp += " WHERE $condition";
//   //   }
//   //
//   //   try{
//   //     final response = await http.post(url,
//   //         body: {
//   //           "Type":  TypeAPI.delete,
//   //           "SQL": tmp
//   //         }
//   //     );
//   //     if(response.statusCode==200){
//   //       EasyLoading.showToast('Xóa thành công');
//   //     }else{
//   //       EasyLoading.showError("Đường truyền lỗi!");
//   //     }
//   //   }catch(e){
//   //     print(e);
//   //   }
//   // }
//
//   Future<void> updateData({String tbName = '',String field = '',var value ,String condition = '', String sql = ''})async {
//     try{
//       final response = await http.post(url,
//           body: {
//             "Type":  TypeAPI.update,
//             "SQL": sql != '' ? sql :  "Update $tbName Set $field = '$value' Where $condition"
//           }
//       );
//       if(response.statusCode==200){
//         // print('Updated');
//         // EasyLoading.showToast('Xóa thành công');
//       }else{
//         EasyLoading.showError("Đường truyền lỗi!");
//       }
//     }catch(e){
//       print(e);
//     }
//   }
//
//   // Future<bool> ktra_tontai({String tbName = '', String field = '', String condition = '', int boquaID = 0 }) async{
//   //   bool b = false;
//   //   try{
//   //     final response = await http.post(url,
//   //         body: {
//   //           "Type":  TypeAPI.read,
//   //           "SQL": "SELECT $field FROM $tbName WHERE $condition"
//   //         }
//   //     );
//   //     if(response.statusCode==200){
//   //       Map<String, dynamic> data = {};
//   //       List<dynamic> row = jsonDecode(response.body);
//   //       if(row[0]!=false) {
//   //         data = row.map((e) => e as Map<String, dynamic>).toList().first;
//   //         if(data.isNotEmpty && boquaID==0) b= true;
//   //         if(data.isNotEmpty && boquaID!=0 && data[0]["ID"]!=boquaID)b = true;
//   //       }
//   //     }else{
//   //       EasyLoading.showError("Đường truyền lỗi!");
//   //     }
//   //   }catch(e){
//   //     print(e);
//   //   }
//   //   return b;
//   // }
//
//   // Future<void> insertList({required List<Map<String, dynamic>> lstData,required String tbName, List<String>? fieldNumber}) async{
//   //   var lstField = lstData[0].keys.join(",");
//   //   int i = 0;
//   //   var lstValue = lstData.map((e) {
//   //     e.forEach((key, value) {
//   //       if(fieldNumber!=null && fieldNumber.contains(key)) {lstData[i][key] = value;}
//   //       else if(value.toString()!='null'){
//   //         lstData[i][key] = "'$value'";
//   //       }else{
//   //         lstData[i][key] = value;
//   //       }
//   //     });
//   //     i+=1;
//   //     return e.values.toList();
//   //   }).toList();
//   //   String str_value =  lstValue.join(",").replaceAll("[", "(").replaceAll(']', ')');
//   //   String sql = '''
//   //     INSERT INTO $tbName($lstField) VALUES $str_value
//   //   ''';
//   //   try{
//   //     final response = await http.post(url,
//   //         body: {
//   //           "Type":  TypeAPI.insert,
//   //           "SQL": sql
//   //         }
//   //     );
//   //     if(response.statusCode==200){
//   //       print('Insert success');
//   //     }else{
//   //       EasyLoading.showError("Đường truyền lỗi!");
//   //     }
//   //   }catch(e){
//   //     print(e);
//   //   }
//   // }
//
// }