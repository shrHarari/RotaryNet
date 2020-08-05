import 'package:rotary_net/shared/constants.dart' as Constants;

class LoginObject {
  Constants.LoginStatusEnum loginStatus;

  LoginObject({this.loginStatus});

  // Set Login Status
  //=====================================
  Future <void> setLoginStatus(Constants.LoginStatusEnum aLoginStatus) async {
    loginStatus = aLoginStatus;
  }
}
