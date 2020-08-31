
class EventObject {
  final String eventId;
  final String eventName;
  final String eventPictureUrl;
  final String eventDescription;
  DateTime eventStartDateTime;
  DateTime eventEndDateTime;
  String eventLocation;
  final String eventManager;

  EventObject({
    this.eventId,
    this.eventName,
    this.eventPictureUrl,
    this.eventDescription,
    this.eventStartDateTime,
    this.eventEndDateTime,
    this.eventLocation,
    this.eventManager,
  });

  // Set Event DateTime
  //=====================================
  Future <void> setStartDateTime(DateTime aStartDateTime) async {
    eventStartDateTime = aStartDateTime;
  }

  //=====================================
  Future <void> setEndDateTime(DateTime aEndDateTime) async {
    eventEndDateTime = aEndDateTime;
  }

  factory EventObject.fromJson(Map<String, dynamic> parsedJson){
    return EventObject(
        eventId: parsedJson['eventId'],
        eventName: parsedJson['eventName'],
        eventPictureUrl : parsedJson['eventPictureUrl'],
        eventDescription : parsedJson['eventDescription'],
        eventStartDateTime : DateTime.parse(parsedJson['eventStartDateTime']),
        eventEndDateTime : DateTime.parse(parsedJson['eventEndDateTime']),
        eventLocation : parsedJson['eventLocation'],
        eventManager : parsedJson['eventManager']
    );
  }

  @override
  String toString() {
    return '{'
        ' ${this.eventId},'
        ' ${this.eventName},'
        ' ${this.eventPictureUrl},'
        ' ${this.eventDescription},'
        ' ${this.eventStartDateTime},'
        ' ${this.eventEndDateTime},'
        ' ${this.eventLocation},'
        ' ${this.eventManager},'
        ' }';
  }

  Map toJson() => {
    'eventId': eventId,
    'eventName': eventName,
    'eventPictureUrl': eventPictureUrl,
    'eventDescription': eventDescription,
    'eventStartDateTime': eventStartDateTime.toString(),
    'eventEndDateTime': eventEndDateTime.toString(),
    'eventLocation': eventLocation,
    'eventManager': eventManager,
  };
}
