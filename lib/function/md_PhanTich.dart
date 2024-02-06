

// ignore_for_file: curly_braces_in_flow_control_structures, non_constant_identifier_names

import 'package:sd_pmn/function/extension.dart';
import 'package:sd_pmn/function/md_xuly.dart';
import 'package:sd_pmn/models/mdl_tinnhan_ptct.dart';

import '../database/db_connect.dart';
import 'hamSoDanh.dart';
import 'hamchung.dart';

ConnectDB db = ConnectDB();
List<TinNhanPTCTModel> lstData = <TinNhanPTCTModel>[]; List lstMaDai=[];  List lstSo=[]; List lstKieu = []; List lstTien = [];
double fxac=0; double fvon=0; double ftrung=0;
Future<List<TinNhanPTCTModel>> phantich_ChuoiTin(int MaTin, int TinCTID, String sChuoiTin)async{
  //sChuoiTin=chuyentin
  lstData.clear();fxac = 0;fvon = 0; ftrung = 0;
  List lstTin = sChuoiTin.split('.');
  bool bCoMaDai =true; bool bKetThuc=false;
  for (int i=0;i<lstTin.length;i++){
    //nếu thấy Mã đài thì lưu lại
    if (await db.dCount("T01_MaDai",Condition: "MaDai='${lstTin[i]}'")>0 || ['2d','3d','4d'].contains(lstTin[i])){
      if (bCoMaDai) lstMaDai.clear();
      lstMaDai.add(lstTin[i]);
      lstSo.clear();lstKieu.clear();lstTien.clear();
      bCoMaDai=false;
    }else if (isNumeric(lstTin[i])){
      bCoMaDai=true;
      lstKieu.clear();lstTien.clear();
      if (bKetThuc) lstSo.clear();
      lstSo.add(lstTin[i]);
      bKetThuc=false;
    }else{
      bCoMaDai=true;
      lstKieu.clear(); lstTien.clear();
      phantich_Kieu(lstTin[i]);
    }
    if (lstMaDai.length>0 && lstSo.length>0 && lstKieu.length>0 && lstTien.length>0) {
      // print("MADai: $lstMaDai | lstSo: $lstSo | lstKieu $lstKieu | lstTien $lstTien");
      await ghi_SoDanh(MaTin, TinCTID);
      lstKieu.clear(); lstTien.clear();
      bKetThuc = true;
    }
  }
  //ghi so lieu vao table TXL_TinPhanTichCT

  // List tupTin=[sChuoiTin,fxac,fvon,ftrung,fvon-ftrung];
  // tupTin=(sChuoiTin,fxac,fvon,ftrung,fvon-ftrung);
  //Module.md_Settings.gl_lst_tableTin.append(tupTin)
  return lstData;
}

void phantich_Kieu(String st){
  int vitri;
  if (st[0]=='t'){
    lstKieu.add('t');
    vitri=st.indexOf('s');
    if (vitri>0){
      lstTien.add(LaySoTien(st.substring(1,vitri)));
      lstKieu.add('s');
      lstTien.add(LaySoTien(st.substring(vitri+1)));
    }else {
      lstTien.add(LaySoTien(st.substring(1)));
    }
  }else if(st[0]=='s'){
    lstKieu.add('s');
    lstTien.add(LaySoTien(st.substring(1)));
  }else if(['dd','dt','dx','dz'].contains(st.substring(0,2))){
    lstKieu.add(st.substring(0,2));
    lstTien.add(LaySoTien(st.substring(2)));
  }else if(st[0]=='b'){
    if (st.length>2 && st.substring(0,3) == 'bsh'){
      lstKieu.add(st.substring(0,3));
      lstTien.add(LaySoTien(st.substring(3)));
    }else {
      vitri = st.indexOf('l');//b7l
      if (vitri>0){
        lstKieu.add(st.substring(0,vitri+1));
        lstTien.add(LaySoTien(st.substring(vitri+1,st.length)));
      }else{
        lstKieu.add('b');
        for(int i = 0; i<st.length;i++){
          if(isNumeric(st[i])){
            lstTien.add(LaySoTien(st.substring(i)));
            break;
          }
        }
        // lstTien.add(LaySoTien(st.substring(1,st.length)));
      }
    }
  }else{
    if (st.substring(0,1)=='g'){//st[:1]=='g': #g17t
      vitri=st.indexOf('t');
      if (vitri>0){
        lstKieu.add(st.substring(0,vitri+1));
        lstTien.add(LaySoTien(st.substring(vitri+1,st.length)));
      }else {
        print('Chua tim thay kieu danh $st');
      }
    }
  }
}

lay_TyLe(int KhachID, String Mien, String Kieu) async{
  List lstTyLe=[];
  switch (Mien){
    case 'N':
      lstTyLe.add(await db.dLookup("TyLeMN","TDM_GiaKhach","KhachID='$KhachID' AND MaKieu='$Kieu'"));
      lstTyLe.add(await db.dLookup("TrungMN", "TDM_GiaKhach", "KhachID='$KhachID' AND MaKieu='$Kieu'"));
      break;
    case 'B':
      lstTyLe.add(await db.dLookup("TyLeMB","TDM_GiaKhach","KhachID='$KhachID' AND MaKieu='$Kieu'"));
      lstTyLe.add(await db.dLookup("TrungMB", "TDM_GiaKhach", "KhachID='$KhachID' AND MaKieu='$Kieu'"));
      break;
    default:
      lstTyLe.add(await db.dLookup("TyLeMT","TDM_GiaKhach","KhachID='$KhachID' AND MaKieu='$Kieu'"));
      lstTyLe.add(await db.dLookup("TrungMT", "TDM_GiaKhach", "KhachID='$KhachID' AND MaKieu='$Kieu'"));
  }
  return lstTyLe;
}

ghi_SoDanh(int MaTin, int TinCTID) async {

  int iSLcon = 0; List TTgiai = []; String MaKieu = '';
  String Ngay = await db.dLookup("Ngay", "TXL_TinNhan", "ID=$MaTin");
  String Mien = await db.dLookup("Mien", "TXL_TinNhan", "ID=$MaTin");
  int KhachID = await db.dLookup("KhachID", "TXL_TinNhan", "ID=$MaTin");
  int KieuTL = await db.dLookup("KieuTyLe", "TDM_Khach", "ID=$KhachID");
  if (['2d', '3d', '4d'].contains(lstMaDai[0])) lstMaDai = await ds_Dai(Ngay, Mien, int.parse(lstMaDai[0][0])); //ds dai
  int iSoDai = LoaiBoPhanTuRong(lstMaDai).length;
  int j = 0; dynamic iSLtrung;
  for (String kieu in lstKieu) {
    double Tien = double.parse(lstTien[j]);
    for (String so in lstSo) {
      if (KieuTL == 2) {
        if (kieu[0] == 'b') {
          switch (so.length) {
            case 2: MaKieu = 'b2'; break;
            case 3: MaKieu = 'b3'; break;
            case 4: MaKieu = 'b4'; break;
          }
        } else {
          switch (so.length) {
            case 2: MaKieu = 'ab'; break;
            case 3: MaKieu = 'xc'; break;
            case 4: MaKieu = 'd4'; break;
          }
        }

      }

      else {
        switch (so.length) {
          case 2: MaKieu = '2s'; break;
          case 3: MaKieu = '3s'; break;
          case 4: MaKieu = '4s'; break;
        }
        if (['dt', 'dx'].contains(kieu)) MaKieu = kieu;
        if (kieu == 't') {
          switch (so.length) {
            case 2: iSLcon = (Mien == 'B' ? 4 : 1);
              TTgiai = (Mien == 'B' ? [24, 25, 26, 27] : [1]);
              break;
            case 3: iSLcon = (Mien == 'B' ? 3 : 1);
              TTgiai = (Mien == 'B' ? [21, 22, 23] : [2]);
              break;
            case 4: iSLcon = (Mien == 'B' ? 6 : 3);
              TTgiai = (Mien == 'B' ? [15, 16, 17, 18, 19, 20] : [3, 4, 5]);
              break;
          }
        } else if (kieu == 's') {
          iSLcon = 1;
          TTgiai = (Mien == 'B' ? [1] : [18]);
        } else if (kieu == 'dd') {
          switch (so.length) {
            case 2:
              iSLcon = (Mien == 'B' ? 5 : 2);
              TTgiai = (Mien == 'B' ? [1, 24, 25, 26, 27] : [1, 18]);
              break;
            case 3:
              iSLcon = (Mien == 'B' ? 4 : 2);
              TTgiai = (Mien == 'B' ? [1, 21, 22, 23] : [2, 18]);
              break;
            case 4:
              iSLcon = (Mien == 'B' ? 7 : 4);
              TTgiai =
              (Mien == 'B' ? [1, 15, 16, 17, 18, 19, 20] : [3, 4, 5, 18]);
              break;
          }
        } else {
          if (kieu[0] == 'b') {
            if (kieu.length == 1) {
              switch (so.length) {
                case 2:
                  iSLcon = (Mien == 'B' ? 27 : 18);
                  TTgiai = (Mien == 'B' ? [for(int n = 1; n < 28; n++) n] : [
                    for(int n = 1; n < 19; n++) n
                  ]);
                  break;
                case 3:
                  iSLcon = (Mien == 'B' ? 23 : 17);
                  TTgiai = (Mien == 'B' ? [for(var n = 1; n < 24; n++) n] : [
                    for(var n = 2; n < 19; n++) n
                  ]);
                  break;
                case 4:
                  iSLcon = (Mien == 'B' ? 20 : 16);
                  TTgiai = (Mien == 'B' ? [for(var n = 1; n < 21; n++) n] : [
                    for(var n = 3; n < 19; n++) n
                  ]);
                  break;
              }
            } else { //bao 7lo
              if (kieu == 'bsh') { //bsh sập hầm mien nam
                iSLcon = 22;
                if (so.length == 2) TTgiai = [for(var n = 1; n < 19; n++) n];
                if (so.length == 3) TTgiai = [for(var n = 2; n < 19; n++) n];
              } else {
                iSLcon = int.parse(kieu.substring(1, kieu.length - 1)); // so lo
                if (Mien == 'B') {
                  if (await db.dLookup("GiaTri", "T00_TuyChon", "Ma='nLB'") == 1) {
                    //8lo 2 số hà nội: giải7, giải6, giải nhất, giải đặc biệt
                    if (so.length == 2) TTgiai = [for(var n = 21; n < 28; n++) n] + [for (var n = 1; n < iSLcon - 6; n++) n];
                    //7lo 3số hà nội: giải đặc biệt, giải nhất, giải nhì, giải 6
                    if (so.length == 3) TTgiai = [21, 22, 23] + [for (var n = 1; n < iSLcon - 2; n++) n];
                    if (so.length == 4) TTgiai = [1] + [for (var n = 20 - iSLcon; n < 21; n++) n];
                  } else {
                    TTgiai = [for (var n = 1; n < iSLcon + 1; n++) n];
                  }
                } else {
                  if (await db.dLookup("GiaTri", "T00_TuyChon", "Ma='nLN'") == 1) {
                    if (so.length == 2) TTgiai = [18] + [for(var n = 1; n < iSLcon; n++) n];
                    if (so.length == 3) TTgiai = [18] + [for(var n = 2; n < iSLcon + 1; n++) n];
                    if (so.length == 4) TTgiai = [18] + [for(var n = 3; n < iSLcon + 2; n++) n];
                  } else {
                    TTgiai = [for(var n = 18 - iSLcon + 1; n < 19; n++) n];
                  }
                }
              }
            }
          } else if (kieu[0] == 'g') {
            iSLcon = 1;
            TTgiai = (Mien == 'B' ? [kieu.substring(1, kieu.length - 1)] : [kieu.substring(1, kieu.length - 1)]); // thu tu lo
          }//kieu == 't'
        }// kieu == 't'
      } //KieuTL == 1


      iSLtrung = await do_KQ(Ngay, Mien, so, lstMaDai, TTgiai);
      //xet an ui 2 con
      bool bAnUi=false; String SoAUt='';String SoAUs='';
      if (iSLtrung==0 && so.length==2 && await db.dLookup("GiaTri","T00_TuyChon","Ma='au'")>0){
        if (so=='00') {
          SoAUs='01';
        } else if (so=='99') {
          SoAUt='98';
        } else {
          SoAUt =('0${int.parse(so) - 1}').substring(so.length - 2);
          SoAUs =('0${int.parse(so) + 1}').substring(so.length - 2);
        }
        iSLtrung = do_KQ(Ngay, Mien, SoAUt, lstMaDai, TTgiai);
        if (iSLtrung==0) iSLtrung = do_KQ(Ngay, Mien, SoAUs, lstMaDai, TTgiai);
        if (iSLtrung >0) bAnUi=true;
      }
      if (kieu == 'bsh'){
        if (so.length == 2) iSLtrung +=do_KQ(Ngay, Mien, so, lstMaDai, [8,9,10,11]);
        if (so.length == 3) iSLtrung += do_KQ(Ngay, Mien, so, lstMaDai, [8, 9, 10, 11, 12]);
      }
      if (iSLcon>0) {
        lstMaDai.removeWhere((e) => e=='');
        await luu_DuLieu(TinCTID,MaTin,Mien, lstMaDai.join('.'),KhachID,kieu,MaKieu,so,iSoDai,iSLcon,iSLtrung,Tien,LoaiBoPhanTuRong(lstMaDai).length,bAnUi);
      }

    } //for so

    if (kieu=='dt'){
      iSLcon= (Mien =='B'?54:36);
      TTgiai = (Mien =='B'?[for (var n=1;n<28;n++) n]: [for (var n=1;n<19;n++) n]);
      List lstCapSo=LayCapSo_from_lst(lstSo);
      for (var dai in lstMaDai){
        if (dai !=''){
          for (var i=0;i<lstCapSo.length;i++){
            List CapSo=lstCapSo[i].split('.');
            int x1 = await do_KQ(Ngay, Mien, CapSo[0], [dai], TTgiai);//list([dai]
            int x2=0;
            if (x1>0){
              x2 = await do_KQ(Ngay, Mien, CapSo[1], [dai], TTgiai);//list([dai]
              if(x2>0){

                iSLtrung = x1<=x2 ? x1 : x2;

                if (Mien=='N'){
                  if ((x1 - x2).abs() >=1 && await db.dLookup("ThuongMN","TDM_Khach","ID= '$KhachID'")==1) iSLtrung += 0.5;
                  if ((x1 - x2).abs() > 1 && await db.dLookup("ThemChiMN","TDM_Khach","ID='$KhachID'")==1) iSLtrung =(x1+x2)/2;

                }else if (Mien=='T'){
                  if ((x1 - x2).abs() >=1 && await db.dLookup("ThuongMT","TDM_Khach","ID='$KhachID'")==1) iSLtrung += 0.5;
                  if ((x1 - x2).abs() > 1 && await db.dLookup("ThemChiMT","TDM_Khach","ID='$KhachID'")==1) iSLtrung =(x1+x2)/2;
                }else{
                  if ((x1 - x2).abs() >=1 && await db.dLookup("ThuongMB","TDM_Khach","ID='$KhachID'")==1) iSLtrung += 0.5;
                  if ((x1 - x2).abs() > 1 && await db.dLookup("ThemChiMB","TDM_Khach","ID='$KhachID'")==1) iSLtrung =(x1+x2)/2;
                }
              }

            }
            if (CapSo[0] == CapSo[1]) iSLtrung = (x1/2 + x2/2) ~/ 2;
            await luu_DuLieu(TinCTID,MaTin,Mien,dai,KhachID,kieu,kieu,lstCapSo[i],1,iSLcon,iSLtrung,Tien,1);
            iSLtrung = 0;
          }
        }
      }
    }else if(kieu=='dx'){
      iSLcon = (Mien =='B'? 108: 72);
      TTgiai = (Mien =='B'? [for (var n=1;n<28;n++) n]: [for (var n=1;n<19;n++) n]);
      List lstCapSo = LayCapSo_from_lst(lstSo);
      List lstCapDai= LayCapSo_from_lst(lstMaDai);
      for (var j=0;j< lstCapDai.length;j++){
        List CapDai=lstCapDai[j].split('.');
        for (var i=0;i<lstCapSo.length;i++){
          iSLtrung=0;
          List CapSo = lstCapSo[i].split('.');
          int x1 = await do_KQ(Ngay, Mien, CapSo[0], CapDai, TTgiai);
          if (x1>0){
            int x2 =await do_KQ(Ngay, Mien, CapSo[1], CapDai, TTgiai);
            if (x2>0) iSLtrung = (x1 <=x2? x1: x2).toInt();
            if (CapSo[0] == CapSo[1]) iSLtrung = (x1 / 2 + x2 / 2) ~/ 2;
          }
          await luu_DuLieu(TinCTID,MaTin,Mien,lstCapDai[j],KhachID,kieu,kieu,lstCapSo[i],1,iSLcon,iSLtrung,Tien,2) ;
        }
      }
    }else if(kieu=='dz'){
      iSLcon = 81; TTgiai = [for (var n=1;n<28;n++) n];
      int i=0; bool bTrat=false;
      while (i <3){
        if (do_KQ(Ngay, Mien, lstSo[i], ['mb'], TTgiai)==0) {
          bTrat=true; break;
        }
        i+=1;
      }
      if (!bTrat) iSLtrung=1;
      await luu_DuLieu(TinCTID, MaTin, Mien, 'mb', KhachID, kieu, kieu, lstSo.join('.'), 1, iSLcon, iSLtrung, Tien,3);
    }
    j+=1;
  }//for kieu
}

Bang_KQSX(String Ngay, String Mien, int SoCon, List Dai, List TT) async{
  Dai = Dai.map((e) => '\'$e\'').toList();
  final List<Map> lst= await db.loadData(sql:"SELECT KQso FROM TXL_KQXS WHERE Ngay='$Ngay' AND Mien='$Mien' AND MaDai in (${Dai.join(',')}) AND TT in (${TT.join(',')})");
  List lstKQ=[];String s='';
  for (var x in lst){
    s=x['KQso'].toString();
    s=s.lastChars(SoCon);//s=s[-SoCon:]
    if (isNumeric(s)) lstKQ.add(s);
  }
  return lstKQ;
}

do_KQ(String Ngay, String Mien, String So, List lstDai, List TTgiai)async{
  //do_KQ(Ngay, Mien, So, lstDai, *TTgiai):
  //them vao 1 phan tu de chuyen sang kieu tuple=('tp',''), neu k thi ('tp',) truyen vao k hieu
  if (lstDai.length==1) lstDai.add('');
  // print(TTgiai);
  // if (TTgiai[0].toString().length==1) TTgiai[0].add('');
  List lstSo = [];
  //lstSo +=await Bang_KQSX(Ngay, Mien, So.length, tuple(lstDai), tuple(TTgiai[0]));
  lstSo += await Bang_KQSX(Ngay, Mien, So.length, lstDai, TTgiai);
  return demPhanTu_list(lstSo,So);//lstSo.count(So)
}

//đến đây
luu_DuLieu(TinCTID, MaTin, Mien,String Dai, KhachID, kieu, MaKieu, So, iSoDai, iSLcon, iSLtrung, Tien, SoDai,[bAnUi=false]) async {
  var tyle = await lay_TyLe(KhachID, Mien, MaKieu)   ;
  // print(Dai);
  var TLthuong = bAnUi ? await db.dLookup("GiaTri", "T00_TuyChon", "Ma='au'") : tyle[1] ;
  double xac = iSoDai * Tien * iSLcon;
  fxac+=xac;
  double von = double.parse((xac * tyle[0]).toStringAsFixed(2));
  fvon+=von;
  double trung = iSLtrung * Tien * TLthuong;
  ftrung += trung;
  // print('Kieu: $kieu | MaKieu: $MaKieu | So: $So | IsLCon: $iSLcon | isLTrung: ${await iSLtrung} | Tien: $Tien | Tyle: $tyle | Xac: $xac | von: $von | trung: $trung');
  lstData.add(
    TinNhanPTCTModel(
      MaDai: Dai, MaTin: MaTin,MaKieu: kieu,SoDai: SoDai,
      SoDanh: So,SoLanTrung: await iSLtrung,SoTien: Tien,TienTrung: trung,
      TienVon: von,TienXac: xac,TinNhanCTID: TinCTID
    )
  );
}

///////////////////////////////////
chen_XC(int KhachID, List<String>  lstTin) async{
  //lstTin=[]
  //chuyen lo=b truoc khi thuc hien
  for (var i=0;i< lstTin.length;i++) {
    if (await db.dLookup("tkAB", "TDM_Khach", "ID='$KhachID'") != 1)
      if (lstTin[i].substring(0,2)=='lo') {
        lstTin[i]=lstTin[i].replaceAll('lo','b');
      }
      if(lstTin[i].length>2 && lstTin[i].substring(0,3)=='bao'){
        lstTin[i]=lstTin[i].replaceAll('bao','b');
      }
  }
  //chen cau truc 1234.b1.b1=1234.b1.234.b1, 1234.b1.xc1.dd1=1234.b1.234.xc1.34.dd1, 123.xc1.dd1=123.xc1.23.dd1
  int i=0; String x='';
  while (i<lstTin.length){
    x=lstTin[i];
    // 1234.b1.x1
    if (x[0]=='x' && isNumeric(x[1])) {
      int j = i - 1;
      while (j > 0) {
        if ((lstTin[j][0] == 'b') && isNumeric(lstTin[j][1])) {
          if (isNumeric(lstTin[j - 1]))
            if (lstTin[j - 1].length == 4) {
              lstTin[i] = ChenKyTu(x, 'c', 1);
              int k = j - 1;
              while (isNumeric(lstTin[k])) {
                lstTin[i] = '${lstTin[k][lstTin[k].length - 3]}.${lstTin[i]}';
                k -= 1;
              }
            } else {
              break;
            }
        } else {
          break;
        }
        j -= 1;
      }
    }  //x[0]=='x'
    if (i < lstTin.length - 1)  {
      String y = lstTin[i + 1];
      if ((x[0] == 'b' && isNumeric(x[1]) && (y[0] == 'b' || ['db', 'xc'].contains(y.substring(0,2)) || (y.length>2 && y.substring(0,3) == 'dxc')))
          || ((x.substring(0,2) == 'xc' ||  (x.length>2 && x.substring(0,3) == 'dxc')) && (['xc', 'dd'].contains(y.substring(0,2))))
          || (x.substring(0,2) == 'db' && (y[0]=='b') || y.substring(0,2) == 'xc'  || (y.length>2 && y.substring(0,3)=='dxc'))){
        String sSo = ''; bool bCoSo = false;
        int j=i-1;

        while (j>0){
          if (isNumeric(lstTin[j])){
            bCoSo=true;
            if (lstTin[j].length == 4 && isNumeric(lstTin[j])){
              if (y.substring(0,2) == 'db') {
                sSo = '${lstTin[j].substring(lstTin[j].length-4)}.$sSo';
              } else if ((y[0] == 'b' || y.substring(0,2) == 'xc' || y.substring(0,3) == 'dxc') && ['b','d'].contains(x[0])) {
                sSo = '${lstTin[j].substring(lstTin[j].length-3)}.$sSo';
              } else if (y.substring(0,2) == 'dd') {
                sSo = '${lstTin[j].substring(lstTin[j].length-2)}.$sSo';
              }
            }else if(lstTin[j].length == 3 && isNumeric(lstTin[j])){
              if ((['db', 'xc'].contains(y.substring(0,2)) || (y.length>2 && y.substring(0,3) == 'dxc') || y[0] == 'b')&& ['b','d'].contains(x[0])) {
                sSo = '${lstTin[j].substring(lstTin[j].length-3)}.$sSo';
              } else if (y.substring(0,2) == 'dd') {
                sSo = '${lstTin[j].substring(lstTin[j].length-2)}.$sSo';
              }
            }else {
              break;
            }
          }else {
            break;//isNumeric(lstTin[j]
          }
          j-=1;
        }//while j>0
        if (sSo != ''){
          lstTin.insert(i + 1, rstrip(sSo));
          i+=demPhanTu_st(sSo,'.');
        }
      }//x[0] == 'b'

      String st = lstTin.join('.');
      lstTin = st.split('.');
    }//i < lstTin
    i+=1;
  }
  return lstTin;
}

chuyenTin(int MaTin, String sTin) async{//su dung MaTin de truy xuat KhachID
  String Ngay = await db.dLookup("Ngay", "TXL_TinNhan", "ID=$MaTin");
  String Mien = await db.dLookup("Mien", "TXL_TinNhan", "ID=$MaTin");
  int KhachID = await db.dLookup("KhachID", "TXL_TinNhan", "ID=$MaTin");
  try{
    sTin = sTin.toLowerCase(); sTin = strip(sTin);
    List<String> lstTin = sTin.split('.');
    if (Mien == 'B' && lstTin.first !='mb') lstTin.insert(0,'mb');

    //List<Map> lstHangSo=await db.rawQuery("SELECT CumTu, ThayThe FROM T01_TuKhoa WHERE SoDanhHang=1");
    //if (lstHangSo.length>0){
    //dicHangSo=dict(lstHangSo);
    List<Map> lstHangSo=await db.loadData(sql: "SELECT CumTu, ThayThe FROM T01_TuKhoa WHERE SoDanhHang=1");
    Map<String,String> dicHangSo={};
    for (var m in lstHangSo){
      //dicHangSo.addAll(m);
      dicHangSo[m['CumTu']]=m['ThayThe'];
    }
    if(await db.dCount("T01_TuKhoa",Condition: "SoDanhHang=1")>0){
      int i=0;
      for (String x in lstTin){
        if (Mien=='N'){
          if (x == 'bt' && Thu(Ngay) == 4) lstTin[i] = 'bth';
          if (x == 'sb' && Thu(Ngay) == 5) {
            lstTin[i] = 'bd';
          }
        }else if(Mien=='T'){
          switch (Thu(Ngay)){
            case 1: if (x == 'tt') lstTin[i] = 'tth'; break;
            case 2: if (x == 'dl') lstTin[i] = 'dlk';
                    if (x == 'qn') lstTin[i] = 'qnm'; break;
            case 4: if (x == 'bd') lstTin[i] = 'bdi'; break;
            case 6: if (x == 'qn') lstTin[i] = 'qng'; break;
          }
          if ([3,6].contains(Thu(Ngay)) && x=='dn') lstTin[i] = 'dng';
        }
        //if dicHangSo.get(x) is not None: lstTin[i]=dicHangSo.get(x) # chuyen doi ham so Hang

        if (dicHangSo[x]!=null) lstTin[i]=dicHangSo[x].toString();
        if (await db.dCount("T01_TuKhoa",Condition: "SoDanhHang= '1' AND CumTu= '$x'" )>0) {
          lstTin[i]=await db.dLookup("ThayThe", "T01_TuKhoa", "SoDanhHang= '1' AND CumTu= '$x'" );
        } else if(x.indexOf('tong')>0) {
          lstTin[i]=Tong(x.substring(4,x.length));//[4:len(x)]
        } else if(x.indexOf('hang')>0) {
          lstTin[i]=Hang(x.substring(4,x.length));
        } else if(x.indexOf('vi')>0) {
          lstTin[i]=Vi(x.substring(2,x.length));
        } else if (x.indexOf('den')>0){//elif x.find('den')>0:#15den20,15t2den24
          int vitri=x.indexOf('den');
          if (isNumeric(x.substring(vitri-1,vitri)) && x.substring(vitri-2,vitri-1) =='t'){
            int vitriT=x.indexOf('t');
            // lstTin[i] = tNden(x.substring(0,vitriT), x.substring(vitri + 3,x.length),N:x.substring(vitriT+1,vitri));
            lstTin[i] = layKeoDen(x.substring(0,vitriT), x.substring(vitri + 3,x.length),kieu: 'den',N:x.substring(vitriT+1,vitri));
          }else {
            lstTin[i]= layKeoDen(x.substring(0,vitri),x.substring(vitri+3,x.length),kieu: 'den');
          }
          //
        }else if (x.indexOf('keo')>0){//15keo35, 15t2keo75=15.35.55.75
          int vitri = x.indexOf('keo');
          if (isNumeric(x.substring(vitri - 1,vitri)) && x.substring(vitri - 2,vitri - 1) == 't'){
            int vitriT = x.indexOf('t');
            // lstTin[i] = tNkeo(x.substring(0,vitriT), x.substring(vitri + 3,x.length), N: x.substring(vitriT + 1,vitri));
            lstTin[i] = layKeoDen(x.substring(0,vitriT), x.substring(vitri + 3,x.length),kieu:  'keo', N: x.substring(vitriT + 1,vitri));
          }else {
            lstTin[i] =layKeoDen(x.substring(0,vitri), x.substring(vitri + 3,x.length),kieu: 'keo');
          }
        }else if(x.substring(0,2)=='dx' && isNumeric(x.substring(2,3))) {//#chen dx->dxc neu truoc do la so 3con
          int j=i-1;
          while (j>0){
            if (isNumeric(lstTin[j])){
              if ([2, 4].contains(lstTin[j].length)) {
                break; //so da
              } else if (lstTin[j].length==3){//chen c vao dx
                lstTin[i]=ChenKyTu(lstTin[i],'c',2);
                break;
              } //else
              else if (lstTin[j].indexOf('den')>0 || lstTin[j].indexOf('keo')>0){
                if (isNumeric(lstTin[0].substring(lstTin[0].length-3,lstTin[0].length-2))){
                  lstTin[i]=ChenKyTu(lstTin[i],'c',2);
                  break;
                }//if
              }//else
            }//if
            j-=1;
          }//while
        }
        //chuyen 1234.b1.b1.xc1.dd1
        //so voi python thi if(await) ngoai vong for

        i+=1;
      }//for
      // print("====$lstTin");
      if (await db.dLookup("GiaTri", "T00_TuyChon", "Ma='kxc'") == 1){
        lstTin = await chen_XC(KhachID,lstTin);
        // x = lstTin[i];
      }
      /// -----------------------------------------------------------------------------------------*
      //chuyen kieu danh
      bool bCoDao = false;
      i=0;
      // print(lstTin);
      for (String x in lstTin){
        String kytuDao = '';
        if (x.length>2 && x.substring(0,3) == 'dlo'){
          lstTin[i] = lstTin[i].replaceAll(x.substring(0,3), 'db');
          x = lstTin[i];
        }
        if (x[0]=='d' && !['l','n','t'].contains(x[1])){///xét đão , ky tu sau khac ma dai dl,dn,dt
          //tach so tien va kieu
          if (x[1]=='b'  || ['xc','ts','ab','dd','lo'].contains(x.substring(1,3))
                        || (x.length>3 && ['dau','dui'].contains(x.substring(1,4)))
                        || (x.length>4 && ['xdau','xdui'].contains(x.substring(1,5)))){
            bCoDao=true; kytuDao='~'; lstTin[i] = x.substring(1);
            x = lstTin[i];
            if (i<lstTin.length-1){//xet cụm sau neu là kieu danh thi lay so dao phia truoc chèn vào để tránh đão
              if (!isNumeric(lstTin[i+1])){
                bool bSoDao = false;
                String kieu=lstTin[i+1];
                int j=i-1; int k=i+1;
                List<String> lstTmp = [];
                while (j>0){
                  if (isNumeric(lstTin[j])){
                    lstTmp.insert(0,lstTin[j]);
                    // if (!isalpha(kieu)) lstTin.insert(k, lstTin[j]);
                    if (!isalpha(kieu)) lstTin[i+1] = '${lstTmp.join('.')}.$kieu'; ///Đã sửa
                    k+=1; bSoDao=true;
                  }else{
                    List<String> ls=lstTin[j].split('.');
                    /////////////
                    if ([3,4].contains(ls[0].length) && isNumeric(ls[0])) bSoDao=true;
                    if (bSoDao) break;
                  }
                  j-=1;
                }//while
              }//if !
            }//if (i<lstTin
          }//if x[1]
          //thuc hien tiep tren x mới


        }//if x[0]


        if (['ts','ab','xc'].contains(x.substring(0,2))) {
          lstTin[i]=lstTin[i].replaceAll(x.substring(0,2),'dd');
        } else if (x.length>2 && x.substring(0,3) == 'dau') {
          lstTin[i] = lstTin[i].replaceAll('dau', 't');
        } else if (x.length>2 && ['dui','gdb'].contains(x.substring(0,3))) {
          lstTin[i] = lstTin[i].replaceAll(x.substring(0,3), 's');
        } else if (x.length>3 &&  x.substring(0,4) == 'xdau') {
          lstTin[i]=lstTin[i].replaceAll('xdau','t');
        } else if (x.length>3 && x.substring(0,4) == 'xdui') {
          lstTin[i]=lstTin[i].replaceAll('xdui','s');
        } else if (x.length>2 && x.substring(0,3) == 'bao') {
          lstTin[i] = lstTin[i].replaceAll('bao', 'b');
        } else if (x.length>1 &&  x.substring(0,2) == 'lo') {
          lstTin[i] = lstTin[i].replaceAll('lo', 'b');
        } else if (x[0]=='c' && isNumeric(x[1])) {
          lstTin[i] = lstTin[i].replaceAll('c', 'b');
        } else if (x[0] == 's' && isNumeric(x[1])){
          if (await db.dLookup("tkAB", "TDM_Khach", "ID=$KhachID") == 2) {
            lstTin[i] = lstTin[i].replaceFirst('s', 'b', 1);
          }
        }
        else if(x[0] == 'x' && isNumeric(x[1])){
          if (await db.dLookup("tkAB", "TDM_Khach", "ID=$KhachID") == 2) {
            lstTin[i] = lstTin[i].replaceFirst('x', 'b', 1);
          } else{
            int j=i-1; bool bCoXC=false;
            while (j>0){
              if (isNumeric(lstTin[j])){
                if (lstTin[j].length == 2) break;
                if (lstTin[j].length == 3){
                  lstTin[i]='xc${x.substring(1)}';
                  x=lstTin[i];
                  bCoXC=true;
                }
              }
              //'033.133.233'
              if (lstTin[j].indexOf('.')>0){
                List<String> lst=lstTin[j].split('.');
                if (lst.first.length==2) break;
                if (lst.first.length == 3) bCoXC=true;
              }
              if (bCoXC) break;
              j-=1;
            }//while
            if (bCoXC){
              if (x[0] == 'x' && isNumeric(x[1]))  lstTin[i] = lstTin[i].replaceFirst('x', 'dd', 1);
              if (x.substring(0,2) == 'xc')  lstTin[i] = lstTin[i].replaceFirst('xc', 'dd', 0);
            }else{
              lstTin[i]='d$x';
              x=lstTin[i];
            }
          }//else
        }else if (x.substring(0,2) == 'bl' && isNumeric(x[2])) {
          lstTin[i] = lstTin[i].replaceAll(x.substring(0,2), 'b');
        } else if (['da','dv'].contains(x.substring(0,2))){
          //kiem tra ma dai truoc do la may dai
          //kiem tra neu 1 dai thi ->dt, neu xien thi dx
          int j=i-1;
          while (j>=0){
            if (['2d','3d','4d'].contains(lstTin[j])){
              if (await db.dLookup("tkDa","TDM_Khach","ID=$KhachID")==1) {
                lstTin[i] = lstTin[i].replaceAll(x.substring(0,2), 'dx');
              } else {
                lstTin[i] = lstTin[i].replaceAll(x.substring(0,2), 'dt');
              }
              break;
            }else
            if (await db.dCount("T01_MaDai",Condition: "MaDai='${lstTin[j]}'")>0){
              if (j>0 && await db.dCount("T01_MaDai", Condition: "MaDai='${lstTin[j-1]}'")>0){
                if (await db.dLookup("tkDa", "TDM_Khach", "ID=$KhachID") == 1) {
                  lstTin[i] = lstTin[i].replaceAll(x.substring(0,2), 'dx');
                } else {
                  lstTin[i] = lstTin[i].replaceAll(x.substring(0,2), 'dt');
                }
              }
              else {
                lstTin[i] = lstTin[i].replaceAll(x.substring(0,2), 'dt');
              }
              break;
            }
            j-=1;
          }//while
          x=lstTin[i];//gán lai để giai quyet tiep: 1234.5678.dt1
        }else if (x[0] =='g' &&  isNumeric(x[1])){
          int vitri=x.indexOf('v');
          if (Mien=='B') {
            lstTin[i]='g${lstVitriB.indexOf(x.substring(0,vitri+1))+1}t${x.substring(vitri+1,x.length)}';
          } else {
            lstTin[i]='g${lstVitriN.indexOf(x.substring(0,vitri+1))+1}t${x.substring(vitri+1,x.length)}';
          }
        }else if (x[0]=='a' && x.substring(2,x.length).contains('b')){ //a50b20=t50s20
          lstTin[i]=lstTin[i].replaceAll('a', 't'); lstTin[i]=lstTin[i].replaceAll('b', 's');
        }else if (x[0] == 'a' && isNumeric(x[1])) {
          lstTin[i]=lstTin[i].replaceAll('a', 't');
        } else if (x[0] == 'd' && x.substring(2,x.length).contains('d')){
          if (x.substring(1,3)=='0d') {
            lstTin[i]='s${x.substring(3,x.length)}'; //d0d50=s50
          } else if (x.substring(x.substring(1,x.length).indexOf('d')+1,x.length)=='d0') {
            lstTin[i]= 't${x.substring(1,x.substring(1,x.length).indexOf('d')+1)}'; //d50d0=t50
          } else {//d10d20=t10s20
            lstTin[i]=lstTin[i].replaceFirst('d', 't',0);
            lstTin[i]=lstTin[i].replaceAll('d', 's');
          }
        }else if (x[0]=='b' && kytuDao=='' && isNumeric(x.substring(1,x.length))
            || x.substring(1,x.length).indexOf(',')>0
            || x.substring(x.length-1,x.length) == 'n'){//b100 la đuôi
          if (await db.dLookup("tkAB","TDM_Khach","ID=$KhachID")==1) {
            lstTin[i]=lstTin[i].replaceFirst('b', 's',1);
          }
        }else if (x.length>3 && x.substring(0,4)=='bdao'){
          bCoDao=true; kytuDao = '~';
          lstTin[i] = 'b${x.substring(4,x.length)}';
        }else if (x.substring(0,2)=='bd' && x.length>2 && isNumeric(x.substring(2,x.length))){
          bCoDao=true; kytuDao = '~'; lstTin[i] = 'b${x.substring(2,x.length)}';
        }
        if (['dt','dx'].contains(x.substring(0,2)) && x.length>2 && isNumeric(x[2])){
          int j=i-1; bool bKco4so=false; bool bCo4so=false;
          while (j>0){
            if (isNumeric(lstTin[j]) && lstTin[j].length==2) bKco4so=true;
            if (bKco4so) break;
            if (isNumeric(lstTin[j]) && lstTin[j].length % 2==0){
              if (lstTin[j+1].length==5 && bCo4so) {
                lstTin[j]='${ChenKyTu('.', lstTin[j], 2)}.$x';
              } else{
                int k = lstTin[j].length-2;
                while (k > 0){
                  lstTin[j]=ChenKyTu(lstTin[j],'.',k);
                  k-=2;
                }//while
              }//if len==5
              bCo4so=true; j-=1; continue;
            }
            if (bCo4so && !isNumeric(lstTin[j])) break;
            j-=1;
          }//while j
        }//if dt,dx
        //gắn ky tu Đão để duyet vòng lặp khác tinh toan Dao
        if (kytuDao!='') lstTin[i] = '~${lstTin[i]}';
        i+=1;
      }//for
      //lay cac so đão đặt trước Đão
      if (bCoDao){

        String st=lstTin.join('.');
        lstTin=st.split('.');
        i=0;
        while (i<lstTin.length){
          String x=lstTin[i]; String sSoDao='';
          if (isNumeric(x) && sSoDao!=''){
            lstTin.insert(i,rstrip(sSoDao));
            sSoDao=''; i+=1;continue;
          }
          if (x[0]=='~'){
            lstTin[i]=x.substring(1);
            bool bCoSo=false; bool bThayThe=false;
            int j=i-1;
            while (j>=0){
              if (isNumeric(lstTin[j])){
                sSoDao = '${lstTin[j]}.$sSoDao';
                if (isNumeric(lstTin[i-1])){
                  lstTin[j]=DaoSo_lst(lstTin[j]);
                  bThayThe=true;
                }else{
                  if (bThayThe) {
                    lstTin[j] = '${DaoSo_lst(lstTin[j])}.${lstTin[i]}';
                  } else {
                    lstTin[i] = '${DaoSo_lst(lstTin[j])}.${lstTin[i]}';
                  }
                }
                bCoSo = true;
              }else //if isNum
                  if (bCoSo) {
                    break;
                  }
              j-=1;
            }
          }
          i+=1;
        }
      }
      return lstTin;
    }//if dcount
  }on Exception catch(e) {print(e);}
}

// get_TTdai(String Ngay, String MaDai)async {//can test lai vi TT:1.1
//   int ttDai=0;
//   String sThu = await db.dLookup("Thu", "T01_MaDai", "MaDai= '$MaDai'");
//   String tt= await db.dLookup("TT","T01_MaDai","MaDai='$MaDai'");
//   if (sThu.length == 1) ttDai= int.parse(tt);
//   else {
//     String thu =Thu(Ngay).toString();
//     if (sThu[0]==thu) ttDai= int.parse(tt[0]);
//     else if (sThu[sThu.length-1]==thu) //sThu[-1:]
//       ttDai= int.parse(tt.substring(tt.length-1)) ;
//   }
//   return ttDai;
// }

ds_Dai(String Ngay, String Mien,int iSoDai) async{//test lai
  String sThu=(Thu(Ngay)-1).toString();
  List<String> lstDaiHT = [];
  if(Mien!="B"){
    // int thu = ngay.weekday - 1;
    List<Map<String, dynamic>> lstDaiHienTai = await db.loadData(sql: '''
      Select MaDai,substr(TT, INSTR(Thu,'$sThu'), 1) as indexTT 
        From T01_MaDai 
        Where Mien = '$Mien' 
        And Thu LIKE '%$sThu%' 
        Order By indexTT
    ''');
    lstDaiHT = lstDaiHienTai.map((e) => e['MaDai'].toString()).toList().sublist(0,iSoDai);
  }
  // List<Map> lstTable=await db.loadData(sql: "SELECT MaDai FROM T01_MaDai WHERE Mien= '$Mien' AND (SUBSTR(Thu,1,1)= '$sThu'  OR SUBSTR(Thu,3,1)= '$sThu')");
  // List lstTTdai=[];
  // for (int i=0;i<lstTable.length;i++)
  //   lstTTdai.add('');
  // int TT=0;
  //
  // for (int i=0;i<lstTable.length;i++){
  //   TT=await get_TTdai(Ngay,lstTable[i]['MaDai']);
  //   lstTTdai[TT-1]=lstTable[i]['MaDai'];
  // }
  // List lsTmp = [];
  // if (lstTTdai.isNotEmpty && iSoDai<=lstTTdai.length)
  //   for (int i = 0; i < iSoDai; i++)
  //     lsTmp.add(lstTTdai[i]);
  return lstDaiHT;
}