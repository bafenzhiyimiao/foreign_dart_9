import 'package:flutter/material.dart';

class About extends StatefulWidget {
  About({Key key}) : super(key: key);
  @override
  _About createState() => _About();
}

class _About extends State<About> {
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.1,
          
          leading: new IconButton(
            icon: new Image.asset('images/left.jpg',
                width: 11, height: 20),
                
          
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("关于",style: TextStyle(fontSize: 18,color: Colors.black87),)
        ),
        body: 
        // new Container(
        //   child: new UiKitView(viewType: "H5Container"),
        // )

        Container(
            color: Colors.white,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 70,bottom: 18),
                  child: Image.asset('images/logo.jpg',fit: BoxFit.fill,width: 200,height: 200,),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 18),
                  child: Text('提 供 最 专 业 的 资 讯',style:TextStyle(fontSize:15,color:Color.fromARGB(255, 132, 132, 132))),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(13, 5, 13, 5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0,color: Color.fromARGB(255, 132, 132, 132)),
                    borderRadius: BorderRadius.circular(18)
                  ),
                  child: Text('V 1.0.0',style:TextStyle(fontSize:15,color:Color.fromARGB(255, 132, 132, 132))),
                )
              ],
            ),
        ),
      );
    }
}