import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jiba/ui/components/spring_curve.dart';
import 'components/month_overview_card.dart';
import 'package:jiba/models/journal.dart';
import 'components/journal_overview_card.dart';
import 'package:jiba/resources/string_values.dart';
import 'package:jiba/helpers/list_helpers.dart';
import 'package:jiba/bloc/journal_bloc.dart';

class OverviewPage extends StatefulWidget {
  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  final ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  String displayString;
  Color fontColor;

  ///The [elevation] value for the [AppBar] on [secondaryPage]
  double elevation = 0;

  @override
  void initState() {
    displayString = randomStrings.getRandom();
    super.initState();

    Timer(Duration(milliseconds: 800), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(scrollController.position.maxScrollExtent * 0.5,
            duration: Duration(milliseconds: 700), curve: SpringCurve.overDamped);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = MediaQuery
        .of(context)
        .platformBrightness == Brightness.dark ? Colors.black : Colors.white;
    fontColor = MediaQuery
        .of(context)
        .platformBrightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: backgroundColor,
          elevation: elevation,
          centerTitle: true,
          title: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: 24,
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                ...['日', '壹', '贰', '叁', '肆', '伍', '陆']
                    .map((e) =>
                    Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 7,
                        child: Center(
                          child: Text(
                            e,
                            style: TextStyle(
                              fontSize: 14,
                              color: fontColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )))
                    .toList()
              ],
            ),
          ),
        ),
        body: StreamBuilder(
          stream: journalBloc.allJournals,
          builder: (_, AsyncSnapshot<List<Journal>> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return FutureBuilder(
                future: computeJournalsByYear(streamSnapshot.data),
                builder: (_, AsyncSnapshot<Map<int, List<Journal>>> futureSnapshot) {
                  if (futureSnapshot.hasData) {
                    print(futureSnapshot.data);
                    return ListView(
                      controller: scrollController,
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        ...buildChildren(futureSnapshot.data, context),
                        SizedBox(
                          height: 24,
                          child: Center(
                            child: Text(
                              displayString,
                              style: TextStyle(color: fontColor, fontWeight: FontWeight.normal),
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    print("No future.");
                    return Container();
                  }
                },
              );
            } else {
              return Container();
            }
          },
        ));
  }

  Future<Map<int, List<Journal>>> computeJournalsByYear(List<Journal> allJournals) async {
    Map<int, List<Journal>> map = Map<int, List<Journal>>();

    return Future.forEach<Journal>(allJournals, (journal) {
      if (map.containsKey(journal.createdDate.year) == false) {
        map[journal.createdDate.year] = <Journal>[];
      }

      map[journal.createdDate.year].add(journal);
    }).then((_) => map);
  }

  List<Widget> buildChildren(Map<int, List<Journal>> allJournalsByYear, BuildContext context) {
    List<Widget> children = <Widget>[];

    if (allJournalsByYear.isEmpty) {
      children.add(SizedBox(
        height: 24,
        child: Center(
          child: Text(
            "${DateTime
                .now()
                .year}",
            style: TextStyle(color: fontColor, fontSize: 18),
          ),
        ),
      ));
      children.add(MonthOverviewCard(
        journals: <Journal>[],
        year: DateTime
            .now()
            .year,
        onJournalPressed: (Journal journal) {
          if (journal != null) {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (_) {
                  return Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: FractionallySizedBox(
                          heightFactor: 0.8, widthFactor: 1, child: JournalOverviewCard(journal: journal, lengthRestricted: false)));
                });
          }
        },
      ));
    }

    var yearNow = DateTime.now().year;
    var years = allJournalsByYear.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    var firstYear = years.isEmpty ? yearNow : years.first;
    years = List.generate(yearNow - firstYear + 1, (index) => firstYear + index);

    for (int year in years) {
      print("The year is ${year}");
      children.add(SizedBox(
        height: 24,
        child: Center(
          child: Text(
            year.toString(),
            style: TextStyle(color: fontColor, fontSize: 18),
          ),
        ),
      ));
      children.add(MonthOverviewCard(
        journals: allJournalsByYear[year] ?? [],
        year: year,
        onJournalPressed: (Journal journal) {
          if (journal != null) {
            showModalBottomSheet(
                context: context,
                builder: (_) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Container(
                      color: Colors.transparent,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: JournalOverviewCard(journal: journal, lengthRestricted: false),
                    ),
                  );
                });
          }
        },
      ));
    }

    return children;
  }
}
