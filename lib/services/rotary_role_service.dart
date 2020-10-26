import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/rotary_role_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;
import 'globals_service.dart';

class RotaryRoleService {

  //#region Create RotaryRole As Object
  //=============================================================================
  RotaryRoleObject createRotaryRoleAsObject(
      String aRoleId,
      int aRoleEnum,
      String aRoleName,
      )
  {
    if (aRoleId == null)
      return RotaryRoleObject(
        roleId: '0',
        roleEnum: 0,
        roleName: '',
      );
    else
      return RotaryRoleObject(
        roleId: aRoleId,
        roleEnum: aRoleEnum,
        roleName: aRoleName,
      );
  }
  //#endregion

  //#region * Get All RotaryRoles List [GET]
  // =========================================================
  Future getAllRotaryRoleListFromServer() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling

      // Because of RotaryUsersListBloc >>> Need to initialize GlobalService here too
      bool debugMode = await GlobalsService.getDebugMode();
      await GlobalsService.setDebugMode(debugMode);

      if (GlobalsService.isDebugMode) {
        List<RotaryRoleObject> rotaryRoleObjListForDebug = await RotaryDataBaseProvider.rotaryDB.getAllRotaryRole();
        if (rotaryRoleObjListForDebug == null) {
        } else {
          rotaryRoleObjListForDebug.sort((a, b) => a.roleName.toLowerCase().compareTo(b.roleName.toLowerCase()));
        }

        return rotaryRoleObjListForDebug;
      } else {
        await LoggerService.log('<RotaryRoleService> Get RotaryRole List From Server >>> Failed');
        print('<RotaryRoleService> Get RotaryRole List From Server >>> Failed');
        return null;
      }
      //***** for debug *****
    }
    catch (e) {
      await LoggerService.log('<RotaryRoleService> Get All RotaryRole List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllRotaryRoleListFromServer',
        name: 'RotaryRoleService',
        error: 'Get All RotaryRole List From Server >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }

  Future getAllRotaryRolesList() async {
    try {
      Response response = await get(Constants.rotaryRoleUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print("GetAllRolesListFromMongoDb/ jsonResponse: $jsonResponse");
        await LoggerService.log('<RotaryRoleService> Get All Rotary Roles List >>> OK\nHeader: $contentType \nRotaryRoleListFromJSON: $jsonResponse');

        var rolesList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<RotaryRoleObject> rolesObjList = rolesList.map((roleJson) => RotaryRoleObject.fromJson(roleJson)).toList();

        return rolesObjList;
      } else {
        await LoggerService.log('<RotaryRoleService> Get All RotaryRoles List >>> Failed: ${response.statusCode}');
        print('<RotaryRoleService> Get All RotaryRoles List >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryRoleService> Get All RotaryRoles List >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllRotaryRolesList',
        name: 'RotaryRoleService',
        error: 'Get All RotaryRoles List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get RotaryRole By RoleId [GET]
  // =========================================================
  Future getRotaryRoleByRoleIdFromServer(int aRoleId) async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling

      // Because of RotaryUsersListBloc >>> Need to initialize GlobalService here too
      bool debugMode = await GlobalsService.getDebugMode();
      await GlobalsService.setDebugMode(debugMode);

      if (GlobalsService.isDebugMode) {
        RotaryRoleObject rotaryRoleObj = await RotaryDataBaseProvider.rotaryDB.getRotaryRoleByRoleId(aRoleId);

        return rotaryRoleObj;
      } else {
        await LoggerService.log('<RotaryRoleService> Get RotaryRole By RoleId From Server >>> Failed');
        print('<RotaryRoleService> Get RotaryRole By RoleId From Server >>> Failed');
        return null;
      }
      //***** for debug *****
    }
    catch (e) {
      await LoggerService.log('<RotaryRoleService> Get All RotaryRole By RoleId From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getRotaryRoleByRoleIdFromServer',
        name: 'RotaryRoleService',
        error: 'Get All RotaryRole By RoleId From Server >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }

  Future getRotaryRoleByRoleId(String aRoleId) async {
    try {
      String _getUrl = Constants.rotaryRoleUrl + "/$aRoleId";
      print ("_getUrl: $_getUrl");

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        print("getRotaryRoleByRoleId/ jsonResponse: $jsonResponse");
        await LoggerService.log('<RotaryRoleService> Get RotaryRole By RoleId >>> OK >>> RotaryRoleFromJSON: $jsonResponse');

        var _role = jsonDecode(jsonResponse);
        print ("_role: $_role");
        RotaryRoleObject _roleObj = RotaryRoleObject.fromJson(_role);

        print("_roleObj: $_roleObj");

        return _roleObj;
      } else {
        await LoggerService.log('<RotaryRoleService> Get RotaryRole By RoleId >>> Failed: ${response.statusCode}');
        print('<RotaryRoleService> Get RotaryRole By RoleId >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryRoleService> Get Get RotaryRole By RoleId >>> ERROR: ${e.toString()}');
      developer.log(
        'getRotaryRoleByRoleId',
        name: 'RotaryRoleService',
        error: 'Get RotaryRole By RoleId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get RotaryRole By RoleEnum [GET]
  // =========================================================

  Future getRotaryRoleByRoleEnum(int aRoleEnum) async {
    try {
      String _getUrl = Constants.rotaryRoleUrl + "/roleEnum/$aRoleEnum";
      print ("_getUrl: $_getUrl");

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        print("getRotaryRoleByRoleEnum/ jsonResponse: $jsonResponse");
        await LoggerService.log('<RotaryRoleService> Get RotaryRole By RoleEnum >>> OK >>> RotaryRoleFromJSON: $jsonResponse');

        var _role = jsonDecode(jsonResponse);
        print ("_role: $_role");
        RotaryRoleObject _roleObj = RotaryRoleObject.fromJson(_role);

        print("_roleObj: $_roleObj");

        return _roleObj;
      } else {
        await LoggerService.log('<RotaryRoleService> Get RotaryRole By RoleEnum >>> Failed: ${response.statusCode}');
        print('<RotaryRoleService> Get RotaryRole By RoleEnum >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryRoleService> Get Get RotaryRole By RoleEnum >>> ERROR: ${e.toString()}');
      developer.log(
        'getRotaryRoleByRoleEnum',
        name: 'RotaryRoleService',
        error: 'Get RotaryRole By RoleEnum >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: RotaryRole

  //#region * Insert RotaryRole [WriteToDB]
  //=============================================================================
  Future insertRotaryRoleToDataBase(RotaryRoleObject aRotaryRoleObj) async {
    try{
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.insertRotaryRole(aRotaryRoleObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryRoleService> Insert RotaryRole To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'insertRotaryRoleToDataBase',
        name: 'RotaryRoleService',
        error: 'Insert RotaryRole To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }

  Future insertRotaryRole(RotaryRoleObject aRotaryRoleObj) async {
    try {
      String jsonToPost = aRotaryRoleObj.rotaryRoleObjectToJson(aRotaryRoleObj);
      print ('insertRotaryRole / RotaryRoleObject / jsonToPost: $jsonToPost');

      Response response = await post(Constants.rotaryRoleUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('insertRotaryRole / RotaryRoleObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryRoleService> Insert RotaryRole >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryRoleService> Insert RotaryRole >>> Failed');
          print('<RotaryRoleService> Insert RotaryRole >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<RotaryRoleService> Insert RotaryRole >>> Failed >>> ${response.statusCode}');
        print('<RotaryRoleService> Insert RotaryRole >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryRoleService> Insert RotaryRole >>> ERROR: ${e.toString()}');
      developer.log(
        'insertRotaryRole',
        name: 'RotaryRoleService',
        error: 'Insert RotaryRole >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update RotaryRole By RoleId [WriteToDB]
  //=============================================================================
  Future updateRotaryRoleByRoleIdToDataBase(RotaryRoleObject aRotaryRoleObj) async {
    try{
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.updateRotaryRoleByRoleId(aRotaryRoleObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Update RotaryRole By RoleId To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'updateRotaryRoleByRoleIdToDataBase',
        name: 'RotaryAreaService',
        error: 'Update RotaryRole By RoleId To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }

  Future updateRotaryRoleByRoleId(RotaryRoleObject aRotaryRoleObj) async {
    try {
      String jsonToPost = aRotaryRoleObj.rotaryRoleObjectToJson(aRotaryRoleObj);
      print ('updateRotaryRoleByRoleId / RotaryRoleObject / jsonToPost: $jsonToPost');

      String _updateUrl = Constants.rotaryRoleUrl + "/${aRotaryRoleObj.roleId}";

      Response response = await put(_updateUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print('updateRotaryRole / RotaryRoleObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryRoleService> Update RotaryRole By RoleId >>> OK');
          return returnVal;
        } else {
          await LoggerService.log(
              '<RotaryRoleService> Update RotaryRole By RoleId >>> Failed');
          print('<RotaryRoleService> Update RotaryRole By RoleId >>> Failed');
          return null;
        }
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryRoleService> Update RotaryRole By RoleId >>> ERROR: ${e.toString()}');
      developer.log(
        'updateRotaryRoleByRoleId',
        name: 'RotaryRoleService',
        error: 'Update RotaryRole By RoleId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Delete RotaryRole By RoleId [WriteToDB]
  //=============================================================================
  Future deleteRotaryRoleByRoleIdFromDataBase(RotaryRoleObject aRotaryRoleObj) async {
    try{
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.deleteRotaryRoleByRoleId(aRotaryRoleObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryRoleService> Delete Rotary Role By RoleId From DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteRotaryRoleByRoleIdFromDataBase',
        name: 'RotaryRoleService',
        error: 'Delete Rotary Role By RoleId From DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }

  Future deleteRotaryRoleByRoleId(RotaryRoleObject aRotaryRoleObj) async {
    try {
      String _deleteUrl = Constants.rotaryRoleUrl + "/${aRotaryRoleObj.roleId}";

      Response response = await delete(_deleteUrl, headers: Constants.rotaryUrlHeader);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('deleteRotaryRoleByRoleId / RotaryRoleObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryRoleService> Delete RotaryRole By RoleId >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryRoleService> Delete RotaryRole By RoleId >>> Failed');
          print('<RotaryRoleService> Delete RotaryRole By RoleId >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<UserService> Delete RotaryRole By RoleId >>> Failed >>> ${response.statusCode}');
        print('<UserService> Delete RotaryRole By RoleId >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryRoleService> Delete Rotary Role By RoleId >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteRotaryRoleByRoleId',
        name: 'RotaryRoleService',
        error: 'Delete Rotary Role By RoleId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

}
