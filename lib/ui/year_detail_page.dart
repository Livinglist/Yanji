import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:jiba/bloc/journal_bloc.dart';
import 'components/journal_overview_card.dart';

class YearDetailPage extends StatefulWidget {
  final List<Journal> journals;
  final String yearString;

  YearDetailPage({@required this.journals, @required this.yearString});

  @override
  _YearDetailPageState createState() => _YearDetailPageState(journals: journals, yearString: yearString);
}

class _YearDetailPageState extends State<YearDetailPage> {
  final ScrollController scrollController = ScrollController();
  final List<Journal> journals;
  final String yearString;

  double elevation = 0;

  _YearDetailPageState({this.journals, this.yearString});

  @override
  void initState() {
    super.initState();

    scrollController.addListener(onPageScrolled);
  }

  @override
  Widget build(BuildContext context) {
    Color fontColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    journals.sort((a, b) => a.createdDate.compareTo(b.createdDate));
    return Scaffold(
        backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white,
          iconTheme: IconThemeData(color: fontColor),
          elevation: elevation,
          title: Text(
            yearString,
            style: TextStyle(color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[...journals.map((e) => JournalOverviewCard(journal: e, lengthRestricted: true)), SizedBox(height: 24)],
          ),
        )
    );
  }

  void onPageScrolled() {
    if (this.mounted) {
      if (scrollController.offset <= 0) {
        setState(() {
          elevation = 0;
        });
      } else {
        setState(() {
          elevation = 8;
        });
      }
    }
  }
}
