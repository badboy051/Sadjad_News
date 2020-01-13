//import 'dart:convert';
//import 'package:http/http.dart' as http;
//import 'package:html/parser.dart';
//import 'package:html/dom.dart' as dom;
//import 'package:sadjad_news/Models/News.dart';
//
//List<News> products = [];
//void getProduct() {
//  if (products.length == 0) {
//    var url = "http://192.168.1.127/flutter_app3/";
//
//    http.get(url).then((response) {
//      print(response.statusCode); //200
//
//      if (response.statusCode == 200) {
//        List jsonResponse = convert.jsonDecode(response.body);
//
//        for (int i = 0; i < jsonResponse.length; i++) {
//          setState(() {
//            products.add(
//              new Product(
//                  title: jsonResponse[i]['title'],
//                  img_url: jsonResponse[i]['img_url'],
//                  price: int.parse(jsonResponse[i]['price'])),
//            );
//          });
//        }
//      }
//    });
//  }
//}