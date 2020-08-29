import 'package:rotary_net/shared/constants.dart' as Constants;

class UserObject {
  String requestId;
  final String emailId;
  final String firstName;
  final String lastName;
  final String password;
  Constants.UserTypeEnum userType;
  bool stayConnected;

  UserObject({
    this.requestId,
    this.emailId,
    this.firstName,
    this.lastName,
    this.password,
    this.userType,
    this.stayConnected});

  // Set User RequestId
  //=====================================
  Future <void> setRequestId(String aRequestId) async {
    requestId = aRequestId;
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

  @override
  String toString() {
    return
     '{'
      ' ${this.requestId},'
      ' ${this.emailId},'
      ' ${this.firstName},'
      ' ${this.lastName},'
      ' ${this.password},'
      ' ${this.userType},'
      ' ${this.stayConnected},'
    ' }';
  }

  Map toJson() => {
    'requestId': requestId,
    'emailId': emailId,
    'firstName': firstName,
    'lastName': lastName,
    'password': password,
    'userType': userType,
    'isStayConnected': stayConnected,
  };
}
