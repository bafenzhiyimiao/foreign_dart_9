import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:html/dom.dart' as dom;
import 'package:futures/global.dart';


class HotDetail extends StatefulWidget {
  final id;
  HotDetail({Key key, @required this.id}) : super(key: key);
  @override
  HotDetailState createState() => HotDetailState(id: id);
}




class HotDetailState extends State<HotDetail> {
  final id;
  HotDetailState({Key key, @required this.id});

  var detail;
  var list;
  bool iscollect = false;


  Future<void> onRefreshing() async {
    var time = new DateTime.now().millisecondsSinceEpoch;
    try {
      Map<String, dynamic> httpHeaders = {
        'x-udid': '6aba6d51a0e4e8f2e8e508c9a946fcba0abb9c06',
        'x-app-ver': 'ios_base_4.3.2',
        'x-token': '',
        'x-app-id': 'g93rhHb9DcDptyPb',
        'x-version':'1.0.1'
      };
      Options options = Options(headers:httpHeaders);
      Response response = await Dio().get(
          "https://reference-api.jin10.com/reference/getOne?type=news&id=${id}&_=${time}",
          options: options,
      );
      if (mounted) {
        // // var res = jsonDecode(response.data);
        setState(() {
          detail = response.data["data"];
        });
      }

    } catch (e) {
      print(e);
    }
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
                          if(w['category_ids'][0] != detail['category_ids'][0]) {
                            arr.add(w)
                          }
                        });
                        LocalStorage.setJSON('collect', arr == null ? [] : arr);
                      });
                      LocalStorage.getJSON('collect').then((arr){
                        print(arr);
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
                        "assets/sc.jpg",
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
                  TimelineUtil.format(DateTime.parse(detail["display_datetime"]).millisecondsSinceEpoch,
                        dayFormat: DayFormat.Full),
                  style: new TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
                // Text(
                //   detail["introtext"],
                //    style: new TextStyle(color: Colors.grey, fontSize: 12.0),
                // )
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(246,247,247,1),
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Text(detail["introduction"],style:TextStyle(color:  Colors.black45,fontSize: 13),),
            ),
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
