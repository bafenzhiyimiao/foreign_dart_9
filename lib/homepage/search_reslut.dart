import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:futures/news/news_list.dart';



class SearchReslut extends StatefulWidget {
  final id;
  SearchReslut({Key key, @required this.id}) : super(key: key);
  @override
  SearchReslutState createState() => SearchReslutState(id:id);
}
class SearchReslutState extends State<SearchReslut> {
  // 总数
  final id;
  SearchReslutState({Key key, @required this.id});
  @override
  Widget build(BuildContext context) {
      return Scaffold(
         appBar: AppBar(
          title: Text('搜索结果'),
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0.1,
          
          leading: new IconButton(
            icon: new Image.asset('assets/left.jpg',
                width: 11, height: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: id == '' ? Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/data.jpg',width: 100,fit: BoxFit.fill,),
              Padding(padding: EdgeInsets.only(top:5),),
              Text('暂无数据',style: TextStyle(color: Colors.grey,fontSize: 12),)
            ],
          ),
        ) : NewsList(catid: id),
      );
  }
}