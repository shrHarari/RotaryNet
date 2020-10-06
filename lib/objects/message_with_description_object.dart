import 'dart:convert';

class MessageWithDescriptionObject {
  final String messageGuidId;
  final String composerGuidId;
  final String composerFirstName;
  final String composerLastName;
  final String composerEmail;
  final String messageText;
  final DateTime messageCreatedDateTime;
  final int roleId;
  final String roleName;
  final int areaId;
  final String areaName;
  final int clusterId;
  final String clusterName;
  final int clubId;
  final String clubName;
  final String clubAddress;
  final String clubMail;
  final String clubManagerGuidId;

  MessageWithDescriptionObject({
    this.messageGuidId,
    this.composerGuidId,
    this.composerFirstName,
    this.composerLastName,
    this.composerEmail,
    this.messageText,
    this.messageCreatedDateTime,
    this.roleId,
    this.roleName,
    this.areaId,
    this.areaName,
    this.clusterId,
    this.clusterName,
    this.clubId,
    this.clubName,
    this.clubAddress,
    this.clubMail,
    this.clubManagerGuidId,
  });

  /// Convert JsonStringStructure to String
  @override
  String toString() {
    return
      '{'
        ' ${this.messageGuidId},'
        ' ${this.composerGuidId},'
        ' ${this.composerFirstName},'
        ' ${this.composerLastName},'
        ' ${this.composerEmail},'
        ' ${this.messageText},'
        ' ${this.messageCreatedDateTime},'
        ' ${this.roleId},'
        ' ${this.roleName},'
        ' ${this.areaId},'
        ' ${this.areaName},'
        ' ${this.clusterId},'
        ' ${this.clusterName},'
        ' ${this.clubId},'
        ' ${this.clubName},'
        ' ${this.clubAddress},'
        ' ${this.clubMail},'
        ' ${this.clubManagerGuidId},'
      '}';
  }

  /// Used for jsonDecode Function
  Map toJson() => {
    'messageGuidId': messageGuidId,
    'composerGuidId': composerGuidId,
    'composerFirstName': composerFirstName,
    'composerLastName': composerLastName,
    'composerEmail': composerEmail,
    'messageText': messageText,
    'messageCreatedDateTime': messageCreatedDateTime.toString(),
    'roleId': roleId,
    'roleName': roleName,
    'areaId': areaId,
    'areaName': areaName,
    'clusterId': clusterId,
    'clusterName': clusterName,
    'clubId': clubId,
    'clubName': clubName,
    'clubAddress': clubAddress,
    'clubMail': clubMail,
    'clubManagerGuidId': clubManagerGuidId,
  };

  factory MessageWithDescriptionObject.fromJson(Map<String, dynamic> parsedJson){
    // DateTime: Convert [String] to [DateTime]
    DateTime _messageCreatedDateTime = DateTime.parse(parsedJson['messageCreatedDateTime']);

    return MessageWithDescriptionObject(
      messageGuidId: parsedJson['messageGuidId'],
      composerGuidId: parsedJson['composerGuidId'],
      composerFirstName: parsedJson['composerFirstName'],
      composerLastName: parsedJson['composerLastName'],
      composerEmail: parsedJson['composerEmail'],
      messageText: parsedJson['messageText'],
      messageCreatedDateTime: _messageCreatedDateTime,
      roleId: parsedJson['roleId'],
      roleName: parsedJson['roleName'],
      areaId: parsedJson['areaId'],
      areaName: parsedJson['areaName'],
      clusterId: parsedJson['clusterId'],
      clusterName: parsedJson['clusterName'],
      clubId: parsedJson['clubId'],
      clubName: parsedJson['clubName'],
      clubAddress: parsedJson['clubAddress'],
      clubMail: parsedJson['clubMail'],
      clubManagerGuidId: parsedJson['clubManagerGuidId'],
    );
  }

  /// DataBase: Madel for MessageObject
  ///----------------------------------------------------
  MessageWithDescriptionObject messageObjectFromJson(String str) {
    final jsonData = json.decode(str);
    return MessageWithDescriptionObject.fromMap(jsonData);
  }

  String messageObjectToJson(MessageWithDescriptionObject aMessageObject) {
    final dyn = aMessageObject.toMap();
    return json.encode(dyn);
  }

  factory MessageWithDescriptionObject.fromMap(Map<String, dynamic> jsonFromMap) {
    // DateTime: Convert [String] to [DateTime]
    DateTime _messageCreatedDateTime = DateTime.parse(jsonFromMap['messageCreatedDateTime']);

    return MessageWithDescriptionObject(
        messageGuidId: jsonFromMap['messageGuidId'],
        composerGuidId: jsonFromMap['composerGuidId'],
        composerFirstName: jsonFromMap['composerFirstName'],
        composerLastName: jsonFromMap['composerLastName'],
        composerEmail: jsonFromMap['composerEmail'],
        messageText: jsonFromMap['messageText'],
        messageCreatedDateTime: _messageCreatedDateTime,
        roleId: jsonFromMap['roleId'],
        roleName: jsonFromMap['roleName'],
        areaId: jsonFromMap['areaId'],
        areaName: jsonFromMap['areaName'],
        clusterId: jsonFromMap['clusterId'],
        clusterName: jsonFromMap['clusterName'],
        clubId: jsonFromMap['clubId'],
        clubName: jsonFromMap['clubName'],
        clubAddress: jsonFromMap['clubAddress'],
        clubMail: jsonFromMap['clubMail'],
        clubManagerGuidId: jsonFromMap['clubManagerGuidId'],
    );
  }

  Map<String, dynamic> toMap() {
    // DateTime: Convert [DateTime] to [String]
    String _messageCreatedDateTime = messageCreatedDateTime.toIso8601String();

    return {
      'messageGuidId': messageGuidId,
      'composerGuidId': composerGuidId,
      'composerFirstName': composerFirstName,
      'composerLastName': composerLastName,
      'composerEmail': composerEmail,
      'messageText': messageText,
      'messageCreatedDateTime': _messageCreatedDateTime,
      'roleId': roleId,
      'roleName': roleName,
      'areaId': areaId,
      'areaName': areaName,
      'clusterId': clusterId,
      'clusterName': clusterName,
      'clubId': clubId,
      'clubName': clubName,
      'clubAddress': clubAddress,
      'clubMail': clubMail,
      'clubManagerGuidId': clubManagerGuidId,
    };
  }
}
