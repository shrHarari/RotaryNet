import 'dart:async';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/event_object.dart';
import 'package:rotary_net/objects/message_object.dart';
import 'package:rotary_net/objects/message_queue_object.dart';
import 'package:rotary_net/objects/message_with_description_object.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/person_card_with_description_object.dart';
import 'package:rotary_net/objects/rotary_area_object.dart';
import 'package:rotary_net/objects/rotary_club_object.dart';
import 'package:rotary_net/objects/rotary_cluster_object.dart';
import 'package:rotary_net/objects/rotary_role_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/shared/constants.dart';
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
          print('>>>  <RotaryDataBaseProvider> Rotary Database was Opened !!!');
        },
        onCreate: (Database db, int version) async {
          await db.execute(CreateDbTablesSyntax.createRotaryRoleTable());
          await db.execute(CreateDbTablesSyntax.createRotaryAreaTable());
          await db.execute(CreateDbTablesSyntax.createRotaryClusterTable());
          await db.execute(CreateDbTablesSyntax.createRotaryClubTable());
          await db.execute(CreateDbTablesSyntax.createUsersTable());
          await db.execute(CreateDbTablesSyntax.createPersonCardsTable());
          await db.execute(CreateDbTablesSyntax.createEventsTable());
          await db.execute(CreateDbTablesSyntax.createMessagesTable());
          await db.execute(CreateDbTablesSyntax.createMessageQueueTable());

          print('+++ <RotaryDataBaseProvider> Rotary Database was Created');
        },
        version: 1
    );
    return database;
  }
  //#endregion

  //#region Delete Rotary DB
  Future deleteRotaryDatabase() async {
    String dbDirectory = await getDatabasesPath();
    String dbPath = join(dbDirectory, "Rotary.db");

    if (await databaseExists(dbPath))
    {
      await deleteDatabase(dbPath);
      _database = null;
      print('+++ <RotaryDataBaseProvider> Rotary Database was Deleted');
    }
  }
  //#endregion

  //#region CRUD: Users

  //#region get All Users
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

  //#region get User By GuidId
  Future getUserByGuidId(String aUserGuidId) async {
    final db = await database;

    var result = await  db.query("Users", where: "userGuidId = ?", whereArgs: [aUserGuidId]);
    return result.isNotEmpty ? UserObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region get User By Email
  Future getUserByEmail(String aEmail) async {
    final db = await database;

    var result = await  db.query("Users", where: "email = ?", whereArgs: [aEmail]);
    return result.isNotEmpty ? UserObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region get User By Email And Password
  Future<ConnectedUserObject> getUserByEmailAndPassword(String aEmail, String aPassword) async {
    final db = await database;

    var result = await  db.query(
        "Users",
        where: "email = ? AND password = ?",
        whereArgs: [aEmail, aPassword]);

    return result.isNotEmpty ? ConnectedUserObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region get User By Search Query
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

  //#region insert Raw User [----------- Not in use...]
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

  //#region insert User
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

  //#region update User By GuidId
  Future updateUserByGuidId(UserObject aUser) async {
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

  //#region delete User By GuidId
  Future<void> deleteUserByGuidId(UserObject aUser) async {
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

  //#region get All PersonCards
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

  //#region get PersonCard By GuidId
  Future getPersonCardByGuidId(String aPersonCardGuidId) async {
    final db = await database;
    var result = await  db.query("PersonCards", where: "personCardGuidId = ?", whereArgs: [aPersonCardGuidId]);
    return result.isNotEmpty ? PersonCardObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region get PersonCard With Description By GuidId
  Future <PersonCardWithDescriptionObject> getPersonCardWithDescriptionByGuidId(String aPersonCardGuidId) async {
    final db = await database;

    if (db == null) return null;
      final result = await db.rawQuery(
        "SELECT "
            "PersonCards.personCardGuidId AS personCardGuidId, "
            "PersonCards.email AS email, "
            "PersonCards.firstName AS firstName, "
            "PersonCards.lastName AS lastName, "
            "PersonCards.firstNameEng AS firstNameEng, "
            "PersonCards.lastNameEng AS lastNameEng, "
            "PersonCards.phoneNumber AS phoneNumber, "
            "PersonCards.phoneNumberDialCode AS phoneNumberDialCode, "
            "PersonCards.phoneNumberParse AS phoneNumberParse, "
            "PersonCards.phoneNumberCleanLongFormat AS phoneNumberCleanLongFormat, "
            "PersonCards.pictureUrl AS pictureUrl, "
            "PersonCards.cardDescription AS cardDescription, "
            "PersonCards.internetSiteUrl AS internetSiteUrl, "
            "PersonCards.address AS address, "
            "RotaryRole.roleId AS roleId, "
            "RotaryRole.roleName AS roleName, "
            "RotaryArea.areaId AS areaId, "
            "RotaryArea.areaName AS areaName, "
            "RotaryCluster.clusterId AS clusterId, "
            "RotaryCluster.clusterName AS clusterName, "
            "RotaryClub.clubId AS clubId, "
            "RotaryClub.clubName AS clubName, "
            "RotaryClub.clubAddress AS clubAddress, "
            "RotaryClub.clubMail AS clubMail, "
            "RotaryClub.clubManagerGuidId AS clubManagerGuidId "
        "FROM PersonCards "
          "INNER JOIN RotaryRole ON "
              "PersonCards.roleId = RotaryRole.roleId "
          "INNER JOIN RotaryArea ON "
              "PersonCards.areaId = RotaryArea.areaId "
          "INNER JOIN RotaryCluster ON "
              "PersonCards.areaId = RotaryCluster.areaId AND "
              "PersonCards.clusterId = RotaryCluster.clusterId "
          "INNER JOIN RotaryClub ON "
              "PersonCards.areaId = RotaryClub.areaId AND "
              "PersonCards.clusterId = RotaryClub.clusterId AND "
              "PersonCards.clubId = RotaryClub.clubId "
        "WHERE PersonCards.personCardGuidId = '$aPersonCardGuidId'"
    );

    return result.isNotEmpty ? PersonCardWithDescriptionObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region get PersonCards List By Search Query
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

  //#region insert Raw PersonCard [----------- Not in use...]
  Future insertRawPersonCard(PersonCardObject aPersonCard) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT Into PersonCards ("
            "personCardGuidId, "
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
            "address,"
            "areaId,"
            "clusterId,"
            "clubId,"
            "roleId"
            ") "
        "VALUES ("
            "${aPersonCard.personCardGuidId}, "
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
            "${aPersonCard.address}, "
            "${aPersonCard.areaId}, "
            "${aPersonCard.clusterId}, "
            "${aPersonCard.clubId}, "
            "${aPersonCard.roleId} "
        ")"
    );
    return result;
  }
  //#endregion

  //#region insert PersonCard
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

  //#region update PersonCard By GuidId
  Future updatePersonCardByGuidId(PersonCardObject aPersonCard) async {
    final db = await database;
    var result = await db.update(
        "PersonCards",
        aPersonCard.toMap(),
        where: "personCardGuidId = ?",
        whereArgs: [aPersonCard.personCardGuidId]
    );

    return result;
  }
  //#endregion

  //#region delete PersonCard By GuidId
  Future<void> deletePersonCardByGuidId(PersonCardObject aPersonCard) async {
    try {
      final db = await database;
      db.delete(
          "PersonCards",
          where: "personCardGuidId = ?",
          whereArgs: [aPersonCard.personCardGuidId]
      );
    } catch (ex) {
      print('Delete PersonCard [${aPersonCard.personCardGuidId} / ${aPersonCard.email}] >>> ERROR: ${ex.toString()}');
    }
  }
  //#endregion

  //#region delete All PersonCards
  Future<void> deleteAllPersonCards() async {
    final db = await database;
    db.rawDelete('Delete * from PersonCards');
  }
  //#endregion

  //#endregion

  //#region CRUD: Events

  //#region get All Events
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

  //#region get Event By EventGuidId
  Future getEventByEventGuidId(String aEventGuidId) async {
    final db = await database;

    var result = await  db.query("Events", where: "eventGuidId = ?", whereArgs: [aEventGuidId]);
    return result.isNotEmpty ? EventObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region get Events By Search Query
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

  //#region insert Raw Event [----------- Not in use...]
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

  //#region insert Event
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

  //#region update Event By EventGuidId
  Future updateEventByEventGuidId(EventObject aEvent) async {
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

  //#region delete Event By Event GuidId
  Future<void> deleteEventByEventGuidId(EventObject aEvent) async {
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

  //#region CRUD: Messages

  //#region get All Messages
  Future <List<MessageObject>> getAllMessages() async {
    final db = await database;

    if (db == null) return null;

    final List<Map<String, dynamic>> mapMessages = await db.query('Messages');
    // print(">>>>>>>> getAllMessages / mapMessages: $mapMessages");

    List<MessageObject> messagesList = List.generate(mapMessages.length, (_message) {
      return MessageObject.fromMap(mapMessages[_message]);
    });

    return messagesList;
  }
  //#endregion

  //#region get All Messages Using MessageQueue
  Future <List<MessageObject>> getAllMessagesUsingMessageQueue(String aUserGuidId) async {

    final db = await database;
    if (db == null) return null;

    String selectClause =
        "SELECT "
            "Messages.messageGuidId AS messageGuidId, "
            "Messages.composerGuidId AS composerGuidId, "
            "Messages.messageText AS messageText, "
            "Messages.messageCreatedDateTime AS messageCreatedDateTime "
        "FROM MessageQueue "
        "INNER JOIN Messages ON "
            "MessageQueue.messageGuidId = Messages.messageGuidId ";

    String selectWhereClause = "WHERE (MessageQueue.personCardGuidId = '$aUserGuidId' )";

    final List<Map<String, dynamic>> mapMessageQueue = await db.rawQuery(selectClause + selectWhereClause);

    List<MessageObject> messagesList = List.generate(mapMessageQueue.length, (_message) {
      return MessageObject.fromMap(mapMessageQueue[_message]);
    });

    return messagesList;
  }
  //#endregion

  //#region get All Messages With Description
  Future <List<MessageWithDescriptionObject>> getAllMessagesWithDescription() async {
    final db = await database;

    if (db == null) return null;

    final List<Map<String, dynamic>> mapMessages = await db.rawQuery(
        "SELECT "
            "Messages.messageGuidId AS messageGuidId, "
            "Messages.composerGuidId AS composerGuidId, "
            "PersonCards.firstName AS composerFirstName, "
            "PersonCards.lastName AS composerLastName, "
            "PersonCards.email AS composerEmail, "
            "Messages.messageText AS messageText, "
            "Messages.messageCreatedDateTime AS messageCreatedDateTime, "
            "RotaryRole.roleId AS roleId, "
            "RotaryRole.roleName AS roleName, "
            "RotaryArea.areaId AS areaId, "
            "RotaryArea.areaName AS areaName, "
            "RotaryCluster.clusterId AS clusterId, "
            "RotaryCluster.clusterName AS clusterName, "
            "RotaryClub.clubId AS clubId, "
            "RotaryClub.clubName AS clubName, "
            "RotaryClub.clubAddress AS clubAddress, "
            "RotaryClub.clubMail AS clubMail, "
            "RotaryClub.clubManagerGuidId AS clubManagerGuidId "
        "FROM PersonCards "
        "INNER JOIN Messages ON "
            "PersonCards.personCardGuidId = Messages.composerGuidId "
        "INNER JOIN RotaryRole ON "
            "PersonCards.roleId = RotaryRole.roleId "
        "INNER JOIN RotaryArea ON "
            "PersonCards.areaId = RotaryArea.areaId "
        "INNER JOIN RotaryCluster ON "
            "PersonCards.areaId = RotaryCluster.areaId AND "
            "PersonCards.clusterId = RotaryCluster.clusterId "
        "INNER JOIN RotaryClub ON "
            "PersonCards.areaId = RotaryClub.areaId AND "
            "PersonCards.clusterId = RotaryClub.clusterId AND "
            "PersonCards.clubId = RotaryClub.clubId "
    );

    List<MessageWithDescriptionObject> messagesList = List.generate(mapMessages.length, (_message) {
      return MessageWithDescriptionObject.fromMap(mapMessages[_message]);
    });

    return messagesList;
  }
  //#endregion

  //#region get All Messages With Description Using MessageQueue
  Future <List<MessageWithDescriptionObject>> getAllMessagesWithDescriptionUsingMessageQueue(String aUserGuidId) async {
    final db = await database;
    if (db == null) return null;

    String selectClause =
        "SELECT "
            "Messages.messageGuidId AS messageGuidId, "
            "Messages.composerGuidId AS composerGuidId, "
            "PersonCards.firstName AS composerFirstName, "
            "PersonCards.lastName AS composerLastName, "
            "PersonCards.email AS composerEmail, "
            "Messages.messageText AS messageText, "
            "Messages.messageCreatedDateTime AS messageCreatedDateTime, "
            "RotaryRole.roleId AS roleId, "
            "RotaryRole.roleName AS roleName, "
            "RotaryArea.areaId AS areaId, "
            "RotaryArea.areaName AS areaName, "
            "RotaryCluster.clusterId AS clusterId, "
            "RotaryCluster.clusterName AS clusterName, "
            "RotaryClub.clubId AS clubId, "
            "RotaryClub.clubName AS clubName, "
            "RotaryClub.clubAddress AS clubAddress, "
            "RotaryClub.clubMail AS clubMail, "
            "RotaryClub.clubManagerGuidId AS clubManagerGuidId "
        "FROM MessageQueue "
          "INNER JOIN Messages ON "
              "MessageQueue.messageGuidId = Messages.messageGuidId "
          "INNER JOIN PersonCards ON "
              "Messages.composerGuidId = PersonCards.personCardGuidId "
          "INNER JOIN RotaryRole ON "
              "PersonCards.roleId = RotaryRole.roleId "
          "INNER JOIN RotaryArea ON "
              "PersonCards.areaId = RotaryArea.areaId "
          "INNER JOIN RotaryCluster ON "
              "PersonCards.areaId = RotaryCluster.areaId AND "
              "PersonCards.clusterId = RotaryCluster.clusterId "
          "INNER JOIN RotaryClub ON "
              "PersonCards.areaId = RotaryClub.areaId AND "
              "PersonCards.clusterId = RotaryClub.clusterId AND "
              "PersonCards.clubId = RotaryClub.clubId ";

    String selectWhereClause = "WHERE (MessageQueue.personCardGuidId = '$aUserGuidId' )";

    final List<Map<String, dynamic>> mapMessageQueue = await db.rawQuery(selectClause + selectWhereClause);

    List<MessageWithDescriptionObject> messagesList = List.generate(mapMessageQueue.length, (_message) {
      return MessageWithDescriptionObject.fromMap(mapMessageQueue[_message]);
    });

    return messagesList;
  }
  //#endregion

  //#region get Message By MessageGuidId
  Future getMessageByMessageGuidId(String aMessageGuidId) async {
    final db = await database;

    var result = await db.query(""
        "Messages",
        where: "messageGuidId = ?",
        whereArgs: [aMessageGuidId]);
    return result.isNotEmpty ? MessageObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region get Messages By ComposerGuidId (UserGuidId)
  Future <List<MessageObject>> getMessagesByComposerGuidId(String aComposerGuidId) async {
    final db = await database;

    final List<Map<String, dynamic>> mapMessages = await db.rawQuery(
        "SELECT * FROM Messages WHERE composerGuidId = '$aComposerGuidId'");

    List<MessageObject> messagesList = List.generate(mapMessages.length, (_message) {
      return MessageObject.fromMap(mapMessages[_message]);
    });

    return messagesList;
  }
  //#endregion

  //#region insertRawMessage [----------- Not in use...]
  Future insertRawMessage(MessageObject aMessage) async {
    final db = await database;

    // DateTime: Convert [DateTime] to [String]
    String _messageCreatedDateTime = aMessage.messageCreatedDateTime.toIso8601String ();

    var result = await db.rawInsert(
        "INSERT Into Messages ("
            "messageGuidId, "
            "composerGuidId, "
            "messageText, "
            "messageCreatedDateTime) "
        "VALUES ("
            "${aMessage.messageGuidId}, "
            "${aMessage.composerGuidId}, "
            "${aMessage.messageText}, "
            "$_messageCreatedDateTime "
        ")"
    );
    return result;
  }
  //#endregion

  //#region insert Message
  Future insertMessage(MessageObject aMessage) async {
    final db = await database;
    var result = await db.insert(
        "Messages",
        aMessage.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    return result;
  }
  //#endregion

  //#region update Message By MessageGuidId
  Future updateMessageByMessageGuidId(MessageObject aMessage) async {
    final db = await database;
    var result = await db.update(
        "Messages",
        aMessage.toMap(),
        where: "messageGuidId = ?",
        whereArgs: [aMessage.messageGuidId]
    );
    return result;
  }
  //#endregion

  //#region delete Message By MessageGuidId
  Future<void> deleteMessageByMessageGuidId(MessageObject aMessage) async {
    try {
      final db = await database;
      db.delete(
          "Messages",
          where: "messageGuidId = ?",
          whereArgs: [aMessage.messageGuidId]
      );
    } catch (ex) {
      print('Delete Message [${aMessage.messageGuidId} / ${aMessage.messageText}] >>> ERROR: ${ex.toString()}');
    }
  }
  //#endregion

  //#region delete All Messages
  Future<void> deleteAllMessages() async {
    final db = await database;
    db.rawDelete('Delete * from Messages');
  }
  //#endregion

  //#endregion

  //#region CRUD: Message Queue

  //#region insertRawMessageQueue [----------- Not in use...]
  Future insertRawMessageQueue(MessageQueueObject aMessageQueueObject) async {
    final db = await database;

    var result = await db.rawInsert(
        "INSERT Into MessageQueue ("
            "messageGuidId, "
            "personCardGuidId, "
            "_messageReadStatus) "
        "VALUES ("
            "${aMessageQueueObject.messageGuidId}, "
            "${aMessageQueueObject.personCardGuidId}, "
            "${aMessageQueueObject.messageReadStatus} "
        ")"
    );
    return result;
  }
  //#endregion

  //#region delete MessageQueue By MessageGuidId
  Future<void> deleteMessageQueueByMessageGuidId(MessageQueueObject aMessageQueueObject) async {
    try {
      final db = await database;
      db.delete(
          "MessageQueue",
          where: "messageGuidId = ?",
          whereArgs: [aMessageQueueObject.messageGuidId]
      );
    } catch (ex) {
      print('Delete MessageQueue By MessageGuidId [${aMessageQueueObject.messageGuidId}] >>> ERROR: ${ex.toString()}');
    }
  }
  //#endregion

  //#region delete MessageQueue By MessageAndPerson GuidId
  Future<void> deleteMessageQueueByMessageAndPersonGuidId(MessageQueueObject aMessageQueueObject) async {
    try {
      final db = await database;
      db.delete(
          "MessageQueue",
          where: "messageGuidId = ? AND personCardGuidId = ?",
          whereArgs: [aMessageQueueObject.messageGuidId, aMessageQueueObject.personCardGuidId]
      );
    } catch (ex) {
      print('Delete MessageQueue By MessageAndPersonGuidId [${aMessageQueueObject.messageGuidId}] >>> ERROR: ${ex.toString()}');
    }
  }
  //#endregion

  //#region insertMessageQueueByHierarchyPermission
  Future insertMessageQueueByHierarchyPermission(MessageWithDescriptionObject aMessageWithDescriptionObject) async {
    final db = await database;
    String selectWhereClause;

    String insertClause =
        "INSERT Into MessageQueue ("
            "messageGuidId, "
            "personCardGuidId, "
            "messageReadStatus) ";
    String selectClause =
        "SELECT "
            "'${aMessageWithDescriptionObject.messageGuidId}', "
            "PersonCards.personCardGuidId, "
            "1 "
        "FROM PersonCards ";

    switch (aMessageWithDescriptionObject.roleId) {
      case (RotaryRolesEnum.RotaryManager):
        selectWhereClause = "";
        break;
      case (RotaryRolesEnum.AreaManager):
        selectWhereClause = "WHERE "
                  "(PersonCards.areaId = ${aMessageWithDescriptionObject.areaId})";
        break;
      case (RotaryRolesEnum.ClusterManager):
        selectWhereClause = "WHERE "
                  "(PersonCards.areaId = ${aMessageWithDescriptionObject.areaId}) AND "
                  "(PersonCards.clusterId = ${aMessageWithDescriptionObject.clusterId})";
        break;
      case (RotaryRolesEnum.ClubManager):
        selectWhereClause = "WHERE "
                  "(PersonCards.areaId = ${aMessageWithDescriptionObject.areaId}) AND "
                  "(PersonCards.clusterId = ${aMessageWithDescriptionObject.clusterId}) AND "
                  "(PersonCards.clubId = ${aMessageWithDescriptionObject.clubId}) ";
        break;
      default:
        return 0;
    }


    // print(">>>>>>>>> insertMessageQueueUsingHierarchyPermission / sqlClause: ${selectClause + selectWhereClause}");
    // final List<Map<String, dynamic>> mapMessageQueue = await db.rawQuery(selectClause + selectWhereClause);
    // print(">>>>>>>>> insertMessageQueueUsingHierarchyPermission / mapMessageQueue: ${mapMessageQueue.length}");

    String sqlClause = insertClause + selectClause + selectWhereClause;
    var result = await db.rawInsert(sqlClause);
    return result;
  }
  //#endregion

  //#region insert MessageQueue
  Future insertMessageQueue(MessageQueueObject aMessageQueueObject) async {
    final db = await database;
    var result = await db.insert(
        "MessageQueue",
        aMessageQueueObject.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    return result;
  }
  //#endregion

  //#endregion

  //#region CRUD: Rotary Role

  //#region get All Rotary Role
  Future <List<RotaryRoleObject>> getAllRotaryRole() async {
    final db = await database;

    if (db == null) return null;

    final List<Map<String, dynamic>> mapRotaryRole = await db.query('RotaryRole');

    List<RotaryRoleObject> rotaryRoleList = List.generate(mapRotaryRole.length, (_rotaryRole) {
      return RotaryRoleObject.fromMap(mapRotaryRole[_rotaryRole]);
    });

    return rotaryRoleList;
  }
  //#endregion

  //#region get Rotary Role By RoleId
  Future getRotaryRoleByRoleId(int aRoleId) async {
    final db = await database;

    var result = await  db.query(
        "RotaryRole",
        where: "roleId = ?",
        whereArgs: [aRoleId]);
    return result.isNotEmpty ? RotaryRoleObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region insertRawRotaryRole [----------- Not in use...]
  Future insertRawRotaryRole(RotaryRoleObject aRotaryRole) async {
    final db = await database;

    var result = await db.rawInsert(
        "INSERT Into RotaryRole ("
            "roleId, "
            "roleName ) "
            "VALUES ("
            "${aRotaryRole.roleId}, "
            "${aRotaryRole.roleName} "
            ")"
    );
    return result;
  }
  //#endregion

  //#region insert Rotary Role
  Future insertRotaryRole(RotaryRoleObject aRotaryRole) async {
    final db = await database;
    var result = await db.insert(
        "RotaryRole",
        aRotaryRole.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    return result;
  }
  //#endregion

  //#region update Rotary Role By RoleId
  Future updateRotaryRoleByRoleId(RotaryRoleObject aRotaryRole) async {
    final db = await database;
    var result = await db.update(
        "RotaryRole",
        aRotaryRole.toMap(),
        where: "roleId = ?",
        whereArgs: [aRotaryRole.roleId]
    );

    return result;
  }
  //#endregion

  //#region delete Rotary Role By RoleId
  Future<void> deleteRotaryRoleByRoleId(RotaryRoleObject aRotaryRole) async {
    try {
      final db = await database;
      db.delete(
          "RotaryRole",
          where: "roleId = ?",
          whereArgs: [aRotaryRole.roleId]
      );
    } catch (ex) {
      print('Delete RotaryRole [${aRotaryRole.roleId} / ${aRotaryRole.roleName}] >>> ERROR: ${ex.toString()}');
    }
  }
  //#endregion

  //#region delete All Rotary Role
  Future<void> deleteAllRotaryRole() async {
    final db = await database;
    db.rawDelete('Delete * from RotaryRole');
  }
  //#endregion

  //#endregion

  //#region CRUD: Rotary Area

  //#region get All Rotary Area
  Future <List<RotaryAreaObject>> getAllRotaryArea() async {
    final db = await database;

    if (db == null) return null;

    final List<Map<String, dynamic>> mapRotaryArea = await db.query('RotaryArea');

    // Convert the List<Map<String, dynamic> into a List<EventObject>.
    List<RotaryAreaObject> rotaryAreaList = List.generate(mapRotaryArea.length, (_rotaryArea) {
      return RotaryAreaObject.fromMap(mapRotaryArea[_rotaryArea]);
    });

    return rotaryAreaList;
  }
  //#endregion

  //#region get Rotary Area By AreaId
  Future getRotaryAreaByAreaId(String aAreaId) async {
    final db = await database;

    var result = await  db.query(
        "RotaryArea",
        where: "areaId = ?",
        whereArgs: [aAreaId]);
    return result.isNotEmpty ? RotaryAreaObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region insertRawRotaryArea [----------- Not in use...]
  Future insertRawRotaryArea(RotaryAreaObject aRotaryArea) async {
    final db = await database;

    var result = await db.rawInsert(
        "INSERT Into RotaryArea ("
            "areaId, "
            "areaName ) "
        "VALUES ("
            "${aRotaryArea.areaId}, "
            "${aRotaryArea.areaName} "
        ")"
    );
    return result;
  }
  //#endregion

  //#region insert Rotary Area
  Future insertRotaryArea(RotaryAreaObject aRotaryArea) async {
    final db = await database;
    var result = await db.insert(
        "RotaryArea",
        aRotaryArea.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    return result;
  }
  //#endregion

  //#region update Rotary Area By AreaId
  Future updateRotaryAreaByAreaId(RotaryAreaObject aRotaryArea) async {
    final db = await database;
    var result = await db.update(
        "RotaryArea",
        aRotaryArea.toMap(),
        where: "areaId = ?",
        whereArgs: [aRotaryArea.areaId]
    );

    return result;
  }
  //#endregion

  //#region delete Rotary Area By AreaId
  Future<void> deleteRotaryAreaByAreaId(RotaryAreaObject aRotaryArea) async {
    try {
      final db = await database;
      db.delete(
          "RotaryArea",
          where: "areaId = ?",
          whereArgs: [aRotaryArea.areaId]
      );
    } catch (ex) {
      print('Delete RotaryArea [${aRotaryArea.areaId} / ${aRotaryArea.areaName}] >>> ERROR: ${ex.toString()}');
    }
  }
  //#endregion

  //#region delete All Rotary Area
  Future<void> deleteAllRotaryArea() async {
    final db = await database;
    db.rawDelete('Delete * from RotaryArea');
  }
  //#endregion

  //#endregion

  //#region CRUD: Rotary Cluster

  //#region get All Rotary Cluster
  Future <List<RotaryClusterObject>> getAllRotaryCluster() async {
    final db = await database;

    if (db == null) return null;

    final List<Map<String, dynamic>> mapRotaryCluster = await db.query('RotaryCluster');

    List<RotaryClusterObject> rotaryClusterList = List.generate(mapRotaryCluster.length, (_rotaryCluster) {
      return RotaryClusterObject.fromMap(mapRotaryCluster[_rotaryCluster]);
    });

    return rotaryClusterList;
  }
  //#endregion

  //#region get Rotary Cluster By AreaId
  Future getRotaryClusterByAreaId(int aAreaId) async {
    final db = await database;

    var result = await  db.query(
        "RotaryCluster",
        where: "areaId = ?",
        whereArgs: [aAreaId]);
    return result.isNotEmpty ? RotaryClusterObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region get Rotary Cluster By AreaClusterId
  Future getRotaryClusterByAreaClusterId(String aAreaId, String aClusterId) async {
    final db = await database;

    var result = await  db.query(
        "RotaryCluster",
        where: "areaId = ? AND clusterId = ?",
        whereArgs: [aAreaId, aClusterId]);
    return result.isNotEmpty ? RotaryClusterObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region insertRawRotaryCluster [----------- Not in use...]
  Future insertRawRotaryCluster(RotaryClusterObject aRotaryCluster) async {
    final db = await database;

    var result = await db.rawInsert(
        "INSERT Into RotaryCluster ("
            "areaId, "
            "clusterId, "
            "clusterName ) "
        "VALUES ("
            "${aRotaryCluster.areaId}, "
            "${aRotaryCluster.clusterId}, "
            "${aRotaryCluster.clusterName} "
        ")"
    );
    return result;
  }
  //#endregion

  //#region insert Rotary Cluster
  Future insertRotaryCluster(RotaryClusterObject aRotaryCluster) async {
    final db = await database;
    var result = await db.insert(
        "RotaryCluster",
        aRotaryCluster.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    return result;
  }
  //#endregion

  //#region update Rotary Cluster By AreaClusterId
  Future updateRotaryClusterByAreaClusterId(RotaryClusterObject aRotaryCluster) async {
    final db = await database;
    var result = await db.update(
        "RotaryCluster",
        aRotaryCluster.toMap(),
        where: "areaId = ? AND clusterId = ?",
        whereArgs: [aRotaryCluster.areaId, aRotaryCluster.clusterId]
    );
    return result;
  }
  //#endregion

  //#region delete Rotary Cluster By AreaClusterId
  Future<void> deleteRotaryClusterByAreaClusterId(RotaryClusterObject aRotaryCluster) async {
    try {
      final db = await database;
      db.delete(
          "RotaryCluster",
          where: "areaId = ? AND clusterId = ?",
          whereArgs: [aRotaryCluster.areaId, aRotaryCluster.clusterId]
      );
    } catch (ex) {
      print('Delete RotaryCluster [${aRotaryCluster.areaId} / ${aRotaryCluster.clusterId} / ${aRotaryCluster.clusterName}] >>> ERROR: ${ex.toString()}');
    }
  }
  //#endregion

  //#region delete All Rotary Cluster
  Future<void> deleteAllRotaryCluster() async {
    final db = await database;
    db.rawDelete('Delete * from RotaryCluster');
  }
  //#endregion

  //#endregion

  //#region CRUD: Rotary Club

  //#region get All Rotary Club
  Future <List<RotaryClubObject>> getAllRotaryClub() async {
    final db = await database;

    if (db == null) return null;

    final List<Map<String, dynamic>> mapRotaryClub = await db.query('RotaryClub');

    List<RotaryClubObject> rotaryClubList = List.generate(mapRotaryClub.length, (_rotaryClub) {
      return RotaryClubObject.fromMap(mapRotaryClub[_rotaryClub]);
    });

    return rotaryClubList;
  }
  //#endregion

  //#region get Rotary Club By AreaId
  Future getRotaryClubByAreaId(int aAreaId) async {
    final db = await database;

    var result = await  db.query(
        "RotaryClub",
        where: "areaId = ?",
        whereArgs: [aAreaId]);
    return result.isNotEmpty ? RotaryClubObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region get Rotary Club By AreaClusterId
  Future getRotaryClubByAreaClusterId(int aAreaId, int aClusterId) async {
    final db = await database;

    var result = await  db.query(
        "RotaryClub",
        where: "areaId = ? AND clusterId = ?",
        whereArgs: [aAreaId, aClusterId]);
    return result.isNotEmpty ? RotaryClubObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region get Rotary Club By AreaClusterClubId
  Future getRotaryClubByAreaClusterClubId(String aAreaId, String aClusterId, String aClubId) async {
    final db = await database;

    var result = await  db.query(
        "RotaryClub",
        where: "areaId = ? AND clusterId = ? AND clubId = ?",
        whereArgs: [aAreaId, aClusterId, aClubId]);
    return result.isNotEmpty ? RotaryClubObject.fromMap(result.first) : null ;
  }
  //#endregion

  //#region insertRawRotaryClub [----------- Not in use...]
  Future insertRawRotaryClub(RotaryClubObject aRotaryClub) async {
    final db = await database;

    var result = await db.rawInsert(
        "INSERT Into RotaryClub ("
            "areaId, "
            "clusterId, "
            "clubId, "
            "clubName ) "
        "VALUES ("
            "${aRotaryClub.areaId}, "
            "${aRotaryClub.clusterId}, "
            "${aRotaryClub.clubId}, "
            "${aRotaryClub.clubName} "
        ")"
    );
    return result;
  }
  //#endregion

  //#region insert Rotary Club
  Future insertRotaryClub(RotaryClubObject aRotaryClub) async {
    final db = await database;
    var result = await db.insert(
        "RotaryClub",
        aRotaryClub.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    return result;
  }
  //#endregion

  //#region update Rotary Club By AreaClusterClubId
  Future updateRotaryClubByAreaClusterClubId(RotaryClubObject aRotaryClub) async {
    final db = await database;
    var result = await db.update(
        "RotaryClub",
        aRotaryClub.toMap(),
        where: "areaId = ? AND clusterId = ? AND clubId = ?",
        whereArgs: [aRotaryClub.areaId, aRotaryClub.clusterId, aRotaryClub.clubId]
    );
    return result;
  }
  //#endregion

  //#region delete Rotary Club By AreaClusterClubId
  Future<void> deleteRotaryClubByAreaClusterClubId(RotaryClubObject aRotaryClub) async {
    try {
      final db = await database;
      db.delete(
          "RotaryClub",
          where: "areaId = ? AND clusterId = ? AND clubId = ?",
          whereArgs: [aRotaryClub.areaId, aRotaryClub.clusterId, aRotaryClub.clubId]
      );
    } catch (ex) {
      print('Delete RotaryCluster [${aRotaryClub.areaId} / ${aRotaryClub.clusterId} / ${aRotaryClub.clubId} / ${aRotaryClub.clubName}] >>> ERROR: ${ex.toString()}');
    }
  }
  //#endregion

  //#region delete All Rotary Club
  Future<void> deleteAllRotaryClub() async {
    final db = await database;
    db.rawDelete('Delete * from RotaryClub');
  }
  //#endregion

  //#endregion
}
