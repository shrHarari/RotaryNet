import 'dart:convert';

class RotaryAreaObject {
  final String areaId;
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

  factory RotaryAreaObject.fromJson(Map<String, dynamic> parsedJson){
    return RotaryAreaObject(
      areaId: parsedJson['_id'],
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
      // areaId: jsonFromMap['_id'],
      areaName: jsonFromMap['areaName'],
    );
  }

  Map<String, dynamic> toMap() {
    if (areaId == null) {
      return {
        // '_id': areaId,
        'areaName': areaName,
      };
    } else {
      return {
        '_id': areaId,
        'areaName': areaName,
      };
    }
  }
}
