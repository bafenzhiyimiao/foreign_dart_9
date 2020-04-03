import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';



class SearchFlash extends StatefulWidget {
  final name;
  SearchFlash({Key key, @required this.name}) : super(key: key);
  @override
  SearchFlashState createState() => SearchFlashState( name: name);
}
class SearchFlashState extends State<SearchFlash> {
   final name;
  SearchFlashState({Key key,  @required this.name});
  // 总数
  var list = [];
  var page = 1;


  Future<void> onRefreshing() async {
    list.clear();
    try {
      Map<String, dynamic> httpHeaders = {
        'x-udid': '6aba6d51a0e4e8f2e8e508c9a946fcba0abb9c06',
        'x-app-ver': 'ios_base_4.4.0',
        'x-token': '',
        'x-app-id': 'g93rhHb9DcDptyPb',
        'x-version':'1.0.1'
      };
      Options options = Options(headers:httpHeaders);
      Response response = await Dio().get(
          "https://search-open-api.jin10.com/search?keyword=${name}&order=1&page=1&page_size=20&position=user&type=flash&vip=-1",
          options: options,
      );
      if (mounted) {
        // // var res = jsonDecode(response.data);
        setState(() {
          list = response.data["data"]["list"];
          page = 2;
        });
      }

    } catch (e) {
      print(e);
    }
  }


  Future<void> onLding() async {
    try {
      Map<String, dynamic> httpHeaders = {
        'x-udid': '6aba6d51a0e4e8f2e8e508c9a946fcba0abb9c06',
        'x-app-ver': 'ios_base_4.4.0',
        'x-token': '',
        'x-app-id': 'g93rhHb9DcDptyPb',
        'x-version':'1.0.1'
      };
      Options options = Options(headers:httpHeaders);
      Response response = await Dio().get(
          "https://search-open-api.jin10.com/search?keyword=${name}&order=1&page=1&page_size=20&position=user&type=flash&vip=-1",
          options: options,
      );
      if (mounted) {
        // // var res = jsonDecode(response.data);
        setState(() {
          list.addAll(response.data["data"]["list"]);
          page = page + 1;
        });
      }

    } catch (e) {
      print(e);
    }
  }

  

  @override
  void initState() {
    super.initState();
    onRefreshing();
  }



  @override
  Widget build(BuildContext context) {

    if(list.isNotEmpty) {

      return Scaffold(
        body: EasyRefresh.custom(
          onRefresh: () async {
             this.onRefreshing();
          },
          onLoad: () async {
            this.onLding();
          },
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    if(list[i]["remark"] != null ) {
                      return Container(height: 0,);
                    }
                        return Container(
                            color: Colors.white,
                            margin:EdgeInsets.only(bottom:10),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                               Container(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Html(
                                        data:list.isNotEmpty != null  && list[i]["data"]["content"] != null ? list[i]["data"]["content"].replaceAll('金十', '期货') : '',
                                        defaultTextStyle: TextStyle(
                                          fontFamily: 'serif',
                                          color:list[i]["important"] == 1 ? Colors.red[300]: Colors.black87,
                                          fontSize: 13
                                        ),
                                        backgroundColor: Colors.white,
                                      ),
                                      Padding(padding: EdgeInsets.only(top:10),),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          list.isNotEmpty
                                              ? TimelineUtil.format(DateTime.parse(list[i]["time"]).millisecondsSinceEpoch,
                                                dayFormat: DayFormat.Full)
                                              : '',
                                          style: TextStyle(color: Colors.blueGrey,fontSize: 12),
                                          textAlign: TextAlign.end,
                                        )
                                      )
                                    ],
                                  )
                                  
                              )
                              ],
                            ),
                        );
                },
                childCount: list.length,
              ),
            ),
          ],
        ),
      );
    }else {
      return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/empty.jpg',width: 100,fit: BoxFit.fill,),
              Padding(padding: EdgeInsets.only(top:5),),
              Text('暂无数据',style: TextStyle(color: Colors.grey,fontSize: 12),)
            ],
          ),
      ); 
    }
  }
}