import 'dart:async';
import 'dart:convert';
import 'package:rotary_net/database/init_database_data.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/rotary_cluster_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'dart:developer' as developer;
import 'globals_service.dart';

class RotaryClusterService {

  //#region Create RotaryCluster As Object
  //=============================================================================
  RotaryClusterObject createRotaryClusterAsObject(
      int aAreaId,
      int aClusterId,
      String aClusterName,
      )
  {
    if (aAreaId == null)
      return RotaryClusterObject(
        areaId: 0,
        clusterId: 0,
        clusterName: '',
      );
    else
      return RotaryClusterObject(
        areaId: aAreaId,
        clusterId: aClusterId,
        clusterName: aClusterName,
      );
  }
  //#endregion

  //#region Initialize Rotary Cluster Table Data [INIT Cluster BY JSON DATA]
  // ========================================================================
  Future initializeRotaryClusterTableData() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        String initializeRotaryClusterJsonForDebug = InitDataBaseData.createJsonRowsForRotaryCluster();
        // print('initializeEventsJsonForDebug: initializeEventsJsonForDebug');

        //// Using JSON
        var initializeRotaryClusterListForDebug = jsonDecode(initializeRotaryClusterJsonForDebug) as List;    // List of Cluster to display;
        List<RotaryClusterObject> rotaryClusterObjListForDebug = initializeRotaryClusterListForDebug.map((clusterJsonDebug) =>
                  RotaryClusterObject.fromJson(clusterJsonDebug)).toList();
        // print('eventObjListForDebug.length: ${eventObjListForDebug.length}');

        rotaryClusterObjListForDebug.sort((a, b) => a.clusterName.toLowerCase().compareTo(b.clusterName.toLowerCase()));
        return rotaryClusterObjListForDebug;
      }
      //***** for debug *****

    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Initialize RotaryCluster Table Data >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeRotaryClusterTableData',
        name: 'RotaryClusterService',
        error: 'Initialize RotaryCluster Table Data >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region insert All Started RotaryCluster To DB
  Future insertAllStartedRotaryClusterToDb() async {
    List<RotaryClusterObject> starterRotaryClusterList;
    starterRotaryClusterList = await initializeRotaryClusterTableData();
    print('starterRotaryClusterList.length: ${starterRotaryClusterList.length}');

    starterRotaryClusterList.forEach((RotaryClusterObject rotaryClusterObj) async =>
            await RotaryDataBaseProvider.rotaryDB.insertRotaryCluster(rotaryClusterObj));

    List<RotaryClusterObject> _rotaryClusterList = await RotaryDataBaseProvider.rotaryDB.getAllRotaryCluster();
    if (_rotaryClusterList.isNotEmpty)
      print('>>>>>>>>>> _rotaryClusterList: ${_rotaryClusterList[1].clusterName}');
  }
  //#endregion

  //#region Get All RotaryCluster List From Server [GET]
  // =========================================================
  Future getAllRotaryClusterListFromServer() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling

      // Because of RotaryUsersListBloc >>> Need to initialize GlobalService here too
      bool debugMode = await GlobalsService.getDebugMode();
      await GlobalsService.setDebugMode(debugMode);

      if (GlobalsService.isDebugMode) {
        List<RotaryClusterObject> rotaryClusterObjListForDebug = await RotaryDataBaseProvider.rotaryDB.getAllRotaryCluster();
        if (rotaryClusterObjListForDebug == null) {
        } else {
          rotaryClusterObjListForDebug.sort((a, b) => a.clusterName.toLowerCase().compareTo(b.clusterName.toLowerCase()));
        }

        return rotaryClusterObjListForDebug;
      } else {
        await LoggerService.log('<RotaryClusterService> Get RotaryCluster List From Server >>> Failed');
        print('<RotaryClusterService> Get RotaryCluster List From Server >>> Failed');
        return null;
      }
      //***** for debug *****
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Get All RotaryCluster List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllRotaryClusterListFromServer',
        name: 'RotaryClusterService',
        error: 'Get All RotaryCluster List From Server >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Get All RotaryCluster By AreaClusterId From Server [GET]
  // =========================================================
  Future getRotaryAreaByAreaClusterIdFromServer(int aAreaId, int aClusterId) async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling

      // Because of RotaryUsersListBloc >>> Need to initialize GlobalService here too
      bool debugMode = await GlobalsService.getDebugMode();
      await GlobalsService.setDebugMode(debugMode);

      if (GlobalsService.isDebugMode) {
        RotaryClusterObject rotaryClusterObj = await RotaryDataBaseProvider.rotaryDB.getRotaryClusterByAreaClusterId(aAreaId, aClusterId);

        return rotaryClusterObj;
      } else {
        await LoggerService.log('<RotaryClusterService> Get RotaryCluster By AreaClusterId From Server >>> Failed');
        print('<RotaryClusterService> Get RotaryCluster By AreaClusterId From Server >>> Failed');
        return null;
      }
      //***** for debug *****
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Get All RotaryCluster By AreaClusterId From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllRotaryAreaByAreaClusterIdFromServer',
        name: 'RotaryClusterService',
        error: 'Get All RotaryCluster By AreaClusterId From Server >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Cluster

  //#region Insert RotaryCluster To DataBase [WriteToDB]
  //=============================================================================
  Future insertRotaryClusterToDataBase(RotaryClusterObject aRotaryClusterObj) async {
    try{
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.insertRotaryCluster(aRotaryClusterObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Insert RotaryCluster To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'insertRotaryClusterToDataBase',
        name: 'RotaryClusterService',
        error: 'Insert RotaryCluster To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Update RotaryCluster By AreaClusterId To DataBase [WriteToDB]
  //=============================================================================
  Future updateRotaryClusterByAreaClusterIdToDataBase(RotaryClusterObject aRotaryClusterObj) async {
    try{
      String jsonToPost = jsonEncode(aRotaryClusterObj);

      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.updateRotaryClusterByAreaClusterId(aRotaryClusterObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Update RotaryCluster By AreaClusterId To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'updateRotaryClusterByAreaClusterIdToDataBase',
        name: 'RotaryClusterService',
        error: 'Update RotaryCluster By AreaClusterId To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Delete RotaryCluster By AreaClusterId From DataBase [WriteToDB]
  //=============================================================================
  Future deleteRotaryClusterByAreaClusterIdFromDataBase(RotaryClusterObject aRotaryClusterObj) async {
    try{
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.deleteRotaryClusterByAreaClusterId(aRotaryClusterObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Delete Rotary Cluster By AreaClusterId From DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteRotaryClusterByAreaClusterIdFromDataBase',
        name: 'RotaryClusterService',
        error: 'Delete Rotary Cluster By AreaClusterId From DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
//#endregion

//#endregion

}
