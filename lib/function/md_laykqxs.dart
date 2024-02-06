import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:sd_pmn/function/extension.dart';

Future<Map<String, dynamic>> getKqxs(DateTime ngay, String mien,{bool xsMinhNgoc =false }) async {
  Map<String, dynamic> result = {"ngay": null, "listDai": [], "kqSo": []};
  List<String> listDai = [];
  List<String> listKq = [];
  Map<String, String> thaydoimien = {"N":"mien-nam", "T":"mien-trung", "B":"mien-bac"};
  mien = thaydoimien[mien]!;
  String ngayKQ = "";
  String dateFormat = DateFormat("dd-MM-yyyy").format(ngay);
  String mamien = mien[0] + mien[mien.indexOf("-") + 1];
  Uri uriXshomnay = Uri.parse(
      'https://xosohomnay.com.vn/ket-qua-xo-so-$mien-kqxs-$mamien/ngay-$dateFormat/');
  Uri uriXsminhngoc = Uri.parse(
      "https://www.minhngoc.net.vn/ket-qua-xo-so/$mien/$dateFormat.html");
  var responseXshomnay = await http.get(uriXshomnay);
  var responseXsminhngoc = await http.get(uriXsminhngoc);


  if(!xsMinhNgoc){
    try{
      if (responseXshomnay.statusCode == 200  ) {
        var convertHtml = parse(responseXshomnay.body);
        String year = convertHtml.getElementsByClassName("year").first.text;
        String date_month =
            convertHtml.getElementsByClassName("daymonth").first.text;
        String month = date_month.substring(date_month.indexOf("/") + 1);
        String date = date_month.substring(0, date_month.indexOf("/"));
        ngayKQ =
            DateFormat("yyyy-MM-dd").format(DateTime.parse("$year-$month-$date"));
        var row;
        if (mamien != "mb") {
          row = convertHtml
              .getElementsByClassName("rightcl")
              .first
              .getElementsByTagName("table")
              .first
              .getElementsByTagName("tbody")
              .first
              .getElementsByTagName("tr")
              .first;
          var namelong = row.getElementsByClassName("namelong");
          for (var itemlong in namelong) {
            String dai = itemlong.innerHtml;
            listDai.add(replaceDai(dai));
          }
          var dayso = row.getElementsByClassName("dayso");
          dayso.forEach((so) {
            if (so.innerHtml.toString().isNumeric) {
              listKq.add(so.innerHtml);
            }
          });
        } else {
          var convertHtml = parse(responseXshomnay.body);
          var row = convertHtml
              .getElementsByClassName("xsmb")
              .first
              .getElementsByClassName("dayso");
          for (var so in row) {
            listKq.add(so.text);
          }
          listDai.add("mb");
        }
      }
    }catch(e){
      print(e);
    }

  }/** Lấy kết quả xổ số hôm nay */
  else{  /** Lấy kết quả xổ số minh ngọc */
    try{
      if(responseXsminhngoc.statusCode==200){
        var convertHtml = parse(responseXsminhngoc.body);
        String ngay = convertHtml.getElementsByClassName("title").first.getElementsByTagName("a").last.text;
        List<String> lstNgay = ngay.split("/");
        ngayKQ = "${lstNgay.last}-${lstNgay[1]}-${lstNgay.first}";

        if(mamien!="mb"){
          var nameLong = convertHtml.getElementsByClassName('content')[0].getElementsByClassName("tinh");
          for(var x in nameLong){
            String dai = replaceDai(x.text.trim());
            listDai.add(dai);
          }
          var row = convertHtml.getElementsByClassName('content')[0].getElementsByClassName("rightcl");
          for(var x in row){
            var dayso = x.getElementsByTagName("div");
            for(var s in dayso){
              listKq.add(s.text);
            }
          }
        }else{
          listDai.add("mb");
          var row = convertHtml.getElementsByClassName('content')[0].getElementsByTagName("tbody")[1].getElementsByTagName("div");
          for(var x in row){
            if(x.text.isNumeric){
              listKq.add(x.text);
            }
          }
        }
      }
    }catch(e){
      print(e);
    }
  }

  result["listDai"] = listDai;
  result["ngay"] = ngayKQ;
  result["kqSo"] = listKq;

  return result;
}

String giaiMN(int stt) {
  String giai = "";
  if (stt == 1) {
    giai = "G8";
  } else if (stt == 2) {
    giai = "G7";
  } else if (stt > 2 && stt < 6) {
    giai = "G6";
  } else if (stt == 6) {
    giai = "G5";
  } else if (stt > 6 && stt < 14) {
    giai = "G4";
  } else if (stt > 13 && stt < 16) {
    giai = "G3";
  } else if (stt == 16) {
    giai = "G2";
  } else if (stt == 17) {
    giai = "G1";
  } else if (stt == 18) {
    giai = "DB";
  }
  return giai;
}

String giaiMB(int tt) {
  String giai = "";
  if (tt == 1) {
    giai = "DB";
  } else if (tt == 2) {
    giai = "G1";
  } else if (tt >= 3 && tt <= 4) {
    giai = "G2";
  } else if (tt >= 5 && tt <= 10) {
    giai = "G3";
  } else if (tt >= 11 && tt <= 14) {
    giai = "G4";
  } else if (tt >= 15 && tt <= 20) {
    giai = "G5";
  } else if (tt >= 21 && tt <= 23) {
    giai = "G6";
  } else if (tt >= 24) {
    giai = "G7";
  }
  return giai;
}

String replaceDai(String dai) {
  Map<String, String> map = {
    "Tiền Giang": "tg",
    "Kiên Giang": "kg",
    "Đà Lạt": "dl",
    "Đà Nẵng": "dng",
    "Khánh Hòa": "kh",
    "Tây Ninh": "tn",
    "An Giang": "ag",
    "Bình Thuận": "bth",
    "Bình Định": "bdi",
    "Quảng Trị": "qt",
    "Quảng Bình": "qb",
    "Vĩnh Long": "vl",
    "Bình Dương": "bd",
    "Trà Vinh": "tv",
    "Gia Lai": "gl",
    "Ninh Thuận": "nt",
    "TP. HCM": "tp",
    "Long An": "la",
    "Bình Phước": "bp",
    "Hậu Giang": "hg",
    "Quảng Ngãi": "qng",
    "Đắk Nông": "dno",
    "Thừa T. Huế": "tth",
    "Kon Tum": "kt",
    "Bến Tre": "bt",
    "Vũng Tàu": "vt",
    "Bạc Liêu": "bl",
    "Đắk Lắk": "dlk",
    "Quảng Nam": "qnm",
    "Phú Yên": "py",
    "Đồng Tháp": "dt",
    "Cà Mau": "cm",
    "Đồng Nai":"dn",
    "Cần Thơ":"ct",
    "Sóc Trăng":"st"
  };

  return map[dai].toString();
}
