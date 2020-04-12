import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:futures/chart/chart_model.dart';
import 'package:futures/chart/kline_view.dart';
import 'dart:convert';


class MarketInfoDetail extends StatefulWidget {
  final id;
  final title;
  MarketInfoDetail({Key key, @required this.id, this.title}) : super(key: key);
  @override
  _MarketInfoDetailState createState() => _MarketInfoDetailState(id:id, title:title);
}

class _MarketInfoDetailState extends State<MarketInfoDetail> with TickerProviderStateMixin{
  final id;
  final title;
  _MarketInfoDetailState({Key key, @required this.id, @required this.title});

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
  var allklist;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this, initialIndex: 0);
    getKDataList();
  }
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }



  ///
  /// kline request
  ///
  // Future getKDataList(int index) async{
  //   var type = '1';
  //   switch (index) {
  //     case 1:
  //       type = '1';
  //       break;
  //     case 2:
  //       type = '3';
  //       break;
  //     case 3:
  //       type = '5';
  //       break;
  //     case 4:
  //       type = '10';
  //       break;
  //     case 5:
  //       type = '30';
  //       break;
  //     case 6:
  //       type = '60';
  //       break;
  //     case 7:
  //       type = '';
  //       break;
  //     default:
  //   }
  //   var time = new DateTime.now().millisecondsSinceEpoch;

  //   // Response response = await dio.get("https://tt3.anrunjf.com/quota/candlestickData/getCandlesticKData.do?contractsCode=${id}&type=${type}&_=${time}");
  //   Response response = await dio.get("https://tt3.anrunjf.com/quota/candlestickData/getCandlesticKData.do?contractsCode=${id}&type=&_=${time}");
  //   Response response1 = await dio.get("https://tt3.anrunjf.com/quota/candlestickData/getCandlesticKData.do?contractsCode=${id}&type=1&_=${time}");
  //   Response response3 = await dio.get("https://tt3.anrunjf.com/quota/candlestickData/getCandlesticKData.do?contractsCode=${id}&type=3&_=${time}");
  //   Response response5 = await dio.get("https://tt3.anrunjf.com/quota/candlestickData/getCandlesticKData.do?contractsCode=${id}&type=5&_=${time}");
  //   Response response10 = await dio.get("https://tt3.anrunjf.com/quota/candlestickData/getCandlesticKData.do?contractsCode=${id}&type=10&_=${time}");
  //   Response response30 = await dio.get("https://tt3.anrunjf.com/quota/candlestickData/getCandlesticKData.do?contractsCode=${id}&type=30&_=${time}");
  //   Response response60 = await dio.get("https://tt3.anrunjf.com/quota/candlestickData/getCandlesticKData.do?contractsCode=${id}&type=60&_=${time}");
  //   Response res = await dio.get("https://tt3.anrunjf.com/quota/quota/getQuotaDataAllByWeb.do?contractsCode=${id}&_=${time}");
  //   setState(() {
  //     // lines.clear();
  //     // var data = jsonDecode(response.data);
  //     // detail = jsonDecode(res.data)["data"];
  //     // color = detail["upDropPrice"] < 0 ? Colors.green : Colors.red;
  //     // lines.addAll(data["data"]);
  //     // getKlineDataList(lines);
  //     // _currentDataType = _timeIndex[index];

  //     postApi({
  //       'detail': jsonDecode(res.data)["data"],
  //       'day':jsonDecode(response.data)["data"],
  //       '1min':jsonDecode(response1.data)["data"],
  //       '3min':jsonDecode(response3.data)["data"],
  //       '5min':jsonDecode(response5.data)["data"],
  //       '10min':jsonDecode(response10.data)["data"],
  //       '30min':jsonDecode(response30.data)["data"],
  //       '60min':jsonDecode(response60.data)["data"],
  //     });
  //   });
  // }


  Future<void> getKDataList()async {
    try {
      Map<String, dynamic> httpHeaders = {
          'X-LC-Id': 'jRGsn1jcAKTcSonNoAGqNFk3-MdYXbMMI',
          'X-LC-Key': 'g7jhcAye3Jls5PpxY4zC8O2e',
        };
        Options options = Options(headers:httpHeaders);
        Response response = await Dio().get(
            "https://jrgsn1jc.api.lncldglobal.com/1.1/classes/marketdetail_${id}",
            options: options,
        );
        print(response.data);
        setState(() {
          detail = response.data["results"][0]["detail"];
          allklist = response.data["results"][0];
          getKlineDataList(allklist["1min"]);
          _currentDataType = _timeIndex[1];
        });
    } catch (e) {
      print('ffff');
    }
  }

  changeTab(index) {
     var type = '1min';
      switch (index) {
        case 1:
          type = '1min';
          break;
        case 2:
          type = '3min';
          break;
        case 3:
          type = '5min';
          break;
        case 4:
          type = '10min';
          break;
        case 5:
          type = '30min';
          break;
        case 6:
          type = '60min';
          break;
        case 7:
          type = 'day';
          break;
        default:
      }
      setState(() {
        getKlineDataList(allklist[type]);
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
          icon: new Image.asset('assets/left_w.jpg',
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
                        changeTab(index);
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

