import 'dart:async';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/event_object.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/event_service.dart';
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
          await db.execute(CreateDbTablesSyntax.createUsersTable());
          await db.execute(CreateDbTablesSyntax.createPersonCardsTable());
          await db.execute(CreateDbTablesSyntax.createEventsTable());
          // print('+++ <RotaryDataBaseProvider> Rotary Database was Created');
        },
        version: 1
    );
    return database;
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

  Future insertAllStartedPersonCardsToDb() async {
    List<PersonCardObject> starterPersonCardsList;
    final PersonCardService personCardService = PersonCardService();
    starterPersonCardsList = await personCardService.initializePersonCardsTableData();
    // print('starterPersonCardsList.length: ${starterPersonCardsList.length}');

    starterPersonCardsList.forEach((PersonCardObject personCardObj) => insertPersonCard(personCardObj));

    // List<PersonCardObject> personCardsList = await RotaryDataBaseProvider.rotaryDB.getAllPersonCards();
    // if (personCardsList.isNotEmpty)
    //   print('>>>>>>>>>> personCardsList: ${personCardsList[0].emailId}');
  }

  Future insertAllStartedEventsToDb() async {
    List<EventObject> starterEventsList;
    final EventService eventService = EventService();
    starterEventsList = await eventService.initializeEventsTableData();
    // print('starterEventsList.length: ${starterEventsList.length}');

    starterEventsList.forEach((EventObject eventObj) => insertEvent(eventObj));
    // starterEventsList.forEach((EventObject eventObj) => insertRawEvent(eventObj));

    List<EventObject> eventsList = await RotaryDataBaseProvider.rotaryDB.getAllEvents();
    // if (eventsList.isNotEmpty)
      // print('>>>>>>>>>> eventsList: ${eventsList[0].eventName}');
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

  //#region getUserByGuidId
  Future getUserByGuidId(String aUserGuidId) async {
    final db = await database;

    var result = await  db.query("Users", where: "userGuidId = ?", whereArgs: [aUserGuidId]);
    return result.isNotEmpty ? UserObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region getUserByEmail
  Future getUserByEmail(String aEmail) async {
    final db = await database;

    var result = await  db.query("Users", where: "email = ?", whereArgs: [aEmail]);
    return result.isNotEmpty ? UserObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region getUserByEmailAndPassword
  Future<ConnectedUserObject> getUserByEmailAndPassword(String aEmail, String aPassword) async {
    final db = await database;

    var result = await  db.query(
        "Users",
        where: "email = ? AND password = ?",
        whereArgs: [aEmail, aPassword]);

    return result.isNotEmpty ? ConnectedUserObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region getUserBySearchQuery
  Future <List<UserObject>> getUsersListBySearchQuery(String aQuery) async {
    // print('aQuery: $aQuery');
    final db = await database;

    /////////////////////////////
    // final List<Map<String, dynamic>> mapUsers = await db.query('Users');

    final List<Map<String, dynamic>> mapUsers = await db.rawQuery(
        "SELECT * FROM Users WHERE firstName LIKE '%$aQuery%' OR  lastName LIKE '%$aQuery%'");
    /////////////////////////////

    // Convert the List<Map<String, dynamic> into a List<UserObject>.
    List<UserObject> usersList = List.generate(mapUsers.length, (_user) {
      return UserObject.fromMap(mapUsers[_user]);
    });

    // print('usersList: ${usersList.length}');
    return usersList;
    // return result.isNotEmpty ? UserObject.fromMap(result.first) : Null ;
  }
  //#endregion

  //#region insertRawUser [----------- Not in use...]
  Future insertRawUser(UserObject aUser) async {
    final db = await database;
    // UserType: Convert [Enum] to [String]
    String _userType = EnumToString.parse(aUser.userType);

    // StayConnected: Convert [int] to [bool]
    int _stayConnected;
    aUser.stayConnected == true ? _stayConnected = 1 : _stayConnected = 0;

    var result = await db.rawInsert(
        "INSERT Into Users ("
            "userGuidId, "
            "email, "
            "firstName, "
            "lastName, "
            "password, "
            "userType, "
            "stayConnected) "
            "VALUES ("
            "${aUser.userGuidId}, "
            "${aUser.email}, "
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
        where: "userGuidId = ?",
        whereArgs: [aUser.userGuidId]
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
          where: "userGuidId = ?",
          whereArgs: [aUser.userGuidId]
      );
    } catch (ex) {
      print('Delete User [${aUser.userGuidId} / ${aUser.email}] >>> ERROR: ${ex.toString()}');
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

  //#region getPersonCardByGuidId
  Future getPersonCardByGuidId(String aUserGuidId) async {
    final db = await database;
    var result = await  db.query("PersonCards", where: "userGuidId = ?", whereArgs: [aUserGuidId]);
    return result.isNotEmpty ? PersonCardObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region getPersonCardsListBySearchQuery
  Future <List<PersonCardObject>> getPersonCardsListBySearchQuery(String aQuery) async {
    final db = await database;

    final List<Map<String, dynamic>> mapPersonCards = await db.rawQuery(
        "SELECT * FROM PersonCards WHERE firstName LIKE '%$aQuery%' OR  lastName LIKE '%$aQuery%'");

    // Convert the List<Map<String, dynamic> into a List<PersonCardObject>.
    List<PersonCardObject> personCardsList = List.generate(mapPersonCards.length, (_personCard) {
      return PersonCardObject.fromMap(mapPersonCards[_personCard]);
    });

    // print('personCardsList: ${personCardsList.length}');
    return personCardsList;
  }
  //#endregion

  //#region insertRawPersonCard [----------- Not in use...]
  Future insertRawPersonCard(PersonCardObject aPersonCard) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT Into PersonCards ("
            "userGuidId, "
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
            "${aPersonCard.userGuidId}, "
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
        where: "userGuidId = ?",
        whereArgs: [aPersonCard.userGuidId]
    );

    return result;
  }
  //#endregion

  //#region deletePersonCard
  Future<void> deletePersonCard(PersonCardObject aPersonCard) async {
    try {
      final db = await database;
      db.delete(
          "PersonCards",
          where: "userGuidId = ?",
          whereArgs: [aPersonCard.userGuidId]
      );
    } catch (ex) {
      print('Delete PersonCard [${aPersonCard.userGuidId} / ${aPersonCard.email}] >>> ERROR: ${ex.toString()}');
    }
  }
  //#endregion

  //#region deleteAllPersonCards
  Future<void> deleteAllPersonCards() async {
    final db = await database;
    db.rawDelete('Delete * from PersonCards');
  }
  //#endregion

  //#endregion

  //#region CRUD: Events

  //#region getAllEvents
  Future <List<EventObject>> getAllEvents() async {
    final db = await database;

    if (db == null) return null;

    final List<Map<String, dynamic>> mapEvents = await db.query('Events');

    // Convert the List<Map<String, dynamic> into a List<EventObject>.
    List<EventObject> eventsList = List.generate(mapEvents.length, (_user) {
      return EventObject.fromMap(mapEvents[_user]);
    });

    return eventsList;
  }
  //#endregion

  //#region getEventByGuidId
  Future getEventByGuidId(String aEventGuidId) async {
    final db = await database;

    var result = await  db.query("Events", where: "eventGuidId = ?", whereArgs: [aEventGuidId]);
    return result.isNotEmpty ? EventObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region getEventsBySearchQuery
  Future <List<EventObject>> getEventsListBySearchQuery(String aQuery) async {
    final db = await database;

    final List<Map<String, dynamic>> mapEvents = await db.rawQuery(
        "SELECT * FROM Events WHERE eventName LIKE '%$aQuery%'");

    // Convert the List<Map<String, dynamic> into a List<UserObject>.
    List<EventObject> eventsList = List.generate(mapEvents.length, (_event) {
      return EventObject.fromMap(mapEvents[_event]);
    });

    return eventsList;
  }
  //#endregion

  //#region insertRawEvent [----------- Not in use...]
  Future insertRawEvent(EventObject aEvent) async {
    final db = await database;

    // DateTime: Convert [DateTime] to [String]
    String _eventStartDateTime = aEvent.eventStartDateTime.toIso8601String ();
    String _eventEndDateTime = aEvent.eventEndDateTime.toIso8601String ();

    var result = await db.rawInsert(
        "INSERT Into Events ("
            "eventGuidId, "
            "eventName, "
            "eventPictureUrl, "
            "eventDescription, "
            "eventStartDateTime, "
            "eventEndDateTime, "
            "eventLocation, "
            "eventManager) "
        "VALUES ("
            "${aEvent.eventGuidId}, "
            "${aEvent.eventName}, "
            "${aEvent.eventPictureUrl}, "
            "${aEvent.eventDescription}, "
            "$_eventStartDateTime, "
            "$_eventEndDateTime, "
            "${aEvent.eventLocation}, "
            "${aEvent.eventManager} "
        ")"
    );
    return result;
  }
  //#endregion

  //#region insertEvent
  Future insertEvent(EventObject aEvent) async {
    final db = await database;
    var result = await db.insert(
        "Events",
        aEvent.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    return result;
  }
  //#endregion

  //#region updateEvent
  Future updateEvent(EventObject aEvent) async {
    final db = await database;
    var result = await db.update(
        "Events",
        aEvent.toMap(),
        where: "eventGuidId = ?",
        whereArgs: [aEvent.eventGuidId]
    );

    return result;
  }
  //#endregion

  //#region deleteEvent
  Future<void> deleteEvent(EventObject aEvent) async {
    try {
      final db = await database;
      db.delete(
          "Events",
          where: "eventGuidId = ?",
          whereArgs: [aEvent.eventGuidId]
      );
    } catch (ex) {
      print('Delete Event [${aEvent.eventGuidId} / ${aEvent.eventName}] >>> ERROR: ${ex.toString()}');
    }
  }
  //#endregion

  //#region deleteAllEvents
  Future<void> deleteAllEvents() async {
    final db = await database;
    db.rawDelete('Delete * from Events');
  }
//#endregion

//#endregion
}
