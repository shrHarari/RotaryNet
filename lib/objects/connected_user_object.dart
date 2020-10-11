import 'dart:convert';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class ConnectedUserObject {
  final String userGuidId;
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  Constants.UserTypeEnum userType;
  bool stayConnected;

  ConnectedUserObject({
    this.userGuidId,
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.userType,
    this.stayConnected});

  // get ConnectedUserObject From UserObject
  //===========================================
  static Future <ConnectedUserObject> getConnectedUserObjectFromUserObject(UserObject aUserObject) async {
    return ConnectedUserObject(
        userGuidId: aUserObject.userGuidId,
        email: aUserObject.email,
        firstName : aUserObject.firstName,
        lastName : aUserObject.lastName,
        password : aUserObject.password,
        userType : aUserObject.userType,
        stayConnected : aUserObject.stayConnected
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

  // /// Used for jsonDecode Function
  // Map toJson() => {
  //   'userGuidId': userGuidId,
  //   'email': email,
  //   'firstName': firstName,
  //   'lastName': lastName,
  //   'password': password,
  //   'userType': userType,
  //   'stayConnected': stayConnected,
  // };

  factory ConnectedUserObject.fromJson(Map<String, dynamic> parsedJson){
    /// Deserialize the parsedJson string to UserObject
    // UserType: Convert [String] to [Enum]
    Constants.UserTypeEnum _userType;
    _userType = EnumToString.fromString(Constants.UserTypeEnum.values, parsedJson['userType']);

    // StayConnected: Convert [int] to [bool]
    bool _stayConnected;
    parsedJson['stayConnected'] == 0 ? _stayConnected = false : _stayConnected = true;

    return ConnectedUserObject(
        userGuidId: parsedJson['userGuidId'],
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
  ConnectedUserObject userFromJson(String str) {
    final jsonData = json.decode(str);
    return ConnectedUserObject.fromMap(jsonData);
  }

  String userToJson(ConnectedUserObject aUser) {
    final dyn = aUser.toMap();
    return json.encode(dyn);
  }

  factory ConnectedUserObject.fromMap(Map<String, dynamic> jsonFromMap) {

    // UserType: Convert [String] to [Enum]
    Constants.UserTypeEnum _userType;
    _userType = EnumToString.fromString(Constants.UserTypeEnum.values, jsonFromMap['userType']);

    // StayConnected: Convert [int] to [bool]
    bool _stayConnected;
    jsonFromMap['stayConnected'] == 0 ? _stayConnected = false : _stayConnected = true;

    return ConnectedUserObject(
      userGuidId: jsonFromMap['userGuidId'],
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
    return {
      'userGuidId': userGuidId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'userType': _userType,
      'stayConnected': stayConnected ? 1 : 0,
    };
  }
}
