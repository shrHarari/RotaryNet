import 'dart:async';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:rotary_net/database/create_db_tables_syntax.dart';

class RotaryDataBaseProvider {
  RotaryDataBaseProvider._();

  static final RotaryDataBaseProvider rotaryDB = RotaryDataBaseProvider._();
  static Database _database;

  //#region Create Rotary DB
  Future<Database> get database async {
    if (_database != null)
      {
        // print ('>>>>>>>>>> Database Exists  !!!!!!!!!');
        return _database;
      }

    // if _database is null we instantiate it
    _database = await createRotaryDB();
    return _database;
  }

  createRotaryDB() async {
    String dbDirectory = await getDatabasesPath();
    String dbPath = join(dbDirectory, "Rotary.db");
    final Future<Database> database = openDatabase(dbPath,
        onOpen: (db) {
          // print('>>>  <RotaryDataBaseProvider> Rotary Database was Opened !!!');
        },
        onCreate: (Database db, int version) async {
          await db.execute(CreateDbTablesSyntax.createPersonCardsTable());
          await db.execute(CreateDbTablesSyntax.createUsersTable());
          print('+++ <RotaryDataBaseProvider> Rotary Database was Created');
        },
        version: 1
    );
    return database;
  }

  Future insertAllStartedPersonCardsToDb() async {
    List<PersonCardObject> starterPersonCardsList;
    final PersonCardService personCardService = PersonCardService();
    starterPersonCardsList = await personCardService.getPersonCardsListSearchFromServer("");
    // print('starterPersonCardsList.length: ${starterPersonCardsList.length}');

    starterPersonCardsList.forEach((PersonCardObject personCardObj) => insertPersonCard(personCardObj));

    // List<PersonCardObject> personCardsList = await RotaryDataBaseProvider.rotaryDB.getAllPersonCards();
    // if (personCardsList.isNotEmpty)
    //   print('>>>>>>>>>> personCardsList: ${personCardsList[0].emailId}');
  }

  Future insertAllStartedUsersToDb() async {
    List<UserObject> starterUsersList;
    final UserService userService = UserService();
    starterUsersList = await userService.initializeUsersTableData();
    // print('starterUsersList.length: ${starterUsersList.length}');

    starterUsersList.forEach((UserObject userObj) => insertUser(userObj));

    // List<UserObject> _usersList = await RotaryDataBaseProvider.rotaryDB.getAllUsers();
    // if (_usersList.isNotEmpty)
    //   print('>>>>>>>>>> usersList: ${_usersList[4].emailId}');
  }
  //#endregion

  //#region Delete Rotary DB
  Future deleteRotaryDatabase() async {
    String dbDirectory = await getDatabasesPath();
    String dbPath = join(dbDirectory, "Rotary.db");

    // await deleteAllUsers();
    // await deleteAllPersonCards();

    if (await databaseExists(dbPath))
      {
        await deleteDatabase(dbPath);
        print('<RotaryDataBaseProvider> Rotary Database was Deleted');
      }
  }
  //#endregion

  //#region CRUD: PersonCards

  //#region getAllPersonCards
  Future <List<PersonCardObject>> getAllPersonCards() async {
    final db = await database;

    final List<Map<String, dynamic>> mapPersonCards = await db.query('PersonCards');

    // Convert the List<Map<String, dynamic> into a List<PersonCards>.
    List<PersonCardObject> personCardList = List.generate(mapPersonCards.length, (_personCard) {
      return PersonCardObject.fromMap(mapPersonCards[_personCard]);
    });

    return personCardList;
  }
  //#endregion

  //#region getPersonCardByEmailId
  Future getPersonCardByEmailId(String aEmailId) async {
    final db = await database;
    var result = await  db.query("PersonCards", where: "emailId = ?", whereArgs: [aEmailId]);
    return result.isNotEmpty ? PersonCardObject.fromMap(result.first) : Null ;
  }
  //#endregion

  //#region insertRawPersonCard
  Future insertRawPersonCard(PersonCardObject aPersonCard) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT Into PersonCards ("
            "emailId, "
            "email, "
            "firstName, "
            "lastName, "
            "firstNameEng, "
            "lastNameEng, "
            "phoneNumber, "
            "phoneNumberDialCode, "
            "phoneNumberParse, "
            "phoneNumberCleanLongFormat, "
            "pictureUrl, "
            "cardDescription, "
            "internetSiteUrl, "
            "address) "
        "VALUES ("
            "${aPersonCard.emailId}, "
            "${aPersonCard.email}, "
            "${aPersonCard.firstName}, "
            "${aPersonCard.lastName}, "
            "${aPersonCard.firstNameEng}, "
            "${aPersonCard.lastNameEng}, "
            "${aPersonCard.phoneNumber}, "
            "${aPersonCard.phoneNumberDialCode}, "
            "${aPersonCard.phoneNumberParse}, "
            "${aPersonCard.phoneNumberCleanLongFormat}, "
            "${aPersonCard.pictureUrl}, "
            "${aPersonCard.cardDescription}, "
            "${aPersonCard.internetSiteUrl}, "
            "${aPersonCard.address} "
        ")"
    );
    return result;
  }
  //#endregion

  //#region insertPersonCard
  Future insertPersonCard(PersonCardObject aPersonCard) async {
    final db = await database;
    var result = await db.insert(
        "PersonCards",
        aPersonCard.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    return result;
  }
  //#endregion

  //#region updatePersonCard
  Future updatePersonCard(PersonCardObject aPersonCard) async {
    final db = await database;
    var result = await db.update(
        "PersonCards",
        aPersonCard.toMap(),
        where: "emailId = ?",
        whereArgs: [aPersonCard.emailId]
    );

    return result;
  }
  //#endregion

  //#region deletePersonCard
  Future<void> deletePersonCard(String aEmailId) async {
    final db = await database;
    db.delete(
        "PersonCards",
        where: "emailId = ?",
        whereArgs: [aEmailId]
    );
  }
  //#endregion

  //#region deleteAllPersonCards
  Future<void> deleteAllPersonCards() async {
    final db = await database;
    db.rawDelete('Delete * from PersonCards');
  }
  //#endregion

//#endregion

  //#region CRUD: Users

  //#region getAllUsers
  Future <List<UserObject>> getAllUsers() async {
    final db = await database;

    if (db == null) return null;

    final List<Map<String, dynamic>> mapUsers = await db.query('Users');

    // Convert the List<Map<String, dynamic> into a List<UserObject>.
    List<UserObject> usersList = List.generate(mapUsers.length, (_user) {
      return UserObject.fromMap(mapUsers[_user]);
    });

    return usersList;
  }
  //#endregion

  //#region getUserByEmailId
  Future getUserByEmailId(String aEmailId) async {
    final db = await database;
    var result = await  db.query("Users", where: "emailId = ?", whereArgs: [aEmailId]);
    return result.isNotEmpty ? UserObject.fromMap(result.first) : Null ;
  }
  //#endregion

  //#region getUserBySearchQuery
  Future <List<UserObject>> getUsersListBySearchQuery(String aQuery) async {
    final db = await database;
    final List<Map<String, dynamic>> mapUsers = await db.rawQuery(
        "SELECT * FROM Users WHERE firstName LIKE '%$aQuery%' OR  lastName LIKE '%$aQuery%'");

    List<UserObject> usersList = List.generate(mapUsers.length, (_user) {
      return UserObject.fromMap(mapUsers[_user]);
    });

    return usersList;
    // return result.isNotEmpty ? UserObject.fromMap(result.first) : Null ;
  }
  //#endregion

  //#region insertRawUser
  Future insertRawUser(UserObject aUser) async {
    final db = await database;
    // UserType: Convert [Enum] to [String]
    String _userType = EnumToString.parse(aUser.userType);

    // StayConnected: Convert [int] to [bool]
    int _stayConnected;
    aUser.stayConnected == true ? _stayConnected = 1 : _stayConnected = 0;

    var result = await db.rawInsert(
        "INSERT Into Users ("
            "emailId, "
            "firstName, "
            "lastName, "
            "password, "
            "userType, "
            "stayConnected) "
        "VALUES ("
            "${aUser.emailId}, "
            "${aUser.firstName}, "
            "${aUser.lastName}, "
            "${aUser.password}, "
            "$_userType, "
            "$_stayConnected "
        ")"
    );
    return result;
  }
  //#endregion

  //#region insertUser
  Future insertUser(UserObject aUser) async {
    final db = await database;
    var result = await db.insert(
        "Users",
        aUser.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    return result;
  }
  //#endregion

  //#region updateUser
  Future updateUser(UserObject aUser) async {
    final db = await database;
    var result = await db.update(
        "Users",
        aUser.toMap(),
        where: "emailId = ?",
        whereArgs: [aUser.emailId]
    );

    return result;
  }
  //#endregion

  //#region deleteUser
  Future<void> deleteUser(UserObject aUser) async {
    try {
      final db = await database;
      db.delete(
          "Users",
          where: "emailId = ?",
          whereArgs: [aUser.emailId]
      );
    } catch (ex) {
      print('Delete User [${aUser.emailId}] >>> ERROR: ${ex.toString()}');
    }
  }
  //#endregion

  //#region deleteAllUsers
  Future<void> deleteAllUsers() async {
    final db = await database;
    db.rawDelete('Delete * from Users');
  }
  //#endregion

//#endregion
}
