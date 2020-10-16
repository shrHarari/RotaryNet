import 'dart:convert';

class RotaryClusterObject {
  final int areaId;
  final int clusterId;
  final String clusterName;

  RotaryClusterObject({
    this.areaId,
    this.clusterId,
    this.clusterName});

  /// Convert JsonStringStructure to String
  @override
  String toString() {
    return
      '{'
        ' ${this.areaId},'
        ' ${this.clusterId},'
        ' ${this.clusterName},'
      '}';
  }

  factory RotaryClusterObject.fromJson(Map<String, dynamic> parsedJson){
    return RotaryClusterObject(
      areaId: parsedJson['areaId'],
      clusterId: parsedJson['clusterId'],
      clusterName: parsedJson['clusterName'],
    );
  }

  /// DataBase: Madel for RotaryClusterObject
  ///----------------------------------------------------
  RotaryClusterObject rotaryClusterObjectFromJson(String str) {
    final jsonData = json.decode(str);
    return RotaryClusterObject.fromMap(jsonData);
  }

  String rotaryClusterObjectToJson(RotaryClusterObject aRotaryClusterObject) {
    final dyn = aRotaryClusterObject.toMap();
    return json.encode(dyn);
  }

  factory RotaryClusterObject.fromMap(Map<String, dynamic> jsonFromMap) {
    return RotaryClusterObject(
      areaId: jsonFromMap['areaId'],
      clusterId: jsonFromMap['clusterId'],
      clusterName: jsonFromMap['clusterName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'areaId': areaId,
      'clusterId': clusterId,
      'clusterName': clusterName,
    };
  }
}
