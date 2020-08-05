import 'package:rotary_net/shared/constants.dart' as Constants;

class UserObject {
  String requestId;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String phoneNumberDialCode;
  final String phoneNumberParse;
  final String phoneNumberCleanLongFormat;

  UserObject({
    this.requestId,
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.phoneNumberDialCode,
    this.phoneNumberParse,
    this.phoneNumberCleanLongFormat});

  // Set User RequestId
  //=====================================
  Future <void> setRequestId(String aRequestId) async {
    requestId = aRequestId;
  }
}
