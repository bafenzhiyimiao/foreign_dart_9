import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';



class FanScreen extends StatefulWidget {
  FanScreen({Key key}) : super(key: key);
  @override
  _FanScreen createState() => _FanScreen();
}

class _FanScreen extends State<FanScreen> {

  TextEditingController content = TextEditingController();
  File _image;

  

  goback() {
    if(content.text == null || content.text == '') {
      Fluttertoast.showToast(
          msg: "请输入内容",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          fontSize: 14.0
      );
      return null;
    }
    if(content.text != null&& content.text != '') {
      Fluttertoast.showToast(
          msg: "已收到您的宝贵意见, 谢谢您的反馈",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          fontSize: 14.0
      );
    } 
      Navigator.pop(context,'ok');

  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(image);
    setState(() {
      _image = image;
    });
  }

  void initState() {
    super.initState();
  }


  @override
    Widget build(BuildContext context) {
      return
       Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0.1,
          
          leading: new IconButton(
            icon: new Image.asset('images/left.jpg',
                width: 11, height: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            '意见反馈',
          ),
        ),
          backgroundColor: Theme.of(context).cardColor,
        body:Scrollbar(
            child: SingleChildScrollView(
            child: 
            
         Container(
            color: Theme.of(context).cardColor,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: content,
                  maxLines: 6,//最大行数
                  // autocorrect: true,//是否自动更正
                  // autofocus: true,//是否自动对焦
                  style: TextStyle(fontSize: 14.0,color: Colors.grey),//输入文本的样式
                  // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//允许的输入格式
                  onChanged: (text) {//内容改变的回调
                    // print('change $text');
                  },
                  onSubmitted: (text) {
                    goback();
                  },
                  decoration: InputDecoration(
                    hintText: '请输入意见',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    fillColor: Theme.of(context).backgroundColor,
                    filled: true,
                  ),//是否禁用
                ),

              Container(
                width: double.infinity,
                height: 200,
                margin: EdgeInsets.only(top: 20),
                child:_image!= null? 
                Image(
                  image: FileImage(_image),
                  fit:BoxFit.fitHeight
                ) :
                  GestureDetector(
  behavior: HitTestBehavior.opaque,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image(
                          width: 120,
                          height: 120,
                          alignment: Alignment.topLeft,
                          image: AssetImage('images/add.png'),
                          ),
                      ],
                    ),
                    onTap: () {
                      getImage();
                    },
                  )
              ),

                Container(
                  margin: EdgeInsets.only(top: 60.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // color: Color.fromRGBO(103, 193, 255, 1),
                      gradient: const LinearGradient(
                          colors: [Color.fromRGBO(0, 132, 255, 1),Color.fromRGBO(0, 132, 255, 0.3)]
                      ),
                    ),
                  child: MaterialButton(
                    onPressed: () {
                        goback();
                    },
                    minWidth: double.infinity,
                    child: Text("提交",style: TextStyle(color: Colors.white,fontSize: 16),),
                    elevation: 2.0,
                    
                    
                    
                  ),
                ),
              ],
            ),
        ),
        )
          ),
      );
    }
}