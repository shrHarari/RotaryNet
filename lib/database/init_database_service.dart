import 'dart:async';
import 'dart:convert';
import 'package:rotary_net/database/init_database_data.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/event_object.dart';
import 'package:rotary_net/objects/message_object.dart';
import 'package:rotary_net/objects/message_queue_object.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/rotary_area_object.dart';
import 'package:rotary_net/objects/rotary_club_object.dart';
import 'package:rotary_net/objects/rotary_cluster_object.dart';
import 'package:rotary_net/objects/rotary_role_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'dart:developer' as developer;

class InitDatabaseService {

  //#region Initialize Users Table Data [INIT USERS BY JSON DATA]
  // =========================================================
  Future initializeUsersTableData() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        String initializeUsersJsonForDebug = InitDataBaseData.createJsonRowsForUsers();

        //// Using JSON
        var initializeUsersListForDebug = jsonDecode(initializeUsersJsonForDebug) as List;    // List of Users to display;
        List<UserObject> userObjListForDebug = initializeUsersListForDebug.map((userJsonDebug) => UserObject.fromJson(userJsonDebug)).toList();

        userObjListForDebug.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
        return userObjListForDebug;
      }
      //***** for debug *****
    }
    catch (e) {
      await LoggerService.log('<InitDatabaseService> Initialize Users Table Data >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeUsersTableData',
        name: 'InitDatabaseService',
        error: 'Users List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region insert All Started Users To DB
  Future insertAllStartedUsersToDb() async {
    List<UserObject> starterUsersList;
    starterUsersList = await initializeUsersTableData();
    // print('starterUsersList.length: ${starterUsersList.length}');

    starterUsersList.forEach((UserObject userObj) async => await RotaryDataBaseProvider.rotaryDB.insertUser(userObj));

    // List<UserObject> _usersList = await RotaryDataBaseProvider.rotaryDB.getAllUsers();
    // if (_usersList.isNotEmpty)
    //   print('>>>>>>>>>> usersList: ${_usersList[4].emailId}');
  }
  //#endregion

  //#region Initialize PersonCards Table Data [INIT PersonCard BY JSON DATA]
  // ========================================================================
  Future initializePersonCardsTableData() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        String initializePersonCardsJsonForDebug = InitDataBaseData.createJsonRowsForPersonCards();
        // print('initializeUsersJsonForDebug: initializeUsersJsonForDebug');

        //// Using JSON
        var initializePersonCardsListForDebug = jsonDecode(initializePersonCardsJsonForDebug) as List;    // List of Users to display;
        List<PersonCardObject> personCardObjListForDebug = initializePersonCardsListForDebug.map((personJsonDebug) => PersonCardObject.fromJson(personJsonDebug)).toList();
        // print('personCardObjListForDebug.length: ${personCardObjListForDebug.length}');

        personCardObjListForDebug.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));
        return personCardObjListForDebug;
      }
      //***** for debug *****

    }
    catch (e) {
      await LoggerService.log('<InitDatabaseService> Get PersonCards List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'initializePersonCardsTableData',
        name: 'InitDatabaseService',
        error: 'PersonCards List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region insert All Started PersonCards To DB
  Future insertAllStartedPersonCardsToDb() async {
    List<PersonCardObject> starterPersonCardsList;
    starterPersonCardsList = await initializePersonCardsTableData();
    // print('starterPersonCardsList.length: ${starterPersonCardsList.length}');

    starterPersonCardsList.forEach((PersonCardObject personCardObj) async => await RotaryDataBaseProvider.rotaryDB.insertPersonCard(personCardObj));

    // List<PersonCardObject> personCardsList = await RotaryDataBaseProvider.rotaryDB.getAllPersonCards();
    // if (personCardsList.isNotEmpty)
    //   print('>>>>>>>>>> personCardsList: ${personCardsList[0].emailId}');
  }
  //#endregion

  //#region Initialize Events Table Data [INIT Events BY JSON DATA]
  // ========================================================================
  Future initializeEventsTableData() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        String initializeEventsJsonForDebug = InitDataBaseData.createJsonRowsForEvents();
        // print('initializeEventsJsonForDebug: initializeEventsJsonForDebug');

        //// Using JSON
        var initializeEventsListForDebug = jsonDecode(initializeEventsJsonForDebug) as List;    // List of Users to display;
        List<EventObject> eventObjListForDebug = initializeEventsListForDebug.map((eventJsonDebug) => EventObject.fromJson(eventJsonDebug)).toList();
        // print('eventObjListForDebug.length: ${eventObjListForDebug.length}');

        eventObjListForDebug.sort((a, b) => a.eventName.toLowerCase().compareTo(b.eventName.toLowerCase()));
        return eventObjListForDebug;
      }
      //***** for debug *****

    }
    catch (e) {
      await LoggerService.log('<InitDatabaseService> Get Events List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeEventsTableData',
        name: 'InitDatabaseService',
        error: 'Events List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region insert All Started Events To DB
  Future insertAllStartedEventsToDb() async {
    List<EventObject> starterEventsList;
    starterEventsList = await initializeEventsTableData();
    // print('starterEventsList.length: ${starterEventsList.length}');

    starterEventsList.forEach((EventObject eventObj) async => await RotaryDataBaseProvider.rotaryDB.insertEvent(eventObj));
    // starterEventsList.forEach((EventObject eventObj) => insertRawEvent(eventObj));

    // List<EventObject> eventsList = await RotaryDataBaseProvider.rotaryDB.getAllEvents();
    // if (eventsList.isNotEmpty)
    // print('>>>>>>>>>> eventsList: ${eventsList[0].eventName}');
  }
  //#endregion

  //#region Initialize Messages Table Data [INIT Messages BY JSON DATA]
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
      await LoggerService.log('<InitDatabaseService> Get Messages List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeMessagesTableData',
        name: 'InitDatabaseService',
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

  //#region Initialize MessageQueue Table Data [INIT MessageQueue BY JSON DATA]
  // ========================================================================
  Future initializeMessageQueueTableData() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        String initializeMessageQueueJsonForDebug = InitDataBaseData.createJsonRowsForMessageQueue();

        //// Using JSON
        var initializeMessageQueueListForDebug = jsonDecode(initializeMessageQueueJsonForDebug) as List;    // List of Users to display;
        List<MessageQueueObject> messageQueueObjListForDebug = initializeMessageQueueListForDebug.map((messageQueueJsonDebug) =>
            MessageQueueObject.fromJson(messageQueueJsonDebug)).toList();

        messageQueueObjListForDebug.sort((a, b) => a.messageGuidId.compareTo(b.messageGuidId));
        return messageQueueObjListForDebug;
      }
      //***** for debug *****

    }
    catch (e) {
      await LoggerService.log('<InitDatabaseService> Get MessageQueue List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeMessageQueueTableData',
        name: 'InitDatabaseService',
        error: 'MessageQueue List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region insert All Started MessageQueue To DB
  Future insertAllStartedMessageQueueToDb() async {
    List<MessageQueueObject> starterMessageQueueList;

    starterMessageQueueList = await initializeMessageQueueTableData();

    starterMessageQueueList.forEach((MessageQueueObject messageQueueObj) async => await RotaryDataBaseProvider.rotaryDB.insertMessageQueue(messageQueueObj));
  }
  //#endregion

  //#region Initialize Rotary Role Table Data [INIT Role BY JSON DATA]
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
      await LoggerService.log('<InitDatabaseService> Initialize RotaryRole Table Data >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeRotaryRoleTableData',
        name: 'InitDatabaseService',
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

  //#region Initialize Rotary Area Table Data [INIT Area BY JSON DATA]
  // ========================================================================
  Future initializeRotaryAreaTableData() async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        String initializeRotaryAreaJsonForDebug = InitDataBaseData.createJsonRowsForRotaryArea();
        // print('initializeEventsJsonForDebug: initializeEventsJsonForDebug');

        //// Using JSON
        var initializeRotaryAreaListForDebug = jsonDecode(initializeRotaryAreaJsonForDebug) as List;    // List of Users to display;
        List<RotaryAreaObject> rotaryAreaObjListForDebug = initializeRotaryAreaListForDebug.map((areaJsonDebug) => RotaryAreaObject.fromJson(areaJsonDebug)).toList();
        // print('eventObjListForDebug.length: ${eventObjListForDebug.length}');

        rotaryAreaObjListForDebug.sort((a, b) => a.areaName.toLowerCase().compareTo(b.areaName.toLowerCase()));
        return rotaryAreaObjListForDebug;
      }
      //***** for debug *****

    }
    catch (e) {
      await LoggerService.log('<InitDatabaseService> Initialize RotaryArea Table Data >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeRotaryAreaTableData',
        name: 'InitDatabaseService',
        error: 'Initialize RotaryArea Table Data >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region insert All Started RotaryArea To DB
  Future insertAllStartedRotaryAreaToDb() async {
    List<RotaryAreaObject> starterRotaryAreaList;
    starterRotaryAreaList = await initializeRotaryAreaTableData();
    print('starterRotaryAreaList.length: ${starterRotaryAreaList.length}');

    starterRotaryAreaList.forEach((RotaryAreaObject rotaryAreaObj) async =>
    await RotaryDataBaseProvider.rotaryDB.insertRotaryArea(rotaryAreaObj));

    List<RotaryAreaObject> _rotaryAreaList = await RotaryDataBaseProvider.rotaryDB.getAllRotaryArea();
    if (_rotaryAreaList.isNotEmpty)
      print('>>>>>>>>>> _rotaryAreaList: ${_rotaryAreaList[1].areaName}');
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
      await LoggerService.log('<InitDatabaseService> Initialize RotaryCluster Table Data >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeRotaryClusterTableData',
        name: 'InitDatabaseService',
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
      await LoggerService.log('<InitDatabaseService> Initialize RotaryClub Table Data >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeRotaryClubTableData',
        name: 'InitDatabaseService',
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
}
