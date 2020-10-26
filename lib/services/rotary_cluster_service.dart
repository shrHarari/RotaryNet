import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/rotary_cluster_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;
import 'globals_service.dart';

class RotaryClusterService {

  //#region Create RotaryCluster As Object
  //=============================================================================
  RotaryClusterObject createRotaryClusterAsObject(
      String aAreaId,
      String aClusterId,
      String aClusterName,
      )
  {
    if (aAreaId == null)
      return RotaryClusterObject(
        areaId: '0',
        clusterId: '0',
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

  //#region * Get All RotaryCluster List (w/o Clubs) [GET]
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

  Future getAllRotaryClusterList({bool withPopulate = false}) async {
    try {
      String _getUrl;

      if (withPopulate) _getUrl = Constants.rotaryClusterUrl + "/withClubs";
      else _getUrl = Constants.rotaryClusterUrl;

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryClusterService> Get All Rotary Cluster List >>> OK\nHeader: $contentType \nRotaryClusterListFromJSON: $jsonResponse');

        var clustersList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<RotaryClusterObject> clustersObjList = clustersList.map((clusterJson) => RotaryClusterObject.fromJson(clusterJson)).toList();

        return clustersObjList;
      } else {
        await LoggerService.log('<RotaryClusterService> Get All RotaryCluster List >>> Failed: ${response.statusCode}');
        print('<RotaryClusterService> Get All RotaryCluster List >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Get All RotaryCluster List >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllRotaryClusterList',
        name: 'RotaryClusterService',
        error: 'Get All RotaryCluster List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get RotaryCluster By ClusterId (w/o Clubs) [GET]
  // =========================================================
  Future getRotaryClusterByAreaClusterIdFromServer(String aAreaId, String aClusterId) async {
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

  Future getRotaryClusterByAreaClusterId(String aAreaId, String aClusterId, {bool withPopulate = false}) async {
    try {
      String _getUrl;

      if (withPopulate) _getUrl = Constants.rotaryClusterUrl + "/withClubs/$aClusterId";
      else _getUrl = Constants.rotaryClusterUrl + "/$aClusterId";

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        print("getRotaryClusterByClusterId/ jsonResponse: $jsonResponse");
        await LoggerService.log('<RotaryClusterService> Get RotaryCluster By ClusterId >>> OK >>> RotaryClusterFromJSON: $jsonResponse');

        var _cluster = jsonDecode(jsonResponse);
        RotaryClusterObject _clusterObj = RotaryClusterObject.fromJson(_cluster);

        return _clusterObj;
      } else {
        await LoggerService.log('<RotaryClusterService> Get RotaryCluster By ClusterId >>> Failed: ${response.statusCode}');
        print('<RotaryClusterService> Get ClusterId By RoleId >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Get All RotaryCluster By ClusterId >>> ERROR: ${e.toString()}');
      developer.log(
        'getRotaryClusterByClusterId',
        name: 'RotaryClusterService',
        error: 'Get All RotaryCluster By ClusterId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get RotaryCluster By ClusterName [GET]
  // =========================================================
  Future getRotaryClusterByClusterName(String aClusterName) async {
    try {
      String _getUrl;

      _getUrl = Constants.rotaryClusterUrl + "/clusterName/$aClusterName";

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryClusterService> Get RotaryCluster By ClusterName >>> OK >>> RotaryClusterFromJSON: $jsonResponse');

        var _cluster = jsonDecode(jsonResponse);
        RotaryClusterObject _clusterObj = RotaryClusterObject.fromJson(_cluster);

        return _clusterObj;
      } else {
        await LoggerService.log('<RotaryClusterService> Get RotaryCluster By ClusterName >>> Failed: ${response.statusCode}');
        print('<RotaryClusterService> Get RotaryCluster By ClusterName >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Get RotaryCluster By ClusterName >>> ERROR: ${e.toString()}');
      developer.log(
        'getRotaryClusterByClusterName',
        name: 'RotaryClusterService',
        error: 'Get RotaryCluster By ClusterName >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Cluster

  //#region * Insert RotaryCluster [WriteToDB]
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

  Future insertRotaryCluster(RotaryClusterObject aRotaryClusterObj) async {
    try{
      String jsonToPost = aRotaryClusterObj.rotaryClusterObjectToJson(aRotaryClusterObj);
      print ('insertRotaryCluster / RotaryClusterObject / jsonToPost: $jsonToPost');

      Response response = await post(Constants.rotaryClusterUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('insertRotaryCluster / RotaryClusterObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryClusterService> Insert RotaryCluster >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryClusterService> Insert RotaryCluster >>> Failed');
          print('<RotaryClusterService> Insert RotaryCluster >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<RotaryClusterService> Insert RotaryCluster >>> Failed >>> ${response.statusCode}');
        print('<RotaryClusterService> Insert RotaryCluster >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Insert RotaryCluster >>> ERROR: ${e.toString()}');
      developer.log(
        'insertRotaryCluster',
        name: 'RotaryClusterService',
        error: 'Insert RotaryCluster >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Insert RotaryCluster With Area [WriteToDB]
  //=============================================================================
  Future insertRotaryClusterWithArea(String aAreaId, RotaryClusterObject aRotaryClusterObj) async {
    try{
      String _getUrl = Constants.rotaryClusterUrl + "/areaId/$aAreaId";

      String jsonToPost = aRotaryClusterObj.rotaryClusterObjectToJson(aRotaryClusterObj);
      print ('insertRotaryClusterWithArea / RotaryClusterObject / jsonToPost: $jsonToPost');

      Response response = await post(_getUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('insertRotaryClusterWithArea / RotaryClusterObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryClusterService> Insert RotaryCluster WithArea >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryClusterService> Insert RotaryCluster WithArea >>> Failed');
          print('<RotaryClusterService> Insert RotaryCluster WithArea >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<RotaryClusterService> Insert RotaryCluster WithArea >>> Failed >>> ${response.statusCode}');
        print('<RotaryClusterService> Insert RotaryCluster WithArea >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Insert RotaryCluster WithArea >>> ERROR: ${e.toString()}');
      developer.log(
        'insertRotaryClusterWithArea',
        name: 'RotaryClusterService',
        error: 'Insert RotaryCluster WithArea >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update RotaryCluster By AreaClusterId [WriteToDB]
  //=============================================================================
  Future updateRotaryClusterByAreaClusterIdToDataBase(RotaryClusterObject aRotaryClusterObj) async {
    try{
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

  Future updateRotaryClusterByAreaClusterId(RotaryClusterObject aRotaryClusterObj) async {
    try {
      String jsonToPost = aRotaryClusterObj.rotaryClusterObjectToJson(aRotaryClusterObj);
      print ('updateRotaryClusterByAreaClusterId / RotaryClusterObject / jsonToPost: $jsonToPost');

      String _updateUrl = Constants.rotaryClusterUrl + "/${aRotaryClusterObj.clusterId}";

      Response response = await put(_updateUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print('updateRotaryClusterByAreaClusterId / RotaryClusterObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryClusterService> Update RotaryCluster By AreaClusterId >>> OK');
          return returnVal;
        } else {
          await LoggerService.log(
              '<RotaryClusterService> Update RotaryCluster By AreaClusterId >>> Failed');
          print('<RotaryClusterService> Update RotaryCluster By AreaClusterId >>> Failed');
          return null;
        }
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Update RotaryCluster By AreaClusterId >>> ERROR: ${e.toString()}');
      developer.log(
        'updateRotaryClusterByAreaClusterId',
        name: 'RotaryClusterService',
        error: 'Update RotaryCluster By AreaClusterId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Delete RotaryCluster By AreaClusterId [WriteToDB]
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

  Future deleteRotaryClusterByAreaClusterId(RotaryClusterObject aRotaryClusterObj) async {
    try {
      String _deleteUrl = Constants.rotaryClusterUrl + "/${aRotaryClusterObj.clusterId}";

      Response response = await delete(_deleteUrl, headers: Constants.rotaryUrlHeader);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print('deleteRotaryClusterByAreaClusterId / RotaryClusterObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryClusterService> Delete Rotary Cluster By AreaClusterId >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryClusterService> Delete Rotary Cluster By AreaClusterId >>> Failed');
          print('<RotaryClusterService> Delete Rotary Cluster By AreaClusterId >>> Failed');
          return null;
        }
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClusterService> Delete Rotary Cluster By AreaClusterId >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteRotaryClusterByAreaClusterId',
        name: 'RotaryClusterService',
        error: 'Delete Rotary Cluster By AreaClusterId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
//#endregion

  //#endregion

}
