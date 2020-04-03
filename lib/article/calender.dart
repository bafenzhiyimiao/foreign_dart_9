import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';

class CalenderScreen extends StatefulWidget {
  CalenderScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalenderScreenState createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  ValueNotifier<String> text;
  ValueNotifier<String> selectText;

  CalendarController controller;
  var list = [];



  Future<dynamic> onRefreshing(date) async {
      var string = '';

    if(date != '') {
      string = date;
    }else {
          string += controller.getSingleSelectCalendar().year.toString();
          string += controller.getSingleSelectCalendar().month < 10 ? '0' + controller.getSingleSelectCalendar().month.toString() : controller.getSingleSelectCalendar().month.toString();
          string += controller.getSingleSelectCalendar().day < 10 ? '0' + controller.getSingleSelectCalendar().day.toString() : controller.getSingleSelectCalendar().day.toString() ;
    }
    
    try {
      Response response = await Dio().get(
          "http://cj.baoninkaixin.xyz/fedata?type=&country=&rele=&enddate=${string}&date=${string}",
      );
      if (mounted) {
        print(response.data["value"]);
        setState(() {
          list = response.data["value"];
        });
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    controller = new CalendarController(
        minYear: now.year,
        minYearMonth: now.month - 2,
        maxYear: now.year,
        maxYearMonth: now.month + 1,
        // selectDateModel: DateModel.fromDateTime(DateTime.now(),
        showMode: CalendarConstants.MODE_SHOW_ONLY_WEEK,
        // selectDateModel: DateModel.fromDateTime(DateTime.now())
      );

    controller.addMonthChangeListener(
      (year, month) {
        text.value = "$year年$month月";
      },
    );

    controller.addOnCalendarSelectListener((dateModel) {
      //刷新选择的时间
       
          this.onRefreshing('');
          controller.changeDefaultSelectedDateModel(dateModel);
      selectText.value =
          "单选模式\n选中的时间:\n${controller.getSingleSelectCalendar()}";
    });

    text = new ValueNotifier("${DateTime.now().year}年${DateTime.now().month}月");

    selectText = new ValueNotifier(
        "单选模式\n选中的时间:\n${controller.getSingleSelectCalendar()}");

    this.onRefreshing("${DateTime.now().year}-0${DateTime.now().month}-${DateTime.now().day}");
  }


  buildList() {
    List<Widget> row = [];
    list.isNotEmpty && list != null ? list.forEach((val) {
      if(val != null && val['title'] != null) {

      row.add(
        Container(
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Text(
                val['stime'] != null ? val['stime'].substring(10,16) : '',
                style: TextStyle(color: Colors.blue[200]),
              ),
              Padding(padding: EdgeInsets.only(left:15),),
              Expanded(
                child: 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    Text(
                        val['affect'] != null ? val['affect'] : '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.orange,fontSize: 12),
                      ),
                      Padding(padding: EdgeInsets.only(top:5),),
                      Text(
                        val['title'] != null ? val['title'] : '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Padding(padding: EdgeInsets.only(top:5),),
                      Row(
                        children: <Widget>[
                          Text('前值: ' ,style: TextStyle(fontSize: 12,color: Colors.grey),),
                          Text(val['previous_price'] != null ?  val['previous_price']:'--',style: TextStyle(fontSize: 12,color: Colors.orange),),
                          Padding(padding: EdgeInsets.only(left:5),),
                          Text('预期: ',style: TextStyle(fontSize: 12,color: Colors.grey),),
                          Text(val['surver_price'] != null ?  val['surver_price']:'--',style: TextStyle(fontSize: 12,color: Colors.orange),),
                          Padding(padding: EdgeInsets.only(left:5),),
                          Text('公布: ',style: TextStyle(fontSize: 12,color: Colors.grey),),
                          Text(val['actual_price'] != null ?  val['actual_price']:'--',style: TextStyle(fontSize: 12,color: Colors.orange),),
                          Padding(padding: EdgeInsets.only(left:5),),
                        ],
                      )
                    ],
                  )
              )
            ],
          ),
        )
      );
      }
    }) : row.add(Container());
    return Column(
      children: row,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('财经日历',style: TextStyle(color: Colors.black87,fontSize: 18),),
        backgroundColor: Colors.white,
        elevation: 0.1,
        
        leading: new IconButton(
          icon: new Image.asset('images/left.jpg',
              width: 11, height: 20),
              
          
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: new Container(
        child: new ListView(
          children: <Widget>[
            CalendarViewWidget(
              calendarController: controller,
            ),
            buildList()
          ],
        ),
      ),
    );
  }
}
