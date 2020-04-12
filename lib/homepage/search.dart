import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:futures/homepage/search_reslut.dart';
import 'package:futures/news/news_list.dart';


class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);
  @override
  _Search createState() => _Search();
}

class _Search extends State<Search> with SingleTickerProviderStateMixin{

    TextEditingController controller = TextEditingController();

    var list = [];

  @override
  void initState() {
    super.initState();
  }


  tag(text,catid) {
    return GestureDetector(
    behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: new BoxDecoration(
          color: Theme.of(context).cardColor,
            // border: new Border.all(width: 1.0, color: Colors.grey[200]),
            borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: new Text(text, style: new TextStyle(color: Colors.blueGrey,fontSize: 12)),
      ),
      onTap:() {
        Navigator.of(context,rootNavigator: true).push(
          new MaterialPageRoute(builder: (BuildContext context) {
          return new SearchReslut(id: catid);
        }));
      }
    );
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
            padding: EdgeInsets.only(top:10),
            color: Theme.of(context).backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15,15,15,0),
                    decoration: new BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            style: BorderStyle.solid,
                            width: 0.1,
                          ),
                        )
                    ),
                    child: Row (
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: 
                        TextField(
                          controller: controller,
                          maxLines: 1,//最大行数
                          autocorrect: true,//是否自动更正
                          autofocus: true,//是否自动对焦
                          textAlign: TextAlign.start,//文本对齐方式
                          style: TextStyle(fontSize: 14.0,color: Colors.blueGrey),//输入文本的样式
                          // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//允许的输入格式
                          onChanged: (text) {//内容改变的回调
                            // print('change $text');
                          },
                          onSubmitted: (text) {//内容提交(按回车)的回调
                            if(text != null) {
                              Navigator.of(context,rootNavigator: true).push(
                                new MaterialPageRoute(builder: (BuildContext context) {
                                return new SearchReslut(id:'');
                              }));
                            }
                          },
                          decoration: InputDecoration(
                            hintText: '请输入关键词',
                            hintStyle: TextStyle(color: Colors.grey[200]),
                              prefixIcon: Container(
                                height: 12,
                                width: 12,
                                padding: EdgeInsets.all(15),
                                child: Image.asset('assets/home_search.jpg',width:10,height:10,fit:BoxFit.fitWidth),
                              ),
                            border: InputBorder.none,
                          ),
                        )
                      ),

                      GestureDetector(
                          child: new Text('取消',style: TextStyle(fontSize: 14),),
                          onTap: () {
                            Navigator.pop(context);
                          }
                        ),
                      
                    ],
                    )
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15,15,15,0),
                        margin: EdgeInsets.only(top: 10),
                        child: Text('热门搜索',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10,10,15,0),
                        child: Wrap(
                          children: <Widget>[
                            tag('贵金属',2),
                            tag('原油',10),
                            tag('黄金',17),
                            tag('白银',11),
                            tag('美元',12),
                            tag('人民币',13),
                            tag('欧元',14),
                            tag('纸黄金',15),
                            tag('美联储',16),
                          ],
                        ),
                      )
                    ],
                  )

                  
                  
                    
              ],
            )
        ),
      );
    }
}