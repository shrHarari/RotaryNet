import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:http/http.dart';
import 'package:rotary_net/objects/menu_page_object.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class MenuPagesService {

  //#region Get Menu About Content From Server [GET]
  // =========================================================
  Future<String> getMenuAboutContentFromServer() async {

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

      String requestStatusUrl = '${Constants.rotaryMenuPagesContentUrl}';
      Response response = await get(requestStatusUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        aboutDisplayText = response.body;

        return aboutDisplayText;
      } else {
        await LoggerService.log('<RegistrationService> Get Menu About Content From Server >>> Failed: ${response.statusCode}');
        print('<RegistrationService> Get Menu About Content From Server >>> Failed: ${response.statusCode}');
        return "No About Content";
      }
    }
    catch (e) {
      await LoggerService.log('<MenuPagesService> Get Menu About Content From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getMenuAboutContentFromServer',
        name: 'MenuPagesService',
        error: 'Request Status >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get MenuPage Content By PageName [GET]
  // =========================================================
  Future<Map<String, Object>> getMenuPrivacyPolicyContentFromServer() async {

    Map<String, Object> privacyPolicyContentMap = HashMap();

    try {
      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        privacyPolicyContentMap['rotary_introduction_start'] = "מועדון רוטרינט מתייחס בכבוד לפרטיות המשתמשים בשירות שהיא מנהלת באמצעות יישומון (אפליקציה) למכשירי קצה חכמים ('";
        privacyPolicyContentMap['rotary_introduction_service'] = "להלן השירות";
        privacyPolicyContentMap['rotary_introduction_end'] = "').\n";
        privacyPolicyContentMap['privacy_introduction'] = "במדיניות הפרטיות שלהלן נציג לך מהי מדיניות הפרטיות הנהוגה בשירות\n";
        privacyPolicyContentMap['add_line_1'] = "....\n";
        privacyPolicyContentMap['add_line_2'] = "....\n";
        privacyPolicyContentMap['rotary_privacy_condition'] = "במידה ואתה סבור כי פרטיותך נפגעה במהלך השימוש בשירות, או בכל שאלה אחרת הנוגעת למדיוניות זו, אנא פנה למפעילת השירות באמצעות כתובת הדוא''ל: ";
        privacyPolicyContentMap['rotary_privacy_condition_mail'] = "abc@rotary.net";

        return privacyPolicyContentMap;

//        return "מועדון רוטרינט מתייחס בכבוד לפרטיות המשתמשים בשירות שהיא מנהלת באמצעות יישומון (אפליקציה) למכשירי קצה חכמים ('השירות').\n"
//            "במדיניות הפרטיות שלהלן נציג לך מהי מדיניות הפרטיות הנהוגה בשירות\n"
//            "....\n"
//            "....\n"
//            "במידה ואתה סבור כי פרטיותך נפגעה במהלך השימוש בשירות, או בכל שאלה אחרת הנוגעת למדיוניות זו, אנא פנה למפעילת השירות באמצעות כתובת הדוא''ל: abc@rotary.net";
      }
      //***** for debug *****

      String aPageName = 'PrivacyPolicyContent';
      String _getUrl = Constants.rotaryMenuPagesContentUrl + "/$aPageName";

      String requestStatusUrl = '${Constants.rotaryMenuPagesContentUrl}';
      Response response = await get(requestStatusUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        privacyPolicyContentMap['ServerJson'] = response.body;
        /// >>>>>>>>>>>>>>>>>>>> TO DO: break ServerJson to MAP

        return privacyPolicyContentMap;
      } else {
        await LoggerService.log('<RegistrationService> Get Menu Privacy Policy Content From Server >>> Failed: ${response.statusCode}');
        print('<RegistrationService> Get Menu Privacy Policy Content From Server >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MenuPagesService> Get Menu Privacy Policy Content From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getMenuPrivacyPolicyContentFromServer',
        name: 'MenuPagesService',
        error: 'Request Status >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }

  Future<Map<String, dynamic>> getMenuPageContentByPageName(String aPageName) async {

    Map<String, dynamic> pageContentItemsMap = HashMap();

    try {
      String _getUrl = Constants.rotaryMenuPagesContentUrl + "/$aPageName";
      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;

        dynamic pageContentItems = jsonDecode(jsonResponse);
        List<dynamic> pageContentItemsList;
        if (pageContentItems['pageItems'] != null) {
          pageContentItemsList = pageContentItems['pageItems'] as List;
        } else {
          pageContentItemsList = [];
        }

        List<PageContentItemObject> pageContentItemsObjList = pageContentItemsList.map((pageItem) =>
                  PageContentItemObject.fromJson(pageItem)).toList();

        pageContentItemsMap = Map.fromIterable(pageContentItemsObjList,
            key: (pageItem) => pageItem.itemName,
            value: (pageItem) => pageItem.itemContent);

        return pageContentItemsMap;
      } else {
        await LoggerService.log('<MenuPagesService> Get MenuPage Content By PageName >>> Failed: ${response.statusCode}');
        print('<MenuPagesService> Get MenuPage Content By PageName >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MenuPagesService> Get MenuPage Content By PageName >>> ERROR: ${e.toString()}');
      developer.log(
        'getMenuPageContentByPageName',
        name: 'MenuPagesService',
        error: 'Get MenuPage Content By PageName >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion
}
