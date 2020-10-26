import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/user_object.dart';
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

  //#region * Get All Users List [GET]
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

  Future getAllUsersList() async {
    try {
      Response response = await get(Constants.rotaryUserUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print("GetAllUsersListFromMongoDb/ jsonResponse: $jsonResponse");
        await LoggerService.log('<UserService> Get All Users List >>> OK\nHeader: $contentType \nUserListFromJSON: $jsonResponse');

        var userList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<UserObject> userObjList = userList.map((userJson) => UserObject.fromJson(userJson)).toList();

        userObjList.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
        print("userObjList: ${userObjList[0]}");

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

  //#region * Get Users List By Search Query From Server [GET]
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
      Response response = await get(Constants.rotaryUserUrl);

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

  //#region * Get User By SearchQuery
  Future getUsersListBySearchQuery(String aValueToSearch) async {

    try {
      String _getUrl = Constants.rotaryUserUrl + "/query/$aValueToSearch";
      print ("_getUrl: $_getUrl");

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print("getUsersListBySearchQuery/ jsonResponse: $jsonResponse");
        await LoggerService.log('<UserService> Get User By SearchQuery >>> OK\nHeader: $contentType \nUserListFromJSON: $jsonResponse');

        var userList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<UserObject> userObjList = userList.map((userJson) => UserObject.fromJson(userJson)).toList();

        userObjList.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
        print("userObjList: ${userObjList[0]}");

        return userObjList;
      } else {
        await LoggerService.log('<UserService> Get User By SearchQuery >>> Failed: ${response.statusCode}');
        print('<UserService> Get User By SearchQuery >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<UserService> Get User By SearchQuery >>> ERROR: ${e.toString()}');
      developer.log(
        'getUsersListBySearchQuery',
        name: 'UserService',
        error: 'User Object >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

  //#region * Get User By Email
  Future<UserObject> getUserByEmail(String aEmail) async {

    try {
      String _getUrl = Constants.rotaryUserUrl + "/email/$aEmail";
      print ("_getUrl: $_getUrl");

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        print("getUserByEmail/ jsonResponse: $jsonResponse");
        await LoggerService.log('<UserService> Get User By Email >>> OK >>> UserListFromJSON: $jsonResponse');

        var _user = jsonDecode(jsonResponse);
        print ("_user: $_user");
        UserObject _userObj = UserObject.fromJson(_user);

        print("userObj: $_userObj");

        return _userObj;
      } else {
        await LoggerService.log('<UserService> Get User By Email >>> Failed: ${response.statusCode}');
        print('<UserService> Get User By Email >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<UserService> Get User By Email >>> ERROR: ${e.toString()}');
      developer.log(
        'get User By Email',
        name: 'UserService',
        error: 'User Object >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Users

  //#region * Insert User [WriteToDB]
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

  Future insertUser(UserObject aUserObj) async {
    try {
      String jsonToPost = aUserObj.userToJson(aUserObj);
      print ('insertUser / UserObject / jsonToPost: $jsonToPost');

      Response response = await post(Constants.rotaryUserUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('insertUser / UserObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<UserService> Insert User >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<UserService> Insert User >>> Failed');
          print('<UserService> Insert User >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<UserService> Insert User >>> Failed >>> ${response.statusCode}');
        print('<UserService> Insert User >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<UserService> Insert User >>> Server ERROR: ${e.toString()}');
      developer.log(
        'insertUser',
        name: 'UserService',
        error: 'Insert User >>> Server ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update User By Id [WriteToDB]
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

  Future updateUserById(UserObject aUserObj) async {
    try {
      // Convert ConnectedUserObject To Json
      String jsonToPost = aUserObj.userToJson(aUserObj);
      print ('updateUserById / UserObject / jsonToPost: $jsonToPost');

      String _updateUrl = Constants.rotaryUserUrl + "/${aUserObj.userGuidId}";

      Response response = await put(_updateUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('updateUserById / UserObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<UserService> Update User By Id >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<UserService> Update User By Id >>> Failed');
          print('<UserService> Update User By Id >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<UserService> Update User By Id >>> Failed >>> ${response.statusCode}');
        print('<UserService> Update User By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<UserService> Update User By Id >>> ERROR: ${e.toString()}');
      developer.log(
        'updateUserById',
        name: 'UserService',
        error: 'Update User By Id >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Delete User By Id [WriteToDB]
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

  Future deleteUserById(UserObject aUserObj) async {
    try {
      String _deleteUrl = Constants.rotaryUserUrl + "/${aUserObj.userGuidId}";

      Response response = await delete(_deleteUrl, headers: Constants.rotaryUrlHeader);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('deleteUserById / UserObj / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<UserService> Delete User By Id >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<UserService> Delete User By Id >>> Failed');
          print('<UserService> Delete User By Id >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<UserService> Delete User By Id >>> Failed >>> ${response.statusCode}');
        print('<UserService> Delete User By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<UserService> Delete User By Id >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteUserById',
        name: 'UserService',
        error: 'Delete User By Id >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion
}
