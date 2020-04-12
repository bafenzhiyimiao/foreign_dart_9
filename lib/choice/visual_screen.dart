import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/taurus_footer.dart';
import 'package:futures/choice/visual_screen_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:futures/choice/visual_screen_list.dart';




class VisualScreen extends StatefulWidget {
  @override
  VisualScreenState createState() => VisualScreenState();
}
class VisualScreenState extends State<VisualScreen> {
  // 总数
  var list = [];
  var page = 1;

  var sliderList = [
    {
				"title": "八周交易计划2 《我的信仰》",
				"detail_img": "https://cdn.jin10.com/pic/2d/3da0c8d2ebd36151c96c8b50812bc865.png",
				"id": 1872,
        "cid": 22,
			},
    {
      "title": "原油走强有模式可循？CME专家教你破解WTI走势“套路”",
      "detail_img": "https://cdn.jin10.com/pic/7a/09e6739363780f895987d8e02deceb40.jpg",
      "id": 5256,
      'cid': 12
    },{
      "title": "旅游业新热点！开间民宿真的很赚钱？",
      "detail_img": "https://cdn.jin10.com/pic/a9/e2fdb14aedc95c0fe6ffba4c50f53ee8.jpg",
      "id": 2695,
      'cid': 9
    }, 
  ];

  Future<void> onRefreshing() async {
    list.clear();
    try {
      Map<String, dynamic> httpHeaders = {
          'X-LC-Id': 'jRGsn1jcAKTcSonNoAGqNFk3-MdYXbMMI',
          'X-LC-Key': 'g7jhcAye3Jls5PpxY4zC8O2e',
        };
        Options options = Options(headers:httpHeaders);
      Response response = await Dio().get(
          "https://jrgsn1jc.api.lncldglobal.com/1.1/classes/video",
            options: options,
      );
      if (mounted) {
        setState(() {
          list.addAll(response.data['results']);
        });
      }

    } catch (e) {
      print(e);
    }
  }

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
  //         "https://reference-api.jin10.com/reference?nav_bar_id=5&page=1&page_size=20",
  //         options: options
  //     );
  //     if (mounted) {
  //       print(response);
  //       // // var res = jsonDecode(response.data);
  //       setState(() {
  //         list.addAll(response.data['data']["categories"]);
  //       });
  //       list.forEach((val) {
  //         postApi(val);
  //       });
  //     }

  //   } catch (e) {
  //     print(e);
  //   }
  // }



  // Future<void> postApi(data)async {
  //   try {
  //     Map<String, dynamic> httpHeaders = {
  //         'X-LC-Id': 'jRGsn1jcAKTcSonNoAGqNFk3-MdYXbMMI',
  //         'X-LC-Key': 'g7jhcAye3Jls5PpxY4zC8O2e',
  //       };
  //       Options options = Options(headers:httpHeaders);
  //       Response response = await Dio().post(
  //           "https://jrgsn1jc.api.lncldglobal.com/1.1/classes/video",
  //           options: options,
  //           data:data
  //       );
  //   } catch (e) {
  //     print('ffff');
  //   }
  // }


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
          },
          onLoad: () async {
          },
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, i) {
                        return Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                i== 0 ? Container(
                                  height: 180,
                                  margin: EdgeInsets.only(top:10,bottom:20),
                                  child: Swiper(
                                    itemBuilder: (BuildContext context, int index) {
                                      return new Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: new EdgeInsets.symmetric(horizontal: 10.0),
                                        alignment: Alignment.bottomLeft,
                                        padding: EdgeInsets.fromLTRB(15, 15, 15, 20),
                                        decoration: new BoxDecoration(
                                          borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                                          image: new DecorationImage(
                                            image: NetworkImage(sliderList[index]["detail_img"]),
                                            fit:BoxFit.fill
                                          ),
                                        ),
                                        child:Text(sliderList[index]["title"], style: new TextStyle(fontSize: 14.0,color: Colors.white,fontWeight: FontWeight.w700),),
                                      );
                                    },
                                    itemCount: 3,
                                    pagination: new SwiperPagination(
                                        builder: DotSwiperPaginationBuilder(
                                      color: Colors.black54,
                                      activeColor: Colors.white,
                                    )),
                                    // control: new SwiperControl(),
                                    scrollDirection: Axis.horizontal,
                                    autoplay: true,
                                    onTap: (index){
                                      Navigator.of(context,rootNavigator: true).push(
                                        new MaterialPageRoute(builder: (BuildContext context) {
                                        return new VisualScreenDetail(id:sliderList[index]["id"],groupid: sliderList[index]["cid"],);
                                      }));
                                    },
                                  ),
                                ) : Container(height: 0,),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 3,
                                      height: 15,
                                      color: Theme.of(context).primaryColor,
                                      margin: EdgeInsets.only(right:10),
                                    ),
                                    Text(
                                      list[i]['name'].replaceAll("金十","期货"),
                                      style: TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          Navigator.of(context,rootNavigator: true).push(
                                            new MaterialPageRoute(builder: (BuildContext context) {
                                            return new VisualScreenList(id:list[i]["category_id"], name:list[i]['name'].replaceAll("金十","期货"));
                                          }));
                                        },
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.more_horiz,
                                            color: Colors.grey,
                                          ),
                                        )
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          Navigator.of(context,rootNavigator: true).push(
                                            new MaterialPageRoute(builder: (BuildContext context) {
                                            return new VisualScreenDetail(id:list[i]["list"][0]["id"], groupid: list[i]["category_id"],);
                                          }));
                                        },
                                        child: Container(
                                            margin: EdgeInsets.all(10),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(bottom:10),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Image(
                                                      image: NetworkImage(list[i]["list"][0]["detail_img"]),
                                                    )
                                                  )
                                                ),
                                              Text(
                                                    list[i]["list"][0]["title"],
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  )
                                              ],
                                            )
                                          )
                                      )
                                    ),

                                    Expanded(
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          Navigator.of(context,rootNavigator: true).push(
                                            new MaterialPageRoute(builder: (BuildContext context) {
                                            return new VisualScreenDetail(id:list[i]["list"][1]["id"], groupid: list[i]["category_id"],);
                                          }));
                                        },
                                        child: Container(
                                            margin: EdgeInsets.all(10),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(bottom:10),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Image(
                                                      image: NetworkImage(list[i]["list"][1]["detail_img"]),
                                                    )
                                                  )
                                                ),
                                              Text(
                                                    list[i]["list"][1]["title"],
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  )
                                              ],
                                            )
                                          )
                                      )
                                    ),
                                   
                                  ],
                                )
                              ],
                            ),
                  
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