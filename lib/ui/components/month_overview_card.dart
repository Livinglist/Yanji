import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jiba/models/journal.dart';
import 'package:jiba/ui/journal_edit_page.dart';

import 'shining_dot.dart';

typedef void JournalPressedCallBack(Journal journal);

enum JournalForm { photoOnly, contentOnly, mixed }

class MonthOverviewCard extends StatelessWidget {
  final List<Journal> journals;
  final int year;
  final int maxLength;
  final int minLength;
  final JournalPressedCallBack onJournalPressed;
  Color fontColor;

  MonthOverviewCard({this.journals, this.year, this.onJournalPressed})
      : maxLength = _findMaxLength(journals),
        minLength = _findMinLength(journals);

  @override
  Widget build(BuildContext context) {
    fontColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: (MediaQuery.of(context).size.width / 7) * 80 * (this.year == DateTime.now().year ? DateTime.now().month / 12 : 1),
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12))),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 7,
        children: _buildChildren(context),
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    List<Widget> children = <Widget>[];
    var date = DateTime(year, 1, 1);

    Widget journalCircle;

    for (var _ in Iterable.generate(3)) {
      children.add(Container());
    }

    children.add(Container(
        child: Center(
      child: Text(_intToMonth(date.month), style: TextStyle(color: fontColor)),
    )));

    for (var _ in Iterable.generate(3)) {
      children.add(Container());
    }

    for (var _ in Iterable.generate(date.weekday)) {
      children.add(Container());
    }

    Journal tempJournal = _findJournal(date.month, date.day);

    if (tempJournal == null) {
      children.add(Container(
        child: Center(
          child: Text(date.day.toString(), style: TextStyle(color: fontColor)),
        ),
      ));
    } else {
      journalCircle = _buildJournalCircle(tempJournal: tempJournal);
      children.add(journalCircle);
    }

    ///S,M,T,W,T,F,S
    ///0,1,2,3,4,5,6
    while (date.isBefore(DateTime.now())) {
      date = date.add(Duration(days: 1));

      tempJournal = _findJournal(date.month, date.day);

      //If date is the beginning of the month
      if (date.day == 1) {
        var yesterdaysWeekday = date.subtract(Duration(days: 1)).weekday;
        yesterdaysWeekday = yesterdaysWeekday == 7 ? 1 : yesterdaysWeekday + 1;
        var todayWeekday = date.weekday == 7 ? 1 : date.weekday + 1;

        for (var _ in Iterable.generate(7 - yesterdaysWeekday)) {
          children.add(Container());
        }

        for (var _ in Iterable.generate(3)) {
          children.add(Container());
        }

        children.add(Container(
            child: Center(
          child: Text(_intToMonth(date.month), style: TextStyle(color: fontColor)),
        )));

        for (var _ in Iterable.generate(3)) {
          children.add(Container());
        }

        for (var _ in Iterable.generate(todayWeekday - 1)) {
          children.add(Container());
        }

        if (tempJournal == null) {
          children.add(Container(
            child: Center(child: Text(date.day.toString(), style: TextStyle(color: fontColor))),
          ));

          continue;
        }

        journalCircle = _buildJournalCircle(tempJournal: tempJournal);

        children.add(journalCircle);
      } else {
        if (tempJournal == null) {
          children.add(Container(
            child: Center(child: Text(date.day.toString(), style: TextStyle(color: fontColor))),
          ));

          continue;
        } else {
          journalCircle = _buildJournalCircle(tempJournal: tempJournal);

          children.add(journalCircle);
        }
      }
    }

    return children;
  }

  Widget _buildJournalCircle({Journal tempJournal}) {
    Widget journalCircle;
    JournalForm form = _determineJournalForm(tempJournal);
    double scale = _getScale(tempJournal);
    switch (form) {
      case JournalForm.contentOnly:
        journalCircle = Transform.scale(
          scale: scale,
          child: Container(
            child: Center(child: Text(tempJournal.createdDate.day.toString())),
            decoration:
                BoxDecoration(color: Colors.cyan, shape: BoxShape.circle, border: Border.all(color: Colors.transparent, width: 0.3)),
          ),
        );
        break;
      case JournalForm.photoOnly:
        journalCircle = Transform.scale(
          scale: scale,
          //scale: 0.7,
          child: Container(
            child: Center(child: Text(tempJournal.createdDate.day.toString())),
            decoration:
                BoxDecoration(color: Colors.orange, shape: BoxShape.circle, border: Border.all(color: Colors.transparent, width: 0.3)),
          ),
        );
        break;
      case JournalForm.mixed:
        journalCircle = Stack(
          children: <Widget>[
            Transform.scale(
              scale: scale,
              //scale: 0.7,
              child: Container(
                decoration:
                    BoxDecoration(color: Colors.cyan, shape: BoxShape.circle, border: Border.all(color: Colors.transparent, width: 0.3)),
              ),
            ),
            Transform.scale(
              scale: _getScale(tempJournal) * 0.6,
              //scale: 0.7,
              child: Container(
                decoration:
                    BoxDecoration(color: Colors.orange, shape: BoxShape.circle, border: Border.all(color: Colors.transparent, width: 0.3)),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(tempJournal.createdDate.day.toString()),
            )
          ],
        );
        break;
      default:
        Container();
    }

    return GestureDetector(onTap: () => this.onJournalPressed(tempJournal), child: journalCircle);
  }

  @Deprecated("")
  List<Widget> _buildMonthRow(BuildContext context) {
    List<Widget> widgets = List<Widget>();

    widgets.addAll(_buildDayRows(context));

    return widgets;
  }

  @Deprecated("")
  List<Widget> _buildDayRows(BuildContext context) {
    List<Widget> widgets = List<Widget>();

    final today = DateTime.now();

    bool alreadyHasToday = false;

    for (int i = 1; i <= 31; i++) {
      widgets.add(Center(child: Text(i.toString())));
      for (int j = 1; j <= 12; j++) {
        Journal tempJournal = _findJournal(j, i);

        if (tempJournal != null) {
          JournalForm form = _determineJournalForm(tempJournal);
          Widget journalCircle;
          double scale = _getScale(tempJournal);

          if (alreadyHasToday == false && tempJournal.createdDate.isTheSameDay(today)) {
            alreadyHasToday = true;
            journalCircle = Transform.scale(scale: scale, child: ShiningDot(onTapped: () => onJournalPressed(tempJournal)));
          } else {
            switch (form) {
              case JournalForm.contentOnly:
                journalCircle = Transform.scale(
                  scale: scale,
                  child: Container(
                    child: GestureDetector(onTap: () => this.onJournalPressed(tempJournal)),
                    decoration: BoxDecoration(
                        color: Colors.cyan, shape: BoxShape.circle, border: Border.all(color: Colors.transparent, width: 0.3)),
                  ),
                );
                break;
              case JournalForm.photoOnly:
                journalCircle = Transform.scale(
                  scale: scale,
                  //scale: 0.7,
                  child: Container(
                    child: GestureDetector(onTap: () => this.onJournalPressed(tempJournal)),
                    decoration: BoxDecoration(
                        color: Colors.orange, shape: BoxShape.circle, border: Border.all(color: Colors.transparent, width: 0.3)),
                  ),
                );
                break;
              case JournalForm.mixed:
                journalCircle = GestureDetector(
                  onTap: () => this.onJournalPressed(tempJournal),
                  child: Stack(
                    children: <Widget>[
                      Transform.scale(
                        scale: scale,
                        //scale: 0.7,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.cyan, shape: BoxShape.circle, border: Border.all(color: Colors.transparent, width: 0.3)),
                        ),
                      ),
                      Transform.scale(
                        scale: _getScale(tempJournal) * 0.6,
                        //scale: 0.7,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.orange, shape: BoxShape.circle, border: Border.all(color: Colors.transparent, width: 0.3)),
                        ),
                      ),
                    ],
                  ),
                );
                break;
              default:
                Container();
            }
          }
          widgets.add(journalCircle);
        } else if (this.year == today.year && j == today.month && i == today.day) {
          widgets.add(Transform.scale(
              scale: 1,
              child: ShiningDot(onTapped: () {
                Navigator.push(context, CupertinoPageRoute(builder: (_) => JournalEditPage(hasUncompletedContent: false)));
              })));
        } else {
          widgets.add(Container());
        }
      }
    }
    return widgets;
  }

  double _getScale(Journal journal) {
    double ratio;

    if (maxLength == minLength) {
      print("hi there this is for getting equal");
      ratio = 1;
    } else
      ratio = journal.content.length / maxLength;

    print(
        "\n=======================\nThe max is $maxLength\nThe min is $minLength\nThe content length is ${journal.content.length}\nThe scale is ${0.4 + ratio * (1 - 0.4)}\n=======================");

    return 0.4 + ratio * (1 - 0.4);
  }

  ///Find whether or not there is a journal on the given month and day.
  Journal _findJournal(int month, int day) {
    var journal = journals.firstWhere((j) => j.createdDate.month == month && j.createdDate.day == day, orElse: () => null);

    return journal;
  }

  static String _intToMonth(int i) {
    switch (i) {
      case 1:
        return '一月';
      case 2:
        return '二月';
      case 3:
        return '三月';
      case 4:
        return '四月';
      case 5:
        return '五月';
      case 6:
        return '六月';
      case 7:
        return '七月';
      case 8:
        return '八月';
      case 9:
        return '九月';
      case 10:
        return '十月';
      case 11:
        return '十一月';
      case 12:
        return '十二月';
      default:
        throw Exception('Inside _intToMonth()');
    }
  }

  ///Find the length of the longest Journal.
  static int _findMaxLength(List<Journal> journals) {
    if (journals.isNotEmpty) {
      int max = journals.first.content.length;

      for (var j in journals) {
        if (j.content.length > max) max = j.content.length;
      }

      print(max);
      return max;
    }

    return 0;
  }

  ///Find the length of the shortest Journal.
  static int _findMinLength(List<Journal> journals) {
    if (journals.isNotEmpty) {
      int min = journals.first.content.length;

      for (var j in journals) {
        if (j.content.length < min) min = j.content.length;
      }

      print(min);
      return min;
    }

    return 0;
  }

  static JournalForm _determineJournalForm(Journal journal) {
    if (journal.hasImage) {
      if (journal.content.isEmpty)
        return JournalForm.photoOnly;
      else
        return JournalForm.mixed;
    } else
      return JournalForm.contentOnly;
  }
}

//class TriangleClipper extends CustomClipper<Path> {
//  @override
//  Path getClip(Size size) {
//    final path = Path();
//    path.lineTo(size.width, 0.0);
//    path.lineTo(size.width / 2, size.height);
//    path.close();
//    return path;
//  }
//
//  @override
//  bool shouldReclip(TriangleClipper oldClipper) => false;
//}
