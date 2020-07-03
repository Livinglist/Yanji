import 'dart:convert';

import 'package:jiba/models/journal.dart';
import 'package:shared_preferences/shared_preferences.dart';

///The content of the last added journal.
const _contentStrKey = 'contentStrKey';

///The [DateTime] of the last added journal.
const _lastDateTimeKey = 'lastDateTimeKey';

///The [FontFamily] user used last time.
const _lastFontFamilyKey = 'lastFontFamilyKey';

const _tempJournalKey = 'tempJournalKey';

const _initialStartKey = 'initialStartKey';

class SharedPreferencesProvider {
  SharedPreferences _sharedPreferences;

  ///The [DateTime] of the uncompleted journal, saved in UTC format.
  DateTime _lastDateTime;

  DateTime get lastDateTime => _lastDateTime.toLocal();

  set lastDateTime(DateTime dateTime) {
    _lastDateTime = dateTime.toUtc();
    _setLastDateTimeString(_lastDateTime);
  }

  ///Content of recent uncompleted journal.
  String _contentStr;
  @Deprecated("we now always save the content in database.")
  String get contentStr => _contentStr;
  @Deprecated("we now always save the content in database.")
  set contentStr(String content) {
    _contentStr = content;
    _setContentStr(_contentStr);
  }

  ///The [FontFamily] user recently used.
  String _lastFontFamily;

  String get lastFontFamily => _lastFontFamily ?? noto;

  set lastFontFamily(String fontFamily) {
    _lastFontFamily = fontFamily;
    _setLastFontFamily(_lastFontFamily);
  }

  Journal _tempJournal;

  Journal get tempJournal => _tempJournal;

  set tempJournal(Journal journal) {
    _tempJournal = journal;
    var map = journal.toMap();
    var str = jsonEncode(map);
    _setTempJournal(str);
  }

  void _setTempJournal(String journalStr) => _sharedPreferences.setString(_tempJournalKey, journalStr);

  Journal _getTempJournal() {
    var str = _sharedPreferences.getString(_tempJournalKey);
    if (str != null) {
      var map = jsonDecode(str);
      var journal = Journal.fromMap(map);
      return journal;
    } else {
      return null;
    }
  }

  Future<SharedPreferences> get sharedPreferences async {
    if (_sharedPreferences != null) return _sharedPreferences;
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences;
  }

  SharedPreferencesProvider() {
    initSharedPrefs();
  }

  Future initSharedPrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    String dateStr = _getLastDateTimeString();

    _lastDateTime = dateStr == null ? DateTime.now().subtract(Duration(days: 1)) : DateTime.parse(dateStr);

    _contentStr = _getContentStr();

    _lastFontFamily = _getLastFontFamily();

    _tempJournal = _getTempJournal();

    return _sharedPreferences;
  }

  String _getLastDateTimeString() => _sharedPreferences.getString(_lastDateTimeKey);

  void _setLastDateTimeString(DateTime dateTime) {
    _sharedPreferences.setString(_lastDateTimeKey, dateTime.toString());
  }

  String _getContentStr() => _sharedPreferences.getString(_contentStrKey);

  void _setContentStr(String content) {
    _sharedPreferences.setString(_contentStrKey, content);
  }

  String _getLastFontFamily() => _sharedPreferences.getString(_lastFontFamilyKey);

  void _setLastFontFamily(String fontFamily) {
    _sharedPreferences.setString(_lastFontFamilyKey, fontFamily);
  }

  Future<bool> getIsInitialStart() async {
    var _sharedPreferences = await SharedPreferences.getInstance();

    var res = _sharedPreferences.getBool(_initialStartKey);

    if(res == null){
      _sharedPreferences.setBool(_initialStartKey, false);
    }

    return Future.value(res == null?true:false);
  }
}

SharedPreferencesProvider sharedPrefsProvider = SharedPreferencesProvider();
