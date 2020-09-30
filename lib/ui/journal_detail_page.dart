import 'dart:io';

import 'package:app_review/app_review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jiba/bloc/journal_bloc.dart';
import 'package:jiba/models/journal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'photo_view_page.dart';

class JournalDetailPage extends StatefulWidget {
  final Journal journal;

  JournalDetailPage({@required this.journal});

  @override
  State<StatefulWidget> createState() => JournalDetailPageState();
}

class JournalDetailPageState extends State<JournalDetailPage> with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  double elevation = 0;
  Color appBarColor = Colors.transparent;
  Color fontColor, subTextColor;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        appBarColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white;
      });
    });

    scrollController.addListener(onScrolled);

    AppReview.requestReview;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fontColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    subTextColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black54;

    return Hero(
      tag: widget.journal.id,
      child: Scaffold(
          backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white,
          appBar: PreferredSize(
              child: AppBar(
                backgroundColor: appBarColor,
                elevation: elevation,
                iconTheme: IconThemeData(color: fontColor),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(widget.journal.isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                    onPressed: onBookmarkPressed,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_forever),
                    onPressed: onDeletePressed,
                  )
                ],
                flexibleSpace: Padding(
                  padding: EdgeInsets.only(left: 24, right: 12, top: 96),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '',
                        style: TextStyle(color: subTextColor, fontSize: 14, fontStyle: FontStyle.italic, fontWeight: FontWeight.normal),
                      ),
                      Spacer(),
                      Container(
                        width: 40,
                        height: 40,
                        child: Image.asset('assets/weather_icons/${widget.journal.weatherCode ?? '01d'}.png'),
                      ),
                      Text(
                        widget.journal.createdDate.toDisplayString(),
                        style: TextStyle(color: subTextColor, fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
              preferredSize: Size.fromHeight(100)),
          body: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: <Widget>[
                SizedBox(width: MediaQuery.of(context).size.width),
                if (widget.journal.hasImage)
                  Center(
                      child: GestureDetector(
                    onTap: onPhotoTapped,
                    child: Container(
                      height: 200,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: FadeInImage(
                            fadeInDuration: Duration(milliseconds: 500),
                            placeholder: Image.memory(
                              kTransparentImage,
                              fit: BoxFit.cover,
                            ).image,
                            image: Image.memory(
                              widget.journal.imageBytes,
                              fit: BoxFit.cover,
                            ).image,
                            fit: BoxFit.cover,
                          )),
                    ),
                  )),
                Padding(
                    padding: EdgeInsets.only(left: 24, right: 24, bottom: 0, top: widget.journal.hasImage ? 12 : 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        widget.journal.content ?? '',
                        style: TextStyle(
                            fontSize: widget.journal.fontFamily == noto ? 18 : 24,
                            color: fontColor,
                            fontFamily: widget.journal.fontFamily,
                            fontWeight: FontWeight.normal),
                        textAlign: widget.journal.textAlign,
                      ),
                    ))
              ],
            ),
          )),
    );
  }

  void onBookmarkPressed() {
    setState(() {
      widget.journal.isBookmarked = !widget.journal.isBookmarked;
    });
    journalBloc.updateJournal(widget.journal);
  }

  void onDeletePressed() {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(
                '删除',
                style: TextStyle(fontFamily: noto, fontWeight: FontWeight.bold),
              ),
              content: Text('确定吗?'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    '是',
                    style: TextStyle(color: Colors.red, fontFamily: noto),
                  ),
                  onPressed: () {
                    journalBloc.removeJournal(widget.journal);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                    child: Text(
                      '否',
                      style: TextStyle(fontFamily: noto, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ));
  }

  void onScrolled() {
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

  void onPhotoTapped() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PhotoViewPage(
              heroTag: widget.journal.id.toString(),
              imageBytes: widget.journal.imageBytes,
            )));
  }

  Future<List<int>> getPic() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File f = File('${appDocDir.path}/${widget.journal.id}.png');
    return f.readAsBytes();
  }
}
