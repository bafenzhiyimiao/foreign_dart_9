import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:futures/market/market_list.dart';

class MarketScreen extends StatefulWidget {
  @override
  MarketScreenState createState() => MarketScreenState();
}


class MarketScreenState extends State<MarketScreen> with SingleTickerProviderStateMixin{
  TabController _tabCon;

  @override
  void initState() {
    super.initState();
    _tabCon = TabController(vsync: this, initialIndex: 0, length: 2);
  
  }

 

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.1,
          
          centerTitle:false,
          title: Container(
            color: Colors.white,
            child: TabBar(
                indicator: null,
                indicatorWeight: 0.01,
                isScrollable: true,
                unselectedLabelColor : Colors.grey,
                unselectedLabelStyle: TextStyle(fontSize: 16),
                labelColor:Colors.black87,
                labelStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                controller: _tabCon,
                tabs:[
                  Tab(text: "国际期货"),
                  Tab(text: "国内期货"),
                ],
            ),
          )
          
    ),
        body:TabBarView(
                controller: _tabCon,
                children: <Widget>[
                  MarketList(channelid: 0),
                  MarketList(channelid: 1),
                ]
              )
      );
  }
}
