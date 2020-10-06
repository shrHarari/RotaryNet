import 'dart:convert';

class RotaryAreaObject {
  final int areaId;
  final String areaName;

  RotaryAreaObject({
    this.areaId,
    this.areaName});

  /// Convert JsonStringStructure to String
  @override
  String toString() {
    return
      '{'
        ' ${this.areaId},'
        ' ${this.areaName},'
      '}';
  }

  /// Used for jsonDecode Function
  Map toJson() => {
    'areaId': areaId,
    'areaName': areaName,
  };

  factory RotaryAreaObject.fromJson(Map<String, dynamic> parsedJson){
    return RotaryAreaObject(
      areaId: parsedJson['areaId'],
      areaName: parsedJson['areaName'],
    );
  }

  /// DataBase: Madel for RotaryAreaObject
  ///----------------------------------------------------
  RotaryAreaObject rotaryAreaObjectFromJson(String str) {
    final jsonData = json.decode(str);
    return RotaryAreaObject.fromMap(jsonData);
  }

  String rotaryAreaObjectToJson(RotaryAreaObject aRotaryAreaObject) {
    final dyn = aRotaryAreaObject.toMap();
    return json.encode(dyn);
  }

  factory RotaryAreaObject.fromMap(Map<String, dynamic> jsonFromMap) {
    return RotaryAreaObject(
      areaId: jsonFromMap['areaId'],
      areaName: jsonFromMap['areaName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'areaId': areaId,
      'areaName': areaName,
    };
  }
}
