import 'package:flutter/material.dart';
import 'package:jiba/ui/password_page.dart';

import 'resources/shared_prefs_provider.dart';
import 'ui/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    sharedPrefsProvider.initSharedPrefs();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '言己',
      darkTheme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
          fontFamily: 'noto',
          textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white), bodyText2: TextStyle(fontWeight: FontWeight.bold))),
      theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
          fontFamily: 'noto',
          textTheme: TextTheme(bodyText1: TextStyle(color: Colors.black), bodyText2: TextStyle(fontWeight: FontWeight.bold))),
      home: FutureBuilder(
        future: SharedPreferencesProvider.getPassword(),
        builder: (_, snapshot){
          if(snapshot.data == null) return MainPage();
          else return PasswordPage(password: snapshot.data);
        },
      ),
      color: Colors.white,
    );
  }
}
