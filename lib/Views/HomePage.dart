

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sadjad_news/Models/News.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<News> newss = [];
  var page = 0;
  var pagecout = 20;

  void getProduct({bool updated=false}) {
    if (newss.isNotEmpty && updated==true) {
      newss.clear();
      page=0;
      pagecout=20;
      print(page);
      print(pagecout);
      print(newss.length);


    }
    print(page);
    var url = "https://www.sadjad.ac.ir/news/classes?page=$page";
    print(url);
    if (newss.isEmpty || page > 0) {
      http.get(url).then((response) {
        if (response.statusCode == 200) {
          var document = parse(response.body);
          List news =
              document.querySelectorAll('#block-sadjad-university-content p');
          List teachers = document.querySelectorAll(".mt-0");
          List date = document.querySelectorAll(".no-gutters");
          dom.Element page = document.querySelector(".active .page-link");

          for (int i = 0; i < news.length; i++) {
            setState(() {
              newss.add(new News(

                teacher: teachers[i].text,
                body: news[i].text,
                date: date[i].text,
                page: page.text,
              ));
            });
          }
        }
      });
    }

  }


  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 2000));
    getProduct(updated: true);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 3000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    await getProduct();
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    if (page == 0) {
      getProduct();
      page++;
    }
    ScrollController _scrollController = new ScrollController();
    _scrollController
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          print(_scrollController.position);
          page++;
          pagecout = pagecout + 20;

          // ... call method to load more repositories
        }
      });
    return
           new Directionality(
          textDirection: TextDirection.rtl,
          child: MaterialApp(
          theme: ThemeData(
          canvasColor: Color(0xff222831),
          primaryColor: Color(0xff222831),
          textTheme: new TextTheme(body1: TextStyle()).apply(
          bodyColor: Color(0xffeeeeee),
          displayColor: Color(0xffeeeeee))),
          localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
          // English
          const Locale('fa'), // Hebrew
          // Chinese *See Advanced Locales below*
          // ... other locales the app supports
          ],
          home: new Scaffold(
          appBar: AppBar(
          title: Text(
          "اخبار کلاس ها",
          style: TextStyle(fontFamily: 'byekan'),
          ),
          ),
          body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropMaterialHeader(
          backgroundColor: Theme.of(context).primaryColor,
          offset: -100.0,
          distance: 30.0,
          ),
          footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
          body = Text("pull up load");
          } else if (mode == LoadStatus.loading) {
          body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
          body = Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
          body = Text("release to load more");
          } else {
          body = Text("No more Data");
          }
          return Container(
          height: 55.0,
          child: Center(child: body),
          );
          },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: new ListView.builder(
          controller: _scrollController,
          itemBuilder: listRow,
          itemCount: pagecout,
          ),
          ),
          ),
          )
          );
        }




  Widget listRow(BuildContext context, int index) {
    return new Container(decoration: myBoxDecoration(),
      child: new Column(children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              child: Expanded(
                child: Center(child: Text(newss[index].date,textAlign: TextAlign.center)),
                flex: 2,
              ),
            ),

            Expanded(flex: 8,
              child: Column(textDirection: TextDirection.rtl,children: <Widget>[
                Text(newss[index].teacher,),
                Text(newss[index].body),


              ],

              )

            )
          ],
        )
      ]),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),


    );
  }
}
BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    color: Color(0xff393e46),
    border: Border.all(
        width: .5
    ),
    borderRadius: BorderRadius.all(
        Radius.circular(5.0)
      //         <--- border radius here
    ),
    boxShadow: [
      new BoxShadow(
          color: Color(0xff323232),
          offset: new Offset(1.0, 1.0),
          blurRadius: 2.0,
          spreadRadius: 1.0
      )
    ],
  );
}