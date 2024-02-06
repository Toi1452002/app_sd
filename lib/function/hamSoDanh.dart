

import 'hamchung.dart';

List lstKieuDanh = ['t', 's', 'a', 'b', 'c', 'x', 'ts', 'ab', 'dd', 'lo', 'bl', 'xc', 'da',
  'dv', 'dt', 'dx', 'dz', 'db', 'gdb', 'dau', 'dui', 'dxc', 'ddd', 'bao',
  'dlo', 'bsh', 'xdau', 'xdui', 'ddau', 'ddui'];

List<String> lstBLo = ['b1l', 'db1l', 'b2l', 'db2l', 'b3l', 'db3l', 'b4l', 'db4l', 'b5l', 'db5l',
  'b6l', 'db6l', 'b7l', 'db7l', 'b8l', 'db8l', 'b9l', 'db9l'];

//tu khoa theo giai g0v, g0t chuyen tin: N=g0t->g17t, B=g0t->g26t
List lstVitriN = ['g8v', 'g7v', 'g61v', 'g62v', 'g63v', 'g5v', 'g41v', 'g42v',
  'g43v', 'g44v', 'g45v', 'g46v', 'g47v', 'g31v', 'g32v', 'g2v', 'g1v', 'g0v'];

List lstVitriB = ['g0v', 'g1v', 'g21v', 'g22v', 'g31v', 'g32v', 'g33v', 'g34v', 'g35v',
  'g36v', 'g41v', 'g42v', 'g43v', 'g44v', 'g51v', 'g52v', 'g53v', 'g54v',
  'g55v', 'g56v', 'g61v', 'g62v', 'g63v', 'g71v', 'g72v', 'g73v', 'g74v'];

List lstSoDanhBien = ['hang, vi, tong, keo, den'];

String layKeoDen(String sodau, String sosau, {required String kieu,var N = 1}) {
  int n = N.runtimeType !=int ? int.parse(N) : N;
  List<String> result = [];
  int _sodau = int.parse(sodau);
  double sokeo = 0;
  if (int.parse(sosau) > _sodau) {
    sokeo = (int.parse(sosau) - _sodau) / int.parse((int.parse(sosau) - _sodau).toString()[0])*n;
    while (_sodau <= int.parse(sosau)) {
      result.add("0" * (sosau.toString().length - _sodau.toString().length) +
          _sodau.toString());
      kieu == "den" ? _sodau+=n : _sodau += sokeo.toInt();
    }
  }
  return result.join(".");
}
bool ktso_TrungLap(var n) {
  //0000=true, 0001=false
  n = n.toString(); //n dua vao la so hoac chuoi deu duoc
  bool bTrungLap = true;
  for (int i = 0; i < n.length - 1; i++) {
    if (n[i] != n[i + 1]) bTrungLap = false;
  }
  return bTrungLap;
}

String Tong(N) {
  int n = 0;
  if (N.runtimeType != int) {
    n = int.parse(N);
  } else {
    n = N;
  }
  if (n == 10) n = 0;
  String st = '';
  String So = '';
  for (var i = 0; i < 10; i++)
    for (var j = 0; j < 10; j++) {
      So = (i + j).toString();
      if (So[So.length - 1] == n.toString()) {
        So = i.toString() + j.toString();
        st = st + '.' + So;
        So = '';
      }
    }
  return lstrip(st);
}

String Hang(N) {
  //hàng. hang0=01den09
  int n = 0;
  if (N.runtimeType != int) {
    n = int.parse(N);
  } else {
    n = N;
  }
  String so = '';
  for (var i = 0; i <= 9; i++) {
    so += '.' + n.toString() + i.toString();
  }
  return lstrip(so);
}

String Vi(N) {
  //vị. vi0=00keo90
  int n = 0;
  if (N.runtimeType != int) {
    n = int.parse(N);
  } else {
    n = N;
  }
  String so = '';
  for (var i = 0; i <= 9; i++) {
    so += '.$i$n';
  }
  return lstrip(so);
}

String DaoSo_lst(String stSo) {
  //dãy số đão: vd '123'->[123,132,...]
  List lstHV = [];
  void HoanVi(List lst, int vitri) {
    if (vitri == lst.length) {
      lstHV.add(lst);
      return;
    }
    for (int i = vitri; i < lst.length; i++) {
      List hv = new List.from(lst);
      hv[vitri] = lst[i];
      hv[i] = lst[vitri];
      HoanVi(hv, vitri + 1);
    }
  }

  HoanVi(stSo.split(''), 0);
  List<String> lstHoanVi = [];
  for (List hv in lstHV) {
    lstHoanVi.add(hv.join());
  }
  final Set<String> set = Set.from(lstHoanVi);
  return set.toList().join('.');
}

//--md_HamChung

String XoaBotKyTu(String s, String KyTu) {
  //bỏ bớt 2 ky tu trắng và chấm gần nhau 12..34.
  for (var i = 0; i < s.length - 1; i++) {
    if (s[i] == KyTu) if (s[i + 1] == KyTu) {
      s = s.substring(0, i) + s.substring(i + 1, s.length);
      i -= 1;
    }
  }
  return s;
}

String LoaiBo_KyTu_DB2dau(String s) {
  //loai bo cac ky thu dac biet 2 dau: k phai số và chữ
  while (!isalnum(s[0])) {
    s = s.substring(1);
  }
  while (!isalnum(s[s.length - 1])) {
    s = s.substring(0, s.length - 1);
  }
  return s;
}

String LoaiBo_Kytu_la(String s) {
  //bỏ ký tự lạ trong chuỗi
  List<String> KyTuLoaiBo = [
    '~',
    '!',
    '@',
    '#',
    '%',
    '^',
    '&',
    '"',
    '?',
    '\$',
    '\t',
    '\n'
  ]; //'$': chuoi k hien thi dc $, chi hien thi dc \$
  List<String> GiuLai = ['(', ')', '[', ']', '{', '}', '/', ':', '+', '=', '.'];
  List<String> ThayThe = [',', '*', ';', ' ', '_', '-', "'"]; //_>'.'
  //String newText='';
  for (var x in KyTuLoaiBo) {
    if (s.contains(x)) s = s.replaceAll(x, '');
  }
  for (var x in ThayThe) {
    if (s.contains(x)) s = s.replaceAll(x, '.');
  }
  return s;
}

String ThayKyTu_TV(String s) {
  //thay ky tu tieng viet
  Map<String, String> TV = {
    'ắ': 'a',
    'ằ': 'a',
    'ẳ': 'a',
    'ẵ': 'a',
    'ặ': 'a',
    'ă': 'a',
    'ả': 'a',
    'ấ': 'a',
    'ầ': 'a',
    'ẩ': 'a',
    'ẫ': 'a',
    'ậ': 'a',
    'â': 'a',
    'á': 'a',
    'à': 'a',
    'ả': 'a',
    'ã': 'a',
    'ạ': 'a',
    'đ': 'd',
    'é': 'e',
    'è': 'e',
    'ẻ': 'e',
    'ẽ': 'e',
    'ẹ': 'e',
    'ê': 'e',
    'ế': 'e',
    'ề': 'e',
    'ể': 'e',
    'ễ': 'e',
    'ệ': 'e',
    'í': 'i',
    'ì': 'i',
    'ỉ': 'i',
    'ĩ': 'i',
    'ị': 'i',
    'ô': 'o',
    'ố': 'o',
    'ồ': 'o',
    'ổ': 'o',
    'ỗ': 'o',
    'ộ': 'o',
    'ớ': 'o',
    'ờ': 'o',
    'ở': 'o',
    'ỡ': 'o',
    'ợ': 'o',
    'ơ': 'o',
    'ó': 'o',
    'ò': 'o',
    'ỏ': 'o',
    'õ': 'o',
    'ọ': 'o',
    'ư': 'u',
    'ứ': 'u',
    'ừ': 'u',
    'ử': 'u',
    'ữ': 'u',
    'ự': 'u',
    'ú': 'u',
    'ù': 'u',
    'ủ': 'u',
    'ũ': 'u',
    'ụ': 'u',
    'ý': 'y',
    'ỳ': 'y',
    'ỷ': 'y',
    'ỹ': 'y',
    'ỵ': 'y',
    '₫': 'd',
    '×': 'x',
    'à': 'a'
  };
  for (var x in TV.keys) {
    if (s.contains(x)) s = s.replaceAll(x, TV[x].toString());
  }
  return s;
}

String thayTuKhoa(String s) {
  Map<String, String> tukhoa = {
    '.': ' ', '  ': ' ', ' ': ' ', 'hn': 'mb',
    '\n': ' ', '\r':' ', '7lo ': ' b7l', ' 7lo': ' b7l', 'xcdui':'xdui', 'xcdau':'xdau',
    ' keo ':'keo','keo ':'keo',' keo':'keo',
    ' den ':'den','den ':'den',' den':'den',
    'tien giang':'tg','tiengiang':'tg','t giang':'tg','tgiang':'tg',
    'kien giang':'kg','kiengiang':'kg','k giang':'kg','kgiang':'kg',
    'da lat':'dl','dalat':'dl','d lat':'dl','dlat':'dl',
    'kon tum':'kt','kontum':'kt','k tum': 'kt', 'ktum':'kt',
    'khanh hoa':'kh','khanhhoa':'kh','k hoa':'kh','khoa':'kh',
    'thua thien hue': 'tth','hue':'tth','tthue':'tth',
    'thanh pho':'tp','thanhpho':'tp','tphcm':'tp','tpho':'tp','t pho':'tp','tp hcm':'tp',
    'dong thap':'dt','dongthap':'dt','d thap':'dt','dthap':'dt',
    'ca mau':'cm','camau':'cm','c mau':'cm','cmau':'cm',
    'phu yen':'py','phuyen':'py','p yen':'py','pyen':'py',
    'ben tre':'bt','bentre':'bt','b tre':'bt','btre':'bt','btr':'bt',
    'vung tau':'vt','vungtau':'vt','v tau':'vt','vtau':'vt',
    'bac lieu':'bl','baclieu':'bl','b lieu':'bl','blieu':'bl','bliu':'bl',
    'dak lak':'dl','dac lac':'dl','dak lac':'dl','dlak':'dl',
    'quang nam':'qn','quangnam':'qn','q nam':'qn','qnam':'qn','quan nam':'qn',
    'dong nai':'dn','dongnai':'dn','d nai':'dn','dnai':'dn',
    'can tho':'ct','cantho':'ct','c tho':'ct','ctho':'ct','cth':'ct',
    'soc trang':'st','soctrang':'st','s trang':'st','strang':'st','str':'st',
    'da nang':'dn','danang':'dn','d nang':'dn','dnang':'dn',
    'tay ninh':'tn','tayninh':'tn','t ninh':'tn','tninh':'tn',
    'an giang':'ag','angiang':'ag','a giang':'ag','agiang':'ag',
    'binh thuan':'bt','binhthuan':'bt','b thuan':'bt','bthuan':'bt',
    'binh dinh':'bd','binhdinh':'bd','b dinh':'bd','bdinh':'bd',
    'quang tri':'qt','quangtri':'qt','q tri':'qt','qtri':'qt','quan tri':'qt',
    'quang binh':'qb','quangbinh':'qb','q binh':'qb','qbinh':'qb','quan binh':'qb',
    'vinh long':'vl','vinhlong':'vl','v long':'vl','vlong':'vl',
    'binh duong':'bd','binhduong':'bd','b duong':'bd','bduong':'bd',
    'tra vinh':'tv','travinh':'tv','t vinh':'tv','tvinh':'tv','trvinh':'tv',
    'gia lai':'gl','gialai':'gl','g lai':'gl','glai':'gl',
    'ninh thuan':'nt','ninhthuan':'nt','n thuan':'nt','nthuan':'nt',
    'long an':'la','longan':'la','l an':'la','lan':'la',
    'binh phuoc':'bp','binhphuoc':'bp','b phuoc':'bp','bphuoc':'bp',
    'hau giang':'hg','haugiang':'hg','h giang':'hg','hgiang':'hg',
    'quang ngai':'qn','quangngai':'qn','q ngai':'qn','qngai':'qn','quan ngai':'qn',
    'dac nong':'dno','dacnong':'dno','d nong':'dno','dnong':'dno'
  };

  for (String x in tukhoa.keys) {
    if (s.contains(x)) s = s.replaceAll(x, tukhoa[x].toString());
  }
  return s;
}

String ThayKyTu(String s, String KyTu, vitri) {
  //Thay the ky tu vd: .->,
  int n = 0;
  if (vitri.runtimeType != int) {
    n = int.parse(vitri);
  } else {
    n = vitri;
  }
  return s.substring(0, n - 1) + KyTu + s.substring(n, s.length);
}

String ChenKyTu(String s, String KyTu, vitri) {
  //chèn 1 ky tu vao chuoi
  int n = 0;
  if (vitri.runtimeType != int) {
    n = int.parse(vitri);
  } else {
    n = vitri;
  }
  return s.substring(0, n) + KyTu + s.substring(n, s.length);
}

String XoaKyTu(String s, vitri) {
  //xoá ky tu o vi tri
  int n = 0;
  if (vitri.runtimeType != int) {
    n = int.parse(vitri);
  } else {
    n = vitri;
  }
  return s.substring(0, n) + s.substring(n + 1, s.length);
}

String LoaiBoDauCham(String s) {
  //lo.12...34.x10
  while (s.contains('..')) {
    s = s.replaceAll('..', '.');
  }
  return s;
}

List LoaiBoPhanTuRong(List lst) {
  //['lo','12','','','34','x10']
  lst.removeWhere((e) => e == '');
  // while (lst.contains('')) {
  //   lst.remove('');
  // }
  return lst;
}

SoCapSo(N) {
  //số cặp số
  int n = 0;
  if (N.runtimeType != int) {
    n = int.parse(N);
  } else {
    n = N;
  }
  return (n * (n - 1) / 2);
}

String LaySoTien(String s) {
  //100, 0,5, 10d, 10n,10k
  String SoTien = '';
  if (s.indexOf(',') > 0) {
    int i = 0;
    while (i < s.length) {
      if (isNumeric(s[i])) SoTien += s[i];
      i += 1;
    }
    SoTien = (int.parse(SoTien) / 10).toString();
  } else {
    if (['n', 'k', 'd'].contains(s[s.length - 1])) {
      SoTien = s.substring(0, s.length - 1);
    } else {
      SoTien = s;
    }
  }
  return SoTien;
}

String SoKhongTrungLap(String s) {
  var lst = s.split('.');
  final Set<String> set = Set.from(lst);
  lst = set.toList();
  return lst.join('.');
}

String LaySoTrungLap(String s) {
  List<String> lst_so = [];
  var lst = s.split('.');
  lst.sort();
  for (var i = 0; i < lst.length - 1; i++) {
    if (lst[i] == lst[i + 1]) lst_so.add(lst[i]);
  }
  return lst_so.join('.');
}

List LayCapSo_from_st(String s) {
  //lay cap so trong 1 day so: 12.13.14=12.13,12.14,13.14 / tg.kg.dl=tg.kg,tg.dl,kg.dl
  List<String> lst_CapSo = [];
  var lst_So = s.split('.');
  for (var i = 0; i < lst_So.length - 1; i++)
    for (var j = i + 1; j < lst_So.length; j++) {
      lst_CapSo.add(lst_So[i] + '.' + lst_So[j]);
    }
  return lst_CapSo;
}

List LayCapSo_from_lst(List lst) {
  //list=['dn','vt','tp']->['dn.vt', 'dn.tp', 'vt.tp']
  List lst_CapSo = [];
  for (var i = 0; i < lst.length - 1; i++)
    for (var j = i + 1; j < lst.length; j++) {
      lst_CapSo.add(lst[i] + '.' + lst[j]);
    }
  return lst_CapSo;
}

List Lay3So_from_st(String s) {
  //01.02.03.04=01.02.03,01.02.04...
  List lst_CapSo = [];
  var lst_So = s.split('.');
  for (var i = 0; i < lst_So.length - 2; i++)
    for (var j = i + 1; j < lst_So.length - 1; j++) {
      for (var k = j + 1; k < lst_So.length; k++) {
        lst_CapSo.add(lst_So[i] + '.' + lst_So[j] + '.' + lst_So[k]);
    }
      }
  return lst_CapSo;
}

List Lay4So_from_st(String s) {
  //01.02.03.04.05=01.02.03.04,01.02.03.05...
  List lst_CapSo = [];
  var lst_So = s.split('.');
  for (var i = 0; i < lst_So.length - 3; i++)
    for (var j = i + 1; j < lst_So.length - 2; j++) {
      for (var m = j + 1; m < lst_So.length - 1; m++) {
        for (var n = m + 1; n < lst_So.length - 1; n++) {
          lst_CapSo.add(
              lst_So[i] + '.' + lst_So[j] + '.' + lst_So[m] + '.' + lst_So[n]);
    }
      }
        }
  return lst_CapSo;
}
