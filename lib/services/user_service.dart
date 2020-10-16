import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/connection_service.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class UserService {

  //#region Create User As Object
  //=============================================================================
  UserObject createUserAsObject(
      String aUserGuidId,
      String aEmail,
      String aFirstName,
      String aLastName,
      String aPassword,
      Constants.UserTypeEnum aUserType,
      bool aStayConnected) {

    if (aEmail == null)
      return UserObject(
          userGuidId: '',
          email: '',
          firstName: '',
          lastName: '',
          password: '',
          userType: Constants.UserTypeEnum.Guest,
          stayConnected: false);
    else
      return UserObject(
          userGuidId: aUserGuidId,
          email: aEmail,
          firstName: aFirstName,
          lastName: aLastName,
          password: aPassword,
          userType: aUserType,
          stayConnected: aStayConnected);
  }
  //#endregion

  //#region Get All Users List From Server [GET]
  // =========================================================
  Future getAllUsersListFromServer() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        List<UserObject> userObjListForDebug = await RotaryDataBaseProvider.rotaryDB.getAllUsers();
        if (userObjListForDebug == null) {
        } else {
          userObjListForDebug.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
        }

        return userObjListForDebug;
      }
      //***** for debug *****

    }
    catch (e) {
      await LoggerService.log('<UserService> Get Get All Users List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllUsersListFromServer',
        name: 'UserService',
        error: 'Users List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Get Users List By Search Query From Server [GET]
  // =========================================================
  Future getUsersListBySearchQueryFromServer(String aValueToSearch) async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling

      // Because of RotaryUsersListBloc >>> Need to initialize GlobalService here too
      bool debugMode = await GlobalsService.getDebugMode();
      await GlobalsService.setDebugMode(debugMode);

      if (GlobalsService.isDebugMode) {
        List<UserObject> userObjListForDebug = await RotaryDataBaseProvider.rotaryDB.getUsersListBySearchQuery(aValueToSearch);
        if (userObjListForDebug == null) {
        } else {
          userObjListForDebug.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
        }

        return userObjListForDebug;
      }
      //***** for debug *****

      /// UserListUrl: 'http://.......'
      Response response = await get(Constants.rotaryGetUsersUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<UserService> Get User List By Search Query From Server >>> OK\nHeader: $contentType \nUserListFromJSON: $jsonResponse');

        var userList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<UserObject> userObjList = userList.map((userJson) => UserObject.fromJson(userJson)).toList();

        userObjList.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));

        return userObjList;

      } else {
        await LoggerService.log('<UserService> Get User List By Search Query From Server >>> Failed: ${response.statusCode}');
        print('<UserService> Get User List By Search Query From Server >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<UserService> Get User List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getUserListBySearchQueryFromServer',
        name: 'UserService',
        error: 'Users List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Get All Users List From DataBase [GET]
  // =========================================================
  Future getAllUsersListFromDataBase() async {
    try {
      Response response = await get(Constants.rotaryGetUsersUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print("GetAllUsersListFromMongoDb/ jsonResponse: $jsonResponse");
        await LoggerService.log('<UserService> Get All Users List From DataBase >>> OK\nHeader: $contentType \nUserListFromJSON: $jsonResponse');

        var userList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<UserObject> userObjList = userList.map((userJson) => UserObject.fromJson(userJson)).toList();

        // userObjList.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));

        return userObjList;
      } else {
        await LoggerService.log('<UserService> Get All Users List From DataBase >>> Failed: ${response.statusCode}');
        print('<UserService> Get All Users List From DataBase >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<UserService> Get User List From DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllUsersListFromDataBase',
        name: 'UserService',
        error: 'Users List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Users

  //#region Insert User To DataBase [WriteToDB]
  //=============================================================================
  Future insertUserToDataBase(UserObject aUserObj) async {
    try{
      var dbResult;

      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        dbResult = await RotaryDataBaseProvider.rotaryDB.insertUser(aUserObj);
        return dbResult;
      }
      //***** for debug *****
    }
    catch (e) {
      await LoggerService.log('<UserService> Insert User To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'insertUserToDataBase',
        name: 'UserService',
        error: 'Insert User To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Update User By GuidId To DataBase [WriteToDB]
  //=============================================================================
  Future updateUserByGuidIdToDataBase(UserObject aUserObj) async {
    try{
      // String jsonToPost = jsonEncode(aUserObj);

      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.updateUserByGuidId(aUserObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<UserService> Update User By GuidId To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'updateUserByGuidIdToDataBase',
        name: 'UserService',
        error: 'Update User By GuidId To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Delete User By GuidId To DataBase [WriteToDB]
  //=============================================================================
  Future deleteUserByGuidIdFromDataBase(UserObject aUserObj) async {
    try{
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.deleteUserByGuidId(aUserObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<UserService> Delete User By GuidId To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteUserByGuidIdFromDataBase',
        name: 'UserService',
        error: 'Delete User By GuidId To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion
}
