import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/person_card_with_description_object.dart';
import 'package:rotary_net/objects/rotary_area_object.dart';
import 'package:rotary_net/objects/rotary_club_object.dart';
import 'package:rotary_net/objects/rotary_cluster_object.dart';
import 'package:rotary_net/objects/rotary_role_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/services/rotary_area_service.dart';
import 'package:rotary_net/services/rotary_club_service.dart';
import 'package:rotary_net/services/rotary_cluster_service.dart';
import 'package:rotary_net/services/rotary_role_service.dart';
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
      String aAreaId,
      String aClusterId,
      String aClubId,
      String aRoleId,
      // Constants.RotaryRolesEnum aRoleId
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
            areaId: null,
            clusterId: null,
            clubId: null,
            roleId: null,
            // roleEnum: null
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
            areaId: aAreaId,
            clusterId: aClusterId,
            clubId: aClubId,
            roleId: aRoleId,
            // roleEnum: aRoleId
        );
    }
  //#endregion

  //#region * Get PersonCards List By Search Query (w/o Populate) [GET]
  // ==================================================================
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
      Response response = await get(Constants.rotaryUserUrl);

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

  Future getPersonCardsListBySearchQuery(String aValueToSearch, {bool withPopulate = false}) async {
    try {
      String _getUrl;

      if (withPopulate) _getUrl = Constants.rotaryPersonUrl + "/query/$aValueToSearch/populated";
      else _getUrl = Constants.rotaryPersonUrl + "/query/$aValueToSearch";
      print ("_getUrl: $_getUrl");

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print("getPersonCardsListBySearchQuery/ jsonResponse: $jsonResponse");
        await LoggerService.log('<PersonCardService> Get PersonCardsList By SearchQuery >>> OK\nHeader: $contentType \nPersonCardsListFromJSON: $jsonResponse');

        var personCardList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<PersonCardObject> personCardObjList = personCardList.map((personCardJson) => PersonCardObject.fromJson(personCardJson)).toList();

        personCardObjList.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));

        return personCardObjList;
      } else {
        await LoggerService.log('<PersonCardService> Get PersonCardsList By SearchQuery >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCardsList By SearchQuery >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Get PersonCardsList By SearchQuery >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonCardsListBySearchQuery',
        name: 'PersonCardService',
        error: 'Get PersonCardsList By SearchQuery >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get Personal Card By PersonId [GET]
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

  Future getPersonCardByPersonId(String aPersonId, {bool withPopulate = false}) async {
    try {
      String _getUrl;

      if (withPopulate) _getUrl = Constants.rotaryPersonUrl + "/personId/$aPersonId/populated";
      else _getUrl = Constants.rotaryPersonUrl + "/$aPersonId";
      print ("_getUrl: $_getUrl");

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        print("getPersonCardByPersonId/ jsonResponse: $jsonResponse");
        await LoggerService.log('<PersonCardService> Get PersonCard By PersonId >>> OK >>> PersonCardFromJSON: $jsonResponse');

        var _personCard = jsonDecode(jsonResponse);
        print ("_personCard: $_personCard");
        PersonCardObject _personObj = PersonCardObject.fromJson(_personCard);

        print("_personObj: $_personObj");

        return _personObj;
      } else {
        await LoggerService.log('<PersonCardService> Get PersonCard By PersonId >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCard By PersonId >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Get PersonCard By PersonId >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonCardByPersonId',
        name: 'PersonCardService',
        error: 'Get PersonCard By PersonId >>> ERROR: ${e.toString()}',
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

  //#region * Insert PersonCard [WriteToDB]
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

  Future insertPersonCard(PersonCardObject aPersonCardObj) async {
    try {
      String jsonToPost = aPersonCardObj.personCardToJson(aPersonCardObj);
      print ('insertPersonCard / PersonCardObject / jsonToPost: $jsonToPost');

      Response response = await post(Constants.rotaryPersonUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print('insertPersonCard / PersonCardObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<PersonCardService> Insert PersonCard >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<PersonCardService> Insert PersonCard >>> Failed');
          print('<PersonCardService> Insert PersonCard >>> Failed');
          return null;
        }
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Insert PersonCard >>> ERROR: ${e.toString()}');
      developer.log(
        'insertPersonCard',
        name: 'PersonCardService',
        error: 'Insert PersonCard >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Insert PersonCard On InitializeDataBase [On Create DataBase]
  //=============================================================================
  Future insertPersonCardOnInitializeDataBase(PersonCardObject aPersonCardObj) async {
    try {

      /// Convert PersonCardObj.roleId[InitValue] ===>>> Role._id
      RotaryRoleService roleService = RotaryRoleService();
      RotaryRoleObject roleObj;
      roleObj = await roleService.getRotaryRoleByRoleEnum(int.parse(aPersonCardObj.roleId));
      aPersonCardObj.setRoleId(roleObj.roleId);

      /// Convert PersonCardObj.areaId[InitValue] ===>>> Area._id
      RotaryAreaService areaService = RotaryAreaService();
      RotaryAreaObject areaObj;
      areaObj = await areaService.getRotaryAreaByAreaName(aPersonCardObj.areaId);
      aPersonCardObj.setAreaId(areaObj.areaId);

      /// Convert PersonCardObj.clusterId[InitValue] ===>>> Cluster._id
      RotaryClusterService clusterService = RotaryClusterService();
      RotaryClusterObject clusterObj;
      clusterObj = await clusterService.getRotaryClusterByClusterName(aPersonCardObj.clusterId);
      aPersonCardObj.setClusterId(clusterObj.clusterId);

      /// Convert PersonCardObj.clubId[InitValue] ===>>> Club._id
      RotaryClubService clubService = RotaryClubService();
      RotaryClubObject clubObj;
      clubObj = await clubService.getRotaryClubByClubName(aPersonCardObj.clubId);
      aPersonCardObj.setClubId(clubObj.clubId);

      String jsonToPost = aPersonCardObj.personCardToJson(aPersonCardObj);

      Response response = await post(Constants.rotaryPersonUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<PersonCardService> Insert PersonCard >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<PersonCardService> Insert PersonCard >>> Failed');
          print('<PersonCardService> Insert PersonCard >>> Failed');
          return null;
        }
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Insert PersonCard >>> ERROR: ${e.toString()}');
      developer.log(
        'insertPersonCard',
        name: 'PersonCardService',
        error: 'Insert PersonCard >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update PersonCard By Id [WriteToDB]
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

  Future updatePersonCardById(PersonCardObject aPersonCardObj) async {
    try {
      // Convert ConnectedUserObject To Json
      String jsonToPost = aPersonCardObj.personCardToJson(aPersonCardObj);
      print ('updatePersonCardById / PersonCardObject / jsonToPost: $jsonToPost');

      String _updateUrl = Constants.rotaryPersonUrl + "/${aPersonCardObj.personCardGuidId}";

      Response response = await put(_updateUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('updatePersonCardById / PersonCardObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<PersonCardService> Update User By Id >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<PersonCardService> Update User By Id >>> Failed');
          print('<PersonCardService> Update User By Id >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<PersonCardService> Update User By Id >>> Failed >>> ${response.statusCode}');
        print('<PersonCardService> Update User By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Update PersonCard By Id >>> ERROR: ${e.toString()}');
      developer.log(
        'updatePersonCardById',
        name: 'PersonCardService',
        error: 'Update PersonCard By Id >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Delete PersonCard By Id [WriteToDB]
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

  Future deletePersonCardById(PersonCardObject aPersonCardObj) async {
    try {
      String _deleteUrl = Constants.rotaryPersonUrl + "/${aPersonCardObj.personCardGuidId}";

      Response response = await delete(_deleteUrl, headers: Constants.rotaryUrlHeader);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('deletePersonCardById / PersonCardObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<PersonCardService> Delete User By Id >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<PersonCardService> Delete User By Id >>> Failed');
          print('<PersonCardService> Delete User By Id >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<PersonCardService> Delete User By Id >>> Failed >>> ${response.statusCode}');
        print('<PersonCardService> Delete User By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Delete PersonCard By Id >>> ERROR: ${e.toString()}');
      developer.log(
        'deletePersonCardById',
        name: 'PersonCardService',
        error: 'Delete PersonCard By GuidId From DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

}
