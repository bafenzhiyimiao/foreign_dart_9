import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:futures/article/video.dart';
import 'package:futures/article/news.dart';
import 'package:futures/article/calender.dart';
import 'package:futures/article/seven.dart';
// import 'package:taurus/header.dart';

class ArticleScreen extends StatefulWidget {
  @override
  ArticleScreenState createState() => ArticleScreenState();
}


class ArticleScreenState extends State<ArticleScreen> with SingleTickerProviderStateMixin{
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
          backgroundColor: Colors.white,
          
          centerTitle:false,
          elevation: 0.1,
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
                Tab(text: "推荐"),
                Tab(text: "快讯"),
                Tab(text: "要闻"),
                // Tab(text: "日历"),
              ],
          ),
          )
           
    ),
        body:TabBarView(
                controller: _tabCon,
                children: <Widget>[
                  VideoScreen(),
                  SevenScreen(),
                  NewsList(),
                  // CalenderScreen(),
                  // VideoList(),
                ]
              )
      );
  }
}
