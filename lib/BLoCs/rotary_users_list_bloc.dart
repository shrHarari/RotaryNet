import 'package:rotary_net/BLoCs/bloc.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'dart:async';
import 'package:rotary_net/services/user_service.dart';

class RotaryUsersListBloc implements BloC {

  /// If we want to create the Bloc with arguments: declare private Parameter and Constructor
  // final UserObject userObj;
  // RotaryUsersListBloc(this.userObj){
  //   getAllUsersQuery(userObj);
  // }

  RotaryUsersListBloc(){
    getUsersListBySearchQuery(_textToSearch);
  }

  final UserService userService = UserService();
  String _textToSearch;

  // a getter of the Bloc List --> to be called from outside
  var _usersList = <UserObject>[];
  List<UserObject> get usersList => _usersList;

  // 1. private StreamController is declared that will manage the stream and sink for this BLoC.
  // StreamControllers use generics to tell the type system what kind of object will be emitted from the stream
  // final _usersController = StreamController<List<UserObject>>();

  // In case of multi calling to the stream we use broadcast
  final _usersController = StreamController<List<UserObject>>.broadcast();

  // 2. exposes a public getter to the StreamController’s stream.
  Stream<List<UserObject>> get usersStream => _usersController.stream;

  // 3. represents the input for the BLoC
  void getUsersListBySearchQuery(String aTextToSearch) async {
    _textToSearch = aTextToSearch;

    if (_textToSearch == null || _textToSearch.length == 0)
      clearUsersList();
    else
      _usersList = await userService.getUsersListBySearchQueryFromServer(_textToSearch);

    _usersController.sink.add(_usersList);
  }

  Future<void> clearUsersList() async {
    _usersList = <UserObject>[];
  }

  // 4. clean up method, the StreamController is closed when this object is deAllocated
  @override
  void dispose() {
    _usersController.close();
  }

  //#region CRUD: User

  Future<void> insertUser(UserObject aUserObj) async {
    if (_usersList.contains(aUserObj)) {
      await userService.insertUserToDataBase(aUserObj);
      // await RotaryDataBaseProvider.rotaryDB.insertUser(aUsrObj);
      _usersList.add(aUserObj);
      _usersController.sink.add(_usersList);
    }
  }

  Future<void> updateUser(UserObject aOldUserObj, UserObject aNewUserObj) async {
    if (_usersList.contains(aOldUserObj)) {
      await userService.updateUserToDataBase(aNewUserObj);

      _usersList.remove(aOldUserObj);
      _usersList.add(aNewUserObj);
      _usersController.sink.add(_usersList);
    }
  }

  Future<void> deleteUser(UserObject aUsrObj) async {
    if (_usersList.contains(aUsrObj)) {
      await userService.deleteUserFromDataBase(aUsrObj);
      // await RotaryDataBaseProvider.rotaryDB.deleteUser(aUsrObj);

      _usersList.remove(aUsrObj);
      _usersController.sink.add(_usersList);
    }
  }
//#endregion

}
