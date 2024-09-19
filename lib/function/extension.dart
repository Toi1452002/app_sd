import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:sd_pmn/config/server.dart';

extension Bool on String{
  bool get toBool=> int.parse(this)==0 ? false : true;
}

extension Numeric on String {
  bool get isNumeric => num.tryParse(this) != null ? true : false;
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

extension Double on String {
  double get toDouble => isNumeric ? double.parse(this) : 0.0;
}
extension FormatDouble on String {
  String get formatDouble {
    if(isNumeric){
      String tmp = toString().toDouble.toStringAsFixed(1);
      if(tmp.lastChars(1)=='0'){
        return NumberFormat('#,###').format(toString().toDouble);
      }else{
        return tmp.replaceAll('.', ',');
      }
    }else{
      return '';
    }
  }
}
//
Future<String> idDevice() async{
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  try{
    if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      InfoApp.API_DEVICE = androidInfo.version.sdkInt;
      return "${androidInfo.id}.${randomStr()}${randomNumber()}";
    }else if(Platform.isIOS){
      String ma = "MLGK.";
      String time = DateTime.now().microsecondsSinceEpoch.toString();
      return "$ma${randomStr()}${time.substring(0,4)}.${randomStr()}${time.substring(4,8)}.${randomStr()}${time.substring(time.length-4)}";
    }

    else{
      final wd = await deviceInfo.windowsInfo;
      return wd.deviceId.replaceAll('{', '').replaceAll('}', '');
    }
  }catch(e){
    String ma = "MLGK.";
    String time = DateTime.now().microsecondsSinceEpoch.toString();
    return "$ma${randomStr()}${time.substring(0,4)}.${randomStr()}${time.substring(4,8)}.${randomStr()}${time.substring(time.length-4)}";
  }
}

String randomStr(){
  List<String> lstText = ['A','B','C','D','E','F','J','L','G','T','K','P','W','X','Y','Z'];
  return (lstText..shuffle()).first;
}

replaceMien(String s){
  Map<String,String> x = {
    'N': 'Nam',
    'T': 'Trung',
    'B': 'Bắc'
  };
  return x[s];
}
String randomNumber(){
  List<String> lstText = ['0','1','2','3','4','5','6','7','8','9'];
  return (lstText..shuffle()).join('').lastChars(4);
}
bool isValidPhoneNumber(String string) {
  // Null or empty string is invalid phone number
  if (string.isEmpty) {
    return false;
  }

  // You may need to change this pattern to fit your requirement.
  // I just copied the pattern from here: https://regexr.com/3c53v
  const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
  final regExp = RegExp(pattern);

  if (!regExp.hasMatch(string)) {
    return false;
  }
  return true;
}