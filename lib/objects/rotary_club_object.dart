import 'dart:convert';

class RotaryClubObject {
  final int areaId;
  final int clusterId;
  final int clubId;
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

  /// Used for jsonDecode Function
  Map toJson() => {
    'areaId': areaId,
    'clusterId': clusterId,
    'clubId': clubId,
    'clubName': clubName,
    'clubAddress': clubAddress,
    'clubMail': clubMail,
    'clubManagerGuidId': clubManagerGuidId,
  };

  factory RotaryClubObject.fromJson(Map<String, dynamic> parsedJson){
    return RotaryClubObject(
      areaId: parsedJson['areaId'],
      clusterId: parsedJson['clusterId'],
      clubId: parsedJson['clubId'],
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
      areaId: jsonFromMap['areaId'],
      clusterId: jsonFromMap['clusterId'],
      clubId: jsonFromMap['clubId'],
      clubName: jsonFromMap['clubName'],
      clubAddress: jsonFromMap['clubAddress'],
      clubMail: jsonFromMap['clubMail'],
      clubManagerGuidId: jsonFromMap['clubManagerGuidId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'areaId': areaId,
      'clusterId': clusterId,
      'clubId': clubId,
      'clubName': clubName,
      'clubAddress': clubAddress,
      'clubMail': clubMail,
      'clubManagerGuidId': clubManagerGuidId,
    };
  }
}
