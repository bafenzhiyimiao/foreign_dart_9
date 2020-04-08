import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:futures/market/market_detail.dart';
import 'package:flutter/cupertino.dart';



class MarketList extends StatefulWidget {
  final channelid;
  MarketList({Key key, @required this.channelid}) : super(key: key);

  @override
  MarketListState createState() => MarketListState(channelid:channelid);
}
class MarketListState extends State<MarketList> {
  final channelid;
  MarketListState({Key key, @required this.channelid});
  // 总数
  int timestamp = new DateTime.now().millisecondsSinceEpoch;
  var list = [];
  var list2 = [];
  Timer timer;


  Future<void> onRefreshing() async {
    try {
     
      Map<String, dynamic> httpHeaders = {
          'X-LC-Id': 'XAA6xGk2UEfmqnwo73HQxYEG-MdYXbMMI',
          'X-LC-Key': '7KKIT3yOUkzDOhc5qnTx3Fly',
        };
        Options options = Options(headers:httpHeaders);
        Response response = await Dio().get(
            "https://xaa6xgk2.api.lncldglobal.com/1.1/classes/quota/5e8d4286c82f9c00080ac71e",
            options: options
        );
      
        var res1 = response.data;

        var arr = [];
        var arr2 = [];
        var namelist = res1["name"];
        var quotalist = res1["quota"];
        arr.addAll(namelist.where((val) => val["isDomestic"] == channelid));


        arr.forEach((val) {
          var quota =  quotalist.where((v) => v["varietyType"] == val["varietyType"]);
          arr2.addAll(quota);
        });
        setState(() {
          list = arr;
          list2 = arr2;
        });
    } catch (e) {
      print(e);
    }
    setState(() {});
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
                                return new MarketDetail(id: list[i]["contractsCode"],title: list[i]["varietyName"],);
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