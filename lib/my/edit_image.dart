import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:futures/toast.dart';
import 'package:futures/global.dart';
import 'dart:convert' as convert;

import 'dart:io';



class UserImageScreen extends StatefulWidget {
  UserImageScreen({Key key}) : super(key: key);
  @override
  _UserImageScreen createState() => _UserImageScreen();
}

class _UserImageScreen extends State<UserImageScreen> {

  TextEditingController content = TextEditingController();
  File _image;
  var imageStr;
  bool upload = false;

  

  save() {
    if( _image == null) {
      ToastUtil.show('您尚未修改图片');
      return null;
    }else {
      imageFile2Base64(_image).then((val) {
        LocalStorage.setString('image', val);
        Navigator.pop(context,true);
      });
    }
  }


  static Future imageFile2Base64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    return convert.base64Encode(imageBytes);
  }


   static Future base642Image(String base64Txt) async {
      // var str = base64Txt.split(',')[1];
      return  convert.Base64Decoder().convert(base64Txt);
   }

   

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void initState() {
    super.initState();
    LocalStorage.getString('image').then((val){
      if(val != null) {
        base642Image(val).then((ol) {
          setState(() {
            imageStr = ol;
          });
        });
      }
    });
  }


  @override
    Widget build(BuildContext context) {
      return
       Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          brightness: Brightness.dark,
          leading: new IconButton(
            icon: new Image.asset('images/left_w.jpg',
                width: 11, height: 20),
                
          
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            '个人头像',
            style: TextStyle(color: Colors.white,fontSize: 18),
          ),
          actions: <Widget>[
            GestureDetector(
  behavior: HitTestBehavior.opaque,
              onTap: () {
                save();
              },
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(right:15),
                  child: Text('保存',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                )
                 
              )
              
            )
          ],
        ),
        body:Scrollbar(
            child: Container(
            color: Colors.black87,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            child: _image != null ? 
                GestureDetector(
  behavior: HitTestBehavior.opaque,
                  onTap: () {
                      getImage();
                  },
                  child: Image(
                    image: FileImage(_image),
                    fit:BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width -30,
                  ) 
                )
                 : 
                 GestureDetector(
  behavior: HitTestBehavior.opaque,
                  onTap: () {
                      getImage();
                  },
                  child: imageStr  == null ? Image.asset(
                    'images/default_nor_avatar.png',
                    fit:BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width -30,
                  ): Image.memory(imageStr,
                    width: MediaQuery.of(context).size.width -30,
                   fit: BoxFit.fitWidth,
                    gaplessPlayback:true, //防止重绘
                  )
                 )
          ),
        )
      );
    }
}