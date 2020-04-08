import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flustars/flustars.dart';
import 'package:futures/news/news_detail.dart';
import 'package:flutter/cupertino.dart';



class News extends StatefulWidget {
  final catid;
  News({Key key, @required this.catid, }) : super(key: key);
  @override
  NewsState createState() => NewsState(catid:catid);
}
class NewsState extends State<News> {

  final catid;
  NewsState({Key key, @required this.catid, });
  // 总数
  var newsList = [];
  var page = 1;

  Future<void> onRefreshing() async {
    newsList.clear();
    try {
      Response response = await Dio().get(
          "http://news.taoketong.cc//api/articlelist?catid=${catid}&number=20&page=1",
      );
      if (mounted) {
        // var res = jsonDecode(response.data);
        setState(() {
          newsList.addAll(response.data);
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
          "http://news.taoketong.cc//api/articlelist?catid=${catid}&number=20&page=${page}",
      );
      if (mounted) {
        // var res = jsonDecode(response.data);
        setState(() {
          newsList.addAll(response.data);
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
    if(newsList.isNotEmpty) {
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
                                return new NewsDetail(id:newsList[i]["id"]);
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
                                        newsList.isNotEmpty? newsList[i]["title"] : "",
                                        style: new TextStyle(fontSize: 14.0),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Padding(padding: EdgeInsets.only(top:10),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                           new Text(
                                          newsList.isNotEmpty
                                              ? TimelineUtil.format(DateTime.parse(newsList[i]["created"]).millisecondsSinceEpoch,
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
                                      newsList.isNotEmpty? newsList[i]["imgurl"] : null),
                                  ),
                              )
                            ],
                          ),
                          )
                        );
                },
                childCount: newsList.length,
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