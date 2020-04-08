import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:futures/chart/chart_model.dart';
import 'package:futures/chart/kline_view.dart';
import 'dart:convert';


class MarketDetail extends StatefulWidget {
  final id;
  final title;
  MarketDetail({Key key, @required this.id, this.title}) : super(key: key);
  @override
  _MarketDetailState createState() => _MarketDetailState(id:id, title:title);
}

class _MarketDetailState extends State<MarketDetail> with TickerProviderStateMixin{
  final id;
  final title;
  _MarketDetailState({Key key, @required this.id, @required this.title});

  List<String> _timeIndex = ["1min","3min","5min","10min","30min","60min","1day",];
  List<ChartModel> dataList = List();
  List lines = List();
  Dio dio = Dio();
  Color text = Color(0xFF6d88a5);
  TabController _tabController;
 
  bool _isShowSubview = false;
  int _viewTypeIndex = 0;
  int _subviewTypeIndex = 0;

  Color color = Colors.red;


  String _currentDataType;

  var detail;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this, initialIndex: 0);
    getKDataList(1);
    // timer();
//    getDepthList();
  }
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }


  void timer() {
    getKDataList(1);
    Future.delayed(Duration(seconds: 1), () => timer());
  }

  ///
  /// kline request
  ///
  Future getKDataList(int index) async{
    var type = '1';
    switch (index) {
      case 1:
        type = '1';
        break;
      case 2:
        type = '3';
        break;
      case 3:
        type = '5';
        break;
      case 4:
        type = '10';
        break;
      case 5:
        type = '30';
        break;
      case 6:
        type = '60';
        break;
      case 7:
        type = '';
        break;
      default:
    }
    var time = new DateTime.now().millisecondsSinceEpoch;

    Response response = await dio.get("https://tt3.anrunjf.com/quota/candlestickData/getCandlesticKData.do?contractsCode=${id}&type=${type}&_=${time}");
    Response res = await dio.get("https://tt3.anrunjf.com/quota/quota/getQuotaDataAllByWeb.do?contractsCode=${id}&_=${time}");
    setState(() {
      lines.clear();
      var data = jsonDecode(response.data);
      detail = jsonDecode(res.data)["data"];
      color = detail["upDropPrice"] < 0 ? Colors.green : Colors.red;
      lines.addAll(data["data"]);
      getKlineDataList(lines);
      _currentDataType = _timeIndex[index];
    });
  }

  // _randomBit(int len) {
  //   String scopeF = "123456789";//首位
  //   String scopeC = "0123456789";//中间
  //   String result = "";
  //   for (int i = 0; i < len; i++) {
  //   if (i == 1) {
  //   result = scopeF[Random().nextInt(scopeF.length)];
  //   } else {
  //   result = result + scopeC[Random().nextInt(scopeC.length)];
  //   }
  //   }
  //   return result;
  // }


  // lines data model
  List<ChartModel> getKlineDataList(List data) {
    dataList.clear();
    for (int i = 0; i < data.length; i++) {
      int timestamp = data[i]["timeStamp"];  ///timestamp
      double openPrice =double.parse(data[i]["openPrice"].toString()); /// open
      double closePrice = double.parse(data[i]["closePrice"].toString()); /// close
      double maxPrice = double.parse(data[i]["maxPrice"].toString()); /// max
      double minPrice = double.parse(data[i]["minPrice"].toString()); /// min
      double volume =  double.parse(data[i]["nowVolume"].toString()); /// volume
      ///
      if(volume > 0) {
        dataList.add(ChartModel(timestamp, openPrice, closePrice, maxPrice, minPrice, volume));
      }
    }
    return dataList;
  }
  ///
  ///
  ///depth request
  ///


  void viewType(int type) {
    switch (type) {
      case 0:
        _viewTypeIndex = 0;
        break;
      case 1:
        _viewTypeIndex = 1;
        break;
      case 2:
        _viewTypeIndex = 2;
        break;
    }
  }
  void subviewType(int type) {
    switch (type) {
      case 0:
        _subviewTypeIndex = 0;
        break;
      case 1:
        _subviewTypeIndex = 1;
        break;
      case 2:
        _subviewTypeIndex = 2;
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(title, style: TextStyle(fontSize: 18,color: Colors.white),),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.1,
      leading: new IconButton(
          icon: new Image.asset('images/left_w.jpg',
              width: 11, height: 20),
          
          
          onPressed: () => Navigator.of(context).pop(),
      )
       
      ),
      body: SingleChildScrollView(
        child:  Column(
          children: <Widget>[
           detail!= null ? Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom:10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          detail["lastPrice"].toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                detail["upDropPrice"].toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color:color
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                (detail["upDropSpeed"]*100).toStringAsFixed(2) + '%',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: color
                                ),
                              ),
                            )
                            
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 20),),

                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '高',
                              style: TextStyle(
                                fontSize: 12,
                                color: text,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10),),
                            Text(
                              detail["highestPrice"].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10),),
                        Row(
                          children: <Widget>[
                            Text(
                              '低',
                              style: TextStyle(
                                fontSize: 12,
                                color: text,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10),),
                            Text(
                              detail["lowestPrice"].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '开',
                              style: TextStyle(
                                fontSize: 12,
                                color: text,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10),),
                            Text(
                              detail["openPrice"].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10),),
                        Row(
                          children: <Widget>[
                            Text(
                              '出',
                              style: TextStyle(
                                fontSize: 12,
                                color: text,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10),),
                            Text(
                              detail["bidPrice"].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '买',
                              style: TextStyle(
                                fontSize: 12,
                                color: text,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10),),
                            Text(
                              detail["askPrice"].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10),),
                        Row(
                          children: <Widget>[
                            Text(
                              '量',
                              style: TextStyle(
                                fontSize: 12,
                                color: text,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10),),
                            Text(
                              detail["volume"].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )

            ) : Container(height: 100,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    labelStyle: TextStyle(fontSize: 14),
                    tabs: <Widget>[
                      Tab(text: "1分"),
                      Tab(text: "3分"),
                      Tab(text: "5分"),
                      Tab(text: "10分"),
                      Tab(text: "30分"),
                      Tab(text: "1小时"),
                      Tab(text: "1日"),
                    ],
                    onTap: (index) {
                      setState(() {
                        getKDataList(index);
                      });
                    },
                  ),
                ),
                // Container(
              //     
              // 
                //   child:  FlatButton(
                //     onPressed: () {
                //       setState(() {
                //         if (_isShowMenu) {
                //           _isShowMenu = false;
                //         } else {
                //           _isShowMenu = true;
                //         }
                //       });
                //     },
                //     child: Icon(Icons.menu, color: text,),
                //   ),
                // )
              ],
            ),
            Container(
              height: 500,
                child: KlineView(
                  dataList: dataList,
                  currentDataType: _currentDataType,
                  isShowSubview: _isShowSubview,
                  viewType: _viewTypeIndex,
                  subviewType: _subviewTypeIndex,
                )
            ),
            //DepthView(depthList(_bidsList), depthList(_asksList)),
          ],
        ),
      )
    );
  }
}

