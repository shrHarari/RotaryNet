
//#region Application Global Parameters
// ==============================================================
const String rotaryApplicationName = 'מועדון רוטרי';
//#endregion

//#region Application Parameters: SharedPreferences [Key Name]
  // ==============================================================
  const String rotaryEncryptedTimeOffsetMin = 'Encrypted Time Offset Min';
  const String rotaryDebugMode = 'Rotary Debug Mode';
  //#endregion

  //#region Application parameters [Globals Values]
  // ==============================================================
  const String rotaryLoggerFileName = 'Rotary_Log.txt';
  //#endregion

  //#region Server URL
  // ==============================================================
  const Map<String, String> rotaryUrlHeader = {"Content-type": "application/json"};
  const String rotaryUserRegistrationUrl = 'http://159.89.225.231:7775/api/registration/';
  const String rotaryUserLoginUrl = 'http://159.89.225.231:7775/api/login/';
  const String rotaryGetPersonCardListUrl = 'http://159.89.225.231:7775/api/registration/';
  const String rotaryPersonCardWriteToDataBaseRequestUrl = 'http://159.89.225.231:7775/api/registration/';
  //#endregion

  //#region User Data: SharedPreferences [Key Name]
  // ==============================================================
  const String rotaryUserRequestId = 'Rotary User Request ID';
  const String rotaryUserEmail = 'Rotary User Email';
  const String rotaryUserFirstName = 'Rotary User First Name';
  const String rotaryUserLastName = 'Rotary User Family Name';
  const String rotaryUserPassword = 'Rotary User Password';
  const String rotaryUserStayConnected = 'Rotary User StayConnected';
  //#endregion

  //#region User Data: SharedPreferences [Initial Value]
  // ==============================================================
  const String rotaryNoRequestIdInitValue = 'No Request ID';
  //#endregion

  //#region Login Status [Key Name]+[Enum]
  // ==============================================================
  const String rotaryLoginStatus = 'Rotary Login Status';
  enum LoginStatusEnum{NoRequest, Waiting, Accepted, Rejected, NoStatus}
  //#endregion

