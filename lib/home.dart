import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:futures/article/article.dart';
import 'package:futures/market/market.dart';
import 'package:futures/dashboard/dashboard.dart';
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
          getTabImage('images/b_1_g.png'),
          getTabImage('images/b_1.png')
        ],
        [
          getTabImage('images/b_2_g.png'),
          getTabImage('images/b_2.png')
        ],
        [
          getTabImage('images/b_3_g.png'),
          getTabImage('images/b_3.png')
        ],
        [
          getTabImage('images/b_4_g.png'),
          getTabImage('images/b_4.png')
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
                        return DashboardScreen(callback: (val) => onTabChange(val));
                        break; 
                      case 1: 
                        return MarketScreen(); 
                        break; 
                      case 2: 
                        return ArticleScreen(); 
                        break; 
                      case 3: 
                        return MyPage(); 
                        break; 
                      default:
                        return MarketScreen();
                    } 
                  }, 
                )
              ),
            );
          } 
        );
  }
}
