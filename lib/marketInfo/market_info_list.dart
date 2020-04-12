import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:futures/marketInfo/market_info_detail.dart';
import 'package:flutter/cupertino.dart';



class MarketInfoList extends StatefulWidget {
  final channelid;
  MarketInfoList({Key key, @required this.channelid}) : super(key: key);

  @override
  MarketInfoListState createState() => MarketInfoListState(channelid:channelid);
}
class MarketInfoListState extends State<MarketInfoList> {
  final channelid;
  MarketInfoListState({Key key, @required this.channelid});
  // 总数
  int timestamp = new DateTime.now().millisecondsSinceEpoch;
  var list = [];
  var list2 = [];
  Timer timer;


  // Future<void> onRefreshing() async {
  //   try {
     
  //     Map<String, dynamic> httpHeaders = {
  //         'X-LC-Id': 'pIwJE5YdPiyFKg2X9uolEcqz-MdYXbMMI',
  //         'X-LC-Key': 'sfIJshbqRGbP3nJpQgBL0QJo',
  //       };
  //       Options options = Options(headers:httpHeaders);
  //       Response response = await Dio().get(
  //           "https://piwje5yd.api.lncldglobal.com/1.1/classes/quota/5e8eb612a5a0f50008a4265a",
  //           options: options
  //       );
      
  //       var res1 = response.data;

  //       var arr = [];
  //       var arr2 = [];
  //       var namelist = res1["variety"];
  //       var quotalist = res1["quota"];
  //       arr.addAll(namelist.where((val) => val["isDomestic"] == channelid));


  //       arr.forEach((val) {
  //         var quota =  quotalist.where((v) => v["varietyType"] == val["varietyType"]);
  //         arr2.addAll(quota);
  //       });
  //       setState(() {
  //         list = arr;
  //         list2 = arr2;
  //       });

  //       postApi({
  //         'name': list,
  //         'quota': list2
  //       });


        
  //   } catch (e) {
  //     print(e);
  //   }
  //   setState(() {});
  // }


  Future<void> onRefreshing()async {
    try {
      Map<String, dynamic> httpHeaders = {
          'X-LC-Id': 'jRGsn1jcAKTcSonNoAGqNFk3-MdYXbMMI',
          'X-LC-Key': 'g7jhcAye3Jls5PpxY4zC8O2e',
        };
        Options options = Options(headers:httpHeaders);
        Response response = await Dio().get(
            "https://jrgsn1jc.api.lncldglobal.com/1.1/classes/market_${channelid}",
            options: options,
        );
        print(response.data);
        setState(() {
          list = response.data["results"][0]["name"];
          list2 = response.data["results"][0]["quota"];
        });
    } catch (e) {
      print('ffff');
    }
  }


  @override
  void initState() {
    super.initState();
    onRefreshing();
    // getlist();
  }


  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
      print('cancel');
    }
    super.dispose();
  }


  getlist() {
    timer = Timer(Duration(seconds: 2), () {
      onRefreshing();
      getlist();
    });
  }


 
  



  @override
  Widget build(BuildContext context) {
    if(list.isNotEmpty) {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: new ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: 
                  (context, i) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if(list.isNotEmpty && list[i]["contractsCode"] != null) {
                              Navigator.of(context,rootNavigator: true).push(
                                new MaterialPageRoute(builder: (BuildContext context) {
                                return new MarketInfoDetail(id: list[i]["contractsCode"],title: list[i]["varietyName"],);
                              }));
                            }
                          },
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                i == 0 ? Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child:Container(
                                    color: Theme.of(context).dividerColor,
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          '名称',
                                          style: TextStyle(color: Colors.grey,fontSize: 12),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '最新价',
                                          style: TextStyle(color: Colors.grey,fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '涨跌',
                                          style: TextStyle(color: Colors.grey,fontSize: 12),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '涨跌幅',
                                          style: TextStyle(color: Colors.grey,fontSize: 12),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ) ): Container(height: 0,),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              list[i]["varietyName"],
                                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                              list[i]["contractsCode"],
                                              style: TextStyle(fontSize: 12,color: Colors.grey),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        )
                                         
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: list2[i]["floatPrice"]< 0 ? Colors.green : Colors.red,
                                          ),
                                          padding: EdgeInsets.only(left:15,right:15,top:10,bottom:10),
                                          child: Text(
                                            list2[i]["lastPrice"].toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),
                                          ),
                                        )
                                        

                                      ),
                                      Expanded(
                                        child: Text(
                                          list2[i]["floatPrice"].toString(),
                                          style: TextStyle(color: list2[i]["floatPrice"]< 0 ? Colors.green : Colors.red,),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          list2[i]["floatPricePoint"],
                                          style: TextStyle(color: list2[i]["floatPrice"]< 0 ? Colors.green : Colors.red,),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                
                              ],
                            )
                            
                          )
                        );
                },
                itemCount: list.length,
              ),
      );
    }else {
      return Center(
          child: CupertinoActivityIndicator(
            radius: 15.0,
            animating: true,
          ),
        ); 
    }
  }
}