import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:futures/dashboard/hotList.dart';
import 'package:flutter/cupertino.dart';



class HotScreen extends StatefulWidget {
  @override
  HotScreenState createState() => HotScreenState();
}
class HotScreenState extends State<HotScreen> {
  // 总数
  var list = [{
				"id": 68,
				"title": "石油价格战",
				"introduction": "沙特发起价格战，又是一次见证历史的时刻。",
				"web_thumb": "https://cdn-news.jin10.com/88f05b81-1642-41b7-bbd8-2d92d914edea.jpg",
			}, {
				"id": 67,
				"title": "期货热图",
				"introduction": "一图读懂世界大小事",
				"web_thumb": "https://cdn.jin10.com/pic/55/58adcb23ced0b1679cd3a9cbf03d1e06.jpg",
			}, {
				"id": 31,
				"title": "聊聊黄金交易",
				"introduction": "黄金市场深度报道与分析",
				"web_thumb": "https://cdn-news.jin10.com/998fa83b-7ba9-4211-ba49-faef3b3fa06a.jpg",
			}, {
				"id": 64,
				"title": "中东地缘局势",
				"introduction": " 中东地缘局势最新动态，都在这里！",
				"web_thumb": "https://cdn-news.jin10.com/b348f406-68a5-402a-bfe0-7f915f7013fe.png",
			}, {
				"id": 61,
				"title": "期货财富故事",
				"introduction": "30分钟颠覆投资思维",
				"web_thumb": "https://cdn-news.jin10.com/295cae98-2304-435f-b148-cf1ff9b2758b.jpeg",
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
            icon: new Image.asset('images/left.jpg',
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
          child: Image.asset('images/list_empty.jpg',fit:BoxFit.fill),
        ),
      );
  }
}