import 'dart:convert';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class ConnectedUserObject {
  final String userGuidId;
  final String personCardId;
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  Constants.UserTypeEnum userType;
  bool stayConnected;

  ConnectedUserObject({
    this.userGuidId,
    this.personCardId,
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
        personCardId: aUserObject.personCardId,
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
        ' ${this.personCardId},'
        ' ${this.email},'
        ' ${this.firstName},'
        ' ${this.lastName},'
        ' ${this.password},'
        ' ${this.userType},'
        ' ${this.stayConnected},'
      '}';
  }

  factory ConnectedUserObject.fromJson(Map<String, dynamic> parsedJson){
    /// Deserialize the parsedJson string to UserObject
    // UserType: Convert [String] to [Enum]
    Constants.UserTypeEnum _userType;
    _userType = EnumToString.fromString(Constants.UserTypeEnum.values, parsedJson['userType']);

    // StayConnected: Convert [int] to [bool]
    bool _stayConnected;
    parsedJson['stayConnected'] == 0 ? _stayConnected = false : _stayConnected = true;

    if (parsedJson['_id'] == null) {
      return ConnectedUserObject(
          userGuidId: '',
          personCardId: parsedJson['personCardId'],
          email: parsedJson['email'],
          firstName : parsedJson['firstName'],
          lastName : parsedJson['lastName'],
          password : parsedJson['password'],
          userType : _userType,
          stayConnected : _stayConnected
      );
    } else {
      return ConnectedUserObject(
          userGuidId: parsedJson['_id'],
          personCardId: parsedJson['personCardId'],
          email: parsedJson['email'],
          firstName : parsedJson['firstName'],
          lastName : parsedJson['lastName'],
          password : parsedJson['password'],
          userType : _userType,
          stayConnected : _stayConnected
      );
    }
  }

  /// DataBase: Madel for User
  ///----------------------------------------------------
  ConnectedUserObject connectedUserFromJson(String str) {
    final jsonData = json.decode(str);
    return ConnectedUserObject.fromMap(jsonData);
  }

  String connectedUserToJson(ConnectedUserObject aConnectedUser) {
    final dyn = aConnectedUser.toMap();
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
      userGuidId: jsonFromMap['_id'],
      personCardId: jsonFromMap['personCardId'],
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
