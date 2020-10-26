import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/rotary_area_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;
import 'globals_service.dart';

class RotaryAreaService {

  //#region Create RotaryArea As Object
  //=============================================================================
  RotaryAreaObject createRotaryAreaAsObject(
      String aAreaId,
      String aAreaName,
      )
  {
    if (aAreaId == null)
      return RotaryAreaObject(
        areaId: '0',
        areaName: '',
      );
    else
      return RotaryAreaObject(
        areaId: aAreaId,
        areaName: aAreaName,
      );
  }
  //#endregion

  //#region * Get All RotaryArea List (w/o Clusters) [GET]
  // =========================================================
  Future getAllRotaryAreaListFromServer() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling

      // Because of RotaryUsersListBloc >>> Need to initialize GlobalService here too
      bool debugMode = await GlobalsService.getDebugMode();
      await GlobalsService.setDebugMode(debugMode);

      if (GlobalsService.isDebugMode) {
        List<RotaryAreaObject> rotaryAreaObjListForDebug = await RotaryDataBaseProvider.rotaryDB.getAllRotaryArea();
        if (rotaryAreaObjListForDebug == null) {
        } else {
          rotaryAreaObjListForDebug.sort((a, b) => a.areaName.toLowerCase().compareTo(b.areaName.toLowerCase()));
        }

        return rotaryAreaObjListForDebug;
      } else {
        await LoggerService.log('<RotaryAreaService> Get RotaryArea List From Server >>> Failed');
        print('<RotaryAreaService> Get RotaryArea List From Server >>> Failed');
        return null;
      }
      //***** for debug *****
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Get All RotaryArea List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllRotaryAreaListFromServer',
        name: 'RotaryAreaService',
        error: 'Get All RotaryArea List From Server >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }

  Future getAllRotaryAreaList({bool withPopulate = false}) async {
    try {
      String _getUrl;

      if (withPopulate) _getUrl = Constants.rotaryAreaUrl + "/withClusters";
      else _getUrl = Constants.rotaryAreaUrl;

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryAreaService> Get All Rotary Area List >>> OK\nHeader: $contentType \nRotaryAreaListFromJSON: $jsonResponse');

        var areasList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<RotaryAreaObject> areasObjList = areasList.map((areaJson) => RotaryAreaObject.fromJson(areaJson)).toList();

        return areasObjList;
      } else {
        await LoggerService.log('<RotaryAreaService> Get All RotaryArea List >>> Failed: ${response.statusCode}');
        print('<RotaryAreaService> Get All RotaryArea List >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Get All RotaryArea List >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllRotaryAreaList',
        name: 'RotaryAreaService',
        error: 'Get All RotaryArea List From Server >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get RotaryArea By AreaId (w/o Clusters) [GET]
  // =========================================================
  Future getRotaryAreaByAreaIdFromServer(String aAreaId) async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling

      // Because of RotaryUsersListBloc >>> Need to initialize GlobalService here too
      bool debugMode = await GlobalsService.getDebugMode();
      await GlobalsService.setDebugMode(debugMode);

      if (GlobalsService.isDebugMode) {
        RotaryAreaObject rotaryAreaObj = await RotaryDataBaseProvider.rotaryDB.getRotaryAreaByAreaId(aAreaId);

        return rotaryAreaObj;
      } else {
        await LoggerService.log('<RotaryAreaService> Get RotaryArea By AreaId From Server >>> Failed');
        print('<RotaryAreaService> Get RotaryArea By AreaId From Server >>> Failed');
        return null;
      }
      //***** for debug *****
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Get All RotaryArea By AreaId From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllRotaryAreaByAreaIdFromServer',
        name: 'RotaryAreaService',
        error: 'Get All RotaryArea By AreaId From Server >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }

  Future getRotaryAreaByAreaId(String aAreaId, {bool withPopulate = false}) async {
    try {
      String _getUrl;

      if (withPopulate) _getUrl = Constants.rotaryAreaUrl + "/withClusters/$aAreaId";
      else _getUrl = Constants.rotaryAreaUrl + "/$aAreaId";

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryAreaService> Get RotaryArea By AreaId >>> OK >>> RotaryAreaFromJSON: $jsonResponse');

        var _area = jsonDecode(jsonResponse);
        RotaryAreaObject _areaObj = RotaryAreaObject.fromJson(_area);

        return _areaObj;
      } else {
        await LoggerService.log('<RotaryAreaService> Get RotaryArea By AreaId >>> Failed: ${response.statusCode}');
        print('<RotaryAreaService> Get RotaryArea By RoleId >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Get All RotaryArea By AreaId >>> ERROR: ${e.toString()}');
      developer.log(
        'getRotaryAreaByAreaId',
        name: 'RotaryAreaService',
        error: 'Get All RotaryArea By AreaId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get RotaryArea By AreaName [GET]
  // =========================================================
  Future getRotaryAreaByAreaName(String aAreaName) async {
    try {
      String _getUrl;

      _getUrl = Constants.rotaryAreaUrl + "/areaName/$aAreaName";

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryAreaService> Get RotaryArea By AreaName >>> OK >>> RotaryAreaFromJSON: $jsonResponse');

        var _area = jsonDecode(jsonResponse);
        RotaryAreaObject _areaObj = RotaryAreaObject.fromJson(_area);

        return _areaObj;
      } else {
        await LoggerService.log('<RotaryAreaService> Get RotaryArea By AreaName >>> Failed: ${response.statusCode}');
        print('<RotaryAreaService> Get RotaryArea By AreaName >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Get All RotaryArea By AreaName >>> ERROR: ${e.toString()}');
      developer.log(
        'getRotaryAreaByAreaName',
        name: 'RotaryAreaService',
        error: 'Get All RotaryArea By AreaName >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Area

  //#region * Insert RotaryArea [WriteToDB]
  //=============================================================================
  Future insertRotaryAreaToDataBase(RotaryAreaObject aRotaryAreaObj) async {
    try{
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.insertRotaryArea(aRotaryAreaObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Insert RotaryArea To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'insertRotaryAreaToDataBase',
        name: 'RotaryAreaService',
        error: 'Insert RotaryArea To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }

  Future insertRotaryArea(RotaryAreaObject aRotaryAreaObj) async {
    try {
      String jsonToPost = aRotaryAreaObj.rotaryAreaObjectToJson(aRotaryAreaObj);
      print ('insertRotaryArea / RotaryAreaObject / jsonToPost: $jsonToPost');

      Response response = await post(Constants.rotaryAreaUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('insertRotaryArea / RotaryAreaObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryAreaService> Insert RotaryArea >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryAreaService> Insert RotaryArea >>> Failed');
          print('<RotaryAreaService> Insert RotaryArea >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<RotaryAreaService> Insert RotaryArea >>> Failed >>> ${response.statusCode}');
        print('<RotaryAreaService> Insert RotaryArea >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Insert RotaryArea >>> ERROR: ${e.toString()}');
      developer.log(
        'insertRotaryArea',
        name: 'RotaryAreaService',
        error: 'Insert RotaryArea >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update RotaryArea By AreaId [WriteToDB]
  //=============================================================================
  Future updateRotaryAreaByAreaIdToDataBase(RotaryAreaObject aRotaryAreaObj) async {
    try{
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.updateRotaryAreaByAreaId(aRotaryAreaObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Update RotaryArea By AreaId To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'updateRotaryAreaByAreaIdToDataBase',
        name: 'RotaryAreaService',
        error: 'Update RotaryArea By AreaId To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }

  Future updateRotaryAreaByAreaId(RotaryAreaObject aRotaryAreaObj) async {
    try {
      String jsonToPost = aRotaryAreaObj.rotaryAreaObjectToJson(aRotaryAreaObj);
      print ('updateRotaryAreaByAreaId / RotaryAreaObject / jsonToPost: $jsonToPost');

      String _updateUrl = Constants.rotaryAreaUrl + "/${aRotaryAreaObj.areaId}";

      Response response = await put(_updateUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print('updateRotaryAreaByAreaId / RotaryAreaObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryAreaService> Update RotaryArea By AreaId >>> OK');
          return returnVal;
        } else {
          await LoggerService.log(
              '<RotaryAreaService> Update RotaryArea By AreaId >>> Failed');
          print('<RotaryAreaService> Update RotaryArea By AreaId >>> Failed');
          return null;
        }
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Update RotaryArea By AreaId >>> ERROR: ${e.toString()}');
      developer.log(
        'updateRotaryAreaByAreaIdToDataBase',
        name: 'RotaryAreaService',
        error: 'Update RotaryArea By AreaId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Delete RotaryArea By AreaId From DataBase [WriteToDB]
  //=============================================================================
  Future deleteRotaryAreaByAreaIdFromDataBase(RotaryAreaObject aRotaryAreaObj) async {
    try {
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.deleteRotaryAreaByAreaId(aRotaryAreaObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Delete Rotary Area By AreaId From DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteRotaryAreaByAreaIdFromDataBase',
        name: 'RotaryAreaService',
        error: 'Delete Rotary Area By AreaId From DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }

  Future deleteRotaryAreaByAreaId(RotaryAreaObject aRotaryAreaObj) async {
    try {
      String _deleteUrl = Constants.rotaryAreaUrl + "/${aRotaryAreaObj.areaId}";

      Response response = await delete(_deleteUrl, headers: Constants.rotaryUrlHeader);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print(
            'deleteRotaryAreaByAreaId / RotaryAreaObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log(
              '<RotaryAreaService> Delete Rotary Area By AreaId >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryAreaService> Delete Rotary Area By AreaId >>> Failed');
          print('<RotaryAreaService> Delete Rotary Area By AreaId >>> Failed');
          return null;
        }
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryAreaService> Delete Rotary Area By AreaId >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteRotaryAreaByAreaId',
        name: 'RotaryAreaService',
        error: 'Delete Rotary Area By AreaId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

}
