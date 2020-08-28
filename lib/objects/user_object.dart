import 'package:rotary_net/shared/constants.dart' as Constants;

class UserObject {
  String requestId;
  final String emailId;
  final String firstName;
  final String lastName;
  final String password;
  bool stayConnected;

  UserObject({
    this.requestId,
    this.emailId,
    this.firstName,
    this.lastName,
    this.password,
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

  @override
  String toString() {
    return '{'
        ' ${this.requestId},'
        ' ${this.emailId},'
        ' ${this.firstName},'
        ' ${this.lastName},'
        ' ${this.password},'
        ' ${this.stayConnected},'
        ' }';
  }

  Map toJson() => {
    'requestId': requestId,
    'emailId': emailId,
    'firstName': firstName,
    'lastName': lastName,
    'password': password,
    'isStayConnected': stayConnected,
  };
}
