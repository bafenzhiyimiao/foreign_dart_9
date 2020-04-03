import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';



class NoticeScreen extends StatefulWidget {

  @override
  NoticeScreenState createState() => NoticeScreenState();
}
class NoticeScreenState extends State<NoticeScreen> {
  // 总数
  
  @override
  Widget build(BuildContext context) {
      return Scaffold(
         appBar: AppBar(
          title: Text('我的消息',style: TextStyle(color: Colors.black87,fontSize: 18),),
          backgroundColor: Colors.white,
          elevation: 0.1,
          
          leading: new IconButton(
            icon: new Image.asset('images/left.jpg',
                width: 11, height: 20),
                
          
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/empty.jpg',width: 100,fit: BoxFit.fill,),
              Padding(padding: EdgeInsets.only(top:5),),
              Text('暂无消息',style: TextStyle(color: Colors.grey,fontSize: 12),)
            ],
          ),
        ),
      );
  }
}