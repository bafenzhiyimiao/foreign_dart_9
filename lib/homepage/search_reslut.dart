import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:futures/homepage/search_ flash.dart';
import 'package:futures/homepage/search_video.dart';


class SearchReslut extends StatefulWidget {
  final name;
  SearchReslut({Key key, @required this.name}) : super(key: key);
  @override
  SearchReslutState createState() => SearchReslutState(name: name);
}

class SearchReslutState extends State<SearchReslut> with SingleTickerProviderStateMixin{
  final name;
  SearchReslutState({Key key, @required this.name});
  
  TabController controller;
  var tabs = <Tab>[];


  @override
  void initState() {
    super.initState();
    tabs = <Tab>[
      Tab(text: "快讯",),
      Tab(text: "视频",),
    ];

    //initialIndex初始选中第几个
    controller =
        TabController(initialIndex: 0, length: tabs.length, vsync: this);
    
  }

  

  

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            backgroundColor: Theme.of(context).cardColor,
            title: Container(
              color: Theme.of(context).cardColor,
              child: TabBar(
                  indicator: null,
                  indicatorWeight: 0.01,
                  isScrollable: true,
                  unselectedLabelColor : Colors.grey,
                  unselectedLabelStyle: TextStyle(fontSize: 14),
                  labelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                  controller: controller,
                  tabs:tabs,
              )
            ),
            elevation: 0.1,
            
            leading: new IconButton(
              icon: new Image.asset('assets/left.jpg',
                width: 11, height: 20),
                
                
              onPressed: () => Navigator.of(context).pop(),
            ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body:  TabBarView(
        controller: controller,
        children: <Widget>[
          SearchFlash(name: name,),
          SearchVideo(name: name,),
        ]
      ),
    );
  }
}
