import 'dart:convert';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class UserObject {
  final String userGuidId;
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  Constants.UserTypeEnum userType;
  bool stayConnected;

  UserObject({
    this.userGuidId,
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.userType,
    this.stayConnected});

  // get UserObject From ConnectedUserObject
  //===========================================
  static Future <UserObject> getUserObjectFromConnectedUserObject(ConnectedUserObject aConnectedUserObject) async {
    return UserObject(
        userGuidId: aConnectedUserObject.userGuidId,
        email: aConnectedUserObject.email,
        firstName : aConnectedUserObject.firstName,
        lastName : aConnectedUserObject.lastName,
        password : aConnectedUserObject.password,
        userType : aConnectedUserObject.userType,
        stayConnected : aConnectedUserObject.stayConnected
    );
  }

  // Set StayConnected
  //=====================================
  Future <void> setStayConnected(bool aStayConnected) async {
    stayConnected = aStayConnected;
  }

  // Set UserType
  //=====================================
  Future <void> setUserType(Constants.UserTypeEnum aUserType) async {
    userType = aUserType;
  }

  /// Convert JsonStringStructure to String
  @override
  String toString() {
    return
      '{'
        ' ${this.userGuidId},'
        ' ${this.email},'
        ' ${this.firstName},'
        ' ${this.lastName},'
        ' ${this.password},'
        ' ${this.userType},'
        ' ${this.stayConnected},'
      '}';
  }

  factory UserObject.fromJson(Map<String, dynamic> parsedJson){
    /// Deserialize the parsedJson string to UserObject
    // UserType: Convert [String] to [Enum]
    Constants.UserTypeEnum _userType;
    _userType = EnumToString.fromString(Constants.UserTypeEnum.values, parsedJson['userType']);

    // StayConnected: Convert [int] to [bool]
    bool _stayConnected;
    parsedJson['stayConnected'] == 0 ? _stayConnected = false : _stayConnected = true;

    return UserObject(
        userGuidId: parsedJson['_id'],
        email: parsedJson['email'],
        firstName : parsedJson['firstName'],
        lastName : parsedJson['lastName'],
        password : parsedJson['password'],
        userType : _userType,
        stayConnected : _stayConnected
    );
  }

  /// DataBase: Madel for User
  ///----------------------------------------------------
  UserObject userFromJson(String str) {
    final jsonData = json.decode(str);
    return UserObject.fromMap(jsonData);
  }

  String userToJson(UserObject aUser) {
    final dyn = aUser.toMap();
    return json.encode(dyn);
  }

  factory UserObject.fromMap(Map<String, dynamic> jsonFromMap) {

    // UserType: Convert [String] to [Enum]
    Constants.UserTypeEnum _userType;
    _userType = EnumToString.fromString(Constants.UserTypeEnum.values, jsonFromMap['userType']);

    // StayConnected: Convert [int] to [bool]
    bool _stayConnected;
    jsonFromMap['stayConnected'] == 0 ? _stayConnected = false : _stayConnected = true;

    return UserObject(
          userGuidId: jsonFromMap['_id'],
          email: jsonFromMap['email'],
          firstName : jsonFromMap['firstName'],
          lastName : jsonFromMap['lastName'],
          password : jsonFromMap['password'],
          userType : _userType,
          stayConnected : _stayConnected,
      );
  }

  Map<String, dynamic> toMap() {
    // UserType: Convert [Enum] to [String]
    String _userType = EnumToString.parse(userType);

    if (userGuidId == null) {
      return {
        // '_id': userGuidId,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
        'userType': _userType,
        'stayConnected': stayConnected ? 1 : 0,
      };
    } else {
      return {
        '_id': userGuidId,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
        'userType': _userType,
        'stayConnected': stayConnected ? 1 : 0,
      };
    }
  }
}
