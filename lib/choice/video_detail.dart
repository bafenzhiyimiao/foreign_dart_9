import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:futures/global.dart';
import 'package:futures/login/login.dart';
import 'package:html/dom.dart' as dom;
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:futures/complaint.dart';



class VideoDetail extends StatefulWidget {
  final id;
  VideoDetail({Key key, @required this.id}) : super(key: key);
  @override
  VideoDetailState createState() => VideoDetailState(id: id);
}

var controller;


class VideoDetailState extends State<VideoDetail> {
  final id;
  VideoDetailState({Key key, @required this.id});

  var detail;
  var list;
  var comments = [];
  var image;

  bool isfollow = false;
  bool islogin = false;

  var chewieController;
  TextEditingController textcontroller = TextEditingController();





  Future<void> onRefreshing() async {
    try {
      Map<String, dynamic> httpHeaders = {
        'x-udid': '6aba6d51a0e4e8f2e8e508c9a946fcba0abb9c06',
        'x-app-ver': 'ios_base_4.3.2',
        'x-token': '',
        'x-app-id': 'g93rhHb9DcDptyPb',
        'x-version':'1.0.1'
      };
      Map<String, dynamic> httpHeaders2 = {
        'x-udid': '6aba6d51a0e4e8f2e8e508c9a946fcba0abb9c06',
        'x-app-ver': 'ios_base_4.4.0',
        'x-token': '',
        'x-app-id': 'g93rhHb9DcDptyPb',
        'x-version':'1.0.0'
      };
      print(id);
      Options options = Options(headers:httpHeaders);
      Options options2 = Options(headers:httpHeaders2);
      Response response = await Dio().get(
          "https://reference-api.jin10.com/reference/getOne?id=${id.toString()}&type=video",
          options: options,
      );
      Response res = await Dio().get(
          "https://comment-api.jin10.com/list?isgood=0&lastId=0&limit=20&object_id=11438&root_id=0&type=video",
          options: options2,
      );
      if (mounted) {
        controller = VideoPlayerController.network(response.data["data"]["video_url"]);
        setState(() {
          detail = response.data["data"];
          comments = res.data["data"]["items"] != null ? res.data["data"]["items"] : [];
          chewieController = ChewieController(
            videoPlayerController: controller,
            aspectRatio: 16 / 9,
            autoPlay: true,
            looping: true,
            placeholder: new Container(
                color: Colors.white,
            ),
          );
        });
        getFollow(response.data["data"]);
      }

    } catch (e) {
      print(e);
    }
  }

 
  @override
  void initState() {
    super.initState();
    onRefreshing();
    LocalStorage.getBool('login').then((val){
      if(val != null) {
        setState(() {
          islogin = val;
        });
      }
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
      return  convert.Base64Decoder().convert(base64Txt);
   }


  getFollow(detail) {
    LocalStorage.getJSON('follow').then((arr) {
      print(arr);
      if(arr != null) {
        arr.forEach((val) {
          if(val['category_ids'][0] == detail["category_ids"][0]) {
            setState(() {
              isfollow = true;
            });
          }
        });
      }
    });
  }


 @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }



  buildComments(parent) {
    if (comments.isEmpty) {
      return Container(
        child: Center(
          heightFactor: 8,
          child: Text('暂无评论', style: TextStyle(color: Colors.grey)),
        ),
      );
    }
    List<Widget> list = [];
    comments.forEach((val) {
      list.add( GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (){
           showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => CupertinoActionSheet(
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                      child: const Text('举报'),
                      onPressed: () {
                        Navigator.of(parent, rootNavigator: true).push(
                            new MaterialPageRoute(
                                builder: (BuildContext parent) {
                          return new Complaint();
                        }));
                        Navigator.pop(context);
                      },
                    )
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    child: const Text('取消'),
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    },
                  )),
            );
        },
        child: Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new CircleAvatar(
                    radius: 15.0,
                    backgroundImage:val["avatar"] != null ?  NetworkImage(val["avatar"]) : (image != null ? MemoryImage(image)  : AssetImage('images/default_nor_avatar.png')),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(val["nick"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700),),
                        Padding(padding: EdgeInsets.only(top: 5),),
                        Text(val["text"].replaceAll('<div>', '').replaceAll('</div>', ''), style: TextStyle(fontSize: 13)),
                        Padding(padding: EdgeInsets.only(top: 5),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(
                                TimelineUtil.format(DateTime.parse(val["created_at"]).millisecondsSinceEpoch,
                                      dayFormat: DayFormat.Full),
                                style: new TextStyle(color: Colors.grey, fontSize: 11.0),
                              ),
                              // GestureDetector(
                              // behavior: HitTestBehavior.opaque,
                              //   onTap: () {
                              //     Navigator.of(context, rootNavigator: true).push(
                              //         new MaterialPageRoute(
                              //             builder: (BuildContext context) {
                              //       return new Complaint();
                              //     }));
                              //   },
                              //   child: Text('举报',style: new TextStyle(color: Colors.grey, fontSize: 11.0),),
                              // )
                              
                          ],
                        )
                      
                      ],
                    )
                  )
                  
                ],
              ),
              
            ],
          ),
          )
        )
      );
    });
    return Column(
      children: list,
    );
  }

  


  



 

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('视频播放',style: TextStyle(fontSize: 18),),
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0.1,
          leading: new IconButton(
            icon: new Image.asset('images/left.jpg',
                width: 11, height: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: detail!= null ? Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top:MediaQuery.of(context).size.width * 9 /16),
                  padding: EdgeInsets.all(10),
                  color: Theme.of(context).cardColor,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              detail["title"],
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                            ),
                          ),
                          !isfollow ? GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              LocalStorage.getJSON('follow').then((val){
                                if(val == null) {
                                  var str = [detail];
                                  LocalStorage.setJSON('follow', str);
                                }else {
                                  var str = val;
                                  str.add(detail);
                                  LocalStorage.setJSON('follow', str);
                                }
                              });
                              
                              setState(() {
                                isfollow = !isfollow;
                              });
                            },
                            child: Container(
                              width: 56,
                              height: 24,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left:10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text('＋关注',style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w700),),
                            )
                          ) : GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              LocalStorage.getJSON('follow').then((val){
                                var arr = [];
                                val.forEach((w) => {
                                  if(w['category_ids'][0] != detail['category_ids'][0]) {
                                    arr.add(w)
                                  }
                                });
                                LocalStorage.setJSON('follow', arr == null ? [] : arr);
                              });
                              LocalStorage.getJSON('follow').then((arr){
                                print(arr);
                              });
                              setState(() {
                                isfollow = !isfollow;
                              });
                            },
                            child: Container(
                              width: 56,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                border: Border.all(width: 1.0,color: Theme.of(context).primaryColor),
                                // color: Theme.of(context).primaryColor
                              ),
                              child: Text('已关注',style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12,fontWeight: FontWeight.w700),),
                            )
                          )
                        ],
                      ),
                      
                      Padding(padding: EdgeInsets.only(top:5),),
                      Row(
                        children: <Widget>[
                          Image(
                            image: AssetImage('images/hot.jpg'),
                            height: 10,
                            width: 8,
                            fit: BoxFit.fill,
                          ),
                          Padding(padding: EdgeInsets.only(left:5),),
                          Text(
                            '热度:  ' + detail["hits"].toString(),
                            style: TextStyle(fontSize: 12,color: Colors.grey),
                          ),
                          Padding(padding: EdgeInsets.only(left:30),),
                          Text(
                            '更新时间:  ' + detail["display_datetime"].toString(),
                            style: TextStyle(fontSize: 12,color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  )
                ),
                Divider(height: 5,color: Theme.of(context).dividerColor,),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: 4,
                            height: 15,
                            color: Theme.of(context).primaryColor,
                            margin: EdgeInsets.only(right:10),
                          ),
                          Text(
                            '本集简介',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top:5),),
                      Text(
                        detail["introduction"],
                        style: TextStyle(fontSize: 13),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: 4,
                            height: 15,
                            color: Theme.of(context).primaryColor,
                            margin: EdgeInsets.only(right:10),
                          ),
                          Text(
                            '最新评论',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top:5),),
                    ],
                  ),
                ),
                buildComments(context),
                Container(height: 70,)
              ],
            ) ,
            Positioned(
              top: 0,
              child: Container(
                height: MediaQuery.of(context).size.width * 9 /16,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: chewieController != null ? Chewie(
                  controller: chewieController,
                ) : Container(),
              ),
            ),

            Positioned(
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 3, 5, 3),
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                          color: Theme.of(context).cardColor, //设置子控件背后的装饰
                          border: Border(
                              top: BorderSide(
                            color: Colors.grey,
                            style: BorderStyle.solid,
                            width: 0.1,
                          ))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: textcontroller,
                              maxLines: 1, //最大行数
                              // autocorrect: true,//是否自动更正
                              // autofocus: true,//是否自动对焦
                              textAlign: TextAlign.start, //文本对齐方式
                              style: TextStyle(
                                  fontSize: 14.0,
                                  ), //输入文本的样式
                              // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//允许的输入格式
                              onChanged: (text) {
                                //内容改变的回调
                              },
                              onSubmitted: (text) {
                                if(text != null || text != '') {
                                  if(islogin) {
                                    LocalStorage.getString('name').then((val){
                                      setState(() {
                                        comments.add(
                                          {
                                            "nick": val,
                                            "text": text,
                                            "created_at": DateTime.now().toString().substring(0,19),
                                          }
                                        );
                                        textcontroller.text = '';
                                      });
                                      
                                    });
                                  }else {
                                    Navigator.of(context,rootNavigator: true).push(
                                      new MaterialPageRoute(builder: (BuildContext context) {
                                      return new LoginPage();
                                    })).then((data) {
                                      if(data != null) {
                                        setState(() {
                                          islogin = true;
                                        });
                                      }
                                    });
                                  }
                                }
                              },
                              // enabled: true,
                              decoration: InputDecoration(
                                hintText: '说点什么吧...',
                                hintStyle: TextStyle(),
                                border: InputBorder.none,
                                fillColor: Theme.of(context).dividerColor,
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 5),
                              ), //是否禁用
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              padding:EdgeInsets.all(10),
                              child: Image.asset(
                                'images/send.jpg',
                                width: 15,
                                height: 15,
                                fit: BoxFit.fitWidth,
                              )
                            ),
                            onTap: () {
                              var  text = textcontroller.text;
                                if(text != null || text != '') {
                                  if(islogin) {
                                    LocalStorage.getString('name').then((val){
                                      setState(() {
                                        comments.add(
                                          {
                                            "nick": val,
                                            "text": text,
                                            "created_at": DateTime.now().toString().substring(0,19),
                                          }
                                        );
                                        textcontroller.text = '';
                                      });
                                      
                                    });
                                  }else {
                                    Navigator.of(context,rootNavigator: true).push(
                                      new MaterialPageRoute(builder: (BuildContext context) {
                                      return new LoginPage();
                                    })).then((data) {
                                      if(data != null) {
                                        setState(() {
                                          islogin = true;
                                        });
                                      }
                                    });
                                  }
                                }
                            },
                          )
                        ],
                      ),
                    ),
                  )



          ],
        )
         : Container(height: 0,)
       
    );
  }
}
