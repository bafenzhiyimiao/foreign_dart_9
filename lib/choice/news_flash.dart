import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;



class NewsFlash extends StatefulWidget {
  @override
  NewsFlashState createState() => NewsFlashState();
}
class NewsFlashState extends State<NewsFlash> {
  // 总数
  var list = [];
  var page = 1;

  Future<void> onRefreshing() async {
    list.clear();
    try {
      Response response = await Dio().get(
          "https://openapi.pubhx.com/hx/?service=Advisory.quickList&companyId=9&page=1&pagesize=20&userCookie=",
      );
      if (mounted) {
        print(response);
        setState(() {
          list.addAll(response.data['data']["list"]);
          page = 2;
        });
      }

    } catch (e) {
      print(e);
    }
  }

  Future<void> onLding() async {
    try {
      Response response = await Dio().get(
          "https://openapi.pubhx.com/hx/?service=Advisory.quickList&companyId=9&page=${page}&pagesize=20&userCookie=",
      );
      if (mounted) {
        print(response);
        setState(() {
          list.addAll(response.data['data']["list"]);
          page = page +1;
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
        backgroundColor: Theme.of(context).backgroundColor,
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
                    return  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            i== 0 ? Container(
                              padding: EdgeInsets.all(2),
                              margin: EdgeInsets.only(left:14,top: 15),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                border: Border.all(width: 0.4,color: Colors.blue[200]),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Text(DateTime.now().day.toString(),style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w700,fontSize: 11),),
                                  Text(DateTime.now().month.toString() + ' 月',style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 10),),
                                ],
                              ),
                            ) : Container(height: 0,),
                            Stack(
                              children: <Widget>[
                                
                                Container(
                                  margin: EdgeInsets.fromLTRB(25,0,10,0),
                                  padding: EdgeInsets.only(top: 10,bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).backgroundColor,
                                      border: Border(
                                        left: BorderSide(
                                          color: Colors.blue[100],
                                          style: BorderStyle.solid,
                                          width: 0.4,
                                        )
                                      ),
                                    ),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 20,
                                        height: 1,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Colors.blue[100],
                                              style: BorderStyle.solid,
                                              width: 0.4,
                                            )
                                          ),
                                    ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 3,bottom:3,left:6,right:6),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
                                        child: new Text(
                                          list.isNotEmpty
                                              ? TimelineUtil.format(DateTime.parse(list[i]["ctime"]).millisecondsSinceEpoch,
                                                dayFormat: DayFormat.Full)
                                              : '',
                                          style: new TextStyle(color: Colors.blueGrey, fontSize: 10.0),
                                        ),
                                      )
                                    ],
                                  )
                                    
                                ),
                                Positioned(
                                  left: 22,
                                  top: 17,

                                  child: Container(
                                    color: Theme.of(context).backgroundColor,
                                    child: Image(
                                      width: 6,
                                      height: 6,
                                      image: AssetImage('assets/circle.jpg'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            Container(
                                margin: EdgeInsets.fromLTRB(25,0,10,0),
                                padding: EdgeInsets.only(left: 20,top: 10,bottom: 10,right: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.blue[100],
                                      style: BorderStyle.solid,
                                      width: 0.4,
                                    )
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      list.isNotEmpty != null  && list[i]["title"] != null? list[i]["title"] : '',
                                    )
                                  ],
                                )
                                
                            )
                          ],
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
          
        ); 
    }
  }
}