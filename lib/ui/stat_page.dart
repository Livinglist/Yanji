import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jiba/bloc/journal_bloc.dart';
import 'package:jiba/ui/components/journal_overview_card.dart';
import 'components/section_header.dart';
import 'bookmarks_page.dart';
import 'package:jiba/helpers/list_helpers.dart';

///This is the page that displays bookmarked journals and today in history.
class StatPage extends StatefulWidget {
  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  @override
  Widget build(BuildContext context) {
    Color fontColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
        backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white,
        body: StreamBuilder(
          stream: journalBloc.allJournals,
          builder: (_, AsyncSnapshot<List<Journal>> snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 48,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.collections_bookmark,
                        color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
                      title: Text(
                        '書籤',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black),
                      ),
                      trailing: Text(
                        snapshot.data.where((element) => element.isBookmarked).length.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold, color: fontColor),
                      ),
                      onTap: () => Navigator.of(context).push(CupertinoPageRoute(builder: (_) => BookmarksPage())),
                    ),
                    SectionHeader(
                      headerText: "过往今日",
                    ),
                    if (snapshot.data.isEmpty)
                      Container(
                        height: 220,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            '空',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ...buildChildren(snapshot.data)
                  ],
                ),
              );
            }
            return CircularProgressIndicator();
          },
        ));
  }

  List<Widget> buildChildren(List<Journal> journals) {
    return journals.reversed.map((e) => JournalOverviewCard(journal: e, lengthRestricted: true)).toList();
  }
}
