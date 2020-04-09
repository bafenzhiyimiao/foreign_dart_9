import 'dart:async';
import 'package:flutter/material.dart';
import 'package:futures/app.dart';
import 'package:flutter/services.dart';
import 'package:futures/i18n.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';





Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "深度期货投资",
      // theme: new ThemeData(
      //   primaryColor: Color.fromRGBO(22, 127, 255, 1),
      //   dividerColor: Colors.grey[100],
      //   backgroundColor: Color.fromRGBO(245,247,250,1),
      //   cardColor: Colors.white,
      //   highlightColor: Colors.transparent,
      //   splashColor: Colors.transparent,
      //   textTheme:  TextTheme(
      //       body1:TextStyle(
      //       fontFamily: "DIN",
      //       color: Colors.black87,
      //     )
      //   ),
      //   appBarTheme: AppBarTheme(
      //     brightness: Brightness.light,
      //     textTheme: TextTheme(
      //       title: TextStyle(
      //         color: Colors.black87,
      //         fontSize: 18
      //       )
      //     ),
      //   )
      // ),
      theme: new ThemeData(
        primaryColor: Color.fromRGBO(22, 127, 255, 1),
        backgroundColor: Color.fromRGBO(35, 35, 35, 1),
        cardColor: Color.fromRGBO(25, 25, 25, 1),
        dividerColor: Color.fromRGBO(55, 55, 55, 1),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        textTheme:  TextTheme(
            body1:TextStyle(
            fontFamily: "DIN",
            color: Color.fromRGBO(198, 198, 198, 1),
          )
        ),
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          textTheme: TextTheme(
            title: TextStyle(
              color: Color.fromRGBO(198, 198, 198, 1),
              fontSize: 18
            )
          ),
        )
      ),
      debugShowCheckedModeBanner: false,
      home: new App(),
      localizationsDelegates: [
        S.delegate,
        GlobalEasyRefreshLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: Locale('zh'),
    );
  }
}
