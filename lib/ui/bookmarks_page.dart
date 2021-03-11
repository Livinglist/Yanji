import 'package:flutter/material.dart';

import 'package:jiba/bloc/journal_bloc.dart';
import 'components/journal_overview_card.dart';

class BookmarksPage extends StatefulWidget {
  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final ScrollController scrollController = ScrollController();

  double elevation = 0;

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
        title: Text('書籤', style: TextStyle(color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black),),
      ),
      body: StreamBuilder(
        stream: journalBloc.allJournals,
        builder: (_, AsyncSnapshot<List<Journal>> snapshot) {
          if (snapshot.hasData) {
            var bookmarkedJournal = snapshot.data.where((e) => e.isBookmarked);
            if (bookmarkedJournal.isEmpty) {
              return Center(
                child: Text('空'),
              );
            } else {
              print("has data");
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(children: [
                  //SizedBox(height: 48),
                  ...bookmarkedJournal.map((e) => JournalOverviewCard(journal: e, lengthRestricted: true)).toList(),
                  SizedBox(height: 24)
                ]),
              );
            }
          } else {
            return Container(child: Text(''),);
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
}
