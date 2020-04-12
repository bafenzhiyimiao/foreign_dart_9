import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/taurus_footer.dart';
import 'package:flutter_easyrefresh/taurus_header.dart';
import 'package:flustars/flustars.dart';
import 'package:futures/choice/visual_screen_detail.dart';
import 'package:flutter/cupertino.dart';



class VisualScreenList extends StatefulWidget {
  final id;
  final name;
  VisualScreenList({Key key, @required this.id, @required this.name}) : super(key: key);
  @override
  VisualScreenListState createState() => VisualScreenListState(id: id, name: name);
}
class VisualScreenListState extends State<VisualScreenList> {
   final id;
   final name;
  VisualScreenListState({Key key, @required this.id,  @required this.name});
  // 总数
  var list = [];
  var page = 1;


  // Future<void> onRefreshing() async {
  //   list.clear();
  //   try {
  //     Map<String, dynamic> httpHeaders = {
  //       'x-udid': '6aba6d51a0e4e8f2e8e508c9a946fcba0abb9c06',
  //       'x-app-ver': 'ios_base_4.3.2',
  //       'x-token': '',
  //       'x-app-id': 'g93rhHb9DcDptyPb',
  //       'x-version':'1.0.1'
  //     };
  //     Options options = Options(headers:httpHeaders);
  //     Response response = await Dio().get(
  //         "https://reference-api.jin10.com/reference/getByCategoryId?category_id=${id}&page=1&page_size=20&types=video",
  //         // https://comment-api.jin10.com/list?isgood=0&lastId=0&limit=20&object_id=11406&root_id=0&type=video
  //         options: options,
  //     );
  //     if (mounted) {
  //       setState(() {
  //         list = response.data["data"]["list"];
  //         page = 2;
  //       });
  //       list.forEach((val) {
  //         postApi(val);
  //       });
  //     }

  //   } catch (e) {
  //     print(e);
  //   }
  // }



  // Future<void> onRefres(vid) async {
  //   try {
  //     Map<String, dynamic> httpHeaders = {
  //       'x-udid': '6aba6d51a0e4e8f2e8e508c9a946fcba0abb9c06',
  //       'x-app-ver': 'ios_base_4.3.2',
  //       'x-token': '',
  //       'x-app-id': 'g93rhHb9DcDptyPb',
  //       'x-version':'1.0.1'
  //     };
  //     Map<String, dynamic> httpHeaders2 = {
  //       'x-udid': '6aba6d51a0e4e8f2e8e508c9a946fcba0abb9c06',
  //       'x-app-ver': 'ios_base_4.4.0',
  //       'x-token': '',
  //       'x-app-id': 'g93rhHb9DcDptyPb',
  //       'x-version':'1.0.0'
  //     };
  //     Options options = Options(headers:httpHeaders);
  //     Options options2 = Options(headers:httpHeaders2);
  //     Response response = await Dio().get(
  //         "https://reference-api.jin10.com/reference/getOne?id=${vid.toString()}&type=video",
  //         options: options,
  //     );
  //     Response res = await Dio().get(
  //         "https://comment-api.jin10.com/list?isgood=0&lastId=0&limit=20&object_id=${vid}&root_id=0&type=video",
  //         options: options2,
  //     );
  //     if (mounted) {
  //       // setState(() {
  //       //   detail = response.data["data"];
  //       //   comments = res.data["data"]["items"] != null ? res.data["data"]["items"] : [];
  //       //   );
  //       // });
  //       postapi(
  //         {
  //           'detail': response.data["data"],
  //           'comment': res.data["data"]["items"],
  //           "id": response.data["data"]["id"]
  //         }
  //       );

  //       print(response.data["data"]['id']);
  //     }

  //   } catch (e) {
  //     print(e);
  //   }
  // }



  // Future<void> postapi(data)async {
  //   try {
  //     Map<String, dynamic> httpHeaders = {
  //         'X-LC-Id': 'jRGsn1jcAKTcSonNoAGqNFk3-MdYXbMMI',
  //         'X-LC-Key': 'g7jhcAye3Jls5PpxY4zC8O2e',
  //       };
  //       Options options = Options(headers:httpHeaders);
  //       Response response = await Dio().post(
  //           "https://jrgsn1jc.api.lncldglobal.com/1.1/classes/video_${id}_detail",
  //           options: options,
  //           data: data,
  //       );

  //   } catch (e) {
  //     print('fffff');
  //   }
  // }





  Future<void> onRefreshing()async {
    try {
      Map<String, dynamic> httpHeaders = {
          'X-LC-Id': 'jRGsn1jcAKTcSonNoAGqNFk3-MdYXbMMI',
          'X-LC-Key': 'g7jhcAye3Jls5PpxY4zC8O2e',
        };
        Options options = Options(headers:httpHeaders);
        Response response = await Dio().get(
            "https://jrgsn1jc.api.lncldglobal.com/1.1/classes/video_${id}",
            options: options,
        );
        if (mounted) {
          setState(() {
            list = response.data["results"];
          });
        }

    } catch (e) {
      print('ffff');
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
          title: Text(name,style: TextStyle(fontSize: 18),),
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0.1,
          leading: new IconButton(
            icon: new Image.asset('assets/left.jpg',
                width: 11, height: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body:list.isNotEmpty ?   EasyRefresh.custom(
          onRefresh: () async {
             this.onRefreshing();
          },
          onLoad: () async {
            // this.onLding();
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
                                return new VisualScreenDetail(id:list[i]["id"], groupid: id,);
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
                                      image: NetworkImage(list[i]["detail_img"]),
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
        ): Container(height: 0,) ,
      );
  }
}