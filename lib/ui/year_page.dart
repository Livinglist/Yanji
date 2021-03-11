import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:jiba/bloc/journal_bloc.dart';
import 'year_detail_page.dart';

class YearPage extends StatefulWidget {
  final List<Journal> journals;

  YearPage({@required this.journals});

  @override
  _YearPageState createState() => _YearPageState(journals: journals);
}

class _YearPageState extends State<YearPage> {
  final ScrollController scrollController = ScrollController();
  final List<Journal> journals;

  double elevation = 0;

  _YearPageState({this.journals});

  @override
  void initState() {
    super.initState();

    scrollController.addListener(onPageScrolled);
  }

  @override
  Widget build(BuildContext context) {
    Color fontColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: fontColor),
        elevation: elevation,
        title: Text(
          '歷年',
          style: TextStyle(color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: compute(convertToYearMap, journals),
        builder: (_, AsyncSnapshot<Map<int, List<Journal>>> snapshot) {
          if (snapshot.hasData) {
            var yearTojournals = snapshot.data;
            var years = yearTojournals.keys.toList()..sort((a, b) => a.compareTo(b));
            if (yearTojournals.isEmpty) {
              return Center(
                child: Text('空'),
              );
            } else {
              print("has data");
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(children: [
                  for (var year in years)
                    ListTile(
                      title: Text(
                        convertToYearString(year),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black),
                      ),
                      trailing: Text(
                        yearTojournals[year].length.toString() + ' 篇',
                        style: TextStyle(fontWeight: FontWeight.bold, color: fontColor),
                      ),
                      onTap: () => Navigator.of(context).push(
                          CupertinoPageRoute(builder: (_) => YearDetailPage(journals: yearTojournals[year], yearString: convertToYearString(year)))),
                    ),
                  SizedBox(height: 24)
                ]),
              );
            }
          } else {
            return Container(
              child: Text(''),
            );
          }
        },
      ),
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

  String convertToYearString(int year) {
    String yearStr = year.toString();
    String str = '';

    for (var i in Iterable.generate(4)) {
      str += numToChineseString(yearStr[i]);
    }

    return str;
  }

  String numToChineseString(String num) {
    switch (num) {
      case '1':
        return '一';
      case '2':
        return '二';
      case '3':
        return '三';
      case '4':
        return '四';
      case '5':
        return '五';
      case '6':
        return '六';
      case '7':
        return '七';
      case '8':
        return '八';
      case '9':
        return '九';
      case '0':
        return '零';
      default:
        throw Exception("Unmatched month");
    }
  }
}

Map<int, List<Journal>> convertToYearMap(List<Journal> journals) {
  var map = Map<int, List<Journal>>();
  for (var journal in journals) {
    var year = journal.createdDate.year;
    if (map.containsKey(year) == false) {
      map[year] = [];
    }
    map[year].add(journal);
  }

  return map;
}
