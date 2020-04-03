import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flustars/flustars.dart';
import 'package:futures/dashboard/hotdetail.dart';
import 'package:flutter/cupertino.dart';



class HotList extends StatefulWidget {
  final id;
  final hot;
  HotList({Key key, @required this.id, @required this.hot}) : super(key: key);
  @override
  HotListState createState() => HotListState(id: id, hot: hot);
}
class HotListState extends State<HotList> {
   final id;
   final hot;
  HotListState({Key key, @required this.id,  @required this.hot});
  // 总数
  var list = [];
  var page = 1;

  

  Future<void> onRefreshing() async {
    list.clear();
    try {
      Map<String, dynamic> httpHeaders = {
        'x-udid': '6aba6d51a0e4e8f2e8e508c9a946fcba0abb9c06',
        'x-app-ver': 'ios_base_4.3.2',
        'x-token': '',
        'x-app-id': 'g93rhHb9DcDptyPb',
        'x-version':'1.0.1'
      };
      Options options = Options(headers:httpHeaders);
      Response response = await Dio().get(
          "https://reference-api.jin10.com/topic/getById?id=${id}&page=1&page_size=20",
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
        'x-app-ver': 'ios_base_4.3.2',
        'x-token': '',
        'x-app-id': 'g93rhHb9DcDptyPb',
        'x-version':'1.0.1'
      };
      Options options = Options(headers:httpHeaders);
      Response response = await Dio().get(
          "https://reference-api.jin10.com/topic/getById?id=${id}&page=${page}&page_size=20",
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

      return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          title: Text(hot["title"],style: TextStyle(fontSize: 18),),
          backgroundColor: Theme.of(context).cardColor,
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
                                return new HotDetail(id:list[i]["id"]);
                              }));
                          },
                          child: Column(
                            children: <Widget>[
                              i == 0 ? Container(
                                margin: EdgeInsets.all(20),
                                  width: double.infinity,
                                  height: 200,
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                                  image: new DecorationImage(
                                    image: NetworkImage(hot["web_thumb"]),
                                    fit:BoxFit.fill
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.3),
                                      offset: Offset(0.0, 4),
                                      blurRadius: 8,
                                    )
                                  ],
                                ),
                                alignment: Alignment.bottomLeft,
                                padding: EdgeInsets.all(10),
                                child: Text(hot['introduction'],style: TextStyle(color: Colors.white,fontSize:16,fontWeight:FontWeight.w700),)
                              ) : Container(),


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
        ) : Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset('images/list_empty.jpg',fit:BoxFit.fill),
        ),
      );
  }
}