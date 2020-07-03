import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String headerText;

  SectionHeader({this.headerText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          headerText,
          style: TextStyle(color: Colors.black, fontSize: 64, fontWeight: FontWeight.w900, fontFamily: 'noto'),
        ),
      ),
    );
  }
}