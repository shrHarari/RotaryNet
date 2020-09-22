
class CreateDbTablesSyntax {

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
          "address TEXT "
          ")";
  }

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
}
