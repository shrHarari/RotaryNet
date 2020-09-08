import 'package:intl/date_symbol_data_local.dart' as SymbolData;
import 'package:intl/intl.dart' as Intl;

class HebrewFormatSyntax {

  static Future<Map> getHebrewDateTimeLabels(DateTime aStartTime, DateTime aEndTime) async {

    await SymbolData.initializeDateFormatting("he", null);
    var formatterStartDate = Intl.DateFormat.yMMMMEEEEd('he');
    String hebrewStartDate = formatterStartDate.format(aStartTime);

    var formatterEndDate = Intl.DateFormat.yMMMMEEEEd('he');
    String hebrewEndDate = formatterEndDate.format(aEndTime);

    var formatterStartTime = Intl.DateFormat.Hm('he');
    String hebrewStartTime = formatterStartTime.format(aStartTime);

    var formatterEndTime = Intl.DateFormat.Hm('he');
    String hebrewEndTime = formatterEndTime.format(aEndTime);

    /// Return multiple data using MAP
    final hebrewDatesMap = {
      "HebrewStartDate": hebrewStartDate,
      "HebrewEndDate": hebrewEndDate,
      "HebrewStartTime": hebrewStartTime,
      "HebrewEndTime": hebrewEndTime
    };

    return hebrewDatesMap;
  }
}