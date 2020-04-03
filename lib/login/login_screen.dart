import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:futures/my/agree.dart';
import 'package:futures/toast.dart';
import 'package:futures/global.dart';






class CodeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int coldDownSeconds;

  CodeButton({@required this.onPressed, @required this.coldDownSeconds});

  @override
  Widget build(BuildContext context) {
    if (coldDownSeconds > 0) {
      return Container(
        width: 95,
        child: Center(
          child: Text(
            '${coldDownSeconds}s',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      );
    }

    return GestureDetector(
  behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        width: 95,
        child: Text('获取验证码',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.white)),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State {
  TextEditingController phoneEditer = TextEditingController();
  TextEditingController codeEditer = TextEditingController();
  int coldDownSeconds = 0;
  Timer timer;
  bool agree = true;

  fetchSmsCode() async {
    if (phoneEditer.text.length != 11) {
      ToastUtil.show("输入手机号不合法");
      return;
    }

     Map<String, dynamic> param = {
      "tel": phoneEditer.text,
    };


    try {
      // Future.delayed(Duration(seconds: 2));
      Response  response= await Dio().post('https://www.sugargirlapp.com/v11/code/get_tel_msg_code',data:param);
      if(mounted) {
        if(response.statusCode != 200) {
          ToastUtil.show("服务器繁忙,请稍后再试");
        }else {
          if(response.data["code"] == 0) {
            ToastUtil.show("短信验证码已发送，请注意查收");
            setState(() {
              coldDownSeconds = 60;
            });
            coldDown();
          }else {
            ToastUtil.show(response.data["data"]);
          }
        }
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  

  login() async {
    var phone = phoneEditer.text;
    var code = codeEditer.text;
    Map<String, dynamic> param = {
      "tel": phone,
      "code": code,
      "deviceNo":""
    };
    if (!agree) {
      ToastUtil.show('您尚未同意用户隐私协议');
      return;
    }
    if (phone.length != 11) {
      ToastUtil.show('输入手机号不合法');
      return;
    }
    try {
      Response  response= await Dio().post('https://www.sugargirlapp.com/v11/user/login',data:param);
      if(mounted) {
        if(response.statusCode != 200) {
          ToastUtil.show('服务器繁忙,请稍后再试');
        }else {
          if(response.data["code"] == 0) {
            LocalStorage.setBool('login',true);
            LocalStorage.setString('phone',phoneEditer.text.toString());
            LocalStorage.setString('tel',response.data["data"]["User"]["Nick"]);
            LocalStorage.setString('name',response.data["data"]["User"]["Nick"]);
            LocalStorage.setString('ctime',response.data["data"]["User"]["CTime"]);
            ToastUtil.show('登录成功');
            Navigator.pop(context,phone);
          }else {
            ToastUtil.show(response.data["message"]);
          }
        }
        
          
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  ///验证码倒计时
  coldDown() {
    timer = Timer(Duration(seconds: 1), () {
      setState(() {
        --coldDownSeconds;
      });

      coldDown();
    });
  }

  Widget buildPhone() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        // borderRadius: BorderRadius.circular(5),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[50],
            style: BorderStyle.solid,
            width: 0.2,
          )
        )
      ),
      child: TextField(
        controller: phoneEditer,
        keyboardType: TextInputType.phone,
        style: TextStyle(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
          hintText: '请输入手机号',
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildCode() {
    return Container(
      padding: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        // borderRadius: BorderRadius.circular(5),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[50],
            style: BorderStyle.solid,
            width: 0.2,
          )
        )
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: codeEditer,
              keyboardType: TextInputType.phone,
              style: TextStyle(fontSize: 14, color: Colors.white),
              decoration: InputDecoration(
                hintText: '请输入短信验证码',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
          // Container(color: Color(0xffdae3f2), width: 1, height: 40),
          CodeButton(
            onPressed: fetchSmsCode,
            coldDownSeconds: coldDownSeconds,
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildPhone(),
              SizedBox(height: 10),
              buildCode(),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(top:50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: const LinearGradient(
                    colors: [Color.fromRGBO(0, 132, 255, 1),Color.fromRGBO(0, 132, 255, 0.3)]
                  ),
                ),
                height: 40,
                child: FlatButton(
                  
                  
                  onPressed: login,
                  child: Text(
                    '登录',
                    style: TextStyle(fontSize: 16, color: Color(0xffffffff)),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top:20),),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    agree = !agree;
                  });
                },
                child: Row(
                  children: <Widget>[
                    Icon(agree ? Icons.check_circle : Icons.radio_button_unchecked, color: Colors.white , size: 14,),
                    Padding(padding: EdgeInsets.only(left: 5),),
                    Text('已阅读并同意《', style: TextStyle(color:Colors.white,fontSize: 12),),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context,rootNavigator: true).push(
                            new MaterialPageRoute(builder: (BuildContext context) {
                          return new AgreeScreen();
                        }));
                      },
                      child: Text('期货投资宝隐私协议',style: TextStyle(color:Colors.white,fontSize: 12,fontWeight: FontWeight.w700)),
                    ),
                    Text('》',style: TextStyle(color:Colors.white,fontSize: 12))
                  ],
                )
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        
        leading: new IconButton(
          icon: new Image.asset('images/left_w.jpg',width: 11, height: 20),
          
          
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("登录",style: TextStyle(color: Colors.white),)
      ),
      backgroundColor: Colors.transparent,
      body: buildBody(),
    );
  }
}
