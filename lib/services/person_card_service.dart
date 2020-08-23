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
      print('updatePersonCardObjectDataToDataBase / Json: \n$jsonToPost');

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
  String createJsonForPersonCardList() {
    final String someText = "\\nשל כרטיס הביקור של שחר הררי\\nפירוט נוסף\\nועוד פירוט\\nשורה נונספת ארוכה מאודדדדדדדדדדד דדדדדדדדדדדדד דדדדדדדדדדדד  דדדדד\\nועוד שורה ארררררוככככה יחדגיכחגי דגיכגדי דגכי ידגכי דגכי דגכי דגכי\\nסוף";

    String personCardListJson =
        '['
        '{'
          '"email": "shr.harari@gmail.com", '
          '"firstName": "שחר", '
          '"lastName": "הררי", '
          '"firstNameEng": "Shahar", '
          '"lastNameEng": "Harari", '
          '"phoneNumber": "+972525464640", '
          '"phoneNumberDialCode": "972", '
          '"phoneNumberParse": "525464640", '
          '"phoneNumberCleanLongFormat": "972525464640", '
          '"pictureUrl": "10.jpg", '
//          '"cardDescription": "תיאור מפורט של כרטיס הביקור של שחר הררי", '
          '"cardDescription": "$someText", '
          '"internetSiteUrl": "https://www.google.co.il/", '
          '"address": "הנשיאים 6, הוד-השרון ישראל" '
        '},'
        '{'
        '"email": "gilad.ardan@gmail.com", '
        '"firstName": "גלעד", '
        '"lastName": "ארדן", '
        '"firstNameEng": "Gilad", '
        '"lastNameEng": "Ardan", '
        '"phoneNumber": "+972521111111", '
        '"phoneNumberDialCode": "972", '
        '"phoneNumberParse": "521111111", '
        '"phoneNumberCleanLongFormat": "972521111111", '
        '"pictureUrl": "1.jpg", '
        '"cardDescription": "תיאור מפורט של כרטיס הביקור של גלעד ארדן", '
        '"internetSiteUrl": "", '
        '"address": "ויצמן 32, כפר-סבא ישראל" '
        '},'
        '{'
        '"email": "yoaz.hendel@gmail.com", '
        '"firstName": "יועז", '
        '"lastName": "הנדל", '
        '"firstNameEng": "Yoaz", '
        '"lastNameEng": "Hendel", '
        '"phoneNumber": "+972522222222", '
        '"phoneNumberDialCode": "972", '
        '"phoneNumberParse": "522222222", '
        '"phoneNumberCleanLongFormat": "972522222222", '
        '"pictureUrl": "2.jpg", '
        '"cardDescription": "תיאור מפורט של כרטיס הביקור של יועז הנדל", '
        '"internetSiteUrl": "", '
        '"address": "יפו 32 ירושלים ישראל" '
        '},'
        '{'
        '"email": "benjamin.nethanyahu@gmail.com", '
        '"firstName": "בנימין", '
        '"lastName": "נתניהו", '
        '"firstNameEng": "Benjamin", '
        '"lastNameEng": "Nethanyahu", '
        '"phoneNumber": "+972523333333", '
        '"phoneNumberDialCode": "972", '
        '"phoneNumberParse": "523333333", '
        '"phoneNumberCleanLongFormat": "972523333333", '
        '"pictureUrl": "3.jpg", '
        '"cardDescription": "תיאור מפורט של כרטיס הביקור של בנימין נתניהו", '
        '"internetSiteUrl": "", '
        '"address": "הכנסת 1, ירושלים" '
        '},'
        '{'
        '"email": "gabi.ashkenazi@gmail.com", '
        '"firstName": "גבי", '
        '"lastName": "אשכנזי", '
        '"firstNameEng": "Gabi", '
        '"lastNameEng": "Ashkenazi", '
        '"phoneNumber": "+972524444444", '
        '"phoneNumberDialCode": "972", '
        '"phoneNumberParse": "524444444", '
        '"phoneNumberCleanLongFormat": "972524444444", '
        '"pictureUrl": "4.jpg", '
        '"cardDescription": "תיאור מפורט של כרטיס הביקור של גבי אשכנזי", '
        '"internetSiteUrl": "", '
        '"address": "תל-חי 18, כפר-סבא ישראל" '
        '},'
        '{'
        '"email": "beni.gantz@gmail.com", '
        '"firstName": "בני", '
        '"lastName": "גנץ", '
        '"firstNameEng": "Beni", '
        '"lastNameEng": "Gantz", '
        '"phoneNumber": "+972525555555", '
        '"phoneNumberDialCode": "972", '
        '"phoneNumberParse": "525555555", '
        '"phoneNumberCleanLongFormat": "972525555555", '
        '"pictureUrl": "5.jpg", '
        '"cardDescription": "תיאור מפורט של כרטיס הביקור של בני גנץ", '
        '"internetSiteUrl": "", '
        '"address": "סוקולוב 6, נתניה" '
        '},'
        '{'
        '"email": "israel.katz@gmail.com", '
        '"firstName": "ישראל", '
        '"lastName": "כץ", '
        '"firstNameEng": "Israel", '
        '"lastNameEng": "Katz", '
        '"phoneNumber": "+972526666666", '
        '"phoneNumberDialCode": "972", '
        '"phoneNumberParse": "526666666", '
        '"phoneNumberCleanLongFormat": "9726666666", '
        '"pictureUrl": "6.jpg", '
        '"cardDescription": "תיאור מפורט של כרטיס הביקור של ישראל כץ", '
        '"internetSiteUrl": "", '
        '"address": "ויצמן 6, חדרה" '
        '},'
        '{'
        '"email": "omer.yankalevich@gmail.com", '
        '"firstName": "עומר", '
        '"lastName": "ינקלביץ", '
        '"firstNameEng": "Omer", '
        '"lastNameEng": "Yankalevich", '
        '"phoneNumber": "+972527777777", '
        '"phoneNumberDialCode": "972", '
        '"phoneNumberParse": "527777777", '
        '"phoneNumberCleanLongFormat": "97257777777", '
        '"pictureUrl": "7.jpg", '
        '"cardDescription": "תיאור מפורט של כרטיס הביקור של עומר ינקלביץ", '
        '"internetSiteUrl": "google.com", '
        '"address": "סוקולוב 6, רמת-השרון" '
        '},'
        '{'
        '"email": "miri.regev@gmail.com", '
        '"firstName": "מירי", '
        '"lastName": "רגב", '
        '"firstNameEng": "Miri", '
        '"lastNameEng": "Regev", '
        '"phoneNumber": "+972528888888", '
        '"phoneNumberDialCode": "972", '
        '"phoneNumberParse": "528888888", '
        '"phoneNumberCleanLongFormat": "97258888888", '
        '"pictureUrl": "7.jpg", '
        '"cardDescription": "תיאור מפורט של כרטיס הביקור של מירי רגב", '
        '"internetSiteUrl": "google.com", '
        '"address": "וינגייט 56, באר-שבע" '
        '},'
        '{'
        '"email": "yair.lapid@gmail.com", '
        '"firstName": "יאיר", '
        '"lastName": "לפיד", '
        '"firstNameEng": "yair", '
        '"lastNameEng": "Lapid", '
        '"phoneNumber": "+972529999999", '
        '"phoneNumberDialCode": "972", '
        '"phoneNumberParse": "529999999", '
        '"phoneNumberCleanLongFormat": "97259999999", '
        '"pictureUrl": "7.jpg", '
        '"cardDescription": "תיאור מפורט של כרטיס הביקור של יאיר לפיד", '
        '"internetSiteUrl": "google.com", '
        '"address": "הנשיא 6, פתח-תקווה" '
        '}'
        ']';

    return personCardListJson;
  }
  //#endregion

  //#region Get PersonCard List From Server [GET]
  // =========================================================
  Future getPersonCardListSearchFromServer(String aValueToSearch) async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        String jsonResponseForDebug = createJsonForPersonCardList();
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

}
