


import 'package:sd_pmn/function/extension.dart';
import 'package:sd_pmn/function/md_xuly.dart';

import '../database/db_connect.dart';
import 'hamSoDanh.dart';
import 'hamchung.dart';

String gl_loitin = '';
List<int> gl_list_index_loi = [];
bool gl_MaDai = false;

ConnectDB db = ConnectDB();
md_KiemLoi ({required int MaTin, required String tin, required String ngay, required String mien,}) async{
  gl_loitin = "";
  gl_list_index_loi.clear();
  int i= 0;
  try{
    bool bLoiTin = false;
    List<String> lstTin = tin.split(".");
    List<Map> ltbMaDai = await db.loadData(sql: "SELECT * FROM T01_MaDai") ;
    List lstMaDai=[];
    for (var x in ltbMaDai) {
      lstMaDai.add(x["MaDai"]);
    }

    List<Map> ltbSoHang =await db.loadData(sql: "SELECT CumTu FROM T01_TuKhoa WHERE SoDanhHang='1'");
    List<String> lstSoHang = [];
    for (var x in ltbSoHang) {
      lstSoHang.add(x['CumTu']);
    }
    //mtr.09.90.bl.200.2d
    if (lstMaDai.contains(lstTin.last) || ['2d', '3d', '4d'].contains(lstTin.last)){
      luu_loi(lstTin.length - 1, '${lstTin.last} không thể đứng sau');
      return true;
    }


    i= 0;
    for(String x in lstTin){
      //1. kiem tra madai

      // print(i);
      //2d.2d--tg.tg--tg.2d
      if( lstMaDai.contains(x)  || ['2d','3d','4d'].contains(x)){
        if(x==lstTin[i+1] || ['2d','3d','4d'].contains(lstTin[i+1])){
           // print("$i--$x--${lstTin[i]}");
          luu_loi(i, '$x không thể đứng liền kề');
          if (!bLoiTin) bLoiTin = true;
        }
      }

      //2d.tg
      if (['2d','3d','4d'].contains(x) && i<lstTin.length-1){
        if (lstMaDai.contains(lstTin[i+1])){
          luu_loi(i, '$x không thể đứng liền kề với ${lstTin[i+1]}');
          if (!bLoiTin) bLoiTin = true;
        }
      }
      if(mien=="B"){
        if(x=="mb") {i+=1;continue;}
        if(["2d","3d","4d","sb","qn"].contains(x) ||lstMaDai.contains(x)){
          luu_loi(i, "Miền Bắc không có mã đài $x");
          if (!bLoiTin) {bLoiTin = true;i+=1; continue;}
        }
      }else{
        if (x=='2d'){i+=1;continue;}
        else if (x=='3d'){
          if (mien=='N') {i+=1;continue;}
          else if (mien=='T'){
            if ([1,2,3,5].contains(Thu(ngay))){
              luu_loi(i, 'Miền Trung ngày này không có 3 đài');
              if (!bLoiTin) {bLoiTin = true;i+=1; continue;}
            }else {i+=1;continue;}
          }
        }else if (x=='4d'){
          if (mien=='N'){
            if (Thu(ngay) == 6) {i+=1;continue;}
            else if (Thu(ngay) != 6){
              luu_loi(i, 'Ngày này không có 4 đài');
              if (! bLoiTin) bLoiTin = true;
              i+=1;
              continue;
            }
          }
          if (mien=='T'){
            luu_loi(i, 'Miền Trung không có 4 đài');
            if (! bLoiTin) bLoiTin = true;
            i+=1;
            continue;
          }
        }
      }
      if (mien == 'N'){
        if (x == 'bt' && Thu(ngay) == 4) {i+=1;continue;}
        if (x == 'sb' && Thu(ngay) == 5) {i+=1;continue;}
      }
      if (mien == 'T'){
        if (x == 'dl' && Thu(ngay) == 2) {i+=1;continue;}
          if (x == 'bd' && Thu(ngay) == 4) {i+=1;continue;}
        if (x == 'dn' && [3, 6].contains(Thu(ngay))){i+=1;continue;}
        if (x == 'qn' && [2, 6].contains(Thu(ngay))) {i+=1;continue;}
      }
      if (!['2d', '3d', '4d', 'mb'].contains(x) && i==0){
        // if (x.isNumeric){
        //   if (gl_bMaDai) continue;  // man hinh 1 tin
        // }
        if (!lstMaDai.contains(x) && mien != 'B'){
          luu_loi(i, '$x không phải mã đài');
          if (! bLoiTin) bLoiTin = true;
          i+=1;
          continue;
        }
      }

      // Kiểm tra đài có đúng ngày

      if(lstMaDai.contains(x) && mien!="B"){
        String sThu = await db.dLookup("Thu", "T01_MaDai", "MaDai='$x' AND Mien='$mien'");
        if(sThu=="") {
          luu_loi(i, 'Tin có lỗi : $x');
          if (!bLoiTin) bLoiTin = true;
          i+=1;
          continue;
        }
        String t = (Thu(ngay)-1).toString();
        if (sThu!="" &&  sThu[0] != t && sThu.substring(sThu.length-1,sThu.length) != t){
          luu_loi(i, 'Ngày này không có Mã đài : $x');
          if (!bLoiTin) bLoiTin = true;
          i+=1;
          continue;
        }

      }
      else if(x.length==1){
        luu_loi(i,'$x không thể đứng 1 mình');
        if (!bLoiTin) bLoiTin = true;
      }else if(x.isNumeric && x.length>4){
        luu_loi(i, '$x không hợp lệ');
        if (!bLoiTin) bLoiTin = true;
      }
      else if (demPhanTu_list(lstSoHang, x)>0) {i+=1;continue;}
      else if (ktra_SoDanhBien(x)) {i+=1;continue;}
      else if (await Ktra_KieuDanh(x,mien)) {i+=1;continue;}
      else if(x.isNumeric && ([2,3,4].contains(x.length))){i+=1;continue;}
      else{
        luu_loi(i, 'có lỗi $x');
        if (!bLoiTin) bLoiTin = true;
        i+=1;
        continue;
      }
      i+=1;
    }

    //for x-tu vung
    //cú pháp
    bool bCoMaDai = false;bool bCoSoDanh=false;bool bCoKieuDanh=false;
    if (mien=='B') bCoMaDai=true;
    i=0;
    for(String x in lstTin){

      if (lstMaDai.contains(x) || ['2d','3d','4d','sb','qn','tt'].contains(x)){
        if (i>0){
          if (demPhanTu_list(lstMaDai, lstTin[i - 1])> 0 || ['2d', '3d', '4d', 'sb', 'qn', 'tt'].contains(lstTin[i - 1])) {i+=1;continue;}
          if(!bCoSoDanh || !bCoKieuDanh){
            luu_loi(i, 'Thiếu số hoặc kiểu');
            if (!bLoiTin) bLoiTin = true;
            i+=1;
            continue;
          }
        }//if i>1
        bCoMaDai=true; bCoSoDanh = false; bCoKieuDanh = false;
      }
      if (demPhanTu_list(lstSoHang, x)>0 || ktra_SoDanhBien(x) || isNumeric(x)){
        bCoSoDanh=true; bCoKieuDanh = false;
      }
      //2d.b5
      if (await Ktra_KieuDanh(x, mien)){
        if (!bCoSoDanh){
          luu_loi(i, 'Thiếu số đánh trong cấu trúc');
          if (!bLoiTin) bLoiTin = true;
          i+=1;
          continue;
        }
        bCoKieuDanh = true;
      }
      // print(i);
      if (i==lstTin.length-1 && ! (bCoMaDai && bCoSoDanh && bCoKieuDanh)){
        // if (gl_bMaDai) continue; //  man hinh 1 tin
        luu_loi(i, 'Thiếu cấu trúc MaDai.Số.Kiểu');
        if (! bLoiTin) bLoiTin = true;
        i+=1;
        continue;
      }
      ///kiểm tra dxdy
      if(!kiemtradd(x)){
        luu_loi(i, 'Có lỗi $x');
        if (!bLoiTin) bLoiTin = true;
      }

      // print(x);
      /// Kiểm tra xỉu chủ

      if((x.length>1 && x[0]=="x" && x[1].isNumeric) || ['xc','dx'].contains(x.substring(0,x.length>=2?2:0)) || x.substring(0,x.length>=3?3:0) == 'dxc'){
        bool bLoiXC = false; bool bcoSo=false;
        int j = i - 1;
        while (j >= 0){

          if (lstMaDai.contains(lstTin[j])) break;
          if(["2d","3d","mb"].contains(lstTin[j]))break;
          // if(!lstTin[j].isNumeric){j-=1;continue;}
          if (lstTin[j].isNumeric && [3,4].contains(lstTin[j].length)){

            if(lstTin[j].length==3){
              bcoSo=true;
              if (j>0&& !lstTin[j-1].isNumeric)  break;
            }
            if (lstTin[j].length == 4){

              if (lstTin[j + 1][0]=='b'){
                bcoSo = true;break;
              }

              // if(lstTin[j].isNumeric){bLoiXC = true;bcoSo=false;break;}
            }

          }

          else if (lstTin[j].isNumeric && lstTin[j].length == 2){

            if (x.substring(0,x.length>=2?2:0)=='xc') bLoiXC=true;
            if (j>0 && (x.substring(0,x.length>=2?2:0)=='dx' || x[0]=='x')){
              if (isNumeric(lstTin[j-1]) && lstTin[j-1].length == 2){
                bcoSo = true; //daxien
                j-=1;
              }
            }

          }
          if (await db.dLookup("GiaTri", "T00_TuyChon", "Ma='kxc'") == 0){
            if (isNumeric(lstTin[j]) && (lstTin[j].length == 2 || lstTin[j].length == 4)) {bLoiXC = true;}
            else {bcoSo=true;}

            if (bcoSo){
              if (await Ktra_KieuDanh(lstTin[j], mien)) break;
            }
            int vitri = lstTin[j].indexOf('den');
            if (vitri == -1){
              vitri = lstTin[j].indexOf('keo');
              if (vitri > 0){
                if ([2,3].contains(lstTin[j].substring(vitri + 3).length)) bLoiXC = true;
              }else{

                int k = i - 1;
                while (k >= 0){
                  if (demPhanTu_list(lstMaDai, lstTin[k]) > 0) {break;}
                  else if (isNumeric(lstTin[k]) && lstTin[k].length == 2){//# xien
                    if (j > 0 && x.substring(0,2) == 'dx'){
                      if (isNumeric(lstTin[k - 1]) && lstTin[k - 1].length == 2){
                        bcoSo = true;  // daxien
                        j-=1;
                      }
                    }
                  }else if (isNumeric(lstTin[k]) && lstTin[k].length >= 3) {bcoSo = true;}
                  k-=1;
                }//while k
                if (!bcoSo) {bLoiXC = true;}
                else {bLoiXC=false;}
              }
            }
          }
          else {
            if ((lstTin[i-1].length>1 &&  lstTin[i-1][0]!='b' && lstTin[i-1].substring(0,2)!='db') || (lstTin[j].length>3 &&  isNumeric(lstTin[j].substring(0,3)))){
              int vitri = lstTin[j].indexOf('den');
              if (vitri == -1){
                vitri = lstTin[j].indexOf('keo');
                if (vitri > 0){

                  if (lstTin[j].substring(vitri + 3).length >= 2) {bcoSo = true;}
                }
              }else if (lstTin[j].substring(vitri + 3).length >= 2) {bcoSo = true;}

              // print("$bLoiXC---$bcoSo--${lstTin[j]}");
              int k=j-1;
              while (k>=0){
                if (demPhanTu_list(lstMaDai, lstTin[k]) > 0) {break;}
                else if (isNumeric(lstTin[k]) && lstTin[k].length == 2){
                  if (j > 0 && x.substring(0,2) == 'dx' && isNumeric(x[2])){
                    if (isNumeric(lstTin[k - 1]) && lstTin[k - 1].length == 2){
                      bcoSo = true;//da xien
                      j -= 1; continue;
                    }
                  }
                }else if (isNumeric(lstTin[j]) && lstTin[j].length>=3) {bcoSo = true;}

                // else if (isNumeric(lstTin[k]) && lstTin[k].length==2) {bcoSo = false;break;}
                else {
                  vitri = lstTin[k].indexOf('den');
                  if (vitri==-1){
                    vitri = lstTin[k].indexOf('keo');
                    if (vitri>0){
                      if (lstTin[k].substring(vitri + 3).length >= 2) bcoSo = true;
                    }
                  }
                }

                if (bcoSo){
                  if (await Ktra_KieuDanh(lstTin[k],mien)) {break;}
                }
                k-=1;
              }
            }//if list
          }
          if (!bcoSo) bLoiXC = true;

          j-=1;
        }//while j

        // print("$bcoSo---$bLoiXC");
        // if(bcoSo && bLoiXC){bcoSo=false;}
        if (bLoiXC && !bcoSo){
          luu_loi(i, 'không tìm thấy số 3 con');
          if (!bLoiTin) bLoiTin = true;
          i+=1;
          continue;
        }

      }
      //kiem tra daobao phai la 3-4 con
      if (x.length>2 && x.substring(0,2)=='db'){
        int j=i-1;
        while (j>0){
          if (isNumeric(lstTin[j])){
            if (lstTin[j].length<3){
              luu_loi(i, '$x phai di voi so 3-4 con');
              if (!bLoiTin) bLoiTin = true;
            }
            break;
          }else{
            int vt=lstTin[j].indexOf('den');
            if (vt==-1) vt=lstTin[j].indexOf('keo');
            if (vt>0){
              if (isNumeric(lstTin[j].substring(vt+3)) && lstTin[j].substring(vt+3).length<3){
                luu_loi(i, '$x phai di voi so 3-4 con');
                if (!bLoiTin) bLoiTin = true;
              }
              break;
            }//if vt
          }
          j-=1;
        }//while
      }
      //5. kiem tra số đá
      if ((x.length>2 && (['dt','da','dx'].contains(x.substring(0,2)) && isNumeric(x[2]))) ||
          (x.length>1&& x[0]=='x' && isNumeric(x[1]) )){
        // && await dLookup("tkAB","TDM_Khach","ID=$KhachID")!=2

        bool bCoSoda = false; bool bXC=false;
        int j=i-1;

        while (j>=0){//xet cặp đá
          if (isNumeric(lstTin[j]) && (lstTin[j].length ==4)) bCoSoda=true;
          if (isNumeric(lstTin[j]) && lstTin[j].length == 3){

            if  (!['da','dt'].contains(x.substring(0,2))) bXC = true;//  # dao xiu chu, bo qua loi
            if (x[0] == 'x') break;
          }

          //#32.92.da0,5.68.da54,2
          // print(lstTin[j-1]);
          if (j>0&& lstTin[j].isNumeric && !isNumeric(lstTin[j-1])){
            bCoSoda = false;
            break;
          }
          if (isNumeric(lstTin[j]) && (lstTin[j].length ==2)){
            while (j>0){
              if (isNumeric(lstTin[j-1])){
                if (lstTin[j - 1].length == 2) {bCoSoda = true;}
                else if (lstTin[j - 1].length == 3){
                  bCoSoda = false;
                  break;
                }
              }else {break;}
              j-=1;
            }
          }
          if (demPhanTu_list(lstSoHang, lstTin[j])>0) bCoSoda=true;
          int vitri=lstTin[j].indexOf('den');
          if (vitri==0) vitri=lstTin[j].indexOf('keo');
          if (vitri>0){
            if (lstTin[j].substring(vitri+3).length==2) {bCoSoda=true;}}
          if (bCoSoda) break;
          j-=1;
        }//while
        if (bXC) {i+=1; continue;}
        if (!bCoSoda){

          luu_loi(i, 'không có cặp số đá');
          if (!bLoiTin) bLoiTin = true;
          i+=1;
          continue;
        }
        if ((x.substring(0,2)=='dx' || (x[0]=='x' && isNumeric(x[1]))) && bCoSoda){
          if (mien=='B'){
            luu_loi(i, 'Miền bắc không có đá xiên');
            if (!bLoiTin) bLoiTin = true;
            i+=1;
            continue;
          }
          bool bCoCapDai=false;
          while (j >= 0){//xet cap đài
            if (['2d','3d','4d'].contains(lstTin[j])) {bCoCapDai=true;}
            else if(demPhanTu_list(lstMaDai, lstTin[j])>0){
              if (demPhanTu_list(lstMaDai, lstTin[j-1])>0) {bCoCapDai=true;}
              else if (['sb','tt','qn'].contains(lstTin[j-1])) {bCoCapDai=true;}
              else {
                luu_loi(i, '$x không đủ cặp đài đá xiên');
                if (!bLoiTin) bLoiTin = true;
                break;
              }
            }
            else if (['sb', 'tt', 'qn'].contains(lstTin[j])){
              if (demPhanTu_list(lstMaDai, lstTin[j-1])>0) {bCoCapDai = true;}
              else {
                luu_loi(i, '$x không đủ cặp đài đá xiên');
                if (!bLoiTin) bLoiTin = true;
                break;
              }
            }
            else if (j==0){
              luu_loi(i, '$x không đủ cặp đài đá xiên');
              if (!bLoiTin) bLoiTin = true;
              break;
            }
            if (bCoCapDai) break;
            j-=1;
          }
        }//if x[0,2]
      }

      i+=1;
    }

    return bLoiTin;

  } catch(e){
      luu_loi(i, 'tin có lỗi!');
      return true;
  }
}

void luu_loi(int vitri,String motaLoi){
  if(gl_loitin.isEmpty)gl_loitin=motaLoi;
  gl_list_index_loi.add(vitri);
  gl_list_index_loi = gl_list_index_loi.toSet().toList();
}


bool ktra_SoDanhBien(String stSo){//kiem tra neu la so danh bien thi True
  bool ktra=false; int vitri; String a; String b;
  if (stSo.indexOf('hang') == 0 || stSo.indexOf('tong') == 0){
    if (stSo.length==5 &&  (stSo[stSo.length-1]).isNumeric) ktra= true;
  }else if (stSo.indexOf('vi') == 0){
    if (stSo.length == 3 &&  (stSo[stSo.length-1]).isNumeric) ktra= true;
  }else if (stSo.indexOf('den') > 0){
    vitri = stSo.indexOf('den');
    if (stSo.substring(vitri-2,vitri-1)=='t' &&  (stSo.substring(vitri-1,vitri)).isNumeric){//15t2den20
      a=stSo.substring(0,vitri-2);
      b=stSo.substring(vitri+3);
    } else{
      a = stSo.substring(0,vitri);
      b=stSo.substring(vitri+3);
    }
    if (a.length==b.length && a.isNumeric && b.isNumeric && int.parse(a)<int.parse(b)) ktra= true;
  }else if (stSo.indexOf('keo') > 0){
    vitri = stSo.indexOf('keo');
    if (stSo.substring(vitri-2,vitri-1)=='t' &&  (stSo.substring(vitri-1,vitri)).isNumeric){//10t2keo50
      a=stSo.substring(0,vitri-2);
      b=stSo.substring(vitri+3);
    }else{
      a = stSo.substring(0,vitri);
      b = stSo.substring(vitri + 3);
    }
    if (a.length==b.length && a.isNumeric && b.isNumeric && int.parse(a)<int.parse(b)){
      if (a[a.length-1]==b[b.length-1]){
        if (a.length==2) ktra= true; //02-92
        if (a.length==3){
          if (a.substring(a.length-2) ==b.substring(b.length-2)) {ktra= true;}//092-992
          else if (a[0]==b[0] && a[a.length-1]==b[b.length-1]) {ktra= true;}//022-092,202-292
          else {ktra=false;}//022-992 sai
        }
        if (a.length==4){
          if (a.substring(a.length-3) ==b.substring(b.length-3)) {ktra= true;}//#0192-9192
          else if (a[0]==b[0] && a.substring(a.length-2)==b.substring(b.length-2)) {ktra= true;}//0192-0592
          else if (a.substring(0,2)==b.substring(0,2) && a[a.length-1]==b[b.length-1]) {ktra=true;}//0102-0192
        }
      }else //00-99
      if (a[0]==a[a.length-1] && b[0]==b[b.length-1]) {ktra=true;}
    }
  }
  return ktra;
}


Future<bool> Ktra_KieuDanh(String sKieu, String Mien) async{//kiem tra xem so danh biến quy cách số đứng sau có đúng k
  bool ktra=false;
  String tien=''; int vitri;

  if (demPhanTu_list(lstKieuDanh, sKieu.substring(0,sKieu.length>=4?4:0)) > 0){// xdau50,'xdui','ddau','ddui'
    if (kt_soTien(sKieu, 4)) ktra= true;
  }else if (demPhanTu_list(lstKieuDanh, sKieu.substring(0,sKieu.length>=3?3:0)) > 0){// gdb50,dau50,dui,bao,dlo,dxc,ddd
    if (kt_soTien(sKieu, 3)) ktra= true;
  }else if (demPhanTu_list(lstKieuDanh, sKieu.substring(0,sKieu.length>=2?2:0)) > 0) {//#ts50,ab50,dd50,lo50,xc50,da50,dt50,dx50,50dz,db50,
    if (kt_soTien(sKieu,2)) ktra= true;
  }

  else if (demPhanTu_list(lstKieuDanh, sKieu[0]) > 0 && sKieu.length>1&&  sKieu[1].isNumeric ){

    tien=sKieu.substring(1);
    if (tien.isNumeric && tien.length >1 && tien[0]=='0') ktra=false;//return;//kieu Future k tra ve true
    tien=tien.replaceAll(',','');
    if (tien[tien.length-1] == 'n'){
      if (tien.length>1) tien=tien.substring(0,tien.length-1);
    }
    if (tien.isNumeric){
      if (await db.dLookup("GiaTri","T00_TuyChon","Ma='t'")==1 && sKieu[0]=='t') {ktra=false;}//return
      else {ktra= true;}
    }else {

      vitri=tien.indexOf('s');
      if (vitri >0){
        String t1 = tien.substring(0,vitri);
        String t2 = tien.substring(vitri+1,tien.length-1);
        if (t1.isNumeric && t2.isNumeric) ktra= true;
      }
      vitri = tien.indexOf('l');//#b7l
      if (0<vitri && vitri<=2){// #7lo , 12lo
        if ( (tien.substring(0,vitri)).isNumeric &&  (tien.substring(vitri+1).isNumeric)
            ||  (tien.substring(vitri+1)).isNumeric ) {
          ktra= true;
        }
      }

    }
  }else if (sKieu[0]=='d'){

    tien = sKieu.substring(1);
    vitri = tien.indexOf('d');
    if (vitri>0){
      String t1 = tien.substring(0,vitri);

      String t2 = tien.substring(vitri+1 );

      t1=t1.replaceAll(',','');
      t2=t2.replaceAll(',','');

      // print(t2[t2.length-1]);
      if (  t1.isNumeric && t2.isNumeric) {ktra= true;}
      else if (t1.isNumeric && (t2[t2.length-1] == 'n' &&  (t2.substring(0,t2.length-1)).isNumeric)) {ktra= true;}
      else if (t1[t1.length-1] == 'n' &&  (t1.substring(0,t1.length-1)).isNumeric &&  t2.isNumeric) {ktra= true;}
      else if (t1[t1.length-1] == 'n' &&  (t1.substring(0,t1.length - 1)).isNumeric && t2[t2.length-1] == 'n' &&  (t2.substring(0,t2.length - 1)).isNumeric) {ktra= true;}

      // print("$sKieu--$tien--$t1--$t2--$ktra");
    }
  }else{

    if (Mien=='B'){
      if (demPhanTu_list(lstVitriB, sKieu.substring(0,sKieu.length>=3?3:0))>0){
        if (kt_soTien(sKieu, 3)) ktra= true;
      }else if (demPhanTu_list(lstVitriB,sKieu.substring(0,sKieu.length>=4?4:0))>0){
        if (kt_soTien(sKieu, 4)) ktra= true;
      }
    }else{

      if (demPhanTu_list(lstVitriN, sKieu.substring(0,sKieu.length>=3?3:0))>0){
        if (kt_soTien(sKieu, 3)) ktra= true;
      }else if (demPhanTu_list(lstVitriN, sKieu.substring(0,sKieu.length>=4?4:0))>0){

        if (kt_soTien(sKieu, 4)) ktra= true;
      }
    }
  }
  return ktra;
}

bool kt_soTien(String sKieu, int vt){
  bool ktra=false;

  String tien = sKieu.substring(vt);

  if(tien.length==1&& tien=="0") return ktra;
  if (tien!="" && tien[0]=='0' && tien.length>1 && tien[1]!=',')  return true;
  if (sKieu.substring(0,2)=='db'){
    if (tien.indexOf('l')>0) tien=tien.substring(tien.indexOf('l')+1);
  }
  tien=tien.replaceAll(',', '');
  if (tien!=""&& tien[tien.length-1] == 'n') tien = tien.substring(0,tien.length-1);
  if (isNumeric(tien)) ktra=true;
  return ktra;
}

kiemtradd(String str){
  List<String> tmp = str.split('d');

  if(tmp.length != 3){
    return true;
  }else{
    tmp.removeWhere((e) => e == '');
    if(tmp.length!=2){
      return true;
    }else{
      if(ktra_stien(tmp[0]) && ktra_stien(tmp[1])){
        return true;
      }else{
        return false;
      }
    }


  }

}