import 'dart:async';
import 'dart:convert';
import 'package:rotary_net/database/init_database_data.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/rotary_role_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'dart:developer' as developer;
import 'globals_service.dart';

class RotaryRoleService {

  //#region Create RotaryRole As Object
  //=============================================================================
  RotaryRoleObject createRotaryRoleAsObject(
      int aRoleId,
      String aRoleName,
      )
  {
    if (aRoleId == null)
      return RotaryRoleObject(
        roleId: 0,
        roleName: '',
      );
    else
      return RotaryRoleObject(
        roleId: aRoleId,
        roleName: aRoleName,
      );
  }
  //#endregion

  //#region Initialize Rotary Role Table Data [INIT Area BY JSON DATA]
  // ========================================================================
  Future initializeRotaryRoleTableData() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        String initializeRotaryRoleJsonForDebug = InitDataBaseData.createJsonRowsForRotaryRole();
        // print('initializeEventsJsonForDebug: initializeEventsJsonForDebug');

        //// Using JSON
        var initializeRotaryRoleListForDebug = jsonDecode(initializeRotaryRoleJsonForDebug) as List;
        List<RotaryRoleObject> rotaryRoleObjListForDebug = initializeRotaryRoleListForDebug.map((roleJsonDebug) =>
                RotaryRoleObject.fromJson(roleJsonDebug)).toList();

        rotaryRoleObjListForDebug.sort((a, b) => a.roleName.toLowerCase().compareTo(b.roleName.toLowerCase()));
        return rotaryRoleObjListForDebug;
      }
      //***** for debug *****

    }
    catch (e) {
      await LoggerService.log('<RotaryRoleService> Initialize RotaryRole Table Data >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeRotaryRoleTableData',
        name: 'RotaryRoleService',
        error: 'Initialize RotaryRole Table Data >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region insert All Started RotaryRole To DB
  Future insertAllStartedRotaryRoleToDb() async {
    List<RotaryRoleObject> starterRotaryRoleList;
    starterRotaryRoleList = await initializeRotaryRoleTableData();
    print('starterRotaryRoleList.length: ${starterRotaryRoleList.length}');

    starterRotaryRoleList.forEach((RotaryRoleObject rotaryRoleObj) async =>
            await RotaryDataBaseProvider.rotaryDB.insertRotaryRole(rotaryRoleObj));

    List<RotaryRoleObject> _rotaryRoleList = await RotaryDataBaseProvider.rotaryDB.getAllRotaryRole();
    if (_rotaryRoleList.isNotEmpty)
      print('>>>>>>>>>> _rotaryRoleList: ${_rotaryRoleList[1].roleName}');
  }
  //#endregion

  //#region Get All RotaryRole List From Server [GET]
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
  //#endregion

  //#region Get All RotaryRole List From Server [GET]
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
  //#endregion

  //#region CRUD: Area

  //#region Insert RotaryRole To DataBase [WriteToDB]
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
  //#endregion

  //#region Update RotaryRole By RoleId To DataBase [WriteToDB]
  //=============================================================================
  Future updateRotaryRoleByRoleIdToDataBase(RotaryRoleObject aRotaryRoleObj) async {
    try{
      String jsonToPost = jsonEncode(aRotaryRoleObj);

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
  //#endregion

  //#region Delete RotaryRole By RoleId From DataBase [WriteToDB]
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
  //#endregion

  //#endregion

}
