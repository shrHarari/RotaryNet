import 'dart:convert';
import 'package:rotary_net/shared/constants.dart' as Constants;

class MessageWithDescriptionObject {
  final String messageGuidId;
  final String composerGuidId;
  final String composerFirstName;
  final String composerLastName;
  final String composerEmail;
  final String messageText;
  final DateTime messageCreatedDateTime;
  Constants.RotaryRolesEnum roleId;
  final String roleName;
  final String areaId;
  final String areaName;
  final String clusterId;
  final String clusterName;
  final String clubId;
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

  MessageWithDescriptionObject.copy(MessageWithDescriptionObject uniqueObject) :
        messageGuidId = uniqueObject.messageGuidId,
        composerGuidId = uniqueObject.composerGuidId,
        composerFirstName = uniqueObject.composerFirstName,
        composerLastName = uniqueObject.composerLastName,
        composerEmail = uniqueObject.composerEmail,
        messageText = uniqueObject.messageText,
        messageCreatedDateTime = uniqueObject.messageCreatedDateTime,
        roleId = uniqueObject.roleId,
        roleName = uniqueObject.roleName,
        areaId = uniqueObject.areaId,
        areaName = uniqueObject.areaName,
        clusterId = uniqueObject.clusterId,
        clusterName = uniqueObject.clusterName,
        clubId = uniqueObject.clubId,
        clubName = uniqueObject.clubName,
        clubAddress = uniqueObject.clubAddress,
        clubMail = uniqueObject.clubMail,
        clubManagerGuidId = uniqueObject.clubManagerGuidId;

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

  factory MessageWithDescriptionObject.fromJson(Map<String, dynamic> parsedJson){
    // DateTime: Convert [String] to [DateTime]
    DateTime _messageCreatedDateTime = DateTime.parse(parsedJson['messageCreatedDateTime']);

    // RoleId: Convert [int] to [Enum]
    Constants.RotaryRolesEnum _roleEnum;
    Constants.RotaryRolesEnum _roleEnumValue = _roleEnum.convertToEnum(parsedJson['roleId']);

    return MessageWithDescriptionObject(
      messageGuidId: parsedJson['messageGuidId'],
      composerGuidId: parsedJson['composerGuidId'],
      composerFirstName: parsedJson['composerFirstName'],
      composerLastName: parsedJson['composerLastName'],
      composerEmail: parsedJson['composerEmail'],
      messageText: parsedJson['messageText'],
      messageCreatedDateTime: _messageCreatedDateTime,
      roleId : _roleEnumValue,
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

    // RoleId: Convert [int] to [Enum]
    Constants.RotaryRolesEnum _roleEnum;
    Constants.RotaryRolesEnum _roleEnumValue = _roleEnum.convertToEnum(jsonFromMap['roleId']);

    return MessageWithDescriptionObject(
        messageGuidId: jsonFromMap['messageGuidId'],
        composerGuidId: jsonFromMap['composerGuidId'],
        composerFirstName: jsonFromMap['composerFirstName'],
        composerLastName: jsonFromMap['composerLastName'],
        composerEmail: jsonFromMap['composerEmail'],
        messageText: jsonFromMap['messageText'],
        messageCreatedDateTime: _messageCreatedDateTime,
        roleId: _roleEnumValue,
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

    // RoleEnum: Convert [Enum] to [int]
    Constants.RotaryRolesEnum _roleEnum = roleId;
    int _roleEnumValue = _roleEnum.value;

    return {
      'messageGuidId': messageGuidId,
      'composerGuidId': composerGuidId,
      'composerFirstName': composerFirstName,
      'composerLastName': composerLastName,
      'composerEmail': composerEmail,
      'messageText': messageText,
      'messageCreatedDateTime': _messageCreatedDateTime,
      'roleId': _roleEnumValue,
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
