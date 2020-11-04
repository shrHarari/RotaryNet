import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/objects/message_object.dart';
import 'package:rotary_net/objects/message_populated_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

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
        composerId: '',
        messageText: '',
        messageCreatedDateTime: null,
      );
    else
      return MessageObject(
        messageGuidId: aMessageGuidId,
        composerId: aComposerGuidId,
        messageText: aMessageText,
        messageCreatedDateTime: aMessageCreatedDateTime,
      );
  }
  //#endregion

  //#region Create Message Populated As Object
  //=============================================================================
  MessagePopulatedObject createMessagePopulatedAsObject(
      String aMessageGuidId,
      String aComposerId,
      String aComposerFirstName,
      String aComposerLastName,
      String aComposerEmail,
      String aMessageText,
      DateTime aMessageCreatedDateTime,
      String aAreaId,
      String aAreaName,
      String aClusterId,
      String aClusterName,
      String aClubId,
      String aClubName,
      String aClubAddress,
      String aClubMail,
      String aClubManagerGuidId,
      String aRoleId,
      int aRoleEnum,
      String aRoleName,
      List<String> aPersonCards,
      )
  {
    if (aMessageGuidId == null)
      return MessagePopulatedObject(
        messageGuidId: '',
        composerId: '',
        composerFirstName: '',
        composerLastName: '',
        composerEmail: '',
        messageText: '',
        messageCreatedDateTime: null,
        areaId: null,
        areaName: '',
        clusterId: null,
        clusterName: '',
        clubId: null,
        clubName: '',
        clubAddress: '',
        clubMail: '',
        clubManagerGuidId: '',
        roleId: '',
        roleEnum: null,
        roleName: '',
        personCards: []
      );
    else
      return MessagePopulatedObject(
        messageGuidId: aMessageGuidId,
        composerId: aComposerId,
        composerFirstName: aComposerFirstName,
        composerLastName: aComposerLastName,
        composerEmail: aComposerEmail,
        messageText: aMessageText,
        messageCreatedDateTime: aMessageCreatedDateTime,
        areaId: aAreaId,
        areaName: aAreaName,
        clusterId: aClusterId,
        clusterName: aClusterName,
        clubId: aClubId,
        clubName: aClubName,
        clubAddress: aClubAddress,
        clubMail: aClubMail,
        clubManagerGuidId: aClubManagerGuidId,
        roleId: aRoleId,
        roleEnum: aRoleEnum,
        roleName: aRoleName,
        personCards: aPersonCards,
      );
  }
  //#endregion

  //#region * Get Messages List [GET]
  // =========================================================
  Future getMessagesList() async {
    try {
      String _getUrl = Constants.rotaryMessageUrl;

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<MessageService> Get Messages List >>> OK\nHeader: $contentType \nMessagesListFromJSON: $jsonResponse');

        var messagesList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<MessageObject> messagesObjList = messagesList.map((messageJson) => MessageObject.fromJson(messageJson)).toList();

        return messagesObjList;
      } else {
        await LoggerService.log('<MessageService> Get Messages List >>> Failed: ${response.statusCode}');
        print('<MessageService> Get Messages List >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Get Messages List >>> ERROR: ${e.toString()}');
      developer.log(
        'getMessagesList',
        name: 'MessageService',
        error: 'Messages List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get Messages List By Composer Id [GET]
  // =========================================================
  Future getMessagesListByComposerId(String aComposerId) async {
    try {
      String _getUrl = Constants.rotaryMessageUrl + "/composerId/$aComposerId";

      Response response = await get(_getUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<MessageService> Get Messages List By Composer Id >>> OK\nHeader: $contentType \nMessagesListFromJSON: $jsonResponse');

        var messagesList = jsonDecode(jsonResponse) as List;
        List<MessageObject> messagesObjList = messagesList.map((messageJson) => MessageObject.fromJson(messageJson)).toList();

        return messagesObjList;
      } else {
        await LoggerService.log('<MessageService> Get Messages List By Composer Id >>> Failed: ${response.statusCode}');
        print('<MessageService> Get Messages List By Composer Id >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Get Messages List By Composer Id >>> ERROR: ${e.toString()}');
      developer.log(
        'getMessagesListByComposerId',
        name: 'MessageService',
        error: 'Messages List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Get Messages List Populated By PersonCardId [GET]
  // =========================================================
  Future getMessagesListPopulatedByPersonCardId(String aPersonCardId) async {
    try {
      PersonCardService personCardService = PersonCardService();
      List<dynamic> _messagesList = await personCardService.getPersonCardByIdMessagePopulated(aPersonCardId);

      List<MessagePopulatedObject> messagesObjectList = _messagesList.map((parsedJson) =>
            MessagePopulatedObject.fromJsonAllPopulated(parsedJson)).toList();

      return messagesObjectList;
    }
    catch (e) {
      await LoggerService.log('<MessageService> Get Messages List Populated By PersonCardId >>> ERROR: ${e.toString()}');
      developer.log(
        'getMessagesListPopulatedByPersonCardId',
        name: 'MessageService',
        error: 'Messages List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Messages

  //#region * Insert Message [WriteToDB]
  //=============================================================================
  Future insertMessage(MessageObject aMessageObj) async {
    try {
      String _getUrl = Constants.rotaryMessageUrl;
      print ("_getUrl: $_getUrl");

      String jsonToPost = aMessageObj.messageObjectToJson(aMessageObj);

      Response response = await post(_getUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        await LoggerService.log('<MessageService> Insert Message >>> OK');
        return jsonResponse;
      } else {
        await LoggerService.log('<MessageService> Insert Message >>> Failed >>> ${response.statusCode}');
        print('<MessageService> Insert Message >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Insert Message >>> ERROR: ${e.toString()}');
      developer.log(
        'insertMessage',
        name: 'MessageService',
        error: 'Insert Message >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Update Message By Id [WriteToDB]
  //=============================================================================
  Future updateMessageById(MessageObject aMessageObj) async {
    try {
      String jsonToPost = aMessageObj.messageObjectToJson(aMessageObj);
      print ('updateMessageById / MessageObject / jsonToPost: $jsonToPost');

      String _updateUrl = Constants.rotaryMessageUrl + "/${aMessageObj.messageGuidId}";
      print ("_updateUrl: $_updateUrl");

      Response response = await put(_updateUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('<MessageService> Update Message By Id >>> MessageObject / jsonResponse: $jsonResponse');

        await LoggerService.log('<MessageService> Update Message By Id >>> OK');
        return jsonResponse;
      } else {
        await LoggerService.log('<MessageService> Update Message By Id >>> Failed >>> ${response.statusCode}');
        print('<MessageService> Update Message By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Update Message By Id >>> ERROR: ${e.toString()}');
      developer.log(
        'updateMessageById',
        name: 'MessageService',
        error: 'Update Message By Id >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Delete Message By Id [WriteToDB]
  //=============================================================================
  Future deleteMessageById(MessageObject aMessageObj) async {
    try {
      String _deleteUrl = Constants.rotaryMessageUrl + "/${aMessageObj.messageGuidId}";

      Response response = await delete(_deleteUrl, headers: Constants.rotaryUrlHeader);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('deleteMessageById / MessageObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<MessageService> Delete Message By Id >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<MessageService> Delete Message By Id >>> Failed');
          print('<MessageService> Delete Message By Id >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<MessageService> Delete Message By Id >>> Failed >>> ${response.statusCode}');
        print('<MessageService> Delete Message By Id >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Delete Message By Id >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteMessageById',
        name: 'MessageService',
        error: 'Delete Message By Id >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region * Remove Message From PersonCard MessageQueue [WriteToDB]
  //=============================================================================
  Future removeMessageFromPersonCardMessageQueue(MessageObject aMessageObj, String aPersonCardId) async {
    try {
      String _deleteUrl = Constants.rotaryMessageUrl + "/removeMessageQueue/${aMessageObj.messageGuidId}/personCard/$aPersonCardId";

      Response response = await put(_deleteUrl, headers: Constants.rotaryUrlHeader);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        print ('deleteMessageFromPersonCardMessageQueue / MessageObject / jsonResponse: $jsonResponse');

        bool returnVal = jsonResponse.toLowerCase() == 'true';
        if (returnVal) {
          await LoggerService.log('<MessageService> Delete Message From PersonCard MessageQueue >>> OK');
          return returnVal;
        } else {
          await LoggerService.log('<MessageService> Delete Message From PersonCard MessageQueue >>> Failed');
          print('<MessageService> Delete Message By Id >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<MessageService> Delete Message From PersonCard MessageQueue >>> Failed >>> ${response.statusCode}');
        print('<MessageService> Delete Message From PersonCard MessageQueue >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Delete Message From PersonCard MessageQueue >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteMessageFromPersonCardMessageQueue',
        name: 'MessageService',
        error: 'Delete Message From PersonCard MessageQueue >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
//#endregion

  //#region * Add Message Back To PersonCard MessageQueue [GET]
  //=============================================================================
  Future addMessageBackToPersonCardMessageQueue(MessageObject aMessageObj, String aPersonCardId) async {
    try {
      String _addMessageUrl = Constants.rotaryMessageUrl + "/addMessageQueue/${aMessageObj.messageGuidId}/personCard/$aPersonCardId";
      print ("_addUrl: $_addMessageUrl");

      Response response = await put(_addMessageUrl, headers: Constants.rotaryUrlHeader);
      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        await LoggerService.log('<MessageService> Insert Message Back To MessageQueue >>> OK');
        return jsonResponse;
      } else {
        await LoggerService.log('<MessageService> Insert Message Back To MessageQueue >>> Failed >>> ${response.statusCode}');
        print('<MessageService> Insert Message Back To MessageQueue >>> Failed >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<MessageService> Insert Message Back To MessageQueue >>> ERROR: ${e.toString()}');
      developer.log(
        'insertMessageBackToMessageQueue',
        name: 'MessageService',
        error: 'Insert Message Back To MessageQueue >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
//#endregion

//#endregion
}
