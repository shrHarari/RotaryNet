import 'dart:async';
import 'package:http/http.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class MenuPagesService {

  //#region Get About Display Text From Server [GET]
  // =========================================================
  Future<String> getAboutDisplayTextFromServer() async {

    String aboutDisplayText;

    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        return "רוטרינט הוא מנוע חיפוש מקומי למציאת אנשי קשר במועדון רוטרי\n"
        "הנתונים נאספים ממשתמשי רוטרינט ומוזנים על ידי חברי המועדון\n"
        "כל חבר רוטרי רשאי להזין את המידע הרלוונטי לגביו, אשר יוצג בכרטיס הביקור שלו";
      }
      //***** for debug *****

      /// StatusUrl: 'http://159.89.225.231:7775/api/registration/isregistered/requestId={requestId}'
      String requestStatusUrl = '${Constants.rotaryUserRegistrationUrl}';
      Response response = await get(requestStatusUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        aboutDisplayText = response.body;

        return aboutDisplayText;
      } else {
        await LoggerService.log('<RegistrationService> Get About Display Text From Server >>> Failed: ${response.statusCode}');
        print('<RegistrationService> Get About Display Text From Server >>> Failed: ${response.statusCode}');
        return "No About Display Text";
      }
    }
    catch (e) {
      await LoggerService.log('<MenuPagesService> Get About Display Text From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getAboutDisplayTextFromServer',
        name: 'MenuPagesService',
        error: 'Request Status >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion
}
