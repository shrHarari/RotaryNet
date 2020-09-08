import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:rotary_net/objects/event_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;
import 'globals_service.dart';

class EventService {

  //#region Create Event As Object
  //=============================================================================
  EventObject createEventAsObject(
      String aEventId,
      String aEventName,
      String aEventPictureUrl,
      String aEventDescription,
      DateTime aEventStartDateTime,
      DateTime aEventEndDateTime,
      String aEventLocation,
      String aEventManager,
      )
  {
    if (aEventId == null)
      return EventObject(
          eventId: '',
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
        eventId: aEventId,
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

  //#region Update Event Object Data To DataBase [WriteToDB]
  //=============================================================================
  Future updateEventObjectDataToDataBase(EventObject aEventObj) async {
    try{
      String jsonToPost = jsonEncode(aEventObj);
//      print('updateEventObjectDataToDataBase / Json: \n$jsonToPost');

      /// *** debug:
      if(GlobalsService.isDebugMode)
        return "100";  // >>> Success
      /// debug***

      Response response = await post(Constants.rotaryEventWriteToDataBaseRequestUrl,
          headers: Constants.rotaryUrlHeader,
          body: jsonToPost);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        String dbResult = jsonResponse;
        if (int.parse(dbResult) > 0){
          await LoggerService.log('<EventService> Event Update >>> OK');
          return dbResult;
        } else {
          await LoggerService.log('<EventService> Event Update >>> Failed');
          print('<EventService> Event Update >>> Failed');
          return null;
        }
      } else {
        await LoggerService.log('<EventService> Event Update >>> Failed');
        print('<EventService> Event Update >>> Failed');
        return null;
      }
    }
    catch  (e) {
      await LoggerService.log('<EventService> Write Event Object Data To DataBase >>> ERROR: ${e.toString()}');
      developer.log(
        'writeEventObjectDataToDataBase',
        name: 'EventService',
        error: 'Write Event Object Data To DataBase >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Create Json EventsList [Data for Debug]
  String createJsonForEventsList() {

    String eventsListJson =
        '['
        '{'
          '"eventId": "1", '
          '"eventName": "מסיבת סיום גדולה", '
          '"eventPictureUrl": "1.jpg", '
          '"eventDescription": "מסיבת סיום גדולה בעיר", '
          '"eventStartDateTime": "${DateTime.now().toString()}", '
          '"eventEndDateTime": "${DateTime.now().add(Duration(hours: 1)).toString()}", '
          '"eventLocation": "ויצמן 32, כפר-סבא ישראל", '
          '"eventManager": "shr.harari@gmail.com" '
        '},'
        '{'
          '"eventId": "2", '
          '"eventName": "מסיבת סיום", '
          '"eventPictureUrl": "2.jpg", '
          '"eventDescription": "מסיבת סיום גדולה בעיר", '
          '"eventStartDateTime": "2020-07-25 09:30:00.000000", '
          '"eventEndDateTime": "2020-07-25 10:30:00.000000", '
          '"eventLocation": "6767 Hollywood Blvd, Los Angeles, CA 90028, ארצות הברית", '
          '"eventManager": "shr.harari@gmail.com" '
        '},'
        '{'
          '"eventId": "3", '
          '"eventName": "הנואם הצעיר אירוע בוקר", '
          '"eventPictureUrl": "3.jpg", '
          '"eventDescription": "הנואם הצעיר - מחוז מרכז", '
          '"eventStartDateTime": "2020-08-12 08:00:00", '
          '"eventEndDateTime": "2020-08-12 10:00:00", '
          '"eventLocation": "יפו 32 ירושלים ישראל", '
          '"eventManager": "shr.harari@gmail.com" '
        '},'
        '{'
          '"eventId": "4", '
          '"eventName": "הנואם הצעיר אירוע ערב", '
          '"eventPictureUrl": "4.jpg", '
          '"eventDescription": "תחרות ארצית - הנואם הצעיר", '
          '"eventStartDateTime": "2020-09-18 20:00:00", '
          '"eventEndDateTime": "2020-09-18 22:00:00", '
          '"eventLocation": "הנשיא 6, פתח-תקווה", '
          '"eventManager": "shr.harari@gmail.com" '
        '}'
        ']';

    return eventsListJson;
  }
  //#endregion

  //#region Get Events List From Server [GET]
  // =========================================================
  Future getEventsListSearchFromServer(String aValueToSearch) async {
    try {

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        String jsonResponseForDebug = createJsonForEventsList();
       // print('jsonResponseForDebug: $jsonResponseForDebug');

        var eventsListForDebug = jsonDecode(jsonResponseForDebug) as List;    // List of PersonCard to display;
        List<EventObject> eventObjListForDebug = eventsListForDebug.map((eventJsonDebug) => EventObject.fromJson(eventJsonDebug)).toList();
//        print('personCardObjListForDebug.length: ${personCardObjListForDebug.length}');

        eventObjListForDebug.sort((a, b) => a.eventName.toLowerCase().compareTo(b.eventName.toLowerCase()));
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

}
