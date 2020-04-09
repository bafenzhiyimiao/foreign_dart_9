import 'package:flutter/material.dart';
import 'package:futures/my/usericon.dart';
import 'package:futures/my/edit.dart';
import 'package:futures/my/edit_image.dart';
import 'package:futures/global.dart';
import 'dart:convert' as convert;



class MyInfoScreen extends StatefulWidget {
  @override
  _MyInfoScreenState createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {

  var name = '';
  var phone = '';
  var image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  getUserInfo() {
    LocalStorage.getString('name').then((val){
      setState(() {
        name = val != null ? val : '';
      });
    });
    LocalStorage.getString('tel').then((val){
      setState(() {
        phone = val != null ? val : '';
      });
    });
    LocalStorage.getString('image').then((val){
      if(val != null) {
        base642Image(val).then((ol) {
          setState(() {
            image = ol;
          });
        });
      }
    });
  }

  static Future base642Image(String base64Txt) async {
      // var str = base64Txt.split(',')[1];
      return  convert.Base64Decoder().convert(base64Txt);
   }

  goEdit() {
    Navigator.of(context,rootNavigator: true).push(
      new MaterialPageRoute(builder: (BuildContext context) {
      return new EditScreen();
    })).then((val) {
      if(val != null) {
        getUserInfo();
      }
    });
  }

  goImage() {
    Navigator.of(context,rootNavigator: true).push(
      new MaterialPageRoute(builder: (BuildContext context) {
      return new UserImageScreen();
    })).then((val) {
      if(val != null) {
        getUserInfo();
      }
    });
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
                          title != '账号' ? Container(
                            padding: EdgeInsets.only(bottom: 15.0, right: 10.0),
                            child: Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            ),
                          ) : Container(width: 0,)
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
    // 头像组件

    Widget userImage =image!= null ?  Image.memory(image,
        width: 55.0,
        height: 55.0,
      fit: BoxFit.fill,
      gaplessPlayback:true, //防止重绘
    ) : new UserIconWidget(
        padding: const EdgeInsets.only(right: 0.0),
        width: 55.0,
        height: 55.0,
        image: 'assets/default_nor_avatar.png',
        isNetwork: false,
        onPressed: () {
          // NavigatorUtils.goPerson(context, eventViewModel.actionUser);
        });
    return new Scaffold(
      appBar: AppBar(
        title: Text('个人信息',style: TextStyle(fontSize: 18),),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0.1,
        
        leading: new IconButton(
          icon: new Image.asset('assets/left.jpg',
              width: 11, height: 20),
              
          
          onPressed: () => Navigator.pop(context,'edit'),
        ),
        ),
        backgroundColor: Theme.of(context).cardColor,
      body: new SingleChildScrollView(
        child: new Container(
          color: Theme.of(context).cardColor,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildRow(userImage, '头像', false,goImage),
              buildRow(Text(name, style: TextStyle(color: Colors.grey, fontSize: 18.0),), '昵称', false, goEdit),
              buildRow(Text(phone, style: TextStyle(color: Colors.grey, fontSize: 18.0),), '账号', true, () => {}),
              // buildRow(Text(''), '更多', true),

              Container(
                margin: EdgeInsets.only(top:80,left: 10,right: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.red[400],
                ),
                height: 40,
                child: FlatButton(
                  
                  
                  onPressed: () {
                    LocalStorage.remove('phone');
                    LocalStorage.remove('login');
                    Navigator.pop(context,'logout');
                  },
                  child: Text(
                    '退出登录',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
