import 'dart:convert';
import 'package:rotary_net/shared/constants.dart' as Constants;

class UserObject {
  // String requestId;
  final String emailId;
  final String firstName;
  final String lastName;
  final String password;
  Constants.UserTypeEnum userType;
  bool stayConnected;

  UserObject({
    // this.requestId,
    this.emailId,
    this.firstName,
    this.lastName,
    this.password,
    this.userType,
    this.stayConnected});

  // Set User RequestId
  //=====================================
  // Future <void> setRequestId(String aRequestId) async {
  //   requestId = aRequestId;
  // }

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

  factory UserObject.fromJson(Map<String, dynamic> parsedJson){
    return UserObject(
        emailId: parsedJson['emailId'],
        firstName : parsedJson['firstName'],
        lastName : parsedJson['lastName'],
        password : parsedJson['password'],
        userType : parsedJson['userType'],
        stayConnected : parsedJson['stayConnected']
    );
  }

  @override
  String toString() {
    return
     '{'
      // ' ${this.requestId},'
      ' ${this.emailId},'
      ' ${this.firstName},'
      ' ${this.lastName},'
      ' ${this.password},'
      ' ${this.userType},'
      ' ${this.stayConnected},'
    ' }';
  }

  Map toJson() => {
    // 'requestId': requestId,
    'emailId': emailId,
    'firstName': firstName,
    'lastName': lastName,
    'password': password,
    'userType': userType,
    'stayConnected': stayConnected,
  };


  /// DataBase: Madel for Person Card
  ///----------------------------------------------------
  UserObject userFromJson(String str) {
    final jsonData = json.decode(str);
    return UserObject.fromMap(jsonData);
  }

  String userToJson(UserObject aUser) {
    final dyn = aUser.toMap();
    return json.encode(dyn);
  }

  factory UserObject.fromMap(Map<String, dynamic> jsonFromMap) =>
      UserObject(
          emailId: jsonFromMap['emailId'],
          firstName : jsonFromMap['firstName'],
          lastName : jsonFromMap['lastName'],
          password : jsonFromMap['password'],
          userType : jsonFromMap['userType'],
          stayConnected : jsonFromMap['stayConnected'],
      );

  Map<String, dynamic> toMap() => {
    'emailId': emailId,
    'firstName': firstName,
    'lastName': lastName,
    'password': password,
    'userType': userType,
    'stayConnected': stayConnected,
  };
}
