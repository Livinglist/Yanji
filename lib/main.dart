import 'package:flutter/material.dart';

import 'resources/shared_prefs_provider.dart';
import 'ui/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    sharedPrefsProvider.initSharedPrefs();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '记吧',
      darkTheme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
          fontFamily: 'noto',
          textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white), bodyText2: TextStyle(fontWeight: FontWeight.bold))),
      theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
          fontFamily: 'noto',
          textTheme: TextTheme(bodyText1: TextStyle(color: Colors.black), bodyText2: TextStyle(fontWeight: FontWeight.bold))),
      home: MainPage(),
      color: Colors.white,
    );
  }
}
