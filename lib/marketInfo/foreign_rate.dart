import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:futures/marketInfo/tool.dart';



class ForeignScreen extends StatefulWidget {

  @override
  ForeignScreenState createState() => ForeignScreenState();
}
class ForeignScreenState extends State<ForeignScreen> {
  // 总数
  var toolList = [];
  Color grey = Color.fromRGBO(184, 193, 204, 1);
  Color black = Color.fromRGBO(51, 51, 51, 1);
  Color green = Color.fromRGBO(39, 199, 156, 1);
  Color red = Color.fromRGBO(254, 82, 76, 1);
  bool empty = false;


  var nameList = [
  {
    'id': 1,
    'name': '美元',
    'subname': 'USD',
  },
  {
    'id':2,
    'name': '日元',
    'subname': 'JPY',
  },
  {
    'name': '英镑',
    'subname': 'GBP',
    'id':3,
  },
  {
    'name': '港币',
    'subname': 'HKD',
    'id': 4,
  },
  {
    'name': '欧元',
    'subname': 'EUR',
    'id': 5,
  },
  {
    'name': '加元',
    'subname': 'CAD',
    'id':6,
  },
   {
    'name': '瑞典克朗',
    'subname': 'SEK',
    'id': 7,
  },
   {
    'name': '丹麦克朗',
    'subname': 'DKK',
    'id': 8,
  },
  {
    'name': '挪威克朗',
    'subname': 'NOK',
    'id': 9,
  },
  {
    'name': '新加坡币',
    'subname': 'SGD',
    'id':10,
  },
  
  {
    'name': '澳元',
    'subname': 'AUD',
    'id': 11,
  },
  
  {
    'name': '瑞士法郎',
    'subname': 'CHF',
    'id': 12,
  },
    {
    'name': '澳门币',
    'subname': 'MOP',
    'id': 13,
  },
   {
    'name': '菲律宾比索',
    'subname': 'PHP',
    'id': 14,
  },

  {
    'name': '泰铢',
    'subname': 'THB',
    'id': 15,
  },
   
  {
    'name': '新西兰币',
    'subname': 'NZD',
    'id': 16,
  },
  {
    'name': '韩元',
    'subname': 'KRW',
    'id': 17,
  },
  {
    'name': '卢布',
    'subname': 'RUB',
    'id': 18,
  },
];


  Future<void> onRefreshing() async {
    try {
      Response response = await Dio().get(
          "http://stage.since2006.com/api/forex/rates");
        print(response.data);

      if (mounted) {
        var l = [];
          nameList.forEach((value) {
            response.data["result"].forEach((val) {
              if(val["fiCurrencyId"] == value["id"] ){
                l.add(
                  {
                    'id': value['id'],
                    'name': value["name"],
                    'subname': value["subname"],
                    "fiCurrencyId": val["fiCurrencyId"],
                    "flBuyingRate": val["flBuyingRate"],
                    "flCashBuyingRate": val["flCashBuyingRate"],
                    "flSellingRate": val["flSellingRate"],
                    "flCashSellingRate": val["flCashSellingRate"],
                    "fdPublishDate": val["fdPublishDate"],
                  }
                );
              }
            });
          });
        setState(() {
          toolList = l;
        });
      }

    } catch (e) {
      print(e);
      print('的点点滴滴');
      setState(() {
        empty = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    onRefreshing();
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if(toolList.isNotEmpty) {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: new ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    i == 0 ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('中行更新时间：' + toolList[i]["fdPublishDate"], style: TextStyle(color: grey,fontSize: 12),)
                        ),
                        Container(
                          color: Theme.of(context).cardColor,
                          padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Center(
                                  child: Text('品种',style: TextStyle(color: grey,fontSize: 12),),
                                )
                              ),
                               Expanded(
                                flex: 1,
                                child: Container(
                                )
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text('买入',style: TextStyle(color: grey,fontSize: 12),),
                                )
                                
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text('卖出',style: TextStyle(color: grey,fontSize: 12),),
                                )
                                
                              ),
                            ],
                          ),
                        )
                      ],
                    ): Container(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if(toolList.isNotEmpty) {
                          Navigator.of(context,rootNavigator: true).push(
                            new MaterialPageRoute(builder: (BuildContext context) {
                            return new ToolPage(info: toolList[i]);
                          }));
                        }
                      },
                      child: 
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, i == 17 ? 20: 0),
                        padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(74, 144, 226, 0.1),
                                  offset: Offset(0.0, 2),
                                  blurRadius: 4,
                                )
                              ],
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Row(
                                children: <Widget>[
                                  // new CircleAvatar(
                                  //   radius: 16.0,
                                  //   backgroundImage: AssetImage('images/${toolList[i]["subname"]}.png'),
                                  // ),
                                  // Padding(padding: EdgeInsets.only(left:10),),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(toolList[i]["name"],style: TextStyle(fontSize: 16),),
                                    Padding(padding: EdgeInsets.only(top:5),),
                                      Text(toolList[i]["subname"],style: TextStyle(color: grey,fontSize: 16),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text('现钞',style: TextStyle(color: grey,fontSize: 12),),
                                  Padding(padding: EdgeInsets.only(top:9),),
                                  Text('现汇',style: TextStyle(color: grey,fontSize: 12),),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(toolList[i]["flCashBuyingRate"].toStringAsFixed(2),style: TextStyle(color: green,fontSize: 16),), //现钞买入
                                  Padding(padding: EdgeInsets.only(top:5),),
                                  Text(toolList[i]["flBuyingRate"].toStringAsFixed(2),style: TextStyle(color: green,fontSize: 16),), // 现汇买入
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(toolList[i]["flCashSellingRate"].toStringAsFixed(2),style: TextStyle(color: red,fontSize: 16),), //现钞卖
                                  Padding(padding: EdgeInsets.only(top:5),),
                                  Text(toolList[i]["flSellingRate"].toStringAsFixed(2),style: TextStyle(color: red,fontSize: 16),), // 现汇卖
                                ],
                              ),
                            )
                            
                             
                             
                             
                          ],
                        ),
                      )
                    )




                  ],
              );




                        // return ;
                },
                itemCount: toolList.length,
              ),
      );
    }else {
      return Scaffold(
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            onRefreshing();
          },
          child: Container(
            padding: EdgeInsets.only(top:150),
            alignment: Alignment.center,
            child: empty ? Column(
                children: <Widget>[
                  Image.asset("images/no.jpg",width: 120,height:120,fit: BoxFit.fitWidth,),
                  Text('点击重试',style: TextStyle(color: grey,fontSize: 12),)
                ],
            ) : Container()
          )
        )
         
      ); 
    }
  }
}