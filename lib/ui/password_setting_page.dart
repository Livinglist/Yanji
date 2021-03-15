import 'package:flutter/material.dart';
import 'package:jiba/resources/shared_prefs_provider.dart';
import 'package:jiba/ui/main_page.dart';
import 'package:pinput/pin_put/pin_put.dart';

class PasswordSettingPage extends StatefulWidget {
  PasswordSettingPage();

  @override
  PasswordSettingPageState createState() => PasswordSettingPageState();
}

class PasswordSettingPageState extends State<PasswordSettingPage> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  Color backgroundColor, foregroundColor;
  String tempPass, message = '請設置密碼';
  bool isFirstTime = true;

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: foregroundColor),
      borderRadius: BorderRadius.circular(4.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    backgroundColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white;
    foregroundColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;

    return WillPopScope(
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(child: Text(message, style: TextStyle(fontFamily: 'noto', fontSize: 28, color: foregroundColor))),
                  Container(
                    color: backgroundColor,
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(20.0),
                    child: PinPut(
                      textStyle: TextStyle(color: foregroundColor),
                      fieldsCount: 4,
                      onSubmit: (String pin) {
                        SharedPreferencesProvider.setPassword(pin);
                        Navigator.pop(context);
                      },
                      autofocus: true,
                      focusNode: _pinPutFocusNode,
                      controller: _pinPutController,
                      submittedFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      selectedFieldDecoration: _pinPutDecoration,
                      followingFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                          color: foregroundColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => _pinPutController.text = '',
                        child: Text(
                          '清空',
                          style: TextStyle(fontFamily: 'noto', color: backgroundColor),
                        ),
                        style: OutlinedButton.styleFrom(backgroundColor: foregroundColor, shadowColor: foregroundColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () => Future.value(false));
  }
}
