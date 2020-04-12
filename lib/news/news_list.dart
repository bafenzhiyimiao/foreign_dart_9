import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flustars/flustars.dart';
import 'package:futures/news/news_detail.dart';
import 'package:flutter/cupertino.dart';



class NewsList extends StatefulWidget {
  final catid;
  NewsList({Key key, @required this.catid, }) : super(key: key);
  @override
  NewsListState createState() => NewsListState(catid:catid);
}
class NewsListState extends State<NewsList> {

  final catid;
  NewsListState({Key key, @required this.catid, });
  // 总数
  var list = [];
  var page = 1;

  Future<void> onRefreshing() async {
    list.clear();
    try {
      Response response = await Dio().get(
          "https://news.followme.com/api/v1/news/${catid}/list?&cid=${catid}&page=1&size=15",
      );
      if (mounted) {
        // var res = jsonDecode(response.data);
        setState(() {
          list.addAll(response.data["data"]["items"]);
          page = 2;
        });
      }

    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  Future<void> onLding() async {
    try {
      Response response = await Dio().get(
          "https://news.followme.com/api/v1/news/${catid}/list?&cid=11&page=${page}&size=15",
      );
      if (mounted) {
        // var res = jsonDecode(response.data);
        setState(() {
          list.addAll(response.data["data"]["items"]);
          page = page +1;
        });
      }

    } catch (e) {
      print(e);
    }
    setState(() {});
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
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                              Navigator.of(context,rootNavigator: true).push(
                                new MaterialPageRoute(builder: (BuildContext context) {
                                return new NewsDetail(id:list[i]["id"]);
                              }));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(context).dividerColor,
                                  style: BorderStyle.solid,
                                  width: 0.4,
                                )
                              ),
                            ),
                          padding: EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child:Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(
                                        list.isNotEmpty? list[i]["title"] : "",
                                        style: new TextStyle(fontSize: 14.0),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Padding(padding: EdgeInsets.only(top:10),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                           new Text(
                                          list.isNotEmpty
                                              ? TimelineUtil.format(list[i]["create_time"]*1000,
                                                dayFormat: DayFormat.Full)
                                              : '',
                                          style: new TextStyle(color: Colors.grey, fontSize: 12.0),
                                        ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ),
                              Expanded(
                                flex: 1,
                                child: new Image(
                                  height: 70,
                                  width: 90,
                                fit: BoxFit.fill,
                                  image: new NetworkImage(
                                      list.isNotEmpty? list[i]["path"] : null),
                                  ),
                              )
                            ],
                          ),
                          )
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