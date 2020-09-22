
//#region Application Global Parameters
// ==============================================================
const String rotaryApplicationName = 'מועדון רוטרי';
//#endregion

//#region Application Parameters: SharedPreferences [Key Name]
// ==============================================================
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
const String rotaryGetUserListUrl = 'http://159.89.225.231:7775/api/registration/';
const String rotaryPersonCardWriteToDataBaseRequestUrl = 'http://159.89.225.231:7775/api/registration/';
const String rotaryEventWriteToDataBaseRequestUrl = 'http://159.89.225.231:7775/api/registration/';
//#endregion

//#region Application Assets URL
// ==============================================================
const String rotaryAssetPersonCardImageUrl = 'C:/FLUTTER_OCTIA/rotary_net/assets/images/person_cards/';
const String rotaryAssetEventImageUrl = 'C:/FLUTTER_OCTIA/rotary_net/assets/images/events';
//#endregion

//#region User Data: Secure Storage [Key Name]
// ==============================================================
const String rotaryUserGuidId = 'Rotary User Guid ID';
const String rotaryUserEmail = 'Rotary User Email';
const String rotaryUserFirstName = 'Rotary User First Name';
const String rotaryUserLastName = 'Rotary User Family Name';
const String rotaryUserPassword = 'Rotary User Password';
const String rotaryUserStayConnected = 'Rotary User StayConnected';
//#endregion

//#region Login Status [Key Name]+[Enum]
// ==============================================================
const String rotaryLoginStatus = 'Rotary Login Status';
enum LoginStatusEnum{NoRequest, Waiting, Accepted, Rejected, NoStatus}
//#endregion

//#region UserType [Key Name]+[Enum]
// ==============================================================
const String rotaryUserType = 'Rotary User Type';
enum UserTypeEnum{SystemAdmin, RotaryMember, Guest}
//#endregion

//#region SearchType [Enum]
// ==============================================================
enum SearchTypeEnum{PersonCard, Event}
//#endregion