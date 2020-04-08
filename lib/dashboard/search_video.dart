import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:futures/choice/video_detail.dart';
import 'package:flutter/cupertino.dart';



class SearchVideo extends StatefulWidget {
  final name;
  SearchVideo({Key key, @required this.name}) : super(key: key);
  @override
  SearchVideoState createState() => SearchVideoState( name: name);
}
class SearchVideoState extends State<SearchVideo> {
   final name;
  SearchVideoState({Key key,  @required this.name});
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
          "https://search-open-api.jin10.com/search?keyword=${name}&order=1&page=1&page_size=20&position=user&type=video&vip=-1",
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
          "https://search-open-api.jin10.com/search?keyword=${name}&order=1&page=1&page_size=20&position=user&type=video&vip=-1",
          options: options,
      );
      if (mounted) {
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
                    if(list[i]["vip"] == 1) {
                      return  Container(height: 0,);
                    }
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                              Navigator.of(context,rootNavigator: true).push(
                                new MaterialPageRoute(builder: (BuildContext context) {
                                return new VideoDetail(id:list[i]["id"]);
                              }));
                          },
                          child: Container(
                            color: Theme.of(context).cardColor,
                            margin:EdgeInsets.only(bottom:1),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(list[i]["title"], style: TextStyle(fontWeight: FontWeight.w700),),
                                Padding(padding: EdgeInsets.only(bottom:10),),
                                Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  margin: new EdgeInsets.symmetric(horizontal: 10.0),
                                  alignment: Alignment.bottomLeft,
                                  padding: EdgeInsets.fromLTRB(15, 15, 15, 20),
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                                    image: new DecorationImage(
                                      image: NetworkImage(list[i]["web_thumbs"][0]),
                                      fit:BoxFit.fill
                                    ),
                                  ),
                                  child:Text(list[i]["display_datetime"], style: new TextStyle(fontSize: 14.0,color: Colors.white,fontWeight: FontWeight.w700),),
                                ),

                                
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