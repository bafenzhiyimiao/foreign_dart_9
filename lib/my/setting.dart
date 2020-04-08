import 'package:flutter/material.dart';
import 'package:futures/my/about.dart';
import 'package:fluttertoast/fluttertoast.dart';



class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  var clear = '1.8Mb';
  clean() {
        this.setState(() {
          clear = '0.0Mb';
        });
          Fluttertoast.showToast(
              msg: "已清除缓存",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              fontSize: 16.0
          );
  }
  about() {
        Navigator.of(context,rootNavigator: true).push(
          new MaterialPageRoute(builder: (BuildContext context) {
          return new About();
        }));
  }

  @override
  Widget build(BuildContext context) {
    Widget buildRow(child, title, isEnd,click) {
      return GestureDetector(
  behavior: HitTestBehavior.opaque,
        onTap: () {
          click();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: !isEnd
                    ? BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Color(0xffd9d9d9), width: .3)))
                    : null,
                padding: EdgeInsets.only(top: 16.0),
                margin: EdgeInsets.only(left: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 15.0, right: 5.0),
                            child: child,
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 15.0, right: 10.0),
                            child: Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      );
    }
    return new Scaffold(
      appBar: AppBar(
        title: Text('设置'),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0.1,
        leading: new IconButton(
          icon: new Image.asset('images/left.jpg',
              width: 11, height: 20),
              
          
          onPressed: () => Navigator.of(context).pop(),
        ),
        ),
        backgroundColor: Theme.of(context).cardColor,
      body: new SingleChildScrollView(
        child: new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildRow(Text(clear, style: TextStyle(color: Colors.grey, fontSize: 18.0),), '清除缓存', false, clean),
              buildRow(Text('', style: TextStyle(color: Colors.grey, fontSize: 18.0),), '关于我们', true,about),
              // buildRow(Text(''), '更多', true),
            ],
          ),
        ),
      ),
    );
  }
}
