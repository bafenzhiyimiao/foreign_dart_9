import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:html/dom.dart' as dom;
import 'package:futures/global.dart';


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
  bool iscollect = false;


  Future<void> onRefreshing() async {
    try {
      Response response = await Dio().get(
          "https://news.followme.com/api/v1/news/${id}/content",
      );
      if (mounted) {
        setState(() {
          detail = response.data["data"];
        });
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
    LocalStorage.getJSON('collect').then((arr) {
      if(arr == null) {
        return;
      }
      arr.forEach((v){
        if(v['id'] == id) {
          setState(() {
            iscollect = true;
          });
        }
      });
    });
  }

  


 

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: AppBar(
          title: Text('',style: TextStyle(color: Colors.black87,fontSize: 18),),
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0.1,
          leading: new IconButton(
            icon: new Image.asset('assets/left.jpg',
                width: 11, height: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 15),
              child: Center(
                child: !iscollect ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      LocalStorage.getJSON('collect').then((val){
                        if(val == null) {
                          var str = [detail];
                          LocalStorage.setJSON('collect', str);
                        }else {
                          var str = val;
                          str.add(detail);
                          LocalStorage.setJSON('collect', str);
                        }
                      });
                      setState(() {
                        iscollect = !iscollect;
                      });
                      print('sss');
                    },
                    child: Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/sc.jpg",
                        fit: BoxFit.fill,
                      ),
                    )
                  ) : GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      LocalStorage.getJSON('collect').then((val){
                        var arr = [];
                        val.forEach((w) => {
                          if(w['id']!= detail['id']) {
                            arr.add(w)
                          }
                        });
                        LocalStorage.setJSON('collect', arr == null ? [] : arr);
                      });
                      setState(() {
                        iscollect = !iscollect;
                      });
                    },
                    child: Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/sc_a.jpg",
                        fit: BoxFit.fill,
                      ),
                    )
                  ),
              )
            )
          ],
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
                  TimelineUtil.format(detail["create_time"] * 1000,
                        dayFormat: DayFormat.Full),
                  style: new TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top:20),),
            Html(
              data: """
                  ${detail != null ? detail["content"] : ''}
                """,
              defaultTextStyle: TextStyle(
                fontFamily: 'serif',
              ),
              backgroundColor: Theme.of(context).backgroundColor,
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
                      //     child: Text(node.text.replaceAll('', '')),
                      //     padding:
                      //         const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      //   );
                      // case "a":
                      //   return Text(
                      //     node.text,
                      //     style: TextStyle(color: Colors.blue),
                      //   );
                      case "hr":
                        return Divider(
                          height: 20,
                        );
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
