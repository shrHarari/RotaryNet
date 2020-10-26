import 'dart:convert';

class RotaryClubObject {
  final int areaId;
  final int clusterId;
  final String clubId;
  final String clubName;
  final String clubAddress;
  final String clubMail;
  final String clubManagerGuidId;

  RotaryClubObject({
    this.areaId,
    this.clusterId,
    this.clubId,
    this.clubName,
    this.clubAddress,
    this.clubMail,
    this.clubManagerGuidId});

  /// Convert JsonStringStructure to String
  @override
  String toString() {
    return
      '{'
        ' ${this.areaId},'
        ' ${this.clusterId},'
        ' ${this.clubId},'
        ' ${this.clubName},'
        ' ${this.clubAddress},'
        ' ${this.clubMail},'
        ' ${this.clubManagerGuidId},'
      '}';
  }

  factory RotaryClubObject.fromJson(Map<String, dynamic> parsedJson){
    return RotaryClubObject(
      // areaId: parsedJson['areaId'],
      // clusterId: parsedJson['clusterId'],
      clubId: parsedJson['_id'],
      clubName: parsedJson['clubName'],
      clubAddress: parsedJson['clubAddress'],
      clubMail: parsedJson['clubMail'],
      clubManagerGuidId: parsedJson['clubManagerGuidId'],
    );
  }

  /// DataBase: Madel for RotaryClubObject
  ///----------------------------------------------------
  RotaryClubObject rotaryClubObjectFromJson(String str) {
    final jsonData = json.decode(str);
    return RotaryClubObject.fromMap(jsonData);
  }

  String rotaryClubObjectToJson(RotaryClubObject aRotaryClubObject) {
    final dyn = aRotaryClubObject.toMap();
    return json.encode(dyn);
  }

  factory RotaryClubObject.fromMap(Map<String, dynamic> jsonFromMap) {
    return RotaryClubObject(
      // areaId: jsonFromMap['areaId'],
      // clusterId: jsonFromMap['clusterId'],
      // clubId: jsonFromMap['_id'],
      clubName: jsonFromMap['clubName'],
      clubAddress: jsonFromMap['clubAddress'],
      clubMail: jsonFromMap['clubMail'],
      clubManagerGuidId: jsonFromMap['clubManagerGuidId'],
    );
  }

  Map<String, dynamic> toMap() {
    if (clusterId == null) {
      return {
        // 'areaId': areaId,
        // 'clusterId': clusterId,
        // '_id': clubId,
        'clubName': clubName,
        'clubAddress': clubAddress,
        'clubMail': clubMail,
        'clubManagerGuidId': clubManagerGuidId,
      };
    } else {
      return {
        // 'areaId': areaId,
        // 'clusterId': clusterId,
        '_id': clubId,
        'clubName': clubName,
        'clubAddress': clubAddress,
        'clubMail': clubMail,
        'clubManagerGuidId': clubManagerGuidId,
      };
    }
  }
}
