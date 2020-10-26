import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/rotary_club_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;
import 'globals_service.dart';

class RotaryClubService {

  //#region Create RotaryClub As Object
  //=============================================================================
  RotaryClubObject createRotaryClubAsObject(
      String aAreaId,
      String aClusterId,
      String aClubId,
      String aClubName,
      )
  {
    if (aAreaId == null)
      return RotaryClubObject(
        // areaId: 0,
        // clusterId: 0,
        clubId: '0',
        clubName: '',
      );
    else
      return RotaryClubObject(
        // areaId: aAreaId,
        // clusterId: aClusterId,
        clubId: aClubId,
        clubName: aClubName,
      );
  }
  //#endregion

  //#region * Get All RotaryClub List [GET]
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

  Future getAllRotaryClubList() async {
    try {
      Response response = await get(Constants.rotaryClubUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryClubService> Get All Rotary Club List >>> OK\nHeader: $contentType \nRotaryClubListFromJSON: $jsonResponse');

        var clubsList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<RotaryClubObject> clubsObjList = clubsList.map((clubJson) => RotaryClubObject.fromJson(clubJson)).toList();

        return clubsObjList;
      } else {
        await LoggerService.log('<RotaryClubService> Get All RotaryClub List >>> Failed: ${response.statusCode}');
        print('<RotaryClubService> Get All RotaryArea List >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Get All RotaryClub List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getAllRotaryClubListFromServer',
        name: 'RotaryClubService',
        error: 'Get All RotaryClub List From Server >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get RotaryClub By AreaClusterClubId [GET]
  // =========================================================
  Future getRotaryClubByAreaClusterClubIdFromServer(String aAreaId, String aClusterId, String aClubId) async {
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

  Future getRotaryClubByAreaClusterClubId(String aAreaId, String aClusterId, String aClubId) async {
    try {
      String _getUrl = Constants.rotaryClubUrl + "/$aClubId";

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryClubService> Get All RotaryClub By AreaClusterClubId >>> OK >>> RotaryClubFromJSON: $jsonResponse');

        var _club = jsonDecode(jsonResponse);
        RotaryClubObject _clubObj = RotaryClubObject.fromJson(_club);

        return _clubObj;
      } else {
        await LoggerService.log('<RotaryClubService> Get All RotaryClub By AreaClusterClubId >>> Failed: ${response.statusCode}');
        print('<RotaryClubService> Get All RotaryClub By AreaClusterClubId >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Get All RotaryClub By AreaClusterClubId >>> ERROR: ${e.toString()}');
      developer.log(
        'getRotaryClubByAreaClusterClubId',
        name: 'RotaryClubService',
        error: 'Get All RotaryClub By AreaClusterClubId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get RotaryClub By ClubName [GET]
  // =========================================================
  Future getRotaryClubByClubName(String aClubName) async {
    try {
      String _getUrl = Constants.rotaryClubUrl + "/clubName/$aClubName";

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        String jsonResponse = response.body;
        await LoggerService.log('<RotaryClubService> Get RotaryClub By ClubName >>> OK >>> RotaryClubFromJSON: $jsonResponse');

        var _club = jsonDecode(jsonResponse);
        RotaryClubObject _clubObj = RotaryClubObject.fromJson(_club);

        return _clubObj;
      } else {
        await LoggerService.log('<RotaryClubService> Get RotaryClub By ClubName >>> Failed: ${response.statusCode}');
        print('<RotaryClubService> Get RotaryClub By ClubName >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Get RotaryClub By ClubName >>> ERROR: ${e.toString()}');
      developer.log(
        'getRotaryClubByClubName',
        name: 'RotaryClubService',
        error: 'Get RotaryClub By ClubName >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Club

  //#region * Insert RotaryClub [WriteToDB]
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

  Future insertRotaryClub(RotaryClubObject aRotaryClubObj) async {
    try{
      String jsonToPost = aRotaryClubObj.rotaryClubObjectToJson(aRotaryClubObj);
      print ('insertRotaryClub / RotaryAreaObject / jsonToPost: $jsonToPost');

      Response response = await post(Constants.rotaryClubUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('insertRotaryClub / RotaryClubObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryClubObject> Insert RotaryClub >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryClubService> Insert RotaryClub >>> Failed');
          print('<RotaryClubService> Insert RotaryClub >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<RotaryClubService> Insert RotaryClub >>> Failed >>> ${response.statusCode}');
        print('<RotaryClubService> Insert RotaryClub >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Insert RotaryClub >>> ERROR: ${e.toString()}');
      developer.log(
        'insertRotaryClub',
        name: 'RotaryClubService',
        error: 'Insert RotaryClub >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Insert RotaryClub With Cluster [WriteToDB]
  //=============================================================================
  Future insertRotaryClubWithCluster(String aClusterId, RotaryClubObject aRotaryClubObj) async {
    try{
      String _getUrl = Constants.rotaryClubUrl + "/clusterId/$aClusterId";

      String jsonToPost = aRotaryClubObj.rotaryClubObjectToJson(aRotaryClubObj);
      print ('insertRotaryClubWithCluster / RotaryClubObject / jsonToPost: $jsonToPost');

      Response response = await post(_getUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('insertRotaryClubWithCluster / RotaryClubObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryClubObject> Insert RotaryClub WithCluster >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryClubService> Insert RotaryClub WithCluster >>> Failed');
          print('<RotaryClubService> Insert RotaryClub WithCluster >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<RotaryClubService> Insert RotaryClub WithCluster >>> Failed >>> ${response.statusCode}');
        print('<RotaryClubService> Insert RotaryClub WithCluster >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Insert RotaryClub WithCluster >>> ERROR: ${e.toString()}');
      developer.log(
        'insertRotaryClubWithCluster',
        name: 'RotaryClubService',
        error: 'Insert RotaryClub WithCluster >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update RotaryClub By AreaClusterClubId [WriteToDB]
  //=============================================================================
  Future updateRotaryClubByAreaClusterClubIdToDataBase(RotaryClubObject aRotaryClubObj) async {
    try{
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

  Future updateRotaryClubByAreaClusterClubId(RotaryClubObject aRotaryClubObj) async {
    try {
      String jsonToPost = aRotaryClubObj.rotaryClubObjectToJson(aRotaryClubObj);
      print ('updateRotaryClubByAreaClusterClubId / RotaryClubObject / jsonToPost: $jsonToPost');

      String _updateUrl = Constants.rotaryClubUrl + "/${aRotaryClubObj.clubId}";

      Response response = await put(_updateUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print('updateRotaryClubByAreaClusterClubId / RotaryClubObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryClubService> Update RotaryClub By AreaClusterClubId >>> OK');
          return returnVal;
        } else {
          await LoggerService.log(
              '<RotaryClubService> Update RotaryClub By AreaClusterClubId >>> Failed');
          print('<RotaryClubService> Update RotaryClub By AreaClusterClubId >>> Failed');
          return null;
        }
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Update RotaryClub By AreaClusterClubId >>> ERROR: ${e.toString()}');
      developer.log(
        'updateRotaryClubByAreaClusterClubIdToDataBase',
        name: 'RotaryClubService',
        error: 'Update RotaryClub By AreaClusterClubId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Delete RotaryClub By AreaClusterClubId [WriteToDB]
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

  Future deleteRotaryClubByAreaClusterClubId(RotaryClubObject aRotaryClubObj) async {
    try {
      String _deleteUrl = Constants.rotaryClubUrl + "/${aRotaryClubObj.clubId}";

      Response response = await delete(_deleteUrl, headers: Constants.rotaryUrlHeader);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print('deleteRotaryClubByAreaClusterClubId / RotaryClubObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<RotaryClubService> Delete Rotary Club By AreaClusterClubId >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<RotaryClubService> Delete Rotary Club By AreaClusterClubId >>> Failed');
          print('<RotaryClubService> Delete Rotary Club By AreaClusterClubId >>> Failed');
          return null;
        }
      }
    }
    catch (e) {
      await LoggerService.log('<RotaryClubService> Delete Rotary Club By AreaClusterClubId >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteRotaryClubByAreaClusterClubId',
        name: 'RotaryClubService',
        error: 'Delete Rotary Club By AreaClusterClubId >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

}
