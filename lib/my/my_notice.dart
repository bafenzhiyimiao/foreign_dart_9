import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';



class MyNoticeScreen extends StatefulWidget {

  @override
  MyNoticeScreenState createState() => MyNoticeScreenState();
}
class MyNoticeScreenState extends State<MyNoticeScreen> {
  // 总数
  
  @override
  Widget build(BuildContext context) {
      return Scaffold(
         appBar: AppBar(
          title: Text('我的消息'),
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0.1,
          
          leading: new IconButton(
            icon: new Image.asset('assets/left.jpg',
                width: 11, height: 20),
                
          
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/data.jpg',width: 100,fit: BoxFit.fill,),
              Padding(padding: EdgeInsets.only(top:5),),
              Text('暂无消息',style: TextStyle(color: Colors.grey,fontSize: 12),)
            ],
          ),
        ),
      );
  }
}