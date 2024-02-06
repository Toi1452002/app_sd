bool isNumeric(String s) {//kiem tra xem chuoi co phai la so khong
  if (s == null) return false;
  return double.tryParse(s) != null;
}

bool isalnum(String s){//kiem tra xem chuoi co phai ky tu va so
  return RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(s);
}

bool isalpha(String s){//kiem tra xem chuoi co phai ky tu
  return RegExp(r'^[A-Za-z_.]+$').hasMatch(s);
}
String lstrip(String s)=>(s[0]=='.'?s.substring(1):s);

String rstrip(String s)=>(s[s.length-1]=='.'?s.substring(0,s.length-1):s);

String strip(String s){
  s=lstrip(s);
  s=rstrip(s);
  return s;
}

int demPhanTu_st(String St, String kitu){//st.count(kytu)
  int dem=0;
  for (var i=0;i<St.length;i++){
    if (St[i]==kitu) dem+=1;
  }
  return dem;
}

int demPhanTu_list(List lstSo, String so){//lstSo.count(So)
  int dem=0;
  for (var x in lstSo){
    if (x==so) dem+=1;
  }
  return dem;
}

int Thu(String Ngay){//Ngay='2022-10-15'=6->saturday; sun=0,..sat=6
  var dt = DateTime.parse(Ngay);
  return dt.weekday;
}