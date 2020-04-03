import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flustars/flustars.dart';
import 'package:futures/dashboard/hotdetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:futures/global.dart';




class CollectList extends StatefulWidget {
  @override
  CollectListState createState() => CollectListState();
}
class CollectListState extends State<CollectList> {
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
  }



  @override
  Widget build(BuildContext context) {

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('我的收藏',style: TextStyle(color: Colors.black87,fontSize: 18),),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          
          leading: new IconButton(
            icon: new Image.asset('images/left.jpg',
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
                                return new HotDetail(id:list[i]["id"]);
                              }));
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[100],
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
                                          TimelineUtil.format(DateTime.parse(list[i]["display_datetime"]).millisecondsSinceEpoch,
                                                dayFormat: DayFormat.Full),
                                          style: new TextStyle(color: Colors.grey, fontSize: 12.0),
                                        ),
                                      ],
                                    ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left:20),
                                       width: 120,
                                        height: 80,
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                                        image: new DecorationImage(
                                          image: NetworkImage(list[i]["web_thumbs"][0]),
                                          fit:BoxFit.fill
                                        ),
                                      ),
                                    )
                                    
                                     
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
              Image.asset('images/empty.jpg',width: 100,fit: BoxFit.fill,),
              Padding(padding: EdgeInsets.only(top:5),),
              Text('暂无收藏',style: TextStyle(color: Colors.grey,fontSize: 12),)
            ],
          ),
      ),
      );
  }
}