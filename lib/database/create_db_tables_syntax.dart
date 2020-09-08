
class CreateDbTablesSyntax {

  static String createPersonCardsTable(){
    return
      "CREATE TABLE PersonCards ("
          "emailId TEXT PRIMARY KEY,"
          "email TEXT,"
          "firstName TEXT,"
          "lastName TEXT,"
          "firstNameEng TEXT,"
          "lastNameEng TEXT,"
          "phoneNumber TEXT,"
          "phoneNumberDialCode TEXT,"
          "phoneNumberParse TEXT,"
          "phoneNumberCleanLongFormat TEXT,"
          "pictureUrl TEXT,"
          "cardDescription TEXT,"
          "internetSiteUrl TEXT,"
          "address TEXT,"
          ")";
  }

  static String createUsersTable(){
    return
      "CREATE TABLE PersonCards ("
          "emailId TEXT PRIMARY KEY,"
          "firstName TEXT,"
          "lastName TEXT,"
          "password TEXT,"
          "userType TEXT,"
          "stayConnected BIT,"
          ")";
  }
}
