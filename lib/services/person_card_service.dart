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

  //#region Write PersonCard Object Data To DataBase [WriteToDB]
  //=============================================================================
  Future writePersonCardObjectDataToDataBase(PersonCardObject aPersonCardObj) async {
    try{

    }
    catch  (e) {
      await LoggerService.log('<PersonCardService> Write PersonCard Object Data To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'writePersonCardObjectDataToDataBase',
        name: 'PersonCardService',
        error: 'Write PersonCard Object Data To dataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Set PersonCard Data for Debug [Data]
  String createJsonForPersonCardList() {

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
          '"cardDescription": "תיאור מפורט של כרטיס הביקור של שחר הררי", '
          '"internetSiteUrl": "shahar.co.il", '
          '"address": "הנשיאים 6, הוד-השרון" '
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
        '"address": "גלעד ארדן 55, הוד-השרון" '
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
        '"address": "יועז הנדל 21, הוד-השרון" '
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
        '"address": "בנימין נתניהו 888, ירושלים" '
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
        '"address": "גבי אשכנזי 18, כפר-סבא" '
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
        '"address": "בני גנץ 99, נתניה" '
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
        '"address": "ישראל כץ 6, חדרה" '
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
        '"address": "עומר ינקלביץ 6, רמת-השרון" '
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
