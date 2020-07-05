import 'dart:ffi';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' show TextAlign;

import 'package:jiba/ui/components/journal_overview_card.dart';
import 'package:jiba/helpers/datetime_helpers.dart';

export 'package:jiba/helpers/datetime_helpers.dart';

const String noto = 'noto';
const String ma = 'ma';
const String liu = 'liu';
const String zhi = 'zhi';
const String long = 'long';

const Map<String, String> fontNames = {'noto': '笔记', 'ma': '飘逸', 'liu': '放纵', 'zhi': '随性', 'long': '得体'};

class Journal extends Comparable<Journal> {
  ///The id of the journal.
  int id;

  ///The content of the journal.
  String content;

  ///The date when this journal is created, in UTC. Once a journal is created, it cannot be edited.
  DateTime _createdDate;
  DateTime get createdDate => _createdDate.toLocal();
  set createdDate(DateTime dateTime) => _createdDate = dateTime.toUtc();

  ///The weather code
  String weatherCode;

  ///The location where this journal is created.
  String location;

  ///The font family of the journal.
  String fontFamily;

  ///The content to be displayed on [JournalOverviewCard].
  String get displayContent => content.length < 100 ? content.substring(0, 80) + '...' : content;

  ///The longitude and latitude of the location
  double longitude;
  double latitude;

  TextAlign textAlign;

  ///Whether or not the journal has an image attached.
  bool get hasImage => this.imageBytes == null ? false : true;

  ///Whether or not the journal is bookmarked
  bool isBookmarked;

  List<int> imageBytes;

  Journal(
      {this.id,
      this.content,
      DateTime createdDate,
      this.isBookmarked = false,
      this.imageBytes,
      this.fontFamily,
      this.weatherCode,
      this.longitude,
      this.latitude,
      this.location,
      this.textAlign = TextAlign.left})
      : assert(content != null || imageBytes != null) {
    if (createdDate == null) {
      _createdDate = DateTime.now().toUtc();
    } else if (!createdDate.isUtc) {
      _createdDate = createdDate.toUtc();
    } else {
      _createdDate = createdDate;
    }

    location = location ?? '';

    fontFamily = fontFamily ?? noto;
  }

  Map<String, dynamic> toMap() => {
        'Id': id,
        'Content': content,
        'CreatedDateTime': _createdDate.millisecondsSinceEpoch,
        'Location': location,
        'Longitude': longitude,
        'Latitude': latitude,
        'WeatherCode': this.weatherCode,
        'FontFamily': this.fontFamily,
        'ImageBytes': this.imageBytes,
        'IsBookmarked': this.isBookmarked ? 1 : 0,
        'textAlign': this.textAlign.index
      };

  Journal.fromMap(Map map) {
    this.id = map['Id'] as int;
    this.content = map['Content'];
    this._createdDate = (map['CreatedDateTime'] as int) == null ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(map['CreatedDateTime']);
    this.location = map['Location'];
    this.longitude = map['Longitude'] as double;
    this.latitude = map['Latitude'] as double;
    this.weatherCode = map['WeatherCode'];
    this.fontFamily = map['FontFamily'];
    this.imageBytes = map['ImageBytes'];
    this.isBookmarked = (map['IsBookmarked'] as int) == 1 ? true : false;
    this.textAlign = (map['TextAlign'] as int) == null ? TextAlign.left : TextAlign.values.elementAt(map['TextAlign'] as int);
  }

  @override
  String toString() {
    return "id: ${this.id}\n"
        "Content: ${this.content}\n"
        "Created Date: ${this.createdDate.toDisplayString()}";
  }

  @override
  int compareTo(Journal other) {
    print(other.createdDate.toDisplayString());
    print(this.createdDate.toDisplayString());
    if (other.createdDate.year == this.createdDate.year &&
        other.createdDate.month == this.createdDate.month &&
        other.createdDate.day == this.createdDate.day) {
      return 0;
    }
    if (other.createdDate.year > this.createdDate.year ||
        other.createdDate.month > this.createdDate.month ||
        other.createdDate.day > this.createdDate.day) {
      return -1;
    } else if (other.createdDate.year < this.createdDate.year ||
        other.createdDate.month < this.createdDate.month ||
        other.createdDate.day < this.createdDate.day) {
      return 1;
    }
  }
}
