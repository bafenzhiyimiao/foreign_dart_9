import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:futures/choice/choice.dart';
import 'package:futures/marketInfo/market.dart';
import 'package:futures/homepage/home_page.dart';
import 'package:futures/my/my.dart';
import 'package:dio/dio.dart';













class App extends StatefulWidget {

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App>
    with SingleTickerProviderStateMixin {

  var tabImages;
  int _tabIndex = 0;






Image getTabImage(path) {
    return Image.asset(path,height: 22.0);
}

Image getTabIcon(int curIndex) {//设置tabbar选中和未选中的状态图标
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
}



  @override
  void initState() {
    super.initState();

      tabImages = [
        [
          getTabImage('assets/home_1_g.png'),
          getTabImage('assets/home_1.png')
        ],
        [
          getTabImage('assets/home_2_g.png'),
          getTabImage('assets/home_2.png')
        ],
        [
          getTabImage('assets/home_3_g.png'),
          getTabImage('assets/home_3.png')
        ],
        [
          getTabImage('assets/home_4_g.png'),
          getTabImage('assets/home_4.png')
        ],
      ];
  }

  onTabChange(val) {
    setState(() {
      _tabIndex = val;
    });
  }

  @override
  Widget build(BuildContext context) {
      return CupertinoTabScaffold( 
        tabBar: CupertinoTabBar( 
          items:[ 
            BottomNavigationBarItem( 
              icon: getTabIcon(0), 
              title: Text("首页"), 
            ), 
            BottomNavigationBarItem( 
              icon: getTabIcon(1), 
              title: Text("行情"), 
            ), 
            BottomNavigationBarItem( 
              icon: getTabIcon(2), 
              title: Text("精选"), 
            ), 
            BottomNavigationBarItem( 
              icon: getTabIcon(3), 
              title: Text("我的"), 
            ), 
          ], 
          currentIndex: _tabIndex,
          onTap: (index) {
            onTabChange(index);
          },
          activeColor: Theme.of(context).primaryColor, 
          inactiveColor: Colors.grey, 
          backgroundColor: Theme.of(context).cardColor, iconSize: 25.0, ), 
          tabBuilder: (context, index) { 
            return Scaffold(
              body: Container(
                height: double.infinity,
                color: Colors.white,
                child: CupertinoTabView( 
                  builder: (context) { 
                    switch (index) { 
                      case 0: 
                        return HomepageScreen(callback: (val) => onTabChange(val));
                        break; 
                      case 1: 
                        return MarketInfoScreen(); 
                        break; 
                      case 2: 
                        return ChoiceScreen(); 
                        break; 
                      case 3: 
                        return MyPage(); 
                        break; 
                      default:
                        return MarketInfoScreen();
                    } 
                  }, 
                )
              ),
            );
          } 
        );
  }
}
