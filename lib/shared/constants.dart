
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

//#region RotaryRoles [Key Name]+[Enum]
// ==============================================================
enum RotaryRolesEnum{RotaryManager, Gizbar, AreaManager, ClusterManager, ClubManager, Member}

extension RotaryRolesEnumExtension on RotaryRolesEnum {

  int get value {
    switch (this) {
      case RotaryRolesEnum.RotaryManager:
        return 1;
      case RotaryRolesEnum.Gizbar:
        return 2;
      case RotaryRolesEnum.AreaManager:
        return 3;
      case RotaryRolesEnum.ClusterManager:
        return 4;
      case RotaryRolesEnum.ClubManager:
        return 5;
      case RotaryRolesEnum.Member:
        return 6;
      default:
        return null;
    }
  }

  String get description {
    switch (this) {
      case RotaryRolesEnum.RotaryManager:
        return "יושב ראש";
      case RotaryRolesEnum.Gizbar:
        return "גזבר";
      case RotaryRolesEnum.AreaManager:
        return "מזכיר אזור";
      case RotaryRolesEnum.ClusterManager:
        return "מזכיר אשכול";
      case RotaryRolesEnum.ClubManager:
        return "מזכיר מועדון";
      case RotaryRolesEnum.Member:
        return "חבר";
      default:
        return null;
    }
  }

  RotaryRolesEnum convertToEnum(int aValue) {
    switch (aValue) {
      case 1:
        return RotaryRolesEnum.RotaryManager;
      case 2:
        return RotaryRolesEnum.Gizbar;
      case 3:
        return RotaryRolesEnum.AreaManager;
      case 4:
        return  RotaryRolesEnum.ClusterManager;
      case 5:
        return   RotaryRolesEnum.ClubManager;
      case 6:
        return  RotaryRolesEnum.Member;
      default:
        return null;
    }
  }

  /////////////// How to Use: /////////////////////
  // RotaryRolesEnum rotaryRolesEnum = RotaryRolesEnum.RotaryManager;
  // String roleDescription = rotaryRolesEnum.description;
  // rotaryRolesEnum.display();
}
//#endregion