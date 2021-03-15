import 'package:flutter/material.dart';
import 'package:jiba/resources/shared_prefs_provider.dart';
import 'package:jiba/ui/password_setting_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Color backgroundColor, foregroundColor;

  @override
  Widget build(BuildContext context) {
    backgroundColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white;
    foregroundColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: foregroundColor),
        elevation: 0,
        title: Text(
          '設置',
          style: TextStyle(color: foregroundColor),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(future: SharedPreferencesProvider.getPassword(),
          builder: (_, snapshot){
            return SwitchListTile(title: Text('密碼'),value: snapshot.data != null, onChanged: (val){
              if(val){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>PasswordSettingPage()));
              }else{
                SharedPreferencesProvider.setPassword(null);

                setState(() {

                });
              }
            });
          },)
        ],
      ),
    );
  }
}
