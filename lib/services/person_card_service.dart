import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/database/init_database_data.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/person_card_with_description_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

import 'globals_service.dart';

class PersonCardService {

  //#region Create PersonCard As Object
  //=============================================================================
  PersonCardObject createPersonCardAsObject(
      String aPersonCardGuidId,
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
      String aAddress,
      Constants.RotaryRolesEnum aRoleId,
      int aAreaId,
      int aClusterId,
      int aClubId
      )
    {
      if (aPersonCardGuidId == null)
        return PersonCardObject(
            personCardGuidId: '',
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
            address: '',
            roleId: null,
            areaId: null,
            clusterId: null,
            clubId: null
        );
      else
        return PersonCardObject(
            personCardGuidId: aPersonCardGuidId,
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
            address: aAddress,
            roleId: aRoleId,
            areaId: aAreaId,
            clusterId: aClusterId,
            clubId: aClubId
        );
    }
  //#endregion

  //#region Update PersonCard Object Data To DataBase [WriteToDB]
  //=============================================================================
  Future updatePersonCardObjectDataToDataBase(PersonCardObject aPersonCardObj) async {
    try{
      String jsonToPost = jsonEncode(aPersonCardObj);
      print("updatePersonCardObjectDataToDataBase / jsonToPost: $jsonToPost");

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

  //#region Initialize PersonCards Table Data [INIT PersonCard BY JSON DATA]
  // ========================================================================
  Future initializePersonCardsTableData() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        String initializePersonCardsJsonForDebug = InitDataBaseData.createJsonRowsForPersonCards();
        // print('initializeUsersJsonForDebug: initializeUsersJsonForDebug');

        //// Using JSON
        var initializePersonCardsListForDebug = jsonDecode(initializePersonCardsJsonForDebug) as List;    // List of Users to display;
        List<PersonCardObject> personCardObjListForDebug = initializePersonCardsListForDebug.map((personJsonDebug) => PersonCardObject.fromJson(personJsonDebug)).toList();
        // print('personCardObjListForDebug.length: ${personCardObjListForDebug.length}');

        personCardObjListForDebug.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
        return personCardObjListForDebug;
      }
      //***** for debug *****

    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Get PersonCards List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'initializePersonCardsTableData',
        name: 'PersonCardService',
        error: 'PersonCards List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region insert All Started PersonCards To DB
  Future insertAllStartedPersonCardsToDb() async {
    List<PersonCardObject> starterPersonCardsList;
    starterPersonCardsList = await initializePersonCardsTableData();
    // print('starterPersonCardsList.length: ${starterPersonCardsList.length}');

    starterPersonCardsList.forEach((PersonCardObject personCardObj) async => await RotaryDataBaseProvider.rotaryDB.insertPersonCard(personCardObj));

    // List<PersonCardObject> personCardsList = await RotaryDataBaseProvider.rotaryDB.getAllPersonCards();
    // if (personCardsList.isNotEmpty)
    //   print('>>>>>>>>>> personCardsList: ${personCardsList[0].emailId}');
  }
  //#endregion

  //#region Get All PersonCards List From Server [GET]  --------->  [Not in Use]
  // =========================================================
  Future getAllPersonCardsListFromServer() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        //// Using DB
        List<PersonCardObject> personCardObjListForDebug = await RotaryDataBaseProvider.rotaryDB.getAllPersonCards();
       print('personCardObjListForDebug.length: ${personCardObjListForDebug.length}');

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
        await LoggerService.log('<PersonCardService> Get All PersonCard List From Server >>> OK\nHeader: $contentType \nPersonCardListFromJSON: $jsonResponse');

        var personCardList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<PersonCardObject> personCardObjList = personCardList.map((personCardJson) => PersonCardObject.fromJson(personCardJson)).toList();

        personCardObjList.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
//      personCardObjList.sort((a, b) {
//        return a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase());
//      });

        return personCardObjList;

      } else {
        await LoggerService.log('<PersonCardService> Get All PersonCard List From Server >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get All PersonCard List From Server >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Get All PersonCard List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllPersonCardsListFromServer',
        name: 'PersonCardService',
        error: 'PersonCards List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Get PersonCards List By Search Query From Server [GET]
  // =========================================================
  Future getPersonCardsListBySearchQueryFromServer(String aValueToSearch) async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling

      // Because of RotaryUsersListBloc >>> Need to initialize GlobalService here too
      bool debugMode = await GlobalsService.getDebugMode();
      await GlobalsService.setDebugMode(debugMode);

      if (GlobalsService.isDebugMode) {
        //// Using DB
        List<PersonCardObject> personCardObjListForDebug = await RotaryDataBaseProvider.rotaryDB.getPersonCardsListBySearchQuery(aValueToSearch);
        if (personCardObjListForDebug == null) {
          // print('>>>>>>>>>> userObjListForDebug: Empty');
        } else {
          // print('>>>>>>>>>> personCardObjListForDebug: ${personCardObjListForDebug[4].email}');
          personCardObjListForDebug.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
        }

        return personCardObjListForDebug;
      }
      //***** for debug *****

      /// UserListUrl: 'http://.......'
      Response response = await get(Constants.rotaryGetUserListUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<PersonCardService> Get PersonCards List By Search Query From Server >>> OK\nHeader: $contentType \nPersonCardsListFromJSON: $jsonResponse');

        var personCardsList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<PersonCardObject> personCardsObjList = personCardsList.map((userJson) => PersonCardObject.fromJson(userJson)).toList();

        personCardsObjList.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));

        return personCardsObjList;

      } else {
        await LoggerService.log('<PersonCardService> Get PersonCards List By Search Query From Server >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCards List By Search Query From Server >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Get PersonCards List By Search Query From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonCardsListBySearchQueryFromServer',
        name: 'PersonCardService',
        error: 'UserCards List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Get Personal Card By PersonCardGuidId From Server [GET]
  // =========================================================
  Future getPersonalCardByUserGuidIdFromServer(String aPersonCardGuidId) async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        PersonCardObject _personCardObj = await RotaryDataBaseProvider.rotaryDB.getPersonCardByGuidId(aPersonCardGuidId);
        return _personCardObj;
      }
      //***** for debug *****

      /// PersonCardListUrl: 'http://.......'
      Response response = await get(Constants.rotaryGetPersonCardListUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<PersonCardService> Get PersonCard ByPersonCardGuidId From Server >>> OK\nHeader: $contentType \nPersonCardListFromJSON: $jsonResponse');

        var personCardList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<PersonCardObject> personCardObjList = personCardList.map((personCardJson) => PersonCardObject.fromJson(personCardJson)).toList();

        return personCardObjList;

      } else {
        await LoggerService.log('<PersonCardService> Get PersonCard By PersonCardGuidId From Server >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCard By PersonCardGuidId From Server >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RegistrationService> Get PersonCard By PersonCardGuidId From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonalCardByPersonCardGuidIdFromServer',
        name: 'PersonCardService',
        error: 'PersonCard By PersonCardGuidId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Get Personal Card WithDescription By PersonCardGuidId From Server [GET]
  // ========================================================================
  Future getPersonCardWithDescriptionByGuidIdFromServer(String aPersonCardGuidId) async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        PersonCardWithDescriptionObject _personCardWithDescriptionObj =
                  await RotaryDataBaseProvider.rotaryDB.getPersonCardWithDescriptionByGuidId(aPersonCardGuidId);
        return _personCardWithDescriptionObj;
      }
      //***** for debug *****

      /// PersonCardListUrl: 'http://.......'
      Response response = await get(Constants.rotaryGetPersonCardListUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<PersonCardService> Get PersonCard ByPersonCardGuidId From Server >>> OK\nHeader: $contentType \nPersonCardListFromJSON: $jsonResponse');

        var personCardList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<PersonCardObject> personCardObjList = personCardList.map((personCardJson) => PersonCardObject.fromJson(personCardJson)).toList();

        return personCardObjList;

      } else {
        await LoggerService.log('<PersonCardService> Get PersonCard WithDescription By PersonCardGuidId From Server >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCard WithDescription From Server >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RegistrationService> Get PersonCard WithDescription By PersonCardGuidId From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonCardWithDescriptionByGuidIdFromServer',
        name: 'PersonCardService',
        error: 'PersonCard By PersonCardGuidId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Person Card

  //#region Insert PersonCard To DataBase [WriteToDB]
  //=============================================================================
  Future insertPersonCardToDataBase(PersonCardObject aPersonCardObj) async {
    try{
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.insertPersonCard(aPersonCardObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Insert PersonCard To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'insertPersonCardToDataBase',
        name: 'PersonCardService',
        error: 'Insert PersonCard To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Update PersonCard By GuidId To DataBase [WriteToDB]
  //=============================================================================
  Future updatePersonCardByGuidIdToDataBase(PersonCardObject aPersonCardObj) async {
    try{
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.updatePersonCardByGuidId(aPersonCardObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Update PersonCard By GuidId To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'updatePersonCardByGuidIdToDataBase',
        name: 'PersonCardService',
        error: 'Update PersonCard By GuidId To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Delete PersonCard By GuidId From DataBase [WriteToDB]
  //=============================================================================
  Future deletePersonCardByGuidIdFromDataBase(PersonCardObject aPersonCardObj) async {
    try{
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.deletePersonCardByGuidId(aPersonCardObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Delete PersonCard By GuidId From DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'deletePersonCardByGuidIdFromDataBase',
        name: 'PersonCardService',
        error: 'Delete PersonCard By GuidId From DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

}
