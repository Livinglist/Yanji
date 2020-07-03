import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jiba/bloc/journal_bloc.dart';
import 'package:jiba/helpers/network_helpers.dart';
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

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        appBarColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white;
      });
    });


    scrollController.addListener(onScrolled);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.journal.id,
      child: Scaffold(
          backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white,
          appBar: PreferredSize(
              child: AppBar(
                backgroundColor: appBarColor,
                elevation: elevation,
                iconTheme: IconThemeData(color: Colors.black),
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
                        style: TextStyle(color: Colors.black54, fontSize: 14, fontStyle: FontStyle.italic, fontWeight: FontWeight.normal),
                      ),
                      Spacer(),
                      Container(
                        width: 40,
                        height: 40,
                        child: Image.asset('assets/weather_icons/${widget.journal.weatherCode ?? '01d'}.png'),
                      ),
                      Text(
                        widget.journal.createdDate.toDisplayString(),
                        style: TextStyle(color: Colors.black54, fontSize: 14, fontStyle: FontStyle.italic, fontWeight: FontWeight.normal),
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
                        style: TextStyle(fontSize: 24, color: Colors.black, fontFamily: widget.journal.fontFamily, fontWeight: FontWeight.normal),
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
                'Delete this journal',
                style: TextStyle(fontFamily: 'SF Pro', fontWeight: FontWeight.bold),
              ),
              content: Text('Are you sure you want to permanently delete this journal?'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    journalBloc.removeJournal(widget.journal);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                    child: Text(
                      'No',
                      style: TextStyle(fontFamily: 'SF Pro', fontWeight: FontWeight.bold),
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
