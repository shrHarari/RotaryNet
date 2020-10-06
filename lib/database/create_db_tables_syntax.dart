
class CreateDbTablesSyntax {

  //#region Create Users Table
  static String createUsersTable(){
    return
      "CREATE TABLE IF NOT EXISTS Users ("
          "userGuidId TEXT PRIMARY KEY, "
          "email TEXT, "
          "firstName TEXT, "
          "lastName TEXT, "
          "password TEXT, "
          "userType TEXT, "
          "stayConnected BIT "
      ")";
  }
  //#endregion

  //#region Create PersonCards Table
  static String createPersonCardsTable(){
    return
      "CREATE TABLE IF NOT EXISTS PersonCards ("
          "userGuidId TEXT PRIMARY KEY, "
          "email TEXT, "
          "firstName TEXT, "
          "lastName TEXT,"
          "firstNameEng TEXT, "
          "lastNameEng TEXT, "
          "phoneNumber TEXT, "
          "phoneNumberDialCode TEXT, "
          "phoneNumberParse TEXT, "
          "phoneNumberCleanLongFormat TEXT, "
          "pictureUrl TEXT, "
          "cardDescription TEXT, "
          "internetSiteUrl TEXT, "
          "address TEXT, "
          "areaId INTEGER, "
          "clusterId INTEGER, "
          "clubId INTEGER, "
          "roleId INTEGER, "
          "FOREIGN KEY (areaId) REFERENCES RotaryArea (areaId) "
                "ON DELETE CASCADE ON UPDATE NO ACTION, "
          "FOREIGN KEY (areaId, clusterId) REFERENCES RotaryCluster (areaId, clusterId) "
                "ON DELETE CASCADE ON UPDATE NO ACTION, "
          "FOREIGN KEY (areaId, clusterId, clubId) REFERENCES RotaryClub (areaId, clusterId, clubId) "
                "ON DELETE CASCADE ON UPDATE NO ACTION "
      ")";
  }
  //#endregion

  //#region Create Events Table
  static String createEventsTable(){
    return
      "CREATE TABLE IF NOT EXISTS Events ("
          "eventGuidId TEXT PRIMARY KEY, "
          "eventName TEXT, "
          "eventPictureUrl TEXT, "
          "eventDescription TEXT, "
          "eventStartDateTime TEXT, "
          "eventEndDateTime TEXT, "
          "eventLocation TEXT, "
          "eventManager TEXT "
      ")";
  }
  //#endregion

  //#region Create Messages Table
  static String createMessagesTable(){
    return
      "CREATE TABLE IF NOT EXISTS Messages ("
          "messageGuidId TEXT PRIMARY KEY, "
          "composerGuidId TEXT, "
          "messageText TEXT, "
          "messageCreatedDateTime TEXT "
      ")";
  }
//#endregion

  /// ============= Code TABLES ================

  //#region Create RotaryRole Table
  static String createRotaryRoleTable(){
    return
      "CREATE TABLE IF NOT EXISTS RotaryRole ("
          "roleId INTEGER PRIMARY KEY, "
          "roleName TEXT "
      ")";
  }
  //#endregion

  //#region Create Rotary Area Table
  static String createRotaryAreaTable(){
    return
      "CREATE TABLE IF NOT EXISTS RotaryArea ("
          "areaId INTEGER PRIMARY KEY, "
          "areaName TEXT "
      ")";
  }
  //#endregion

  //#region Create RotaryCluster Table
  static String createRotaryClusterTable(){
    return
      "CREATE TABLE IF NOT EXISTS RotaryCluster ("
          "areaId INTEGER NOT NULL, "
          "clusterId INTEGER NOT NULL, "
          "clusterName TEXT, "
          "PRIMARY KEY(areaId, clusterId)"
      ")";
  }
  //#endregion

  //#region Create RotaryClub Table
  static String createRotaryClubTable(){
    return
      "CREATE TABLE IF NOT EXISTS RotaryClub ("
          "areaId INTEGER NOT NULL, "
          "clusterId INTEGER NOT NULL, "
          "clubId INTEGER NOT NULL, "
          "clubName TEXT, "
          "clubAddress TEXT, "
          "clubMail TEXT, "
          "clubManagerGuidId TEXT, "
          "PRIMARY KEY(areaId, clusterId, clubId)"
      ")";
  }
  //#endregion

}
