import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:futures/marketInfo/market_info_list.dart';
import 'package:futures/marketInfo/foreign_rate.dart';

class MarketInfoScreen extends StatefulWidget {
  @override
  MarketInfoScreenState createState() => MarketInfoScreenState();
}


class MarketInfoScreenState extends State<MarketInfoScreen> with SingleTickerProviderStateMixin{
  TabController _tabCon;

  @override
  void initState() {
    super.initState();
    _tabCon = TabController(vsync: this, initialIndex: 0, length: 3);
  
  }

 

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0.1,
          
          centerTitle:false,
          title: Container(
            child: TabBar(
                indicator: null,
                indicatorWeight: 0.01,
                isScrollable: true,
                unselectedLabelColor : Colors.grey,
                unselectedLabelStyle: TextStyle(fontSize: 16),
                // labelColor:Colors.black87,
                labelStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                controller: _tabCon,
                tabs:[
                  Tab(text: "外汇牌价"),
                  Tab(text: "国际期货"),
                  Tab(text: "国内期货"),
                ],
            ),
          )
          
    ),
    backgroundColor: Theme.of(context).backgroundColor,
        body:TabBarView(
                controller: _tabCon,
                children: <Widget>[
                  ForeignScreen(),
                  MarketInfoList(channelid: 0),
                  MarketInfoList(channelid: 1),
                ]
              )
      );
  }
}
