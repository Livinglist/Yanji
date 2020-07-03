extension DatetimeStringify on DateTime {
  String get yearString {
    String yearStr = this.year.toString();
    String str = '';

    for (var i in Iterable.generate(4)) {
      str += _numToChineseString(yearStr[i]);
    }

    return str;
  }

  String _numToChineseString(String num) {
    switch (num) {
      case '1':
        return '一';
      case '2':
        return '二';
      case '3':
        return '三';
      case '4':
        return '四';
      case '5':
        return '五';
      case '6':
        return '六';
      case '7':
        return '七';
      case '8':
        return '八';
      case '9':
        return '九';
      case '0':
        return '〇';
      default:
        throw Exception("Unmatched month");
    }
  }

  String _monthToChineseString(int num) {
    switch (num) {
      case 1:
        return '一月';
      case 2:
        return '二月';
      case 3:
        return '三月';
      case 4:
        return '四月';
      case 5:
        return '五月';
      case 6:
        return '六月';
      case 7:
        return '七月';
      case 8:
        return '八月';
      case 9:
        return '九月';
      case 10:
        return '十月';
      case 11:
        return '十一月';
      case 12:
        return '十二月';
      default:
        throw Exception("Unmatched month");
    }
  }

  String _dayToChineseString(int num) {
    String str = '';

    if(num > 30){
      str = '三十' + _numToChineseString(num.toString()[1]);
    }if(num > 20){
      str = '二十' + _numToChineseString(num.toString()[1]);
    }if(num > 30){
      str = '十' + _numToChineseString(num.toString()[1]);
    }else{
      str = _numToChineseString(num.toString()[0]);
    }

    return str;
  }

  String get monthString {
    switch (this.month) {
      case 1:
        return '一月';
      case 2:
        return '二月';
      case 3:
        return '三月';
      case 4:
        return '四月';
      case 5:
        return '五月';
      case 6:
        return '六月';
      case 7:
        return '七月';
      case 8:
        return '八月';
      case 9:
        return '九月';
      case 10:
        return '十月';
      case 11:
        return '十一月';
      case 12:
        return '十二月';
      default:
        throw Exception("Unmatched month");
    }
  }

  String toDisplayString() {
    return "${this.yearString} ${this.monthString} ${_dayToChineseString(this.day)}日";
  }

  bool isTheSameDay(DateTime dateTime) {
    if (this.day == dateTime.day && this.month == dateTime.month && this.year == dateTime.year) {
      return true;
    } else {
      return false;
    }
  }

  bool isInSameWeek(DateTime dateTime) {
    if (this.year == dateTime.year && this.difference(dateTime).inDays.abs() <= 6) {
      if (this.weekday == dateTime.weekday) return true;
      var weekDay = this.weekday;
      var day = this.day;
      var upper = day + (7 - weekDay);
      var lower = day - weekDay + 1;

      if (dateTime.day >= lower && dateTime.day <= upper) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  String getMonth() {
    switch (this.month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        throw Exception("Unmatched month");
    }
  }
}

class DateTimeHelpers {
  static String getMonth(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        throw Exception("Unmatched month");
    }
  }
}
