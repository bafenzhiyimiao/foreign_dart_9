import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:futures/choice/visual_screen_detail.dart';
import 'package:flutter/cupertino.dart';



class SchoolScreen extends StatefulWidget {
  @override
  _SchoolScreen createState() => _SchoolScreen();
}
class _SchoolScreen extends State<SchoolScreen> {
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
          "https://reference-api.jin10.com/reference?nav_bar_id=18&page=1&page_size=20",
          // https://comment-api.jin10.com/list?isgood=0&lastId=0&limit=20&object_id=11406&root_id=0&type=video
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
          "https://reference-api.jin10.com/reference?nav_bar_id=18&page=${page}&page_size=20",
          // https://comment-api.jin10.com/list?isgood=0&lastId=0&limit=20&object_id=11406&root_id=0&type=video
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
        appBar: AppBar(
          title: Text('交易课堂',style: TextStyle(fontSize: 18),),
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0.1,
          
          leading: new IconButton(
            icon: new Image.asset('assets/left.jpg',
                width: 11, height: 20),
                
          
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Theme.of(context).cardColor,
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
                        if(i.isOdd) {
                      return  Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                  Navigator.of(context,rootNavigator: true).push(
                                    new MaterialPageRoute(builder: (BuildContext context) {
                                    return new VisualScreenDetail(id:list[i]["id"]);
                                  }));
                              },
                              child: Container(
                                padding:EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 100,
                                      padding: EdgeInsets.all(5),
                                      alignment: Alignment.bottomLeft,
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                                        image: new DecorationImage(
                                          image: NetworkImage(list[i]["detail_img"]),
                                          fit:BoxFit.fill
                                        ),
                                      ),
                                      child:Text(list[i]["display_datetime"], style: new TextStyle(fontSize: 12.0,color: Colors.white,fontWeight: FontWeight.w700),),
                                    ),
                                    Padding(padding: EdgeInsets.only(bottom:10),),
                                    Text(
                                      list[i]["title"], 
                                     style: TextStyle(fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              )
                            )
                          ),

                         list[i+1] != null ? Expanded(
                            flex: 1,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                  Navigator.of(context,rootNavigator: true).push(
                                    new MaterialPageRoute(builder: (BuildContext context) {
                                    return new VisualScreenDetail(id:list[i+1]["id"]);
                                  }));
                              },
                              child: Container(
                                padding:EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 100,
                                      alignment: Alignment.bottomLeft,
                                      padding: EdgeInsets.all(5),
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                                        image: new DecorationImage(
                                          image: NetworkImage(list[i+1]["detail_img"]),
                                          fit:BoxFit.fill
                                        ),
                                      ),
                                      child:Text(list[i+1]["display_datetime"], style: new TextStyle(fontSize: 12.0,color: Colors.white,fontWeight: FontWeight.w700),),
                                    ),
                                    Padding(padding: EdgeInsets.only(bottom:10),),
                                    Text(
                                      list[i+1]["title"], 
                                      style: TextStyle(fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              )
                            )
                          ) : Expanded(
                            flex: 1,
                            child: Container(),
                          )
                        ],
                      );
                    }else {
                      return Container(height: 0,);
                    }
                },
                childCount: list.length~/2,
              ),
            ),
          ],
        ) :  Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/data.jpg',width: 100,fit: BoxFit.fill,),
              Padding(padding: EdgeInsets.only(top:5),),
              Text('暂无关注',style: TextStyle(color: Colors.grey,fontSize: 12),)
            ],
          ),
      ),
      );
  }
}