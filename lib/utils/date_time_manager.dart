
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:intl/intl.dart';
class DateTimeManager{
  static const String _dateTimeFormat="yyyy-MM-dd hh:mm aa";
  static const String _dateTimeFormat2="MMMM dd | hh:mm aa";


  static const String _dateTimeFormat24="yyyy-MM-dd HH:mm:ss";
  static const String _dateTimeFormat24_2="yyyy-MM-ddTHH:mm:ssZ";


  //static const String _dateFormat="yyyy-MM-dd";
  static const String _dateFormat="MM/dd/yyyy";
  static const String _monthYearFormat="MM/yyyy";
  static const String _timeFormat="hh:mm aa";
  static const String _twentyFourHourTimeFormat="hh:mm";

  static const String twentyFourHourTimeFormat="hh:mm aa";

  static DateTime _parseDateTime24(String date,{bool isutc=false}){
    DateTime dateTime=DateFormat(_dateTimeFormat24).parse(date,isutc,);
    return isutc?dateTime.toLocal():dateTime;
  }

  static String getFormattedDateTime(String date){
    return DateFormat(_dateTimeFormat).format(_parseDateTime24(date));
  }
/*
  static String getFormattedTime(String date){
    return DateFormat(_dateTimeFormat).format(_parseDateTime24(date)).split(" ")[1];
  }
*/

  static DateTime covertDateTimeToUtc(
      {required DateTime dateTime,}) {
    print("dataee time is "+dateTime.toString());
    return dateTime.toUtc();
  }
  static String getFormattedDateTime2(String date){
    return DateFormat(_dateTimeFormat2).format(_parseDateTime24(date));
  }

  static String getFormattedDate(String? date,{bool isutc=false}){
    return DateFormat(_dateFormat).format(_parseDateTime24(date??"",isutc:isutc));
  }
  static String getFormattedMonthYear(String date,{bool isutc=false}){
    return DateFormat(_monthYearFormat).format(_parseDateTime24(date,isutc:isutc));
  }

  static String getFormattedTime(String date,{bool isutc=false}){
    return DateFormat(_timeFormat).format(_parseDateTime24(date,isutc:isutc));
  }
  static DateTime parseDateTime(
      {required String parseFormat,
        required String inputDateTime,
        bool utc = false}) {
    return DateFormat(parseFormat).parse(inputDateTime, utc);
  }

  static int getRemainingHour({String? time}){
    DateTime createdDateTime= DateTimeManager.parseDateTime(
      utc: true,
      inputDateTime: time.toString(),
      parseFormat:_dateTimeFormat24_2,
    ).toLocal();
    DateTime endTime=createdDateTime.add(Duration(days: 1));
    DateTime now=DateTime.now();
    int remainingHour=endTime.difference(now).inHours;
    return remainingHour;
  }
  static int getRemainingMin({String? time}){
    DateTime createdDateTime= DateTimeManager.parseDateTime(
      utc: true,
      inputDateTime: time.toString(),
      parseFormat:_dateTimeFormat24_2,
    ).toLocal();
    DateTime endTime=createdDateTime.add(Duration(days: 1));
    DateTime now=DateTime.now();
    int remainingHour=endTime.difference(now).inMinutes;
    return remainingHour;
  }
  static int getRemainingSecond({String? time}){
    DateTime createdDateTime= DateTimeManager.parseDateTime(
      utc: true,
      inputDateTime: time.toString(),
      parseFormat:_dateTimeFormat24_2,
    ).toLocal();
    DateTime endTime=createdDateTime.add(Duration(days: 1));
    DateTime now=DateTime.now();
    int remainingHour=endTime.difference(now).inSeconds;
    return remainingHour;
  }

  static String? timeAgoMethod(
      {required String createdDate, String? endPoint,bool? isUtc=false}) {
    DateTime createdDateTime = parseDateTime(
        parseFormat: createdDate.contains("T")
            ? _dateTimeFormat24_2
            : _dateTimeFormat24,
        inputDateTime: createdDate,
        utc: isUtc!)
        .toLocal();
    String timeAgoTime = timeAgo.format(createdDateTime, locale: "en_short");

    if(timeAgoTime.contains("~")){
      timeAgoTime=timeAgoTime.toString().split("~")[1]+ " ago";
    }
    else{
      timeAgoTime=timeAgoTime;
    }
    return timeAgoTime;
  }


}