import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;



class SevenScreen extends StatefulWidget {
  @override
  SevenScreenState createState() => SevenScreenState();
}
class SevenScreenState extends State<SevenScreen> {
  // 总数
  var list = [];
  var time = '';

  Future<void> onRefreshing() async {
    list.clear();
    try {
      Map<String, dynamic> httpHeaders = {
        'x-udid': '6aba6d51a0e4e8f2e8e508c9a946fcba0abb9c06',
        'x-app-ver': 'ios_base_4.4.0',
        'x-token': '',
        'x-app-id': 'g93rhHb9DcDptyPb',
        'x-version':'1.0.0'
      };
      Options options = Options(headers:httpHeaders);
      Response response = await Dio().get(
          "https://flash-api.jin10.com/get_flash_list",
          options: options
      );
      if (mounted) {
        print(response);
        setState(() {
          list.addAll(response.data['data']);
          time = list.last["time"];
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
        'x-version':'1.0.0'
      };
      Options options = Options(headers:httpHeaders);
      Response response = await Dio().get(
          "https://flash-api.jin10.com/get_flash_list?max_time=${time}",
          options: options
      );
      if (mounted) {
        print(response);
        setState(() {
          list.addAll(response.data['data']);
          time = list.last["time"];
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
        backgroundColor: Colors.white,
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
                    if(list[i]["type"] != 0) {
                      return Container(height: 0,);
                    }
                    return  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            i== 0 ? Container(
                              padding: EdgeInsets.all(2),
                              margin: EdgeInsets.only(left:14),
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                      color: Colors.white,
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
                                              ? TimelineUtil.format(DateTime.parse(list[i]["time"]).millisecondsSinceEpoch,
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
                                    color: Colors.white,
                                    child: Image(
                                      width: 6,
                                      height: 6,
                                      image: AssetImage('images/circle.jpg'),
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
                                  color: Colors.white,
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
                                    Html(
                                      data:list.isNotEmpty != null  && list[i]["data"]["content"] != null ? list[i]["data"]["content"].replaceAll('金十', '期货') : '',
                                      defaultTextStyle: TextStyle(
                                        fontFamily: 'serif',
                                        color:list[i]["important"] == 1 ? Colors.red[300]: Colors.black87,
                                        fontSize: 13
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    list[i]["data"]["pic"] != '' ? Image(
                                      image: NetworkImage(list[i]["data"]["pic"] ),
                                      height: 90,
                                      fit: BoxFit.fitHeight,
                                    ) :Container(),
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