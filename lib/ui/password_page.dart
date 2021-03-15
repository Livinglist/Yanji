import 'package:flutter/material.dart';
import 'package:jiba/ui/main_page.dart';
import 'package:pinput/pin_put/pin_put.dart';

class PasswordPage extends StatefulWidget {
  final String password;

  PasswordPage({@required this.password});

  @override
  PasswordPageState createState() => PasswordPageState();
}

class PasswordPageState extends State<PasswordPage> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  Color backgroundColor, foregroundColor;

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

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(child: Text('言 己', style: TextStyle(fontFamily: 'noto', fontSize: 28,color: foregroundColor))),
              Container(
                color: backgroundColor,
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(20.0),
                child: PinPut(
                  textStyle: TextStyle(color: foregroundColor),
                  fieldsCount: 4,
                  onSubmit: (String pin){
                    if(pin == widget.password) {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => MainPage()));
                    }else{
                      _pinPutController.text = '';
                      _showWrongPasswordSnackBar(pin, context);
                    }
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
                    child: Text('清空', style: TextStyle(fontFamily: 'noto', color: backgroundColor),),
                    style: OutlinedButton.styleFrom(
                        backgroundColor: foregroundColor,
                        shadowColor: foregroundColor
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWrongPasswordSnackBar(String pin, BuildContext context) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(
        '输入错误。',
        style: const TextStyle(fontFamily: 'noto'),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
