import 'package:flutter/material.dart';
import 'package:futures/global.dart';
import 'package:futures/toast.dart';





class EditScreen extends StatefulWidget {
  @override
  _EditScreen createState() => _EditScreen();
}

class _EditScreen extends State<EditScreen> {


  TextEditingController content = TextEditingController();


  @override
  void initState() {
    super.initState();
    LocalStorage.getString('name').then((val) {
      setState(() {
        if(val != null) {
          content.text = val;
        }
      });
    });
  }

  save() {
    if(content.text == '') {
      ToastUtil.show('请输入昵称');
      return null;
    }else {
      ToastUtil.show('修改成功');
      LocalStorage.setString('name', content.text);
      Navigator.pop(context,true);
    }
  }


  @override
    Widget build(BuildContext context) {
      return
       Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.1,
          
          leading: new IconButton(
            icon: new Image.asset('images/left.jpg',
                width: 11, height: 20),
                
          
            onPressed: () => Navigator.of(context).pop(),
          ),

          title: Text(
            '个人信息',
            style: TextStyle(color: Colors.black87,fontSize: 18),
          ),
        ),
        body:Scrollbar(
            child: SingleChildScrollView(
            child: 
            
         Container(
            color: Colors.white,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: content,
                  maxLines: 1,//最大行数
                  // autocorrect: true,//是否自动更正
                  autofocus: true,//是否自动对焦
                  style: TextStyle(fontSize: 14.0, color: Colors.black87),//输入文本的样式
                  // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//允许的输入格式
                  onChanged: (text) {//内容改变的回调
                    // print('change $text');
                  },
                  onSubmitted: (text) {
                    save();
                  },
                  decoration: InputDecoration(
                    hintText: '',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    fillColor: Colors.grey[100],
                    filled: true,
                  ),//是否禁用
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
                        save();
                    },
                    minWidth: double.infinity,
                    child: Text("保存",style: TextStyle(color: Colors.white,fontSize: 16),),
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