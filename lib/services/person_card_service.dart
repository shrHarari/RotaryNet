import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/database/init_database_data.dart';
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

  //#region Read PersonCard Object Data From DataBase [ReadFromDB OLD]
  //=============================================================================
  // Future<PersonCardObject> readPersonCardObjectDataFromDataBase() async {
  //   String _emailId;
  //   String _email;
  //   String _firstName;
  //   String _lastName;
  //   String _firstNameEng;
  //   String _lastNameEng;
  //   String _phoneNumber;
  //   String _phoneNumberDialCode;
  //   String _phoneNumberParse;
  //   String _phoneNumberCleanLongFormat;
  //   String _pictureUrl;
  //   String _cardDescription;
  //   String _internetSiteUrl;
  //   String _address;
  //
  //   try{
  //     _emailId = 'shr.harari@gmail.com';
  //     _email = 'shr.harari@gmail.com';
  //     _firstName = 'שחר';
  //     _lastName = 'הררי';
  //     _firstNameEng = 'Shahar';
  //     _lastNameEng = 'Harari';
  //     _phoneNumber = '+972525464640';
  //     _phoneNumberDialCode = '972';
  //     _phoneNumberParse = '525464640';
  //     _phoneNumberCleanLongFormat = '972525464640';
  //     _pictureUrl = '';
  //     _cardDescription = 'תיאור מפורט של כרטיס הביקור';
  //     _internetSiteUrl = '';
  //     _address = 'הנשיאים 6, הוד-השרון';
  //
  //     return createPersonCardAsObject(
  //         _emailId,
  //         _email,
  //         _firstName,
  //         _lastName,
  //         _firstNameEng,
  //         _lastNameEng,
  //         _phoneNumber,
  //         _phoneNumberDialCode,
  //         _phoneNumberParse,
  //         _phoneNumberCleanLongFormat,
  //         _pictureUrl,
  //         _cardDescription,
  //         _internetSiteUrl,
  //         _address);
  //   }
  //   catch  (e) {
  //     await LoggerService.log('<PersonCardService> Read PersonCard Object Data From DataBase >>> ERROR: ${e.toString()}');
  //     developer.log(
  //       'readPersonCardObjectDataFromDataBase',
  //       name: 'PersonCardService',
  //       error: 'Read PersonCard Object Data From DataBase >>> ERROR: ${e.toString()}',
  //     );
  //     return null;
  //   }
  // }
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

  //#region Get PersonCard List From Server [GET]
  // =========================================================
  Future getPersonCardsListSearchFromServer(String aValueToSearch) async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        String jsonResponseForDebug = InitDataBaseData.createJsonRowsForPersonCards();
        // String jsonResponseForDebug = createJsonForPersonCardsList();
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
      await LoggerService.log('<PersonCardService> Get PersonCard List From Server >>> ERROR: ${e.toString()}');
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
