import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:jiba/models/journal.dart';
import 'package:jiba/ui/journal_detail_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:transparent_image/transparent_image.dart';

class JournalOverviewCard extends StatefulWidget {
  final Journal journal;
  final bool lengthRestricted;

  JournalOverviewCard({this.journal, this.lengthRestricted = true});

  @override
  State<StatefulWidget> createState() => _JournalOverviewCardState();
}

class _JournalOverviewCardState extends State<JournalOverviewCard> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Tween<double> tween = Tween(begin: 1, end: 0.95);
  double scale = 1;
  int maxLines = 3;

  double imageOpacity = 0.0;

  Uint8List imageBytes;

  bool initialized = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    tween.animate(controller);

    maxLines = widget.lengthRestricted ? 3 : 8;

    //if (widget.journal.hasImage) initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainPart;

    if (widget.journal.hasImage == false) {
      mainPart = Padding(
          padding: EdgeInsets.all(12),
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.journal.content ?? '',
                  maxLines: maxLines,
                  style: TextStyle(
                      fontSize: widget.journal.fontFamily == noto ? 18 : 24,
                      fontFamily: widget.journal.fontFamily,
                      fontWeight: FontWeight.normal),
                  textAlign: widget.journal.textAlign,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              if (widget.lengthRestricted) Container() else Spacer(),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          '',
                          style: TextStyle(color: Colors.black54, fontSize: 14, fontStyle: FontStyle.italic, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          widget.journal.createdDate.toDisplayString() ?? '11.03.1998',
                          style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ));
    } else {
      if (widget.journal.content == null || widget.journal.content.isEmpty) {
        mainPart = Container(
          width: MediaQuery.of(context).size.width,
          height: 240,
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 240,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: FadeInImage(
                            placeholder: Image.memory(
                              kTransparentImage,
                              fit: BoxFit.cover,
                            ).image,
                            image: Image.memory(
                              widget.journal.imageBytes,
                              fit: BoxFit.cover,
                            ).image,
                            fit: BoxFit.cover,
                          )))),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 240,
                  width: MediaQuery.of(context).size.width,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 12, bottom: 12),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            '',
                            style: TextStyle(color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 12, bottom: 12),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            widget.journal.createdDate.toDisplayString() ?? '11.03.1998',
                            style: TextStyle(color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic, fontWeight: FontWeight.normal),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        mainPart = Container(
          width: MediaQuery.of(context).size.width,
          height: 240,
          child: Stack(
            //direction: Axis.vertical,
            children: <Widget>[
              Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 240,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: FadeInImage(
                            placeholder: Image.memory(
                              kTransparentImage,
                              fit: BoxFit.cover,
                            ).image,
                            image: Image.memory(
                              widget.journal.imageBytes,
                              fit: BoxFit.cover,
                            ).image,
                            fit: BoxFit.cover,
                          )))),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 240,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), color: Colors.white.withOpacity(0.6)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12, top: 12, right: 8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.journal.content,
                    maxLines: 4,
                    style: TextStyle(
                        fontSize: widget.journal.fontFamily == noto ? 18 : 24,
                        fontFamily: widget.journal.fontFamily,
                        fontWeight: FontWeight.normal),
                    textAlign: widget.journal.textAlign,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 12, bottom: 12),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "",
                          style: TextStyle(color: Colors.black54, fontSize: 14, fontStyle: FontStyle.italic, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 12, bottom: 12),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          widget.journal.createdDate.toDisplayString() ?? '11.03.1998',
                          style: TextStyle(color: Colors.black54, fontSize: 14, fontStyle: FontStyle.italic, fontWeight: FontWeight.normal),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              )
            ],
          ),
        );
      }
    }
    return Padding(
        padding: EdgeInsets.all(12),
        child: GestureDetector(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onTap: onTap,
          onTapCancel: onTapCancel,
          child: AnimatedBuilder(
            animation: CurvedAnimation(parent: controller, curve: Curves.decelerate),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                  child: Hero(
                tag: widget.journal.id ?? widget.journal.createdDate.toString(),
                child: Material(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: mainPart,
                ),
              )),
            ),
            builder: (context, child) {
              return Transform.scale(scale: tween.evaluate(controller), child: child);
            },
          ),
        ));
  }

  void onTapDown(TapDownDetails details) {
    controller.forward();
  }

  void onTapUp(TapUpDetails details) {
    controller.reverse();
  }

  void onTapCancel() {
    controller.reverse();
  }

  void onTap() {
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (_) => JournalDetailPage(
              journal: widget.journal,
            )));
  }

  Future<List<int>> getPic() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File f = File('${appDocDir.path}/${widget.journal.id}.png');
    return f.readAsBytes();
  }
}
