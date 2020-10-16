import 'dart:async';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/rotary_area_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'dart:developer' as developer;
import 'globals_service.dart';

class RotaryAreaService {

  //#region Create RotaryArea As Object
  //=============================================================================
  RotaryAreaObject createRotaryAreaAsObject(
      int aAreaId,
      String aAreaName,
      )
  {
    if (aAreaId == null)
      return RotaryAreaObject(
        areaId: 0,
        areaName: '',
      );
    else
      return RotaryAreaObject(
        areaId: aAreaId,
        areaName: aAreaName,
      );
  }
  //#endregion

  //#region Get All RotaryArea List From Server [GET]
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
  //#endregion

  //#region Get RotaryArea By AreaId From Server [GET]
  // =========================================================
  Future getRotaryAreaByAreaIdFromServer(int aAreaId) async {
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
  //#endregion

  //#region CRUD: Area

  //#region Insert RotaryArea To DataBase [WriteToDB]
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
  //#endregion

  //#region Update RotaryArea By AreaId To DataBase [WriteToDB]
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
  //#endregion

  //#region Delete RotaryArea By AreaId From DataBase [WriteToDB]
  //=============================================================================
  Future deleteRotaryAreaByAreaIdFromDataBase(RotaryAreaObject aRotaryAreaObj) async {
    try{
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
  //#endregion

  //#endregion

}
