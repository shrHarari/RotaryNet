import 'dart:convert';

import 'package:rotary_net/objects/message_with_description_object.dart';

class MessageQueueObject {
  final String messageGuidId;
  final String personCardGuidId;
  bool messageReadStatus;

  MessageQueueObject({
    this.messageGuidId,
    this.personCardGuidId,
    this.messageReadStatus,});

  // Set ReadStatus
  //=====================================
  Future <void> setReadStatus(bool aReadStatus) async {
    messageReadStatus = aReadStatus;
  }

  // get MessageQueueObject From MessageWithDescriptionObject
  //=======================================================
  static Future <MessageQueueObject> getMessageQueueObjectFromMessageWithDescriptionObject(
              MessageWithDescriptionObject aMessageWithDescriptionObject) async {
    return MessageQueueObject(
      messageGuidId: aMessageWithDescriptionObject.messageGuidId,
      personCardGuidId: aMessageWithDescriptionObject.composerGuidId,
      messageReadStatus: false,
    );
  }

  /// Convert JsonStringStructure to String
  @override
  String toString() {
    return
      '{'
        ' ${this.messageGuidId},'
        ' ${this.personCardGuidId},'
        ' ${this.messageReadStatus},'
      '}';
  }

  // /// Used for jsonDecode Function
  // Map toJson() => {
  //   'messageGuidId': messageGuidId,
  //   'personCardGuidId': personCardGuidId,
  //   'messageReadStatus': messageReadStatus,
  // };

  factory MessageQueueObject.fromJson(Map<String, dynamic> parsedJson){

    // ReadStatus: Convert [int] to [bool]
    bool _messageReadStatus;
    parsedJson['messageReadStatus'] == 0 ? _messageReadStatus = false : _messageReadStatus = true;

    return MessageQueueObject(
      messageGuidId: parsedJson['messageGuidId'],
      personCardGuidId: parsedJson['personCardGuidId'],
      messageReadStatus: _messageReadStatus,
    );
  }

  /// DataBase: Madel for MessageQueueObject
  ///----------------------------------------------------
  MessageQueueObject messageQueueObjectObjectFromJson(String str) {
    final jsonData = json.decode(str);
    return MessageQueueObject.fromMap(jsonData);
  }

  String messageQueueObjectToJson(MessageQueueObject aMessageQueueObject) {
    final dyn = aMessageQueueObject.toMap();
    return json.encode(dyn);
  }

  factory MessageQueueObject.fromMap(Map<String, dynamic> jsonFromMap) {
    // ReadStatus: Convert [int] to [bool]
    bool _messageReadStatus;
    jsonFromMap['messageReadStatus'] == 0 ? _messageReadStatus = false : _messageReadStatus = true;


    return MessageQueueObject(
      messageGuidId: jsonFromMap['messageGuidId'],
      personCardGuidId: jsonFromMap['personCardGuidId'],
      messageReadStatus: _messageReadStatus,
    );
  }

  Map<String, dynamic> toMap() {

    return {
      'messageGuidId': messageGuidId,
      'personCardGuidId': personCardGuidId,
      'messageReadStatus': messageReadStatus ? 1 : 0,
    };
  }
}
