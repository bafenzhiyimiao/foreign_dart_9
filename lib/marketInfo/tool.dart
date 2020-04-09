import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';











class ToolPage extends StatefulWidget {
  final info;
  ToolPage({Key key, @required this.info, }) : super(key: key);

  @override
  _ToolPageState createState() => _ToolPageState(info: info);
}

class _ToolPageState extends State<ToolPage> {
  final info;
  _ToolPageState({Key key, @required this.info, });

  TextEditingController yuan = TextEditingController();
  TextEditingController mon = TextEditingController();

  Color grey = Color.fromRGBO(184, 193, 204, 1);

  var select = 1;
  var rate;



  @override
  void initState() {
    super.initState();
    setState(() {
      rate = info["flCashBuyingRate"];
    });
  }

  







  @override
  Widget build(BuildContext context) {

    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(info["name"] + '计算'),
        elevation: 0.1,
        leading: new IconButton(
          icon: new Image.asset(isDark ? 'assets/left.jpg': 'assets/left.jpg',width: 11, height: 20),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      // backgroundColor: Color.fromRGBO(245,247,250,1),
      body: Container(
        child: Column(
          children: <Widget>[
           Column(
             children: <Widget>[
               Row(
                 children: <Widget>[
                   Expanded(
                     flex: 1,
                     child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 5, 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Column(
                        children: <Widget>[
                          Text('买入',style: TextStyle(color:grey,fontSize: 16),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    setState(() {
                                      select = 1;
                                      rate = info["flCashBuyingRate"];
                                    });
                                  },
                                  child:Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      image: new DecorationImage(
                                        image: AssetImage(select == 1 ? "assets/actived.jpg" : "assets/default.jpg"),
                                        fit:BoxFit.fill
                                      ),
                                    ),
                                    child: Center(
                                      child: Text('现钞',style: TextStyle(color: select == 1 ? Colors.white : Colors.black87,fontSize: 12),),
                                    )
                                    
                                  )
                                )
                              ),

                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    setState(() {
                                      select = 2;
                                      rate = info["flBuyingRate"];

                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      image: new DecorationImage(
                                        image: AssetImage(select == 2 ? "assets/actived.jpg" : "assets/default.jpg"),
                                        fit:BoxFit.fill
                                      ),
                                    ),
                                    child: Center(
                                      child: Text('现汇',style: TextStyle(color:select == 2 ? Colors.white : Colors.black87,fontSize: 12),),
                                    )
                                    
                                  )
                                )
                              )
                              
                            ],
                          )
                        ],
                      ),
                    )
                   ),

                   Expanded(
                     flex: 1,
                     child: Container(
                      margin: EdgeInsets.fromLTRB(5, 10, 10, 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Column(
                        children: <Widget>[
                          Text('卖出',style: TextStyle(color:grey,fontSize: 16),),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    setState(() {
                                      select = 3;
                                      rate = info["flCashSellingRate"];
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      image: new DecorationImage(
                                        image: AssetImage(select == 3 ? "assets/actived.jpg" : "assets/default.jpg"),
                                        fit:BoxFit.fill
                                      ),
                                    ),
                                    child: Center(
                                      child: Text('现钞',style: TextStyle(color:select == 3 ? Colors.white : Colors.black87,fontSize: 12),),
                                    )
                                    
                                  )
                                )
                                
                              ),

                              Expanded(
                                flex: 1,
                                child:  GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    setState(() {
                                      select = 4;
                                      rate = info["flSellingRate"];
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      image: new DecorationImage(
                                        image: AssetImage(select == 4 ? "assets/actived.jpg" : "assets/default.jpg"),
                                        fit:BoxFit.fill
                                      ),
                                    ),
                                    child: Center(
                                      child: Text('现汇',style: TextStyle(color:select == 4 ? Colors.white : Colors.black87,fontSize: 12),),
                                    )
                                  )
                                )
                              )
                              
                            ],
                          ),
                        ],
                      ),
                    )
                   ),
                   
                 ],
               ),
               Padding(padding: EdgeInsets.only(top:30),),

              Text('100 ${info["name"]} = ${rate.toString()} 人民币' , style: TextStyle(fontSize: 14),),
              Padding(padding: EdgeInsets.only(top:15),),
              Text('1 人民币= ${(100/rate).toStringAsFixed(4)} ${info["name"]}', style: TextStyle(fontSize: 14),),


              Container(
                margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                color: Theme.of(context).cardColor,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text('人民币',textAlign: TextAlign.left,style: TextStyle(fontSize: 16),),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: yuan,
                        onChanged: (text) {//内容改变的回调
                          if(text != '' && text != null) {
                            setState(() {
                              mon.text = (double.parse(text) * (100/rate)).toStringAsFixed(4);
                            });
                          }
                        },
                        keyboardType: TextInputType.phone,
                        style: TextStyle(fontSize: 16,color: grey),
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: '兑换金额',
                          hintStyle: TextStyle(color: grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    yuan.text != null && yuan.text != '' ? GestureDetector(
                      child: Image.asset("assets/closed.jpg",width: 20,height: 20,fit: BoxFit.fitWidth,),
                      onTap: () {
                        setState(() {
                          yuan.text = '';
                          mon.text = '';
                        });
                      },
                    ):Container(width: 0,height: 0,),
                  ],
                )
              ),

              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                color: Theme.of(context).cardColor,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(info['name'],textAlign: TextAlign.left,style: TextStyle(fontSize: 16),),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: mon,
                        onChanged: (text) {//内容改变的回调
                          if(text != '' && text != null) {
                            setState(() {
                              yuan.text = (double.parse(text) * (rate/100)).toStringAsFixed(4);
                            });
                          }
                        },
                        keyboardType: TextInputType.phone,
                        style: TextStyle(fontSize: 16,color: grey),
                        decoration: InputDecoration(
                          hintText: '兑换金额',
                          hintStyle: TextStyle(color: grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    mon.text != null && mon.text != '' ? GestureDetector(
                      child: Image.asset("assets/closed.jpg",width: 20,height: 20,fit: BoxFit.fitWidth,),
                      onTap: () {
                        setState(() {
                          mon.text = '';
                          yuan.text = '';
                        });
                      },
                    ): Container(width: 0,height: 0,),
                  ],
                )
              )
              

             ],
           )
          ],
        ),
      )
    );
  }

  
}
