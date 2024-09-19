import 'package:intl/intl.dart';

class Helper{
  static String dMy(String date){
    if(date == '') return '';
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
  }
}