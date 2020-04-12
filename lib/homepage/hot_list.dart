import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:futures/news/news_list.dart';



class HotList extends StatefulWidget {
  final id;
  final hot;
  HotList({Key key, @required this.id, @required this.hot}) : super(key: key);
  @override
  HotListState createState() => HotListState(id: id, hot: hot);
}
class HotListState extends State<HotList> {
   final id;
   final hot;
  HotListState({Key key, @required this.id,  @required this.hot});
  // 总数



  

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

      return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          title: Text(hot["title"],style: TextStyle(fontSize: 18),),
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0.0,
          
          leading: new IconButton(
            icon: new Image.asset('assets/left.jpg',
                width: 11, height: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: NewsList(catid: id,)
      );
  }
}