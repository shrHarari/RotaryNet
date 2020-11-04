import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/objects/message_populated_object.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/person_card_populated_object.dart';
import 'package:rotary_net/objects/person_card_role_and_hierarchy_object.dart';
import 'package:rotary_net/objects/rotary_area_object.dart';
import 'package:rotary_net/objects/rotary_club_object.dart';
import 'package:rotary_net/objects/rotary_cluster_object.dart';
import 'package:rotary_net/objects/rotary_role_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/services/rotary_area_service.dart';
import 'package:rotary_net/services/rotary_club_service.dart';
import 'package:rotary_net/services/rotary_cluster_service.dart';
import 'package:rotary_net/services/rotary_role_service.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

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
        );
    }
  //#endregion

  //#region * Get PersonCards List By Search Query (w/o Populate) [GET]
  // ==================================================================
  Future getPersonCardsListBySearchQuery(String aValueToSearch, {bool withPopulate = false}) async {
    try {
      String _getUrl;

      if (withPopulate) _getUrl = Constants.rotaryPersonCardUrl + "/query/$aValueToSearch/populated";
      else _getUrl = Constants.rotaryPersonCardUrl + "/query/$aValueToSearch";
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

  //#region * Get PersonCards List By Role Hierarchy Permission [GET]
  // ==================================================================
  Future getPersonCardListByRoleHierarchyPermission(PersonCardRoleAndHierarchyIdObject aPersonCardRoleAndHierarchyIdObject) async {
    try {
      /// RoleEnum: Convert [int] to [EnumValue]
      Constants.RotaryRolesEnum _roleEnum;
      Constants.RotaryRolesEnum _roleEnumValue = _roleEnum.convertToEnum(aPersonCardRoleAndHierarchyIdObject.roleEnum);

      String _getUrl;

      switch (_roleEnumValue) {
        case Constants.RotaryRolesEnum.RotaryManager:
          _getUrl = Constants.rotaryPersonCardUrl + "/roleHierarchyByAll";
          break;
        case Constants.RotaryRolesEnum.AreaManager:
          _getUrl = Constants.rotaryPersonCardUrl + "/roleHierarchyByAreaId/${aPersonCardRoleAndHierarchyIdObject.areaId}";
          break;
        case Constants.RotaryRolesEnum.ClusterManager:
          _getUrl = Constants.rotaryPersonCardUrl + "/roleHierarchyByClusterId/${aPersonCardRoleAndHierarchyIdObject.clusterId}";
          break;
        case Constants.RotaryRolesEnum.ClubManager:
          _getUrl = Constants.rotaryPersonCardUrl + "/roleHierarchyByClubId/${aPersonCardRoleAndHierarchyIdObject.clubId}";
          break;

        case Constants.RotaryRolesEnum.Gizbar:
        case Constants.RotaryRolesEnum.Member:
        default:
          return [];
      }
      print ("_getUrl: $_getUrl");

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<PersonCardService> Get PersonCardsList By Role Hierarchy Permission >>> OK\nHeader: $contentType \nPersonCardsListFromJSON: $jsonResponse');

        // var personCardsIdList = jsonDecode(jsonResponse) as List;
        List<dynamic> personCardsIdList = jsonDecode(jsonResponse) as List;

        return personCardsIdList;
      } else {
        await LoggerService.log('<PersonCardService> Get PersonCardsList By Role Hierarchy Permission >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCardsList By Role Hierarchy Permission >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Get PersonCardsList By Role Hierarchy Permission >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonCardListByRoleHierarchyPermission',
        name: 'PersonCardService',
        error: 'Get PersonCardsList By Role Hierarchy Permission >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get Person Card By PersonId [GET]
  // =========================================================
  Future getPersonCardByPersonId(String aPersonCardId, {bool withPopulate = false}) async {
    try {
      String _getUrl;

      if (withPopulate) _getUrl = Constants.rotaryPersonCardUrl + "/personCardId/$aPersonCardId/populated";
      else _getUrl = Constants.rotaryPersonCardUrl + "/personCardId/$aPersonCardId";
      print ("_getUrl: $_getUrl");

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;

        if (jsonResponse != "")
        {
          await LoggerService.log('<PersonCardService> Get PersonCard By PersonId >>> OK >>> PersonCardFromJSON: $jsonResponse');

          var _personCard = jsonDecode(jsonResponse);
          PersonCardObject _personObj = PersonCardObject.fromJson(_personCard);

          return _personObj;
        } else {
          await LoggerService.log('<PersonCardService>  Get PersonCard By PersonId >>> Failed');
          print('<PersonCardService>  Get PersonCard By PersonId >>> Failed');
          // Return Empty PersonCardObject
          return null;
        }
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

  //#region * Get PersonCard By Id Populated [GET]
  // ========================================================================

  //#region Get PersonCard By Id Populated [PersonCard + Populate All Fields without Messages]
  Future getPersonCardByIdPopulated(String aPersonCardId) async {
    try {
      String _getUrl = Constants.rotaryPersonCardUrl + "/personCardId/$aPersonCardId/populated";
      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        if (jsonResponse != "")
        {
          await LoggerService.log('<PersonCardService> Get PersonCard By Id Populated >>> OK >>> PersonCardPopulatedFromJSON: $jsonResponse');

          var _personCardPopulated = jsonDecode(jsonResponse);
          PersonCardPopulatedObject _personCardPopulatedObj = PersonCardPopulatedObject.fromJson(_personCardPopulated);

          return _personCardPopulatedObj;
        } else {
          await LoggerService.log('<PersonCardService>  Get PersonCard By Id Populated >>> Failed');
          print('<PersonCardService>  Get PersonCard By Id Populated >>> Failed');

          return null;  // Return Empty PersonCardObject
        }
      } else {
        await LoggerService.log('<PersonCardService> Get PersonCard By Id Populated >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCard By Id Populated >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Get PersonCard By Id Populated >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonCardByIdPopulated',
        name: 'PersonCardService',
        error: 'Get PersonCard By Id Populated >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Get PersonCard By Id Message Populated [PersonCard + Populate Only Messages List]
  Future getPersonCardByIdMessagePopulated(String aPersonCardId) async {
    try {
      String _getUrl = Constants.rotaryPersonCardUrl + "/personCardId/$aPersonCardId/message_populated";
      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        if (jsonResponse != "")
        {
          await LoggerService.log('<PersonCardService> Get PersonCard By Id Message Populated >>> OK >>> JSON: $jsonResponse');

          var _personCardPopulated = jsonDecode(jsonResponse);
          var messagesObjectList;
          if (_personCardPopulated['messages'] != null) {
            messagesObjectList = _personCardPopulated['messages'] as List;
          } else {
            messagesObjectList = [];
          }

          return messagesObjectList;
        } else {
          await LoggerService.log('<PersonCardService>  Get PersonCard By Id Message Populated >>> Failed');
          print('<PersonCardService>  Get PersonCard By Id Message Populated >>> Failed');
          // Return Empty PersonCardObject
          return null;
        }
      } else {
        await LoggerService.log('<PersonCardService> Get PersonCard By Id Message Populated >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCard By Id Message Populated >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Get PersonCard By Id Message Populated >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonCardByIdMessagePopulated',
        name: 'PersonCardService',
        error: 'Get PersonCard By Id Populated >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Get PersonCard By Id All Populated [PersonCard + Populate All Fields]
  Future getPersonCardByIdAllPopulated(String aPersonCardId) async {
    try {
      String _getUrl = Constants.rotaryPersonCardUrl + "/personCardId/$aPersonCardId/all_populated";
      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        if (jsonResponse != "")
        {
          await LoggerService.log('<PersonCardService> Get PersonCard By Id ALL Populated >>> OK >>> PersonCardPopulatedFromJSON: $jsonResponse');

          var _personCardPopulated = jsonDecode(jsonResponse);
          PersonCardPopulatedObject _personCardPopulatedObj = PersonCardPopulatedObject.fromJsonAllPopulated(_personCardPopulated);

          return _personCardPopulatedObj;
        } else {
          await LoggerService.log('<PersonCardService>  Get PersonCard By Id ALL Populated >>> Failed');
          print('<PersonCardService>  Get PersonCard By Id ALL Populated >>> Failed');
          // Return Empty PersonCardObject
          return null;
        }
      } else {
        await LoggerService.log('<PersonCardService> Get PersonCard By Id ALL Populated >>> Failed: ${response.statusCode}');
        print('<PersonCardService> Get PersonCard By Id Populated >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Get PersonCard By Id ALL Populated >>> ERROR: ${e.toString()}');
      developer.log(
        'getPersonCardByIdAllPopulated',
        name: 'PersonCardService',
        error: 'Get PersonCard By Id ALL Populated >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

  //#region CRUD: Person Card

  //#region * Insert PersonCard [WriteToDB]
  //=============================================================================
  Future insertPersonCard(String aUserId, PersonCardObject aPersonCardObj) async {
    try {
      String _getUrl = Constants.rotaryPersonCardUrl + "/userId/$aUserId";
      print ("_getUrl: $_getUrl");

      String jsonToPost = aPersonCardObj.personCardToJson(aPersonCardObj);
      print ('insertPersonCard / PersonCardObject / jsonToPost: $jsonToPost');

      Response response = await post(_getUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print('insertPersonCard / PersonCardObject / jsonResponse: $jsonResponse');

        await LoggerService.log('<PersonCardService> Insert PersonCard By Id >>> OK');
        return jsonResponse;
      } else {
        await LoggerService.log('<PersonCardService> Insert PersonCard By Id >>> Failed >>> ${response.statusCode}');
        print('<PersonCardService> Insert PersonCard By Id >>> Failed >>> ${response.statusCode}');
        return null;
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

      /// Convert PersonCardObj.personCardId[InitValue] ===>>> User._id
      UserService userService = UserService();
      UserObject userObj;
      userObj = await userService.getUserByEmail(aPersonCardObj.email);

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

      String _getUrl = Constants.rotaryPersonCardUrl + "/userId/${userObj.userGuidId}";
      print ("_getUrl: $_getUrl");

      String jsonToPost = aPersonCardObj.personCardToJson(aPersonCardObj);

      Response response = await post(_getUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        await LoggerService.log('<PersonCardService> Insert PersonCard OnInitialize DataBase >>> OK');
        return jsonResponse;
      } else {
        await LoggerService.log('<PersonCardService> Insert PersonCard By Id >>> Failed >>> ${response.statusCode}');
        print('<PersonCardService> Insert PersonCard By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<PersonCardService> Insert PersonCard >>> ERROR: ${e.toString()}');
      developer.log(
        'insertPersonCardOnInitializeDataBase',
        name: 'PersonCardService',
        error: 'Insert PersonCard >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update PersonCard By Id [WriteToDB]
  //=============================================================================
  Future updatePersonCardById(PersonCardObject aPersonCardObj) async {
    try {
      // Convert PersonCardObject To Json
      String jsonToPost = aPersonCardObj.personCardToJson(aPersonCardObj);
      print ('updatePersonCardById / PersonCardObject / jsonToPost: $jsonToPost');

      String _updateUrl = Constants.rotaryPersonCardUrl + "/${aPersonCardObj.personCardGuidId}";

      Response response = await put(_updateUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('<PersonCardService> Update PersonCard By Id >>> PersonCardObject / jsonResponse: $jsonResponse');

        await LoggerService.log('<PersonCardService> Update PersonCard By Id >>> OK');
        return jsonResponse;
      } else {
        await LoggerService.log('<PersonCardService> Update PersonCard By Id >>> Failed >>> ${response.statusCode}');
        print('<PersonCardService> Update PersonCard By Id >>> Failed >>> ${response.statusCode}');
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
  Future deletePersonCardById(PersonCardObject aPersonCardObj) async {
    try {
      String _deleteUrl = Constants.rotaryPersonCardUrl + "/${aPersonCardObj.personCardGuidId}";

      Response response = await delete(_deleteUrl, headers: Constants.rotaryUrlHeader);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('deletePersonCardById / PersonCardObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<PersonCardService> Delete PersonCard By Id >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<PersonCardService> Delete PersonCard By Id >>> Failed');
          print('<PersonCardService> Delete PersonCard By Id >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<PersonCardService> Delete PersonCard By Id >>> Failed >>> ${response.statusCode}');
        print('<PersonCardService> Delete PersonCard By Id >>> Failed >>> ${response.statusCode}');
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
