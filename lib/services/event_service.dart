import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/database/init_database_data.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/event_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;
import 'globals_service.dart';

class EventService {

  //#region Create Event As Object
  //=============================================================================
  EventObject createEventAsObject(
      String aEventGuidId,
      String aEventName,
      String aEventPictureUrl,
      String aEventDescription,
      DateTime aEventStartDateTime,
      DateTime aEventEndDateTime,
      String aEventLocation,
      String aEventManager,
      )
  {
    if (aEventGuidId == null)
      return EventObject(
          eventGuidId: '',
          eventName: '',
          eventPictureUrl: '',
          eventDescription: '',
          eventStartDateTime: null,
          eventEndDateTime: null,
          eventLocation: '',
          eventManager: '',
      );
    else
      return EventObject(
        eventGuidId: aEventGuidId,
        eventName: aEventName,
        eventPictureUrl: aEventPictureUrl,
        eventDescription: aEventDescription,
        eventStartDateTime: aEventStartDateTime,
        eventEndDateTime: aEventEndDateTime,
        eventLocation: aEventLocation,
        eventManager: aEventManager,
      );
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
      await LoggerService.log('<EventService> Get Events List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'initializeEventsTableData',
        name: 'EventService',
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

  //#region Get Events List By Search Query From Server [GET]
  // =========================================================
  Future getEventsListBySearchQueryFromServer(String aValueToSearch) async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling

      // Because of RotaryUsersListBloc >>> Need to initialize GlobalService here too
      bool debugMode = await GlobalsService.getDebugMode();
      await GlobalsService.setDebugMode(debugMode);

      if (GlobalsService.isDebugMode) {
        List<EventObject> eventObjListForDebug = await RotaryDataBaseProvider.rotaryDB.getEventsListBySearchQuery(aValueToSearch);
        if (eventObjListForDebug == null) {
        } else {
          eventObjListForDebug.sort((a, b) => a.eventName.toLowerCase().compareTo(b.eventName.toLowerCase()));
        }

        return eventObjListForDebug;
      }
      //***** for debug *****

      /// PersonCardListUrl: 'http://.......'
      Response response = await get(Constants.rotaryGetPersonCardListUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<PersonCardService> Get PersonCard List From Server >>> OK\nHeader: $contentType \nPersonCardListFromJSON: $jsonResponse');

        var eventsList = jsonDecode(jsonResponse) as List;    // List of PersonCard to display;
        List<EventObject> eventObjList = eventsList.map((eventJson) => EventObject.fromJson(eventJson)).toList();

        eventObjList.sort((a, b) => a.eventName.toLowerCase().compareTo(b.eventName.toLowerCase()));
//      personCardObjList.sort((a, b) {
//        return a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase());
//      });

        return eventObjList;

      } else {
        await LoggerService.log('<EventService> Get Event List From Server >>> Failed: ${response.statusCode}');
        print('<EventService> Get Event List From Server >>> Failed: ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<EventService> Get Event List From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getEventListFromServer',
        name: 'EventService',
        error: 'Events List >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region CRUD: Events

  //#region Insert Event To DataBase [WriteToDB]
  //=============================================================================
  Future insertEventToDataBase(EventObject aEventObj) async {
    try{
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.insertEvent(aEventObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<EventService> Insert Event To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'insertEventToDataBase',
        name: 'EventService',
        error: 'Insert Event To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Update Event By EventGuidId To DataBase [WriteToDB]
  //=============================================================================
  Future updateEventByEventGuidIdToDataBase(EventObject aEventObj) async {
    try{
      String jsonToPost = jsonEncode(aEventObj);

      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.updateEventByEventGuidId(aEventObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<EventService> Update Event To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'updateEventToDataBase',
        name: 'EventService',
        error: 'Update Event To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Delete Event By EventGuidId From DataBase [WriteToDB]
  //=============================================================================
  Future deleteEventByEventGuidIdFromDataBase(EventObject aEventObj) async {
    try{
      //***** for debug *****
      if (GlobalsService.isDebugMode) {
        var dbResult = await RotaryDataBaseProvider.rotaryDB.deleteEventByEventGuidId(aEventObj);
        return dbResult;
        //***** for debug *****
      }
    }
    catch (e) {
      await LoggerService.log('<EventService> Delete Event To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'deleteEventFromDataBase',
        name: 'EventService',
        error: 'Delete Event To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

}
