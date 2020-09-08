import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/screens/person_card_detail_pages/person_card_detail_page_screen.dart';
import 'package:rotary_net/screens/person_card_search_result_pages/person_card_search_result_page_card_tile.dart';
import 'package:rotary_net/screens/person_card_search_result_pages/person_card_search_result_page_header_search_box.dart';
import 'package:rotary_net/screens/person_card_search_result_pages/person_card_search_result_page_header_title.dart';
import 'package:rotary_net/screens/user_pages/user_page_header_search_box.dart';
import 'package:rotary_net/screens/user_pages/user_page_header_title.dart';
import 'package:rotary_net/screens/user_pages/user_page_list_tile.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';

class UserPageScreen extends StatefulWidget {
  static const routeName = '/UserPageScreen';
  final ArgDataUserObject argDataObject;
  final String searchText;

  UserPageScreen({Key key, @required this.argDataObject, @required this.searchText}) : super(key: key);

  @override
  _UserPageScreenState createState() => _UserPageScreenState();
}

class _UserPageScreenState extends State<UserPageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();

  final UserService userService = UserService();
  Future<List<UserObject>> usersListForBuild;
  List<UserObject> currentUsersList;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController(text: widget.searchText);
    usersListForBuild = getUsersListFromServer(widget.searchText);
  }

  void renderSearch(String aSearchText){
    // Hide Keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      searchController = TextEditingController(text: aSearchText);
      usersListForBuild = getUsersListFromServer(aSearchText);
    });
  }

  Future<List<UserObject>> getUsersListFromServer(String aSearchText) async {

//    await Future<void>.delayed(Duration(seconds: 1));

    dynamic usersList = await userService.getUsersListFromServer(widget.searchText);
    return usersList;
  }

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  openUserDetailScreen(UserObject aUserObj, int indexOfUserObj) async {
    ArgDataUserObject argDataUserObject;
    argDataUserObject = ArgDataUserObject(widget.argDataObject.passUserObj, widget.argDataObject.passLoginObj);

///>>>>When will be implemented
    // final resultDataObj = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => UserDetailPageScreen(argDataObject: argDataUserObject),
    //   ),
    // );

    /// When return from Page >>> Update UserObject in the List[pos: indexOfUserObj]
    // if (resultDataObj != null) {
    //   setState(() {
    //     currentUsersList[indexOfUserObj] = resultDataObj;
    //   });
    // };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserObject>>(
      future: usersListForBuild,
      builder: (context, snapshot) {
        if (snapshot.hasData) currentUsersList = snapshot.data;

        return Scaffold(
          key: _scaffoldKey,
          drawer: Container(
            width: 250,
            child: Drawer(
              child: ApplicationMenuDrawer(argUserObj: widget.argDataObject.passUserObj),
            ),
          ),

          body: Container(
            child: Stack(
              children: [
                /// ----------- Header - Application Logo [Title] & Search Box Area [TextBox] -----------------
                CustomScrollView(
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      pinned: false,
                      floating: false,
                      delegate: UserPageHeaderTitle(
                        minExtent: 140.0,
                        maxExtent: 140.0,
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: UserPageHeaderSearchBox(
                          minExtent: 90.0,
                          maxExtent: 90.0,
                          searchController: searchController,
                          funcRenderSearch: renderSearch
                      ),
                    ),

                    (snapshot.connectionState == ConnectionState.waiting) ?
                    SliverFillRemaining(
                        child: Loading()
                    ) :

                    (snapshot.hasError) ?
                    SliverFillRemaining(
                      child: DisplayErrorTextAndRetryButton(
                        errorText: 'שגיאה בשליפת כרטיסי הביקור',
                        buttonText: 'נסה שוב',
                        onPressed: () {renderSearch(searchController.text);},
                      ),
                    ) :

                    (snapshot.hasData) ?
                    SliverFixedExtentList(
                      itemExtent: 130.0,
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return BuildUserListTile(
                            argUserObj: currentUsersList[index],
                            argFuncOpenUserDetail: openUserDetailScreen,
                            argIndexOfUserObj: index,
                          );
                        },
                        childCount: currentUsersList.length,
                      ),
                    ) :
                    //========================================
                    SliverFillRemaining(
                      child: Center(child: Text('אין תוצאות')),
                    ),
                  ],
                ),

                /// --------------- Application Menu ---------------------
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      /// Menu Icon --->>> Open Drawer Menu
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 0.0, bottom: 0.0),
                        child: IconButton(
                          icon: Icon(Icons.menu, color: Colors.white),
                          onPressed: () async {await openMenu();},
                        ),
                      ),

                      /// Back Icon --->>> Back to previous screen
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 10.0, bottom: 0.0),
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward, color: Colors.white),
                          onPressed: () {Navigator.pop(context, searchController.text);},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
