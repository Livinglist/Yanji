import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jiba/bloc/journal_bloc.dart';
import 'package:jiba/resources/shared_prefs_provider.dart';
import 'package:jiba/ui/components/journal_overview_card.dart';
import 'journal_edit_page.dart';
import 'overview_page.dart';
import 'stat_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  AnimationController controller;
  Tween<Offset> offsetTween = Tween(begin: Offset.zero, end: Offset(150, 150));
  PageController pageController = PageController();

  bool isShy = false;
  bool isHidden = false;
  bool isTryingToHide = false;

  bool isFirstTimeUser = false;

  ///Weather or not user has a journal that has not been saved.
  bool hasIncompleteJournal = false;
  Journal tempJournal;

  int nextId;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    scrollController.addListener(onScrolled);

    pageController.addListener(onPageScrolled);

    journalBloc.fetchAllJournals().whenComplete(() {
      journalBloc.getNextId().then((value) {
        this.nextId = value;
      });
    }).whenComplete(() {
      checkIsFirstTimeUser().then((bool val) {
        if (val) {
          var tempJournal = Journal(
              id: 1,
              content: 'Welcome to Journalyst! This is your first journal.',
              createdDate: DateTime.now(),
              fontFamily: noto,
              isBookmarked: false,
              weatherCode: null,
              longitude: null,
              latitude: null,
              location: null);

          journalBloc.addJournal(tempJournal);
        }
      });
    });
  }

  Future<bool> checkIsFirstTimeUser() async => await sharedPrefsProvider.getIsInitialStart();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Color.fromRGBO(232, 216, 189, 1),
        backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white,
        //floatingActionButton: fab,
        body: StreamBuilder(
          stream: journalBloc.allJournals,
          builder: (_, AsyncSnapshot<List<Journal>> snapshot) {
            if (snapshot.hasData) {
              var journals = snapshot.data;
              return PageView(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  StreamBuilder(
                    stream: journalBloc.incompleteJournal,
                    builder: (_, AsyncSnapshot<Journal> journalSnapshot) {
                      if (journalSnapshot.hasData) {
                        this.hasIncompleteJournal = true;
                        this.tempJournal = journalSnapshot.data;
                      } else {
                        this.hasIncompleteJournal = false;
                      }

                      return buildMainView(journals);
                    },
                  ),
                  StatPage(),
                  OverviewPage()
                ],
              );
            } else {
              return Container();
            }
          },
        ));
  }

  Widget buildMainView(List<Journal> journals) {
//    if (journals.isNotEmpty) {
//      print("the id of first journal is${journals.first.id}");
//      this.hasIncompleteJournal = journals.first.createdDate.isTheSameDay(DateTime.now());
//      this.tempJournal = hasIncompleteJournal ? journals.first : null;
//    }

    Widget fab = AnimatedBuilder(
      animation: controller,
      child: Transform.scale(
          scale: 3,
          child: FloatingActionButton(
            elevation: 8,
            child: Icon(hasIncompleteJournal ? Icons.edit : Icons.add),
            onPressed: onFabPressed,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
          )),
      builder: (context, child) {
        return Transform.translate(offset: controller.drive(offsetTween).value, child: child);
      },
    );
    return Stack(
      children: <Widget>[
        ListView(
          controller: scrollController,
          children: [
            SizedBox(
              height: 24,
            ),
            if (journals.isNotEmpty) ...buildChildren(journals),
            if (journals.isEmpty)
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text('No journals found', style: TextStyle(color: Colors.grey)),
                ),
              ),
            SizedBox(
              height: 12,
            )
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Transform.translate(
            offset: Offset(-12, -12),
            child: fab,
          ),
        )
      ],
    );
  }

  List<Widget> buildChildren(List<Journal> journals) {
    //var list = journals.map((e) => JournalOverviewCard(journal: e)).toList();
    DateTime now = DateTime.now();
    List<Journal> journalsInTheSameWeek = [];

    if (journals.isEmpty) return [];

    if (journals.first.createdDate.isInSameWeek(now)) {
      for (var j in journals) {
        if (j.createdDate.isInSameWeek(now)) {
          journalsInTheSameWeek.add(j);
        } else {
          break;
        }
      }
    }

    List<Widget> list = [
      if (journalsInTheSameWeek.isNotEmpty) SectionHeader(headerText: '本周'),
      ...journalsInTheSameWeek.map((j) => JournalOverviewCard(journal: j)).toList()
    ];

    int journalsInTheSameYearCount = 0;
    int lastMonth = 0;
    int currentMonth;
    for (int i = journalsInTheSameWeek.length; i < journals.length; i++) {
      var j = journals[i];

      if (j.createdDate.year != now.year) break;

      currentMonth = j.createdDate.month;

      if (currentMonth != lastMonth) {
        list.add(SectionHeader(headerText: j.createdDate.monthString));
      }

      list.add(JournalOverviewCard(journal: j));

      journalsInTheSameYearCount++;

      lastMonth = currentMonth;
    }

    int lastYear = 0;
    int currentYear;
    for (int i = journalsInTheSameYearCount + journalsInTheSameWeek.length; i < journals.length; i++) {
      var j = journals[i];

      currentYear = j.createdDate.year;

      if (currentYear != lastYear) {
        list.add(SectionHeader(
          headerText: j.createdDate.yearString,
        ));
      }

      list.add(JournalOverviewCard(journal: j));

      lastYear = currentYear;
    }

    return list;
  }

  void onFabPressed() => navigateToJournalEditPage();

  void navigateToJournalEditPage() {
    print("hasIncompleteJournal: $hasIncompleteJournal");
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => JournalEditPage(
              hasUncompletedContent: hasIncompleteJournal,
              nextId: nextId,
              tempJournal: hasIncompleteJournal ? tempJournal : null,
            )));
  }

  ///Called when [ListView] is being interacted with.
  void onScrolled() {
    if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      isShy = true;
      controller.animateTo(0.5);
      //controller.forward();
    } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
      isShy = false;
      controller.animateBack(0);
    }
  }

  ///Called when [PageView] is being interacted with.
  void onPageScrolled() {
    //If the user is scrolling to the secondary page, hide the floating button
    if (pageController.position.userScrollDirection == ScrollDirection.reverse) {
      isTryingToHide = true;
      controller.animateTo(1.5);
    } else if (pageController.position.userScrollDirection == ScrollDirection.forward) {
      isTryingToHide = false;
      if (isShy) {
        controller.animateBack(0.5);
      } else {
        controller.animateBack(0);
      }
    }
  }
}

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
          style: TextStyle(
              color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
              fontSize: 64,
              fontWeight: FontWeight.w900,
              fontFamily: 'noto'),
        ),
      ),
    );
  }
}
