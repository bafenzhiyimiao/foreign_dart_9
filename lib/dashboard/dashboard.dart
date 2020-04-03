import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:futures/article/news_detail.dart';
import 'package:futures/news/news_screen.dart';
import 'package:futures/article/calender.dart';
import 'package:futures/dashboard/school.dart';
import 'package:futures/dashboard/hot.dart';
import 'package:futures/article/video_list.dart';
import 'package:futures/dashboard/search.dart';
import 'package:dio/dio.dart';







class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key, this.callback}) :super(key: key);
  final callback;
  @override
  DashboardScreenState createState() => DashboardScreenState(callback: callback);
  
}
class DashboardScreenState extends State<DashboardScreen> {
  DashboardScreenState({Key key, this.callback});
  final callback;
  
  var marketlist = [];

 

  @override
  void initState() {
    super.initState();
    getlist();
  }


  Future<void> getlist() async {
    marketlist.clear();
    try {
      Response response = await Dio().get(
          "http://cj.taoketong.cc/cftc_app?");
      if (mounted) {
        setState(() {
          marketlist.addAll(response.data);
        });
        print(marketlist);
      }

    } catch (e) {
      print(e);
    }
    setState(() {});
  }


  var sliderList = [
    {
      "title": "全球资产惨遭杀跌 金银推手流星坠落！",
      "id": '27722',
      'img': 'images/banner1.png'
    },{
      "title": "道指反弹仅“昙花一现” 金价40美元涨幅悉数回吐",
      'img': 'images/banner2.png',
      "id": '27721'
    }, {
				"title": "全球股市崩盘重失传 贵金属全线暴跌",
        'img': 'images/banner3.png',
        "id": '27718',
			},
  ];
  var noticeList = [
    {
      "title": "交易女神经 第4集：Cindy交易胜率高达75%！她究竟制定了什么交易规则？",
      "name": '交易女神经',
      "category_id": '45',
    },
    {
      "title": "从悉尼到深圳，身临千万资金交易圈|卓识私享会第二期活动回顾",
      "name": '伦敦交易者',
      "category_id": '44',
    },
    {
      "title": "【自习室】真人交易验证，交易学习真的有迹可循！",
      "name": '交易学院',
      "category_id": '41',
    },
  ];


  buildLinear() {
    List<Widget> rows = [];
    marketlist.isNotEmpty ? marketlist.forEach((val) {
      rows.add(
        Container(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Row(
              children: <Widget>[
                Text(val["cftc_name"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700),),
                Padding(padding: EdgeInsets.only(left:40),),
                Text(
                  (val["net_short"]/(val["net_long"] +val["net_short"]) * 100).toStringAsFixed(0) + '%',
                  style: TextStyle(color: Color.fromRGBO(155, 209, 61, 1),fontSize: 12),
                ),
                Expanded(
                  child: Container(
                      height: 10.0,
                      padding: EdgeInsets.only(left:5,right: 5),
                      child: LinearProgressIndicator(
                        value: val["net_short"]/(val["net_long"] +val["net_short"]),
                        valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(155, 209, 61, 1)),
                        backgroundColor: Color.fromRGBO(255, 77, 79, 1),
                      ),
                  ),
                ),
                Text(
                  (val["net_long"]/(val["net_long"] +val["net_short"]) * 100).toStringAsFixed(0) + '%',
                  style: TextStyle(color: Color.fromRGBO(255, 77, 79, 1),fontSize: 12),
                ),
              ],
            )
        )
      );
    }) : '';
    
    return Container(
      child: Column(
        children: rows,
      ),
    );
  }

  buildTableList() {
    List<Widget> rows = [];
    marketlist.isNotEmpty ? marketlist.forEach((val) {
      rows.add(
        Container(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  val["cftc_name"],
                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  val["net_short"].toString(),
                  style: TextStyle(fontSize: 12,),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  val["net_long"].toString(),
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  val["publish_time"].substring(0,11),
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        )
      );
    }) : '';
    
    return Container(
      child: Column(
        children: rows,
      ),
    );
  }

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0.1,
          
          centerTitle: false,
          title: Container(
            child: Row(
              children: <Widget>[
                Image(
                  image: AssetImage('images/name.jpg'),
                  width: 80,
                  fit: BoxFit.fitWidth,
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                       Navigator.of(context,rootNavigator: true).push(
                        new MaterialPageRoute(builder: (BuildContext context) {
                        return new Search();
                      }));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left:20),
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Image(
                        image: AssetImage('images/search.jpg'),
                        height: 18,
                        width: 18,
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.centerLeft,
                      )
                    )
                  )
                   
                )
                
              ],
            ),
          ),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: ListView(
          children: <Widget>[
            Container(
              height: 200,
              // margin: EdgeInsets.only(top:10,bottom:20,left: 10,right: 10),
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return new Container(
                    width: MediaQuery.of(context).size.width,
                    margin: new EdgeInsets.all(10.0),
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                      image: new DecorationImage(
                        image: AssetImage(sliderList[index]["img"]),
                        fit:BoxFit.fill
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          offset: Offset(0.0, 2),
                          blurRadius: 4,
                        )
                      ],
                      
                      // image: new DecorationImage(
                      //   image: AssetImage("images/banner1.png"),
                      //   fit:BoxFit.fill
                      // ),
                    ),
                    child:Text(
                      sliderList[index]["title"], 
                      style: new TextStyle(fontSize: 16.0,color: Colors.white,fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
                itemCount: 3,
                // control: new SwiperControl(),
                scrollDirection: Axis.horizontal,
                autoplay: true,
                onTap: (index){
                  Navigator.of(context,rootNavigator: true).push(
                    new MaterialPageRoute(builder: (BuildContext context) {
                    return new NewsDetail(id: sliderList[index]["id"]);
                  }));
                },
              ),
            ),
            


            Container(
              color: Theme.of(context).cardColor,
              child: Column(
                children: <Widget>[

                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.of(context,rootNavigator: true).push(
                              new MaterialPageRoute(builder: (BuildContext context) {
                              return new HotScreen();
                            }));
                          },
                          child:Container(
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '热门专题',
                                        style: TextStyle( fontSize: 16,fontWeight: FontWeight.w700),
                                      ),
                                      Padding(padding: EdgeInsets.only(top:5),),
                                      Text(
                                        '专业视角解读近期热点',
                                        style: TextStyle(color: Color.fromRGBO(176, 191, 205, 1), fontSize: 10),
                                      ),

                                    ],
                                  ),
                                  Expanded(
                                    child: Image(
                                      width: 32,
                                      height: 32,
                                      image: AssetImage('images/icon1.png'),
                                      alignment: Alignment.centerRight,
                                    ),
                                  )

                                ],
                              ),
                          )
                        )
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.of(context,rootNavigator: true).push(
                              new MaterialPageRoute(builder: (BuildContext context) {
                              return new SchoolScreen();
                            }));
                          },
                          child:Container(
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '交易课堂',
                                        style: TextStyle(  fontSize: 16,fontWeight: FontWeight.w700),
                                      ),
                                      Padding(padding: EdgeInsets.only(top:5),),
                                      Text(
                                        '机会留给有准备的人',
                                        style: TextStyle(color: Color.fromRGBO(176, 191, 205, 1), fontSize: 10),
                                      ),

                                    ],
                                  ),
                                  Expanded(
                                    child: Image(
                                      width: 32,
                                      height: 32,
                                      image: AssetImage('images/icon2.png'),
                                      alignment: Alignment.centerRight,
                                    ),
                                  )

                                ],
                              ),
                          )
                        )
                      ),
                    ],
                  ),



                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.of(context,rootNavigator: true).push(
                              new MaterialPageRoute(builder: (BuildContext context) {
                              return new NewsScreen();
                            }));
                          },
                          child:Container(
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '新闻资讯',
                                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                                      ),
                                      Padding(padding: EdgeInsets.only(top:5),),
                                      Text(
                                        '专业视角独家精准分析',
                                        style: TextStyle(color: Color.fromRGBO(176, 191, 205, 1), fontSize: 10),
                                      ),

                                    ],
                                  ),
                                  Expanded(
                                    child: Image(
                                      width: 32,
                                      height: 32,
                                      image: AssetImage('images/icon3.png'),
                                      alignment: Alignment.centerRight,
                                    ),
                                  )

                                ],
                              ),
                          )
                        )
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.of(context,rootNavigator: true).push(
                              new MaterialPageRoute(builder: (BuildContext context) {
                              return  new CalenderScreen();
                            }));
                          },
                          child:Container(
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '财经日历',
                                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                                      ),
                                      Padding(padding: EdgeInsets.only(top:5),),
                                      Text(
                                        '快人一步，数据抢先知',
                                        style: TextStyle(color: Color.fromRGBO(176, 191, 205, 1), fontSize: 10),
                                      ),

                                    ],
                                  ),
                                  Expanded(
                                    child: Image(
                                      width: 32,
                                      height: 32,
                                      image: AssetImage('images/icon4.png'),
                                      alignment: Alignment.centerRight,
                                    ),
                                  )

                                ],
                              ),
                          )
                        )
                      ),
                    ],
                  )
                ],
              ),
            ),

             Container(
                padding: EdgeInsets.only(left:10,right:10,top:10,bottom:10),
                alignment: Alignment.centerLeft,
                color: Theme.of(context).cardColor,
                child:  Row(
                  children: <Widget>[
                    Icon(Icons.video_call,size: 14,color: Theme.of(context).primaryColor,),
                    Text(
                      '  推荐   ', 
                      style: new TextStyle(fontSize: 12.0,color: Theme.of(context).primaryColor,),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                        height: 16,
                        width: MediaQuery.of(context).size.width-75,
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return new Container(
                              padding: EdgeInsets.only(left:10,right:10),
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      noticeList[index]["title"], 
                                      style: new TextStyle(fontSize: 12.0),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text('更多',style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12),),
                                        Icon(Icons.keyboard_arrow_right,size: 14,color: Theme.of(context).primaryColor)
                                      ],
                                    ),
                                  )
                                ],
                              )
                              
                            );
                          },
                          itemCount: 3,
                          scrollDirection: Axis.vertical,
                          autoplay: true,
                          onTap: (index){
                            Navigator.of(context,rootNavigator: true).push(
                              new MaterialPageRoute(builder: (BuildContext context) {
                              return new VideoList(id:noticeList[index]["category_id"], name:noticeList[index]['name'].replaceAll("金十","期货"));
                            }));
                          },
                        ),
                      ),

                    
                    

                  ],
                )
              ),

            

            Container(
              margin: EdgeInsets.only(top:8),
              padding: EdgeInsets.all(10),
              color: Theme.of(context).cardColor,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '净空头',
                          style: TextStyle(color: Colors.grey,fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '净多头',
                          style: TextStyle(color: Colors.grey,fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '日期',
                          style: TextStyle(color: Colors.grey,fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top:10),),
                  buildTableList(),
                ],
              )
            ),


            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top:8),
              color: Theme.of(context).cardColor,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text('CFTC持仓榜'),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(height: 10,width: 10,color: Color.fromRGBO(155, 209, 61, 1),margin: EdgeInsets.only(right: 5),),
                            Text('买跌',style: TextStyle(fontSize: 12),),
                            Container(height: 10,width: 10,color: Color.fromRGBO(255, 77, 79, 1),margin: EdgeInsets.only(right: 5,left:20),),
                            Text('买涨',style: TextStyle(fontSize: 12),),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top:10),),
                  buildLinear()
                ],
              ),
            ),

           

             
            
          ],
        ),
      )
    );
  }
}