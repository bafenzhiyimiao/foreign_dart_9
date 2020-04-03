import 'package:flutter/material.dart';
import 'package:futures/login/login.dart';
import 'package:futures/my/collect.dart';
import 'package:futures/my/follow.dart';
import 'package:futures/my/usericon.dart';
import 'package:futures/my/my_info.dart';
import 'package:futures/my/agree.dart';
import 'package:futures/my/fankui.dart';
import 'package:futures/my/setting.dart';
import 'package:futures/global.dart';
import 'package:futures/my/notice.dart';
import 'dart:convert' as convert;



class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  var login = false;
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
    LocalStorage.getBool('login').then((val){
      setState(() {
        login = val != null ? val : false;
      });
    });
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

  agree() {
    Navigator.of(context,rootNavigator: true).push(
      new MaterialPageRoute(builder: (BuildContext context) {
      return new AgreeScreen();
    }));
  }
  fan() {
    Navigator.of(context,rootNavigator: true).push(
      new MaterialPageRoute(builder: (BuildContext context) {
      return new FanScreen();
    }));
  }
  setting() {
    Navigator.of(context,rootNavigator: true).push(
      new MaterialPageRoute(builder: (BuildContext context) {
      return new SettingScreen();
    }));
  }
  notice() {
    Navigator.of(context,rootNavigator: true).push(
      new MaterialPageRoute(builder: (BuildContext context) {
      return new NoticeScreen();
    }));
  }
  follow() {
    Navigator.of(context,rootNavigator: true).push(
      new MaterialPageRoute(builder: (BuildContext context) {
      return new FollowList();
    }));
  }
  collect() {
    Navigator.of(context,rootNavigator: true).push(
      new MaterialPageRoute(builder: (BuildContext context) {
      return new CollectList();
    }));
  }

  @override
  Widget build(BuildContext context) {
    // 头像组件


  Widget userImage = (image != null && login == true )? Container(
    padding: const EdgeInsets.only(top: 28.0, right: 18.0, left: 25.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5))
    ),
    child:  Image.memory(image,
        width: 55.0,
        height: 55.0,
      fit: BoxFit.fill,
      gaplessPlayback:true, //防止重绘
    )
  )
   : new UserIconWidget(
        padding: const EdgeInsets.only(top: 28.0, right: 18.0, left: 25.0),
        width: 55.0,
        height: 55.0,
        image: 'images/default_nor_avatar.png',
        isNetwork: false,
        onPressed: () {
          // NavigatorUtils.goPerson(context, eventViewModel.actionUser);
        });
    Widget buildRow(icon, title, isEnd, click) {
      return GestureDetector(
  behavior: HitTestBehavior.opaque,
        onTap: () {
          click();
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new UserIconWidget(
                  padding: const EdgeInsets.only(top: 0.0, right: 14.0, left: 14.0),
                  width: 22.0,
                  height: 22.0,
                  image: icon,
                  isNetwork: false,
                  onPressed: () {
                    // NavigatorUtils.goPerson(context, eventViewModel.actionUser);
                  }),
              Expanded(
                child: Container(
                  decoration: !isEnd
                      ? BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Color(0xffd9d9d9), width: .3)))
                      : null,
                  padding: EdgeInsets.only(top: 16.0),
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
                          child: Container(
                            margin: EdgeInsets.only(bottom: 15.0, right: 10.0),
                            child: Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            ),
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

    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Container(
              height: 180.0,
              child:
               RawMaterialButton(
                
                
                onPressed: () {
                  if(login) {
                    Navigator.of(context,rootNavigator: true).push(
                      new MaterialPageRoute(builder: (BuildContext context) {
                      return new MyInfoPage();
                    })).then((data) {
                      if(data != null) {
                        if(data == 'logout') {
                          setState(() {
                            login = false;
                            phone = '';
                            name = '';
                          });
                        }else if (data == 'edit') {
                          getUserInfo();
                        }
                      }
                    });
                  }else {
                    Navigator.of(context,rootNavigator: true).push(
                      new MaterialPageRoute(builder: (BuildContext context) {
                      return new LoginPage();
                    })).then((data) {
                      if(data != null) {
                        getUserInfo();
                      }
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    userImage,
                    Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 83.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                login ? (name != '' ? name :'用户' + phone.substring(7,11)) : '登录',
                                style: TextStyle(
                                    fontSize: 22.5, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 2.0,
                              ),
                              Text(
                                login ? '账号：' + phone : '登录后可享更多功能' ,
                                maxLines: 1,
                                style: TextStyle(color: Colors.grey, fontSize: 13.0),
                              )
                            ],
                          ),
                        )),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              top: 65.0, bottom: 15.0, right: 10.0),
                          child: Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  color: Colors.grey[100],
                  height: 10.0,
                ),
                buildRow('images/m1.png', '我的消息', true, notice),
              ],
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    color: Colors.grey[100],
                    height: 10.0,
                  ),
                  buildRow('images/m2.png', '收藏', false,collect),
                  buildRow('images/m3.png', '关注', false,follow),
                  buildRow('images/m4.png', '隐私协议', false, agree),
                  buildRow('images/m5.png', '意见反馈', true,fan),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  color: Colors.grey[100],
                  height: 10.0,
                ),
                buildRow('images/m6.png', '设置', true,setting),
              ],
            ),
          ],
        )
      ],
    );
  }
}
