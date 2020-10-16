import 'dart:convert';

class RotaryRoleObject {
  final int roleId;
  final String roleName;

  RotaryRoleObject({
    this.roleId,
    this.roleName});

  /// Convert JsonStringStructure to String
  @override
  String toString() {
    return
      '{'
        ' ${this.roleId},'
        ' ${this.roleName},'
      '}';
  }

  factory RotaryRoleObject.fromJson(Map<String, dynamic> parsedJson){
    return RotaryRoleObject(
      roleId: parsedJson['roleId'],
      roleName: parsedJson['roleName'],
    );
  }

  /// DataBase: Madel for RotaryRole
  ///----------------------------------------------------
  RotaryRoleObject rotaryRoleObjectFromJson(String str) {
    final jsonData = json.decode(str);
    return RotaryRoleObject.fromMap(jsonData);
  }

  String rotaryRoleObjectToJson(RotaryRoleObject aRotaryRoleObject) {
    final dyn = aRotaryRoleObject.toMap();
    return json.encode(dyn);
  }

  factory RotaryRoleObject.fromMap(Map<String, dynamic> jsonFromMap) {
    return RotaryRoleObject(
      roleId: jsonFromMap['roleId'],
      roleName: jsonFromMap['roleName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roleId': roleId,
      'roleName': roleName,
    };
  }
}
