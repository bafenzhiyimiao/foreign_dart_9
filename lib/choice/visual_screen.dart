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
				"title": "技术指标与价格形态如何搭配使用？Cindy学会后全部盈利！",
				"detail_img": "https://cdn-news.jin10.com/a0bd13f3-8291-4910-9b95-28edcf4d78b5.jpg",
				"id": 11588,
			},
    {
      "title": "从悉尼到深圳，身临千万资金交易圈|卓识私享会第二期活动回顾",
      "detail_img": "https://cdn-news.jin10.com/6238d7be-27bd-40e6-94e6-776b5a4dfe53.jpg",
      "id": 11218,
    },{
      "title": "特斯拉股价全解析 5年内涨至7000美元？",
      "detail_img": "https://cdn-news.jin10.com/004e7245-1555-4c66-a3ec-5aa7b76c2c0c.png",
      "id": 11360,
    }, 
  ];

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
          "https://reference-api.jin10.com/reference?nav_bar_id=5&page=1&page_size=20",
          options: options
      );
      if (mounted) {
        print(response);
        // // var res = jsonDecode(response.data);
        setState(() {
          list.addAll(response.data['data']["categories"]);
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
                                        return new VisualScreenDetail(id:sliderList[index]["id"]);
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
                                            return new VisualScreenDetail(id:list[i]["list"][0]["id"]);
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
                                            return new VisualScreenDetail(id:list[i]["list"][1]["id"]);
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