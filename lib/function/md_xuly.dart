
import 'package:sd_pmn/database/db_connect.dart';
import 'package:sd_pmn/function/extension.dart';

import 'hamSoDanh.dart';
ConnectDB db = ConnectDB();
hamXL(String tin, DateTime ngay,String mien)async {
  List<String> result = [];
  /// -----------------------------------------------------------------------------------------*
  tin = ThayKyTu_TV(tin.toLowerCase());
  List<Map> lstDThayThe = await db.loadData(sql:"SELECT CumTu, ThayThe From T01_TuKhoa Where SoDanhHang!='1'  Order by length(CumTu) desc");
  for (var x in lstDThayThe) {
    tin = tin.replaceAll(x['CumTu'], x['ThayThe']??' ');
  }

  tin = thayTuKhoa(tin).trim().replaceAll(RegExp(r'[^\w\s]+'),' ').replaceAll(RegExp(' +'), '.');
  /// -----------------------------------------------------------------------------------------*
  List<String> lstTin = tin.split(".");
  ///
  List<Map> dbMadai = await db.loadData(sql: "SELECT  * FROM T01_MaDai") ;
  List lstMaDai= dbMadai.map((e) => e['MaDai']).toList();
  ///
  List  dbSohang = await db.loadData(sql: "SELECT CumTu,ThayThe FROM T01_TuKhoa WHERE SoDanhHang=1");
  List  lstSoHang = dbSohang.map((e) => e['CumTu']).toList();
  ///
  /// -----------------------------------------------------------------------------------------*
  List<String> lstDaiHT = [];
  if(mien!="B"){
    int thu = ngay.weekday - 1;
    List<Map<String, dynamic>> lstDaiHienTai = await db.loadData(sql: '''
      Select MaDai,substr(TT, INSTR(Thu,'$thu'), 1) as indexTT 
        From T01_MaDai 
        Where Mien = '$mien' 
        And Thu LIKE '%$thu%' 
        Order By indexTT
    ''');
    lstDaiHT = lstDaiHienTai.map((e) => e['MaDai'].toString()).toList();
  }
  /// -----------------------------------------------------------------------------------------*
  ///
  int i = 0;
  for(String x in lstTin){
    // ignore: iterable_contains_unrelated_type
    if(x!="n"&& i<lstTin.length-1 && lstTin[i+1]=="n"){
      x+="n";
      lstTin[i+1]="";
    }
    if(["dc",'dchinh'].contains(x) && lstDaiHT.isNotEmpty){result.add(lstDaiHT[0]);i+=1;continue;}
    if(["dp",'dphu'].contains(x) && lstDaiHT.isNotEmpty && lstDaiHT.length>1){result.add(lstDaiHT[1]);i+=1;continue;}
    if(x=="0" && i<lstTin.length-1 && ktra_stien(lstTin[i+1])){
      if(lstTin[i+1].length==1 || (lstTin[i+1].length==2 && lstTin[i+1].lastChars(1)=="n")){
        x+=",${lstTin[i+1]}";
        lstTin[i+1]="";
      }
    }
    if(x.isNotEmpty && x[0]=='g') {
      result.add(x);i+=1;continue;
    }
    var kd_st = tach_kd_tien(x,lstSoHang);
    //b7lo --> b7l
    if(kd_st["kieudanh"]!="" && kd_st["kieudanh"].toString().length>3 && kd_st["kieudanh"].toString().lastChars(2)=="lo" && kd_st["kieudanh"].toString()[0]=="b"){
      x = x.replaceAll("o", '');
    }
    if(kd_st["kieudanh"]!="" && kd_st["kieudanh"].toString().length>=2){
      if(kd_st["kieudanh"].toString()=="xcd")x = x.replaceAll("xcd", 'dxc');
      if(kd_st["kieudanh"].toString()=="bld")x = x.replaceAll("bld", 'db');
      if(kd_st["kieudanh"].toString()=="xd")x = x.replaceAll("xd", 'dxc');
      if(kd_st["kieudanh"].toString()=="dadx")x = x.replaceAll("dadx", 'dx');
    }
    if(!["bl","dt"].contains(x) && (lstKieuDanh.contains(x)|| lstBLo.contains(x)) && i<lstTin.length-1  && ktra_stien(lstTin[i+1])){
      x+=lstTin[i+1];
      lstTin[i+1]="";
    }



    if(lstMaDai.contains(x)){result.add(x);i+=1;continue;}

    if(kd_st["kieudanh"]!="" && kd_st["sotien"]!=""  && lstKieuDanh.contains(kd_st["kieudanh"])){

      if(['01','02','03','04','05','06','07','08','09'].contains(kd_st["sotien"]) || ['01n','02n','03n','04n','05n','06n','07n','08n','09n'].contains(kd_st["sotien"]))
      {
        result.add(kd_st["kieudanh"]+so_sang_thapPhan(kd_st["sotien"]));i+=1;continue;
      }else if(kd_st["sotien"].toString().lastChars(1)!="n" && i<lstTin.length-1 && ktra_stien(lstTin[i+1])){

        if(lstTin[i+1].length==1 || (lstTin[i+1].length==2 && lstTin[i+1].lastChars(1)=="n")){
          result.add("$x,${lstTin[i+1]}");
          lstTin[i+1]="";i+=1;continue;
        }
      }
      else if(kd_st["sotien"].toString().lastChars(1)!="n" && i<lstTin.length-1 && lstTin[i+1].length>=1 &&  lstTin[i+1][0].isNumeric && !lstTin[i+1][1].isNumeric && lstTin[i+1].lastChars(1)=="n"  ){
        x = "$x,${lstTin[i+1]}";
        lstTin[i+1]="";
        i+=1;continue;
      }

      else{
        result.add(x);i+=1;continue;
      }

    }

    if(tachDauDui(x).length==2){result.add(x);i+=1;continue;}

    if(x.isNumeric && !['01','02','03','04','05','06','07','08','09'].contains(x) && x.length>1){result.add(x);i+=1;continue;}
    if(["2d","3d","4d","mb"].contains(x)){result.add(x);i+=1;continue;}

    String tmp = "";

    for(int k = 0;k<x.length;k++){
      tmp+=x[k];
      //tách đài 2d231.b6
      if(tmp.length>1 && ["2d","3d","4d","mb"].contains(tmp.substring(tmp.length-2)) ){
        if(tmp.length==2 &&  k<x.length-1  && x[k+1].isNumeric){
          result.add(tmp);
          tmp=x.substring(k+1);
        }
        else if(tmp.length>2 && tmp.substring(0,k-1).lastChars(1)=="n"){
          result.add(tmp.substring(0,k-1));
          if(k<x.length-1 && x[k+1].isNumeric){
            result.add(tmp.substring(tmp.length-2));
            tmp = x.substring(k+1);
          }else{
            result.add(tmp.substring(tmp.length-2));
            tmp="";
          }
          // print(tmp);
        }
        else{
          tmp=x;
        }
        break;
      }
      //tg tp
      if(tmp.length>1 && !["bl","dt"].contains(tmp.substring(tmp.length-2)) && lstMaDai.contains(tmp.substring(tmp.length-2))){
        if(tmp.length==2 &&  k<x.length-1  && x[k+1].isNumeric){
          result.add(tmp);
          tmp=x.substring(k+1);
        }else if(tmp.length>2 && tmp.substring(0,k-1).lastChars(1)=="n"){
          result.add(tmp.substring(0,k-1));
          if(k<x.length-1 && x[k+1].isNumeric){
            result.add(tmp.substring(tmp.length-2));
            tmp = x.substring(k+1);
          }else{
            result.add(tmp.substring(tmp.length-2));
            tmp="";
          }
        }
        else{
          tmp = x;
        }
        break;
      }
    }


    if(tmp!=""){
      //d4 d6-->d4d6
      if(tmp.length>1 && tmp[0]=="d" && ktra_stien(tmp.substring(1))){
        if(i<lstTin.length-1 && lstTin[i+1].length>1 && lstTin[i+1][0]=="d" && ktra_stien(lstTin[i+1].substring(1))){
          result.add(tmp+lstTin[i+1]);

          lstTin[i+1]="";
          i+=1;
          continue;
        }else if(i<lstTin.length-1 && lstTin[i+1].length>2){

          if(lstTin[i+1][1]=="d" && lstTin[i+1][0].isNumeric && ktra_stien(lstTin[i+1].substring(2))){
            result.add(tmp+','+lstTin[i+1]);
            lstTin[i+1]="";
            i+=1;
            continue;
          }else if(lstTin[i+1][1]=="n" && lstTin[i+1][0].isNumeric && lstTin[i+1][2]=="d" && ktra_stien(lstTin[i+1].substring(3))){
            result.add(tmp+','+lstTin[i+1]);
            lstTin[i+1]="";
            i+=1;
            continue;
          }
        }
      }
      //231b6-->231.b6
      if(tmp.length>1 && !tmp.isNumeric && tmp.substring(0,2).isNumeric && !ktra_stien(tmp)){
        int vitri = 0;
        for(int k=0;k<tmp.length;k++){
          if(tmp[k].isNumeric && k<tmp.length-1 && !tmp[k+1].isNumeric){
            vitri = k+1;
            break;
          }
        }
        String a = tmp.substring(vitri);
        // print(a);
        if(a.length>3 && ["den","keo"].contains(a.substring(0,3))){
          int vt = 0;
          for(int i = 0;i<a.length;i++){
            if(a[i].isNumeric && i<a.length-1 && !a[i+1].isNumeric ){
              vt = i+1;
              break;
            }
          }
          if(vt==0){
            result.add(tmp.substring(0,vitri)+a);
            i+=1;
            continue;
          }else{
            result.add(tmp.substring(0,vitri)+a.substring(0,vt));
            tmp= a.substring(vt);
          }
        }
        else{
          result.add(tmp.substring(0,vitri));
          tmp=a;
        }
      }

      String b = "";
      bool bCheck =false ;
      try{
        for(int k = 0;k<tmp.length;k++){
          b+=tmp[k];
          if(b.length>1 &&  tmp[k].isNumeric && ((k<tmp.length-1 && !tmp[k+1].isNumeric )|| k==tmp.length-1)){
            if(k<tmp.length-1 && [","].contains(tmp[k+1])){continue;}
            if(k<tmp.length-1 && tmp.length>=4 && tmp.lastChars(1)!="d"  && ["l","d"].contains(tmp[k+1]) && tmp[k+2].isNumeric){continue;}
            if(k<tmp.length-1 && tmp[k+1]=="n")b+="n";
            if(k>0 && b[0]=="n") b = b.replaceFirst("n", "");
            var kdSotien = tach_kd_tien(b,lstSoHang);
            if(lstKieuDanh.contains(kdSotien["kieudanh"]) && ktra_stien(kdSotien["sotien"])){
              if(b.length>1 && ktra_stien(kdSotien["sotien"]) && lstKieuDanh.contains(kdSotien["kieudanh"])){
                result.add(kdSotien["kieudanh"]+so_sang_thapPhan(kdSotien["sotien"]));
                bCheck=true;
              }
            }else{
              bCheck = true;
              result.add(b);
            }
            b="";
          }
          else{
            if(k==tmp.length-1){
              if(bCheck){
                if(k>0 && b[0]=="n") b = b.replaceFirst("n", "");
                result.add(b);
              }
            }
          }
          if(k==tmp.length-1){
            if(bCheck){
              tmp ="";
            }
          }
        }
      }catch(e){
        print("Loi xu ly");
      }

      result.add(tmp);
    }

    i+=1;

  }
  result.removeWhere((element) => element=="");

  try{
    int k = 0;
    for (String x in result) {
      if(x.length == 1 && k>0 && x.isNumeric && result[k-1].lastChars(1).isNumeric && !result[k-1].lastChars(2).isNumeric){
        result[k-1] += ",$x";
        result[k] = "";
      }else if(x.length==2 && x[0].isNumeric && x[1]=='n' && k>0 && result[k-1].lastChars(1).isNumeric && (result[k-1].length>1 && !result[k-1].lastChars(2).isNumeric)){
        result[k-1] += ",$x";
        result[k] = "";
      }else if(x.length>8 && x.substring(0,2) == 'da' && x.substring(2,4).isNumeric){
         result[k] = "${x.substring(0,4)}.${x.substring(4)}";
      }
      k+=1;
    }
  }catch(e){
    print("Loi xuly $e");
  }
  result.removeWhere((element) => element=="");
  // print(result);

  return result.join(".");
}

so_sang_thapPhan(String s){
  if(!s.contains(",")){
    if(s[0]=="0" && s.length>1){
      s = "${s[0]},${s.substring(1)}";
    }
  }
  return s;
}

Map<String, dynamic> tach_kd_tien(String str, List lstSoHang) {
  List<String> _arr = str.split('');
  Map<String, dynamic> result = {"kieudanh":"","sotien":""};
  if(!lstSoHang.contains(str)){
    for (int i = _arr.length - 1; i >= 0; i--) {
      if (!_arr[i].isNumeric && _arr[i] != 'n' && _arr[i] != ',') {
        result["kieudanh"] = (str.substring(0, _arr.lastIndexOf(_arr[i]) + 1));
        break;
      }
    }

    if(str!="" && result["kieudanh"]!=null){
      result["sotien"] = str.substring(result["kieudanh"].length);
    }
  }

  return result;
}

bool ktra_stien(String s){
  bool b_tien = false;
  if(s=="" || s==null)return false;
  if(s.isNumeric) {
    b_tien = true;
  } else if(!s.isNumeric && !s.contains(",") && s.lastChars(1)=="n"){
    if(s.substring(0,s.indexOf("n")).isNumeric) {
      b_tien = true;
    }
  }
  else if(!s.isNumeric && s.contains(",")){
    if(s.lastChars(1)!="n" ){
      if(s.substring(0,s.indexOf(",")).isNumeric && s.substring(s.indexOf(",")+1).isNumeric){
        b_tien =true;
      }
    }else if(s.lastChars(1)=="n"){
      if(s.substring(0,s.indexOf(",")).isNumeric && s.substring(s.indexOf(",")+1, s.indexOf("n")).isNumeric)
      {
        b_tien = true;
      }
    }

  }
  return b_tien;
}

List<String> tachDauDui(String str) {
  List<String> arr_sotien = str.replaceAll('n', '').split('d');
  List<String> result = [];

  if (arr_sotien.length == 3 &&  arr_sotien[1].isNumeric && arr_sotien[2].isNumeric && arr_sotien[0]=="") {
    result.add("dau${arr_sotien[1]}");
    result.add("dui${arr_sotien[2]}");
  }
  return result;
}
