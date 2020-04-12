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



  Future<void> onRefreshing()async {
    try {
      Map<String, dynamic> httpHeaders = {
          'X-LC-Id': 'jRGsn1jcAKTcSonNoAGqNFk3-MdYXbMMI',
          'X-LC-Key': 'g7jhcAye3Jls5PpxY4zC8O2e',
        };
        Options options = Options(headers:httpHeaders);
        Response response = await Dio().get(
            "https://jrgsn1jc.api.lncldglobal.com/1.1/classes/rate",
            options: options,
        );
        setState(() {
          toolList = response.data["results"];
        });
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
        backgroundColor: Theme.of(context).backgroundColor,
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