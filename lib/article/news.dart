import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/taurus_footer.dart';
import 'package:flutter_easyrefresh/taurus_header.dart';
import 'package:flustars/flustars.dart';
import 'package:futures/article/news_detail.dart';
import 'package:flutter/cupertino.dart';



class NewsList extends StatefulWidget {
  @override
  NewsListState createState() => NewsListState();
}
class NewsListState extends State<NewsList> {
  // 总数
  var newsList = [];
  var page = 1;

  Future<void> onRefreshing() async {
    newsList.clear();
    try {
      Response response = await Dio().get(
          "http://news.taoketong.cc//api/articlelist?catid=14,16,10,12,11&number=20&page=1",
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
          "http://news.taoketong.cc//api/articlelist?catid=14&number=20&page=${page}",
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
      return Scaffold(
        body: newsList.isNotEmpty ?  EasyRefresh.custom(
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
                          child: Card(
                          margin: EdgeInsets.only(left: 10,right: 10,bottom: 0,top: 10),
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
                                child: Container(
                                  height: 90,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    image: new DecorationImage(
                                      image: NetworkImage(newsList[i]["imgurl"]),
                                      fit:BoxFit.fill
                                    ),
                                  ),
                                )
                                 
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
        ) : Image(
          image: AssetImage('images/list_empty.jpg'),
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        )
      );
  }
}