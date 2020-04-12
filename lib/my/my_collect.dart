import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flustars/flustars.dart';
import 'package:futures/news/news_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:futures/global.dart';




class CollectScreen extends StatefulWidget {
  @override
  CollectScreenState createState() => CollectScreenState();
}
class CollectScreenState extends State<CollectScreen> {
  // 总数
  var list = [];

  

  Future<void> onRefreshing() async {
    LocalStorage.getJSON('collect').then((val) {
      if(val!= null) {
        setState(() {
          list = val;
        });
      }
    });
  }



  

  @override
  void initState() {
    super.initState();
    onRefreshing();
    LocalStorage.clear();
  }



  @override
  Widget build(BuildContext context) {

      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('我的收藏'),
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0.0,
          
          leading: new IconButton(
            icon: new Image.asset('assets/left.jpg',
                width: 11, height: 20),
                
          
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: list.isNotEmpty ? EasyRefresh.custom(
          onRefresh: () async {
             this.onRefreshing();
          },
          onLoad: () async {
          },
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, i) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                              Navigator.of(context,rootNavigator: true).push(
                                new MaterialPageRoute(builder: (BuildContext context) {
                                return new NewsDetail(id:list[i]["id"]);
                              }));
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Theme.of(context).dividerColor,
                                      style: BorderStyle.solid,
                                      width: 1,
                                    )
                                  ),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          list[i]["title"].replaceAll('金十','期货'), 
                                          style: TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                        Padding(padding: EdgeInsets.only(top:20),),
                                        new Text(
                                          TimelineUtil.format(list[i]["create_time"]*1000,
                                                dayFormat: DayFormat.Full),
                                          style: new TextStyle(color: Colors.grey, fontSize: 12.0),
                                        ),
                                      ],
                                    ),
                                    ),
                                     
                                  ],
                                ),
                              )
                               ],
                          )
                        );
                },
                childCount: list.length,
              ),
            ),
          ],
        ) : Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/data.jpg',width: 100,fit: BoxFit.fill,),
              Padding(padding: EdgeInsets.only(top:5),),
              Text('暂无收藏',style: TextStyle(color: Colors.grey,fontSize: 12),)
            ],
          ),
      ),
      );
  }
}