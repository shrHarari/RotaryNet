import 'dart:convert';

import 'package:rotary_net/objects/message_with_description_object.dart';

class MessageObject {
  final String messageGuidId;
  final String composerGuidId;
  final String messageText;
  final DateTime messageCreatedDateTime;

  MessageObject({
    this.messageGuidId,
    this.composerGuidId,
    this.messageText,
    this.messageCreatedDateTime,});

  // get MessageObject From MessageWithDescriptionObject
  //=======================================================
  static Future <MessageObject> getMessageObjectFromMessageWithDescriptionObject(MessageWithDescriptionObject aMessageWithDescriptionObject) async {
    return MessageObject(
        messageGuidId: aMessageWithDescriptionObject.messageGuidId,
        composerGuidId: aMessageWithDescriptionObject.composerGuidId,
        messageText: aMessageWithDescriptionObject.messageText,
        messageCreatedDateTime: aMessageWithDescriptionObject.messageCreatedDateTime,
    );
  }

  /// Convert JsonStringStructure to String
  @override
  String toString() {
    // DateTime: Convert [DateTime] to [String]
    String _messageCreatedDateTime = this.messageCreatedDateTime.toIso8601String();
    return
      '{'
          ' ${this.messageGuidId},'
          ' ${this.composerGuidId},'
          ' ${this.messageText},'
          ' $_messageCreatedDateTime,'
          '}';
  }

  // /// Used for jsonDecode Function
  // Map toJson() => {
  //   'messageGuidId': messageGuidId,
  //   'composerGuidId': composerGuidId,
  //   'messageText': messageText,
  //   'messageCreatedDateTime': messageCreatedDateTime.toString(),
  // };

  factory MessageObject.fromJson(Map<String, dynamic> parsedJson){
    // DateTime: Convert [String] to [DateTime]
    DateTime _messageCreatedDateTime = DateTime.parse(parsedJson['messageCreatedDateTime']);

    return MessageObject(
      messageGuidId: parsedJson['messageGuidId'],
      composerGuidId: parsedJson['composerGuidId'],
      messageText: parsedJson['messageText'],
      messageCreatedDateTime: _messageCreatedDateTime,
    );
  }

  /// DataBase: Madel for MessageObject
  ///----------------------------------------------------
  MessageObject messageObjectFromJson(String str) {
    final jsonData = json.decode(str);
    return MessageObject.fromMap(jsonData);
  }

  String messageObjectToJson(MessageObject aMessageObject) {
    final dyn = aMessageObject.toMap();
    return json.encode(dyn);
  }

  factory MessageObject.fromMap(Map<String, dynamic> jsonFromMap) {
    // DateTime: Convert [String] to [DateTime]
    DateTime _messageCreatedDateTime = DateTime.parse(jsonFromMap['messageCreatedDateTime']);

    return MessageObject(
      messageGuidId: jsonFromMap['messageGuidId'],
      composerGuidId: jsonFromMap['composerGuidId'],
      messageText: jsonFromMap['messageText'],
      messageCreatedDateTime: _messageCreatedDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    // DateTime: Convert [DateTime] to [String]
    String _messageCreatedDateTime = messageCreatedDateTime.toIso8601String();

    return {
      'messageGuidId': messageGuidId,
      'composerGuidId': composerGuidId,
      'messageText': messageText,
      'messageCreatedDateTime': _messageCreatedDateTime,
    };
  }
}
