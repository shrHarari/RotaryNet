import 'dart:async';
import 'dart:convert';
import 'package:rotary_net/database/init_database_data.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/message_object.dart';
import 'package:rotary_net/objects/message_with_description_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'dart:developer' as developer;
import 'globals_service.dart';

class MessageService {

  //#region Create Message As Object
  //=============================================================================
  MessageObject createMessageAsObject(
      String aMessageGuidId,
      String aComposerGuidId,
      String aMessageText,
      DateTime aMessageCreatedDateTime,
      )
  {
    if (aMessageGuidId == null)
      return MessageObject(
        messageGuidId: '',
        composerGuidId: '',
        messageText: '',
        messageCreatedDateTime: null,
      );
    else
      return MessageObject(
        messageGuidId: aMessageGuidId,
        composerGuidId: aComposerGuidId,
        messageText: aMessageText,
        messageCreatedDateTime: aMessageCreatedDateTime,
      );
  }
  //#endregion

  //#region Create Message With Description As Object
  //=============================================================================
  MessageWithDescriptionObject createMessageWithDescriptionAsObject(
      String aMessageGuidId,
      String aComposerGuidId,
      String aComposerFirstName,
      String aComposerLastName,
      String aComposerEmail,
      String aMessageText,
      DateTime aMessageCreatedDateTime,
      int aRoleId,
      String aRoleName,
      int aAreaId,
      String aAreaName,
      int aClusterId,
      String aClusterName,
      int aClubId,
      String aClubName,
      String aClubAddress,
      String aClubMail,
      String aClubManagerGuidId,
      )
  {
    if (aMessageGuidId == null)
      return MessageWithDescriptionObject(
        messageGuidId: '',
        composerGuidId: '',
        composerFirstName: '',
        composerLastName: '',
        composerEmail: '',
        messageText: '',
        messageCreatedDateTime: null,
        roleId: null,
        roleName: '',
        areaId: null,
        areaName: '',
        clusterId: null,
        clusterName: '',
        clubId: null,
        clubName: '',
        clubAddress: '',
        clubMail: '',
        clubManagerGuidId: '',
      );
    else
      return MessageWithDescriptionObject(
        messageGuidId: aMessageGuidId,
        composerGuidId: aComposerGuidId,
        composerFirstName: aComposerFirstName,
        composerLastName: aComposerLastName,
        composerEmail: aComposerEmail,
        messageText: aMessageText,
        messageCreatedDateTime: aMessageCreatedDateTime,
        roleId: aRoleId,
        roleName: aRoleName,
        areaId: aAreaId,
        areaName: aAreaName,
        clusterId: aClusterId,
        clusterName: aClusterName,
        clubId: aClubId,
        clubName: aClubName,
        clubAddress: aClubAddress,
        clubMail: aClubMail,
        clubManagerGuidId: aClubManagerGuidId,
      );
  }
  //#endregion

  //#region Initialize Messages Table Data [INIT Events BY JSON DATA]
  // ========================================================================
  Future initializeMessagesTableData() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        String initializeMessagesJsonForDebug = InitDataBaseData.createJsonRowsForMessages();
        // print('initializeEventsJsonForDebug: initializeEventsJsonForDebug');

        //// Using JSON
        var initializeMessagesListForDebug = jsonDecode(initializeMessagesJsonForDebug) as List;    // List of Users to display;
        List<MessageObject> messageObjListForDebug = initializeMessagesListForDebug.map((messageJsonDebug) => 
                MessageObject.fromJson(messageJsonDebug)).toList();
        // print('eventObjListForDebug.length: ${eventObjListForDebug.length}');

        messageObjListForDebug.sort((a, b) => a.messageCreatedDateTime.compareTo(b.messageCreatedDateTime));
        return messageObjListForDebug;
      }
      //***** for debug *****

    }
    catch (e) {
      await LoggerService.log('<MessageService> Get Messages List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeMessagesTableData',
        name: 'MessageService',
        error: 'Messages List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region insert All Started Messages To DB
  Future insertAllStartedMessagesToDb() async {
    List<MessageObject> starterMessagesList;
    
    starterMessagesList = await initializeMessagesTableData();
    // print('starterEventsList.length: ${starterEventsList.length}');

    starterMessagesList.forEach((MessageObject messageObj) async => await RotaryDataBaseProvider.rotaryDB.insertMessage(messageObj));
    // starterEventsList.forEach((EventObject eventObj) => insertRawEvent(eventObj));

    // List<EventObject> eventsList = await RotaryDataBaseProvider.rotaryDB.getAllEvents();
    // if (eventsList.isNotEmpty)
    // print('>>>>>>>>>> eventsList: ${eventsList[0].eventName}');
  }
  //#endregion

  //#region Get Messages List By Composer GuidId From Server [GET]
  // =========================================================
  Future getMessagesListByComposerGuidIdFromServer(String aComposerGuidId) async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling

      // Because of RotaryUsersListBloc >>> Need to initialize GlobalService here too
      bool debugMode = await GlobalsService.getDebugMode();
      await GlobalsService.setDebugMode(debugMode);

      if (GlobalsService.isDebugMode) {
        List<MessageObject> messageObjListForDebug = await RotaryDataBaseProvider.rotaryDB.getMessagesByComposerGuidId(aComposerGuidId);
        if (messageObjListForDebug == null) {
        } else {
          messageObjListForDebug.sort((a, b) => a.messageCreatedDateTime.compareTo(b.messageCreatedDateTime));
        }

        return messageObjListForDebug;
      } else {
        await LoggerService.log('<MessageService> Get Messages List By Composer GuidId From Server >>> Failed');
        print('<MessageService> Get Messages List By Composer GuidId From Server >>> Failed');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Get Messages List By Composer GuidId From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getMessagesListByComposerGuidIdFromServer',
        name: 'MessageService',
        error: 'Messages List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Get Messages List From Server [GET]
  // =========================================================
  Future getMessagesListFromServer() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling

      // Because of RotaryUsersListBloc >>> Need to initialize GlobalService here too
      bool debugMode = await GlobalsService.getDebugMode();
      await GlobalsService.setDebugMode(debugMode);

      if (GlobalsService.isDebugMode) {
        List<MessageObject> messageObjListForDebug = await RotaryDataBaseProvider.rotaryDB.getAllMessages();
        if (messageObjListForDebug == null) {
        } else {
          messageObjListForDebug.sort((a, b) => a.messageCreatedDateTime.compareTo(b.messageCreatedDateTime));
        }

        return messageObjListForDebug;
      } else {
        await LoggerService.log('<MessageService> Get Messages List From Server >>> Failed');
        print('<MessageService> Get Messages List From Server >>> Failed');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Get Messages List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getMessagesListFromServer',
        name: 'MessageService',
        error: 'Messages List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Get Messages List With Description From Server [GET]
  // =========================================================
  Future getMessagesListWithDescriptionFromServer() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling

      // Because of RotaryUsersListBloc >>> Need to initialize GlobalService here too
      bool debugMode = await GlobalsService.getDebugMode();
      await GlobalsService.setDebugMode(debugMode);

      if (GlobalsService.isDebugMode) {
        List<MessageWithDescriptionObject> messageObjListForDebug = await RotaryDataBaseProvider.rotaryDB.getAllMessagesWithDescription();
        if (messageObjListForDebug == null) {
        } else {
          messageObjListForDebug.sort((a, b) => b.messageCreatedDateTime.compareTo(a.messageCreatedDateTime));
        }

        return messageObjListForDebug;
      } else {
        await LoggerService.log('<MessageService> Get Messages List With Description From Server >>> Failed');
        print('<MessageService> Get Messages List With Description From Server >>> Failed');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Get Messages List With Description From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getMessagesListWithDescriptionFromServer',
        name: 'MessageService',
        error: 'Messages List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Messages

  //#region Insert Message To DataBase [WriteToDB]
  //=============================================================================
  Future insertMessageToDataBase(MessageObject aMessageObj) async {
    try{
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.insertMessage(aMessageObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Insert Message To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'insertMessageToDataBase',
        name: 'MessageService',
        error: 'Insert Message To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Update Message By MessageGuidId To DataBase [WriteToDB]
  //=============================================================================
  Future updateMessageByMessageGuidIdToDataBase(MessageObject aMessageObj) async {
    try{
      String jsonToPost = jsonEncode(aMessageObj);

      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.updateMessageByMessageGuidId(aMessageObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Update Message By MessageGuidId To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'updateMessageByMessageGuidIdToDataBase',
        name: 'MessageService',
        error: 'Update Message By MessageGuidId To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Delete Message By MessageGuidId From DataBase [WriteToDB]
  //=============================================================================
  Future deleteMessageByMessageGuidIdFromDataBase(MessageObject aMessageObj) async {
    try{
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.deleteMessageByMessageGuidId(aMessageObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Delete Message By MessageGuidId To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteMessageByMessageGuidIdFromDataBase',
        name: 'MessageService',
        error: 'Delete Message By MessageGuidId To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion
  
  //#endregion
}
