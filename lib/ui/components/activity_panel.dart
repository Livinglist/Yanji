import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:jiba/models/journal.dart';
import 'package:jiba/ui/journal_detail_page.dart';

class ActivityPanel extends StatelessWidget {
  final List<Journal> journals;
  static Map<DateTime, List<Journal>> data;
  final scrollController = ScrollController();

  ActivityPanel({@required this.journals});

  @override
  Widget build(BuildContext context) {
    return buildView(context);
  }

  Widget buildView(BuildContext context) {
    Color backgroundColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white;
    Color foregroundColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;

    double width = MediaQuery.of(context).size.width / 40;
    convertTimeStampsToDateTimeMap(journals);
    return FutureBuilder(
      future: compute(convertTimeStampsToDateTimeMap, journals),
      builder: (_, snapshot) {
        var map = snapshot.data;

        if (snapshot.hasData) {
          return Material(
              color: backgroundColor,
              child: InkWell(
                child: Container(
                  height: (MediaQuery.of(context).size.width / 12) * 5,
                  color: Colors.transparent,
                  child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      controller: scrollController,
                      padding: EdgeInsets.all(2),
                      childAspectRatio: 1,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      scrollDirection: Axis.horizontal,
                      crossAxisCount: 5,
                      children: Iterable.generate(60, (index) {
                        var d = DateTime.now().subtract(Duration(days: 59 - index));
                        var date = DateTime(d.year, d.month, d.day);
                        if (map.containsKey(date)) {
                          return OpenContainer(
                            closedBuilder: (_, __) {
                              return Material(
                                  elevation: 2,
                                  child: Container(
                                    height: width - 2,
                                    width: width - 2,
                                    color: foregroundColor,
                                  ),);
                            },
                            openBuilder: (_, __) {
                              return JournalDetailPage(journal: map[date]);
                            },
                          );
                        } else {
                          return Material(
                            elevation: 1,
                            color: Colors.transparent,
                            child: Container(
                              height: width - 2,
                              width: width - 2,
                              decoration: BoxDecoration(color: backgroundColor, border: Border.all(color: foregroundColor)),
                            ),
                          );
                        }
                      }).toList()),
                ),
              ));
        }

        return Material(
            color: backgroundColor,
            child: InkWell(
              child: Container(
                height: (MediaQuery.of(context).size.width / 12) * 5,
                color: Colors.transparent,
                child: GridView.count(
                    controller: scrollController,
                    padding: EdgeInsets.all(2),
                    childAspectRatio: 1,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: 5,
                    children: Iterable.generate(60, (index) {
                      return Material(
                        elevation: 1,
                        color: Colors.transparent,
                        child: Container(
                          height: width - 2,
                          width: width - 2,
                          decoration: BoxDecoration(color: backgroundColor, border: Border.all(color: foregroundColor)),
                        ),
                      );
                    }).toList()),
              ),
            ));
      },
    );
  }
}

Map<DateTime, Journal> convertTimeStampsToDateTimeMap(List<Journal> journals) {
  var map = Map<DateTime, Journal>();
  for (var journal in journals) {
    var createdDate = journal.createdDate;
    var datetime = DateTime(createdDate.year, createdDate.month, createdDate.day);
    if (map.containsKey(datetime) == false) map[datetime] = journal;
  }
  return map;
}
