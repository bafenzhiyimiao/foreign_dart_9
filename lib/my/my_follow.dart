import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:futures/choice/visual_screen_detail.dart';
import 'package:futures/choice/visual_screen_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:futures/global.dart';
import 'package:dio/dio.dart';




class FollowScreen extends StatefulWidget {
  @override
  FollowScreenState createState() => FollowScreenState();
}
class FollowScreenState extends State<FollowScreen> {

  // 总数
  var list = [];
  var page = 1;



  

  @override
  void initState() {
    super.initState();
    getFollow();
  }
  getFollow() {
    LocalStorage.getJSON('follow').then((val) {
      if(val == null) {
        return;
      } 
      print(val);
      onRefreshing(val);
    });
  }


  Future<void> onRefreshing(val) async {
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
        var arr = [];
        val.forEach((val) {
          response.data['results'].forEach((v) {
            if(val== v["category_id"] ) {
              arr.add(v);
            }
          });
        });
        setState(() {
          list.addAll(arr);
        });
      }

    } catch (e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('我的关注'),
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0.1,
          
          leading: new IconButton(
            icon: new Image.asset('assets/left.jpg',
                width: 11, height: 20),
                
          
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: list.isNotEmpty ? EasyRefresh.custom(
          onRefresh: () async {
            getFollow();
          },
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, i) {
                        return Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
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
        ) : Center(
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