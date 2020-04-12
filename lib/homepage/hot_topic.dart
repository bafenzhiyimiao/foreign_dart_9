import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:futures/homepage/hot_list.dart';
import 'package:flutter/cupertino.dart';



class HotTopicScreen extends StatefulWidget {
  @override
  HotTopicScreenState createState() => HotTopicScreenState();
}
class HotTopicScreenState extends State<HotTopicScreen> {
  // 总数
  var list = [{
				"id": 12,
				"title": "美元价格战",
				"web_thumb": "https://socialstatic.followme-acceleration.com/social/201907/7941491bb82f44319d4b2016767be264.png",
			}, {
				"id": 13,
				"title": "人民币热图",
				"web_thumb": "https://socialstatic.followme-acceleration.com/social/202003/6f3d64823f0541d5a22a19e26dd3b784.png",
			}, {
				"id": 14,
				"title": "聊聊欧元交易",
				"web_thumb": "https://socialstatic.followme-acceleration.com/social/202004/df7e4b77918a4d63a3d124ed1d2a5822.png",
			}, {
				"id": 15,
				"title": "纸黄金",
				"web_thumb": "https://socialstatic.followme-acceleration.com/social/202004/83a8457580904561b72abcf9ac31b6f1.png",
			}, {
				"id": 16,
				"title": "美联储",
				"web_thumb": "http://www.fx168.com/fx168_news/stock/us/1808/W020180825240410923029.jpg",
			}];

  

  

  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('热门专题',style: TextStyle(fontSize: 18),),
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0.1,
          leading: new IconButton(
            icon: new Image.asset('assets/left.jpg',
                width: 11, height: 20),
                
                
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Theme.of(context).cardColor,
        body:list.isNotEmpty ? EasyRefresh.custom(
          onRefresh: () async {
          },
          onLoad: () async {
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
                                return new HotList(id:list[i]["id"],hot:list[i]);
                              }));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 10,left: 15,right: 15),
                                child: Text(
                                  list[i]["title"], 
                                  style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),
                                ),
                              ),
                              
                              Card(
                                color: Colors.white,
                                margin:EdgeInsets.fromLTRB(15, 5, 15, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    
                                    Container(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.center,
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.all(new Radius.circular(3.0)),
                                        image: new DecorationImage(
                                          image: NetworkImage(list[i]["web_thumb"]),
                                          fit:BoxFit.fill
                                        ),
                                      ),
                                    ),                                
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
        ): Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset('assets/list_empty_dark.jpg',fit:BoxFit.fill),
        ),
      );
  }
}