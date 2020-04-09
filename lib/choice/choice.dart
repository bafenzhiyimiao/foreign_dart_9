import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:futures/choice/visual_screen.dart';
import 'package:futures/choice/article.dart';
import 'package:futures/choice/news_flash.dart';
// import 'package:taurus/header.dart';

class ChoiceScreen extends StatefulWidget {
  @override
  _ChoiceScreen createState() => _ChoiceScreen();
}


class _ChoiceScreen extends State<ChoiceScreen> with SingleTickerProviderStateMixin{
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
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          
          centerTitle:false,
          elevation: 0.1,
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
                  VisualScreen(),
                  NewsFlash(),
                  ArticleScreen(),
                  // DiaryScreen(),
                  // VisualScreenList(),
                ]
              )
      );
  }
}
