import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

import 'globals_service.dart';

class PersonCardService {

  //#region Create PersonCard As Object
  //=============================================================================
  PersonCardObject createPersonCardAsObject(
      String aEmailId,
      String aEmail,
      String aFirstName,
      String aLastName,
      String aFirstNameEng,
      String aLastNameEng,
      String aPhoneNumber,
      String aPhoneNumberDialCode,
      String aPhoneNumberParse,
      String aPhoneNumberCleanLongFormat,
      String aPictureUrl,
      String aCardDescription,
      String aInternetSiteUrl,
      String aAddress
      )
    {
      if (aEmail == null)
        return PersonCardObject(
            emailId: '',
            email: '',
            firstName: '',
            lastName: '',
            firstNameEng: '',
            lastNameEng: '',
            phoneNumber: '',
            phoneNumberDialCode: '',
            phoneNumberParse: '',
            phoneNumberCleanLongFormat: '',
            pictureUrl: '',
            cardDescription: '',
            internetSiteUrl: '',
            address: ''
        );
      else
        return PersonCardObject(
            emailId: aEmailId,
            email: aEmail,
            firstName: aFirstName,
            lastName: aLastName,
            firstNameEng: aFirstNameEng,
            lastNameEng: aLastNameEng,
            phoneNumber: aPhoneNumber,
            phoneNumberDialCode: aPhoneNumberDialCode,
            phoneNumberParse: aPhoneNumberParse,
            phoneNumberCleanLongFormat: aPhoneNumberCleanLongFormat,
            pictureUrl: aPictureUrl,
            cardDescription: aCardDescription,
            internetSiteUrl: aInternetSiteUrl,
            address: aAddress
        );
    }
  //#endregion

  //#region Read PersonCard Object Data From DataBase [ReadFromDB]
  //=============================================================================
  Future<PersonCardObject> readPersonCardObjectDataFromDataBase() async {
    String _emailId;
    String _email;
    String _firstName;
    String _lastName;
    String _firstNameEng;
    String _lastNameEng;
    String _phoneNumber;
    String _phoneNumberDialCode;
    String _phoneNumberParse;
    String _phoneNumberCleanLongFormat;
    String _pictureUrl;
    String _cardDescription;
    String _internetSiteUrl;
    String _address;

    try{
      _emailId = 'shr.harari@gmail.com';
      _email = 'shr.harari@gmail.com';
      _firstName = 'שחר';
      _lastName = 'הררי';
      _firstNameEng = 'Shahar';
      _lastNameEng = 'Harari';
      _phoneNumber = '+972525464640';
      _phoneNumberDialCode = '972';
      _phoneNumberParse = '525464640';
      _phoneNumberCleanLongFormat = '972525464640';
      _pictureUrl = '';
      _cardDescription = 'תיאור מפורט של כרטיס הביקור';
      _internetSiteUrl = '';
      _address = 'הנשיאים 6, הוד-השרון';

      return createPersonCardAsObject(
          _emailId,
          _email,
          _firstName,
          _lastName,
          _firstNameEng,
          _lastNameEng,
          _phoneNumber,
          _phoneNumberDialCode,
          _phoneNumberParse,
          _phoneNumberCleanLongFormat,
          _pictureUrl,
          _cardDescription,
          _internetSiteUrl,
          _address);
    }
    catch  (e) {
      await LoggerService.log('<PersonCardService> Read PersonCard Object Data From DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'readPersonCardObjectDataFromDataBase',
        name: 'PersonCardService',
        error: 'Read PersonCard Object Data From DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Update PersonCard Object Data To DataBase [WriteToDB]
  //=============================================================================
  Future updatePersonCardObjectDataToDataBase(PersonCardObject aPersonCardObj) async {
    try{
      String jsonToPost = jsonEncode(aPersonCardObj);
//      print('updatePersonCardObjectDataToDataBase / Json: \n$jsonToPost');

      /// *** debug:
      if(GlobalsService.isDebugMode)
          return "100";  // >>> Success
      /// debug***

      Response response = await post(Constants.rotaryPersonCardWriteToDataBaseRequestUrl,
          headers: Constants.rotaryUrlHeader,
          body: jsonToPost);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        String dbResult = jsonResponse;
        if (int.parse(dbResult) > 0){
          await LoggerService.log('<PersonCardService> PersonCard Update >>> OK');
          return dbResult;
        } else {
          await LoggerService.log('<PersonCardService> PersonCard Update >>> Failed');
          print('<PersonCardService> PersonCard Update >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<PersonCardService> PersonCard Update >>> Failed');
        print('<PersonCardService> PersonCard Update >>> Failed');
        return null;
      }
    }
    catch  (e) {
      await LoggerService.log('<PersonCardService> Write PersonCard Object Data To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'writePersonCardObjectDataToDataBase',
        name: 'PersonCardService',
        error: 'Write PersonCard Object Data To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Create Json PersonCardList [Data for Debug]
  String createJsonForPersonCardsList() {
    final String someText = "\\nשל כרטיס הביקור של אלק באלדווי\\nפירוט נוסף\\nועוד פירוט\\nשורה נונספת ארוכה מאודדדדדדדדדדד דדדדדדדדדדדדד דדדדדדדדדדדד  דדדדד\\nועוד שורה ארררררוככככה יחדגיכחגי דגיכגדי דגכי ידגכי דגכי דגכי דגכי\\nסוף";

    String personCardListJson =
        '['
        '{'
          '"emailId": "shr.harari@gmail.com", '
          '"email": "shr.harari@gmail.com", '
          '"firstName": "שחר", '
          '"lastName": "הררי", '
          '"firstNameEng": "Shahar", '
          '"lastNameEng": "Harari", '
          '"phoneNumber": "+972525464640", '
          '"phoneNumberDialCode": "972", '
          '"phoneNumberParse": "525464640", '
          '"phoneNumberCleanLongFormat": "972525464640", '
          '"pictureUrl": "shr.harari@gmail.com.jpg", '
          '"cardDescription": "תיאור מפורט של כרטיס הביקור של שחר הררי", '
          '"internetSiteUrl": "https://www.google.co.il/", '
          '"address": "הנשיאים 6, הוד-השרון ישראל" '
        '},'
        '{'
          '"emailId": "alec.baldwin@gmail.com", '
          '"email": "alec.baldwin@gmail.com", '
          '"firstName": "אלק", '
          '"lastName": "באלדווי", '
          '"firstNameEng": "Alec", '
          '"lastNameEng": "Baldwin", '
          '"phoneNumber": "+972521111111", '
          '"phoneNumberDialCode": "972", '
          '"phoneNumberParse": "521111111", '
          '"phoneNumberCleanLongFormat": "972521111111", '
          '"pictureUrl": "alec_baldwin@gmail.com.jpg", '
          '"cardDescription": "$someText", '
          '"internetSiteUrl": "", '
          '"address": "ויצמן 32, כפר-סבא ישראל" '
        '},'
        '{'
          '"emailId": "gal_gadot@gmail.com", '
          '"email": "gal_gadot@gmail.com", '
          '"firstName": "גל", '
          '"lastName": "גדות", '
          '"firstNameEng": "Gal", '
          '"lastNameEng": "Gadot", '
          '"phoneNumber": "+972522222222", '
          '"phoneNumberDialCode": "972", '
          '"phoneNumberParse": "522222222", '
          '"phoneNumberCleanLongFormat": "972522222222", '
          '"pictureUrl": "gal_gadot@gmail.com.jpg", '
          '"cardDescription": "תיאור מפורט של כרטיס הביקור של גל גדות", '
          '"internetSiteUrl": "", '
          '"address": "יפו 32 ירושלים ישראל" '
        '},'
        '{'
          '"emailId": "tom_cruise@gmail.com", '
          '"email": "tom_cruise@gmail.com", '
          '"firstName": "טום", '
          '"lastName": "קרוז", '
          '"firstNameEng": "Tom", '
          '"lastNameEng": "Cruise", '
          '"phoneNumber": "+972523333333", '
          '"phoneNumberDialCode": "972", '
          '"phoneNumberParse": "523333333", '
          '"phoneNumberCleanLongFormat": "972523333333", '
          '"pictureUrl": "tom_cruise@gmail.com.jpg", '
          '"cardDescription": "תיאור מפורט של כרטיס הביקור של טום קרוז", '
          '"internetSiteUrl": "", '
          '"address": "הכנסת 1, ירושלים" '
        '},'
        '{'
          '"emailId": "cameron_diaz@gmail.com", '
          '"email": "cameron_diaz@gmail.com", '
          '"firstName": "קמרון", '
          '"lastName": "דיאז", '
          '"firstNameEng": "Cameron", '
          '"lastNameEng": "Diaz", '
          '"phoneNumber": "+972524444444", '
          '"phoneNumberDialCode": "972", '
          '"phoneNumberParse": "524444444", '
          '"phoneNumberCleanLongFormat": "972524444444", '
          '"pictureUrl": "cameron_diaz@gmail.com.jpg", '
          '"cardDescription": "תיאור מפורט של כרטיס הביקור של קמרון דיאז", '
          '"internetSiteUrl": "", '
          '"address": "תל-חי 18, כפר-סבא ישראל" '
        '},'
        '{'
          '"emailId": "harrison_ford@gmail.com", '
          '"email": "harrison_ford@gmail.com", '
          '"firstName": "האריסון", '
          '"lastName": "פורד", '
          '"firstNameEng": "Harrison", '
          '"lastNameEng": "Ford", '
          '"phoneNumber": "+972525555555", '
          '"phoneNumberDialCode": "972", '
          '"phoneNumberParse": "525555555", '
          '"phoneNumberCleanLongFormat": "972525555555", '
          '"pictureUrl": "harrison_ford@gmail.com.jpg", '
          '"cardDescription": "תיאור מפורט של כרטיס הביקור של האריסון פורד", '
          '"internetSiteUrl": "", '
          '"address": "סוקולוב 6, נתניה" '
        '},'
        '{'
          '"emailId": "jack_nicholson@gmail.com", '
          '"email": "jack_nicholson@gmail.com", '
          '"firstName": "גק", '
          '"lastName": "ניקולסון", '
          '"firstNameEng": "Jack", '
          '"lastNameEng": "Nicholson", '
          '"phoneNumber": "+972526666666", '
          '"phoneNumberDialCode": "972", '
          '"phoneNumberParse": "526666666", '
          '"phoneNumberCleanLongFormat": "9726666666", '
          '"pictureUrl": "jack_nicholson@gmail.com.jpg", '
          '"cardDescription": "תיאור מפורט של כרטיס הביקור של גק ניקולסון", '
          '"internetSiteUrl": "", '
          '"address": "ויצמן 6, חדרה" '
        '},'
        '{'
          '"emailId": "julia_roberts@gmail.com", '
          '"email": "julia_roberts@gmail.com", '
          '"firstName": "גוליה", '
          '"lastName": "רוברטס", '
          '"firstNameEng": "Julia", '
          '"lastNameEng": "Roberts", '
          '"phoneNumber": "+972527777777", '
          '"phoneNumberDialCode": "972", '
          '"phoneNumberParse": "527777777", '
          '"phoneNumberCleanLongFormat": "97257777777", '
          '"pictureUrl": "julia_roberts@gmail.com.jpg", '
          '"cardDescription": "תיאור מפורט של כרטיס הביקור של גוליה רוברטס", '
          '"internetSiteUrl": "google.com", '
          '"address": "סוקולוב 6, רמת-השרון" '
        '},'
        '{'
          '"emailId": "paul_newman@gmail.com", '
          '"email": "paul_newman@gmail.com", '
          '"firstName": "פול", '
          '"lastName": "ניומן", '
          '"firstNameEng": "Paul", '
          '"lastNameEng": "Newman", '
          '"phoneNumber": "+972528888888", '
          '"phoneNumberDialCode": "972", '
          '"phoneNumberParse": "528888888", '
          '"phoneNumberCleanLongFormat": "97258888888", '
          '"pictureUrl": "paul_newman@gmail.com.jpg", '
          '"cardDescription": "תיאור מפורט של כרטיס הביקור של פול ניומן", '
          '"internetSiteUrl": "google.com", '
          '"address": "וינגייט 56, באר-שבע" '
        '},'
        '{'
          '"emailId": "robert_de_niro@gmail.com", '
          '"email": "robert_de_niro@gmail.com", '
          '"firstName": "רוברט", '
          '"lastName": "דה-נירו", '
          '"firstNameEng": "Robert", '
          '"lastNameEng": "De_niro", '
          '"phoneNumber": "+972529999999", '
          '"phoneNumberDialCode": "972", '
          '"phoneNumberParse": "529999999", '
          '"phoneNumberCleanLongFormat": "97259999999", '
          '"pictureUrl": "robert_de_niro@gmail.com.jpg", '
          '"cardDescription": "תיאור מפורט של כרטיס הביקור של רוברט דה-נירו", '
          '"internetSiteUrl": "google.com", '
          '"address": "הנשיא 6, פתח-תקווה" '
        '},'
        '{'
        '"emailId": "uma_thurman@gmail.com", '
        '"email": "uma_thurman@gmail.com", '
        '"firstName": "אומה", '
        '"lastName": "תורמן", '
        '"firstNameEng": "Uma", '
        '"lastNameEng": "Thurman", '
        '"phoneNumber": "+972529999999", '
        '"phoneNumberDialCode": "972", '
        '"phoneNumberParse": "529999999", '
        '"phoneNumberCleanLongFormat": "97259999999", '
        '"pictureUrl": "uma_thurman@gmail.com.jpg", '
        '"cardDescription": "תיאור מפורט של כרטיס הביקור של אומה תורמן", '
        '"internetSiteUrl": "google.com", '
        '"address": "6767 Hollywood Blvd, Los Angeles, CA 90028, ארצות הברית" '
        '}'
        ']';

    return personCardListJson;
  }
  //#endregion

  //#region Get PersonCard List From Server [GET]
  // =========================================================
  Future getPersonCardsListSearchFromServer(String aValueToSearch) async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        String jsonResponseForDebug = createJsonForPersonCardsList();
//        print('jsonResponseForDebug: $jsonResponseForDebug');

        var personCardsListForDebug = jsonDecode(jsonResponseForDebug) as List;    // List of PersonCard to display;
        List<PersonCardObject> personCardObjListForDebug = personCardsListForDebug.map((personCardJsonDebug) => PersonCardObject.fromJson(personCardJsonDebug)).toList();
//        print('personCardObjListForDebug.length: ${personCardObjListForDebug.length}');

        personCardObjListForDebug.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
        return personCardObjListForDebug;
      }
      //***** for debug *****

      /// PersonCardListUrl: 'http://.......'
      Response response = await get(Constants.rotaryGetPersonCardListUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<PersonCardService> Get PersonCard List From Server >>> OK\nHeader: $contentType \nPersonCardListFromJSON: $jsonResponse');

        var personCardList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<PersonCardObject> personCardObjList = personCardList.map((personCardJson) => PersonCardObject.fromJson(personCardJson)).toList();

        personCardObjList.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
//      personCardObjList.sort((a, b) {
//        return a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase());
//      });

        return personCardObjList;

      } else {
        await LoggerService.log('<PersonCardService> Get PersonCard List From Server >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCard List From Server >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RegistrationService> Get PersonCard List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonCardListFromServer',
        name: 'PersonCardService',
        error: 'PersonCards List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Create Json PersonalCard [Data for Debug]
  String createJsonForPersonalCardByEmail() {

    String personCardListJson =
        '{'
        '"emailId": "shr.harari@gmail.com", '
        '"email": "shr.harari@gmail.com", '
        '"firstName": "שחר", '
        '"lastName": "הררי", '
        '"firstNameEng": "Shahar", '
        '"lastNameEng": "Harari", '
        '"phoneNumber": "+972525464640", '
        '"phoneNumberDialCode": "972", '
        '"phoneNumberParse": "525464640", '
        '"phoneNumberCleanLongFormat": "972525464640", '
        '"pictureUrl": "shr.harari@gmail.com.jpg", '
          '"cardDescription": "תיאור מפורט של כרטיס הביקור של שחר הררי", '
        '"internetSiteUrl": "https://www.google.co.il/", '
        '"address": "הנשיאים 6, הוד-השרון ישראל" '
        '}';

    return personCardListJson;
  }
  //#endregion

  //#region Get Personal Card By EmailId From Server [GET]
  // =========================================================
  Future getPersonalCardByEmailFromServer(String aEmailId) async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        String jsonResponseForDebug = createJsonForPersonalCardByEmail();
//        print('jsonResponseForDebug: $jsonResponseForDebug');

        var personCardForDebug = jsonDecode(jsonResponseForDebug);
        PersonCardObject personCardObjForDebug = PersonCardObject.fromJson(personCardForDebug);

        return personCardObjForDebug;
      }
      //***** for debug *****

      /// PersonCardListUrl: 'http://.......'
      Response response = await get(Constants.rotaryGetPersonCardListUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<PersonCardService> Get PersonCard List From Server >>> OK\nHeader: $contentType \nPersonCardListFromJSON: $jsonResponse');

        var personCardList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<PersonCardObject> personCardObjList = personCardList.map((personCardJson) => PersonCardObject.fromJson(personCardJson)).toList();

        return personCardObjList;

      } else {
        await LoggerService.log('<PersonCardService> Get PersonCard List From Server >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCard List From Server >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RegistrationService> Get PersonCard List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonCardListFromServer',
        name: 'PersonCardService',
        error: 'PersonCards List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
//#endregion

}
