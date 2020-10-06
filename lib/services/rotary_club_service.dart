import 'dart:async';
import 'dart:convert';
import 'package:rotary_net/database/init_database_data.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/rotary_club_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'dart:developer' as developer;
import 'globals_service.dart';

class RotaryClubService {

  //#region Create RotaryClub As Object
  //=============================================================================
  RotaryClubObject createRotaryClubAsObject(
      int aAreaId,
      int aClusterId,
      int aClubId,
      String aClubName,
      )
  {
    if (aAreaId == null)
      return RotaryClubObject(
        areaId: 0,
        clusterId: 0,
        clubId: 0,
        clubName: '',
      );
    else
      return RotaryClubObject(
        areaId: aAreaId,
        clusterId: aClusterId,
        clubId: aClubId,
        clubName: aClubName,
      );
  }
  //#endregion

  //#region Initialize Rotary Club Table Data [INIT Club BY JSON DATA]
  // ========================================================================
  Future initializeRotaryClubTableData() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        String initializeRotaryClubJsonForDebug = InitDataBaseData.createJsonRowsForRotaryClub();
        // print('initializeEventsJsonForDebug: initializeEventsJsonForDebug');

        //// Using JSON
        var initializeRotaryClubListForDebug = jsonDecode(initializeRotaryClubJsonForDebug) as List;    // List of Cluster to display;
        List<RotaryClubObject> rotaryClubObjListForDebug = initializeRotaryClubListForDebug.map((clubJsonDebug) =>
                  RotaryClubObject.fromJson(clubJsonDebug)).toList();
        // print('eventObjListForDebug.length: ${eventObjListForDebug.length}');

        rotaryClubObjListForDebug.sort((a, b) => a.clubName.toLowerCase().compareTo(b.clubName.toLowerCase()));
        return rotaryClubObjListForDebug;
      }
      //***** for debug *****

    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Initialize RotaryClub Table Data >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeRotaryClubTableData',
        name: 'RotaryClubService',
        error: 'Initialize RotaryClub Table Data >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region insert All Started RotaryClub To DB
  Future insertAllStartedRotaryClubToDb() async {
    List<RotaryClubObject> starterRotaryClubList;
    starterRotaryClubList = await initializeRotaryClubTableData();
    print('starterRotaryClubList.length: ${starterRotaryClubList.length}');

    starterRotaryClubList.forEach((RotaryClubObject rotaryClubObj) async =>
            await RotaryDataBaseProvider.rotaryDB.insertRotaryClub(rotaryClubObj));

    List<RotaryClubObject> _rotaryClubList = await RotaryDataBaseProvider.rotaryDB.getAllRotaryClub();
    if (_rotaryClubList.isNotEmpty)
      print('>>>>>>>>>> _rotaryClubList: ${_rotaryClubList[1].clubName} / ${_rotaryClubList[1].clubMail}');
  }
  //#endregion

  //#region Get All RotaryClub List From Server [GET]
  // =========================================================
  Future getAllRotaryClubListFromServer() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling

      // Because of RotaryUsersListBloc >>> Need to initialize GlobalService here too
      bool debugMode = await GlobalsService.getDebugMode();
      await GlobalsService.setDebugMode(debugMode);

      if (GlobalsService.isDebugMode) {
        List<RotaryClubObject> rotaryClubObjListForDebug = await RotaryDataBaseProvider.rotaryDB.getAllRotaryClub();
        if (rotaryClubObjListForDebug == null) {
        } else {
          rotaryClubObjListForDebug.sort((a, b) => a.clubName.toLowerCase().compareTo(b.clubName.toLowerCase()));
        }
        return rotaryClubObjListForDebug;
      } else {
        await LoggerService.log('<RotaryClubService> Get RotaryClub List From Server >>> Failed');
        print('<RotaryClubService> Get RotaryClub List From Server >>> Failed');
        return null;
      }
      //***** for debug *****
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Get All RotaryClub List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllRotaryClubListFromServer',
        name: 'RotaryClubService',
        error: 'Get All RotaryClub List From Server >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Get All RotaryClub By AreaClusterClubId From Server [GET]
  // =========================================================
  Future getRotaryClubByAreaClusterClubIdFromServer(int aAreaId, int aClusterId, int aClubId) async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling

      // Because of RotaryUsersListBloc >>> Need to initialize GlobalService here too
      bool debugMode = await GlobalsService.getDebugMode();
      await GlobalsService.setDebugMode(debugMode);

      if (GlobalsService.isDebugMode) {
        RotaryClubObject rotaryClubObj = await RotaryDataBaseProvider.rotaryDB.getRotaryClubByAreaClusterClubId(
            aAreaId, aClusterId, aClubId);

        return rotaryClubObj;
      } else {
        await LoggerService.log('<RotaryClubService> Get RotaryClub By AreaClusterClubId From Server >>> Failed');
        print('<RotaryClubService> Get RotaryClub By AreaClusterClubId From Server >>> Failed');
        return null;
      }
      //***** for debug *****
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Get All RotaryClub By AreaClusterClubId From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllRotaryClubByAreaClusterClubIdFromServer',
        name: 'RotaryClubService',
        error: 'Get All RotaryClub By AreaClusterClubId From Server >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Club

  //#region Insert RotaryClub To DataBase [WriteToDB]
  //=============================================================================
  Future insertRotaryClubToDataBase(RotaryClubObject aRotaryClubObj) async {
    try{
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.insertRotaryClub(aRotaryClubObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Insert RotaryCluster To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'insertRotaryClusterToDataBase',
        name: 'RotaryClubService',
        error: 'Insert RotaryCluster To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Update RotaryClub By AreaClusterClubId To DataBase [WriteToDB]
  //=============================================================================
  Future updateRotaryClubByAreaClusterClubIdToDataBase(RotaryClubObject aRotaryClubObj) async {
    try{
      String jsonToPost = jsonEncode(aRotaryClubObj);

      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.updateRotaryClubByAreaClusterClubId(aRotaryClubObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Update RotaryClub By AreaClusterClubId To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'updateRotaryClubByAreaClusterClubIdToDataBase',
        name: 'RotaryClubService',
        error: 'Update RotaryClub By AreaClusterClubId To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Delete RotaryClub By AreaClusterClubId From DataBase [WriteToDB]
  //=============================================================================
  Future deleteRotaryClubByAreaClusterClubIdFromDataBase(RotaryClubObject aRotaryClubObj) async {
    try{
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.deleteRotaryClubByAreaClusterClubId(aRotaryClubObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Delete Rotary Club By AreaClusterClubId From DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteRotaryClubByAreaClusterClubIdFromDataBase',
        name: 'RotaryClubService',
        error: 'Delete Rotary Club By AreaClusterClubId From DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

}
