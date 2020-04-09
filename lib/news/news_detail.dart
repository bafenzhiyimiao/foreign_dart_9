import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:html/dom.dart' as dom;

class NewsDetail extends StatefulWidget {
  final id;
  NewsDetail({Key key, @required this.id}) : super(key: key);
  @override
  NewsDetailState createState() => NewsDetailState(id: id);
}




class NewsDetailState extends State<NewsDetail> {
  final id;
  NewsDetailState({Key key, @required this.id});

  var detail;
  var list;



  Future<void> onRefreshing() async {
    try {
      Response response = await Dio().get(
          "http://news.taoketong.cc//api/articledetail?id=${id}&language",
      );
      if (mounted) {
        setState(() {
          detail = response.data;
        });
        print(response.data);
      }

    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onRefreshing();
  }


 

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: AppBar(
          title: Text('',),
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0.1,
          
          leading: new IconButton(
            icon: new Image.asset('assets/left.jpg',
                width: 11, height: 20),
                
          
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: detail != null ? ListView(
          padding: EdgeInsets.only(left:10,right:10),
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top:10),),
            Text(
              detail['title'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700
              ),
            ),
            Padding(padding: EdgeInsets.only(top:10),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  TimelineUtil.format(DateTime.parse(detail["created"]).millisecondsSinceEpoch,
                        dayFormat: DayFormat.Full),
                  style: new TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
                // Text(
                //   detail["introtext"],
                //    style: new TextStyle(color: Colors.grey, fontSize: 12.0),
                // )
              ],
            ),
            Padding(padding: EdgeInsets.only(top:20),),

            Image(
              image: NetworkImage(detail["imgurl"]),
            ),
            Padding(padding: EdgeInsets.only(top:20),),
            Html(
              data: """
                  ${detail != null ? detail["introtext"] : ''}
                """,
              defaultTextStyle: TextStyle(
                fontFamily: 'serif',
              ),
               customTextStyle:
                    (dom.Node node, TextStyle baseStyle) {
                  if (node is dom.Element) {
                    switch (node.localName) {
                      case "p":
                        return baseStyle.merge(
                            TextStyle(height: 16, fontSize: 14.0));
                    }
                  }
                  return baseStyle;
                },
                customRender: (node, children) {
                  if (node is dom.Element) {
                    switch (node.localName) {
                      // case "p":
                      //   return Padding(
                      //     child: Text(node.text.replaceAll('鑫汇宝贵金属', '')),
                      //     padding:
                      //         const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      //   );
                      case "a":
                        return Text(
                          node.text,
                          style: TextStyle(color: Colors.blue),
                        );
                      case "hr":
                        return Divider(
                          height: 20,
                        );
                    }
                    if(node.text == '鑫汇宝贵金属') {
                      return Text('');
                    }
                  }
                }
            ),
          ],
        ) : Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset('assets/empty_dark.jpg',fit:BoxFit.fill),
        )
    );
  }
}
