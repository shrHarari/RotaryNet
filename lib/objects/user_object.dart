import 'dart:convert';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class UserObject {
  final String emailId;
  final String firstName;
  final String lastName;
  final String password;
  Constants.UserTypeEnum userType;
  bool stayConnected;

  UserObject({
    this.emailId,
    this.firstName,
    this.lastName,
    this.password,
    this.userType,
    this.stayConnected});

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
        ' ${this.emailId},'
        ' ${this.firstName},'
        ' ${this.lastName},'
        ' ${this.password},'
        ' ${this.userType},'
        ' ${this.stayConnected},'
      '}';
  }

  /// Used for jsonDecode Function
  Map toJson() => {
    'emailId': emailId,
    'firstName': firstName,
    'lastName': lastName,
    'password': password,
    'userType': userType,
    'stayConnected': stayConnected,
  };

  factory UserObject.fromJson(Map<String, dynamic> parsedJson){
    /// Deserialize the parsedJson string to UserObject
    // UserType: Convert [String] to [Enum]
    Constants.UserTypeEnum _userType;
    _userType = EnumToString.fromString(Constants.UserTypeEnum.values, parsedJson['userType']);

    // StayConnected: Convert [int] to [bool]
    bool _stayConnected;
    parsedJson['stayConnected'] == 0 ? _stayConnected = false : _stayConnected = true;

    return UserObject(
        emailId: parsedJson['emailId'],
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
          emailId: jsonFromMap['emailId'],
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
      'emailId': emailId,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'userType': _userType,
      'stayConnected': stayConnected ? 1 : 0,
    };
  }
}
