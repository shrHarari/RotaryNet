import 'dart:async';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:rotary_net/database/create_db_tables_syntax.dart';

class InitRotaryDataBase {
  InitRotaryDataBase._();

  static final InitRotaryDataBase rotaryDB = InitRotaryDataBase._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await createRotaryDB();
    return _database;
  }

  //#region Delete Rotary DB
  Future deleteRotaryDatabase() async {
    String dbDirectory = await getDatabasesPath();
    String dbPath = join(dbDirectory, "Rotary.db");

    await deleteDatabase(dbPath);
  }
  //#endregion

  //#region Init Rotary DB
  createRotaryDB() async {
    String dbDirectory = await getDatabasesPath();
    String dbPath = join(dbDirectory, "Rotary.db");
    final Future<Database> database = openDatabase(dbPath,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(CreateDbTablesSyntax.createPersonCardsTable());
          await db.execute(CreateDbTablesSyntax.createUsersTable());
        },
        version: 1
    );
    return database;
  }

  Future insertAllStartedPersonCardsToDb() async {
    List<PersonCardObject> starterPersonCardsList;
    final PersonCardService personCardService = PersonCardService();
    starterPersonCardsList = await personCardService.getPersonCardsListSearchFromServer("");

    starterPersonCardsList.map((personCardObj) => insertPersonCard(personCardObj));
  }

  Future insertAllStartedUsersToDb() async {
    List<UserObject> starterUsersList;
    final UserService userService = UserService();
    starterUsersList = await userService.getUsersListFromServer("");

    starterUsersList.map((userObj) => insertUser(userObj));
  }
  //#endregion

  //#region CRUD: PersonCards
  Future <List<PersonCardObject>> getAllPersonCards() async {
    final db = await database;

    final List<Map<String, dynamic>> mapPersonCards = await db.query('PersonCards');

    // Convert the List<Map<String, dynamic> into a List<PersonCards>.
    List<PersonCardObject> personCardList = List.generate(mapPersonCards.length, (_personCard) {
      return PersonCardObject.fromMap(mapPersonCards[_personCard]);
    });

    return personCardList;
  }

  Future getPersonCardByEmailId(String aEmailId) async {
    final db = await database;
    var result = await  db.query("PersonCards", where: "emailId = ?", whereArgs: [aEmailId]);
    return result.isNotEmpty ? PersonCardObject.fromMap(result.first) : Null ;
  }

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
            "${aPersonCard.email}"
            "${aPersonCard.firstName}"
            "${aPersonCard.lastName}"
            "${aPersonCard.firstNameEng}"
            "${aPersonCard.lastNameEng}"
            "${aPersonCard.phoneNumber}"
            "${aPersonCard.phoneNumberDialCode}"
            "${aPersonCard.phoneNumberParse}"
            "${aPersonCard.phoneNumberCleanLongFormat}"
            "${aPersonCard.pictureUrl}"
            "${aPersonCard.cardDescription}"
            "${aPersonCard.internetSiteUrl}"
            "${aPersonCard.address}"
        ")"
    );
    return result;
  }

  Future insertPersonCard(PersonCardObject aPersonCard) async {
    final db = await database;
    var result = await db.insert(
        "PersonCards",
        aPersonCard.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    return result;
  }

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

  Future<void> deletePersonCard(String aEmailId) async {
    final db = await database;
    db.delete(
        "PersonCards",
        where: "emailId = ?",
        whereArgs: [aEmailId]
    );
  }

  deleteAllPersonCards() async {
    final db = await database;
    db.rawDelete("Delete * from PersonCards");
  }
//#endregion

  //#region CRUD: Users
  Future <List<UserObject>> getAllUsers() async {
    final db = await database;

    final List<Map<String, dynamic>> mapUsers = await db.query('Users');

    // Convert the List<Map<String, dynamic> into a List<PersonCards>.
    List<UserObject> usersList = List.generate(mapUsers.length, (_user) {
      return UserObject.fromMap(mapUsers[_user]);
    });

    return usersList;
  }

  Future getUserByEmailId(String aEmailId) async {
    final db = await database;
    var result = await  db.query("Users", where: "emailId = ?", whereArgs: [aEmailId]);
    return result.isNotEmpty ? UserObject.fromMap(result.first) : Null ;
  }

  Future insertRawUser(UserObject aUser) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT Into PersonCards ("
            "emailId, "
            "firstName, "
            "lastName, "
            "password, "
            "userType, "
            "stayConnected) "
        "VALUES ("
            "${aUser.emailId}, "
            "${aUser.firstName}"
            "${aUser.lastName}"
            "${aUser.password}"
            "${aUser.userType}"
            "${aUser.stayConnected}"
        ")"
    );
    return result;
  }

  Future insertUser(UserObject aUser) async {
    final db = await database;
    var result = await db.insert(
        "Users",
        aUser.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    return result;
  }

  Future updateUser(UserObject aUser) async {
    final db = await database;
    var result = await db.update(
        "PersonCards",
        aUser.toMap(),
        where: "emailId = ?",
        whereArgs: [aUser.emailId]
    );

    return result;
  }

  Future<void> deleteUser(String aEmailId) async {
    final db = await database;
    db.delete(
        "Users",
        where: "emailId = ?",
        whereArgs: [aEmailId]
    );
  }

  deleteAllUsers() async {
    final db = await database;
    db.rawDelete("Delete * from Users");
  }
//#endregion
}
