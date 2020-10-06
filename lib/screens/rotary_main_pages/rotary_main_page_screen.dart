import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/messages_list_bloc.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/login_object.dart';
import 'package:rotary_net/objects/message_with_description_object.dart';
import 'package:rotary_net/screens/debug_setting_screen.dart';
import 'package:rotary_net/screens/event_detail_pages/event_detail_edit_page_screen.dart';
import 'package:rotary_net/screens/event_search_result_pages/event_search_result_page_screen.dart';
import 'package:rotary_net/screens/message_detail_pages/rotary_main_page_message_list_tile.dart';
import 'package:rotary_net/screens/person_card_search_result_pages/person_card_search_result_page_screen.dart';
import 'package:rotary_net/screens/rotary_main_pages/rotary_main_page_action_image_icons.dart';
import 'package:rotary_net/screens/rotary_main_pages/rotary_main_page_header_search_box.dart';
import 'package:rotary_net/screens/rotary_main_pages/rotary_main_page_header_title.dart';
import 'package:rotary_net/shared/constants.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class RotaryMainPageScreen extends StatefulWidget {
  static const routeName = '/RotaryMainPage';
  final LoginObject argLoginObject;

  RotaryMainPageScreen({Key key, @required this.argLoginObject}) : super(key: key);

  @override
  _RotaryMainPageScreenState createState() => _RotaryMainPageScreenState();
}

class _RotaryMainPageScreenState extends State<RotaryMainPageScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool userHasPermission = false;
  bool loading = false;

  SearchTypeEnum currentSearchType = SearchTypeEnum.PersonCard;
  Color personCardBackgroundColor = Colors.amberAccent;
  Color eventsBackgroundColor = Colors.white;

  TextEditingController searchController = new TextEditingController();

  MessagesListBloc messagesBloc;
  List<MessageWithDescriptionObject> currentMessagesList;

  @override
  void initState() {

    messagesBloc = BlocProvider.of<MessagesListBloc>(context);
    messagesBloc.getMessagesListWithDescription();

    /// Lock Screen orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    userHasPermission = getUserPermission();
    super.initState();
  }

  @override
  dispose(){
    /// UnLock Screen orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  //#region Get User Permission
  bool getUserPermission()  {
    ConnectedUserObject _connectedUserObj = ConnectedUserGlobal.currentConnectedUserObject;

    bool _userHasPermission = false;

    switch (_connectedUserObj.userType) {
      case Constants.UserTypeEnum.SystemAdmin:
        _userHasPermission = true;
        break;
      case  Constants.UserTypeEnum.RotaryMember:
        _userHasPermission = true;
        break;
      case  Constants.UserTypeEnum.Guest:
        _userHasPermission = false;
    }
    return _userHasPermission;
  }
  //#endregion

  //#region Open Debug Settings
  Future<void> openDebugSettings() async {
    // Navigate to DebugSettings Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DebugSettingsScreen(argLoginObject: widget.argLoginObject,),
      ),
    );
  }
  //#endregion

  //#region Open Person Cards Search Result Screen
  Future<void> openPersonCardsSearchResultScreen(String aValueToSearch) async {
    /// Navigate to PersonCardsSearchResultScreen Screen
    if (searchController.text != "") {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PersonCardSearchResultPage(
                  searchText: aValueToSearch
              ),
        ),
      );

      if (result == null) {
        setState(() {
          searchController.text = '';
        });
      } else {
        setState(() {
          searchController.text = result;
        });
      };
    }
  }
  //#endregion

  //#region Open Events Search Result Screen
  Future<void> openEventsSearchResultScreen(String aValueToSearch) async {
    /// Navigate to EventsSearchResultScreen Screen
    if (searchController.text != "") {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              EventSearchResultPage(
                  searchText: aValueToSearch
              ),
        ),
      );

      if (result == null) {
        setState(() {
          searchController.text = '';
        });
      } else {
        setState(() {
          searchController.text = result;
        });
      };
    }
  }
  //#endregion

  //#region Execute Search By Type
  Future<void> executeSearchByType(String aValueToSearch, SearchTypeEnum aSearchType) async {
    // Hide Keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      currentSearchType = aSearchType;
    });

    switch (currentSearchType) {
      case SearchTypeEnum.PersonCard:
        setState(() {
          personCardBackgroundColor = Colors.amberAccent;
          eventsBackgroundColor = Colors.white;
        });

        if (searchController.text != "")
        {
          openPersonCardsSearchResultScreen(aValueToSearch);
        }
        break;

      case SearchTypeEnum.Event:
        setState(() {
          personCardBackgroundColor = Colors.white;
          eventsBackgroundColor = Colors.amberAccent;
        });

        if (searchController.text != "")
        {
          openEventsSearchResultScreen(aValueToSearch);
        }
        break;
    }
  }
  //#endregion

  //#region Open Event Detail Edit Screen
  openEventDetailEditScreen() async {
    // Hide Keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailEditPageScreen(
            argEventObject: null,
            argHebrewEventTimeLabel: null
        ),
      ),
    );
  }
  //#endregion

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :
      StreamBuilder<List<MessageWithDescriptionObject>>(
        stream: messagesBloc.messagesWithDescriptionStream,
        initialData: messagesBloc.messagesListWithDescription,
        builder: (context, snapshot) {
          currentMessagesList =
          (snapshot.connectionState == ConnectionState.waiting)
              ? messagesBloc.messagesListWithDescription
              : snapshot.data;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,

          drawer: Container(
            width: 250,
            child: Drawer(
              child: ApplicationMenuDrawer(),
            ),
          ),

          // body: buildMainScaffoldBody(),
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background/main_screen.jpg"),
                    fit: BoxFit.cover
                )
            ),
            child: Column(
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          /// ----------- Header - Application Logo [Title] -----------------
                          RotaryMainPageHeaderTitle(),
                          /// ----------- Header - Search Box Area [TextBox] -----------------
                          RotaryMainPageHeaderSearchBox(
                            searchController: searchController,
                            argExecuteSearchFunc: executeSearchByType
                          ),
                          /// ----------- Body - Action Image Icons -----------------
                          RotaryMainPageActionImageIcons(
                            searchController: searchController,
                            argExecuteSearchFunc: executeSearchByType,
                            argOpenEventDetailFunc: openEventDetailEditScreen,
                            argUserHasPermission: userHasPermission,
                            argPersonCardBackgroundColor: personCardBackgroundColor,
                            argEventsBackgroundColor: eventsBackgroundColor,
                          )
                        ],
                      ),
                      /// ----------- Header - Application Menu -----------------
                      buildApplicationMenuRow(),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    child: CustomScrollView(
                      slivers: <Widget>[
                        /// ----------- Body - Error Message -----------------
                        (snapshot.hasError) ?
                        SliverFillRemaining(
                          child: DisplayErrorTextAndRetryButton(
                            errorText: 'שגיאה בשליפת כרטיסי הביקור',
                            buttonText: 'נסה שוב',
                            onPressed: () {},
                          ),
                        ) :

                        /// ----------- Body - Messages List -----------------
                        (snapshot.hasData) ?
                        Container(
                          child: SliverFixedExtentList(
                            itemExtent: 220.0,
                            delegate: SliverChildBuilderDelegate((context, index) {
                                return RotaryMainPageMessageListTile(
                                  argMessageWithDescriptionObject: currentMessagesList[index],
                                );
                              },
                              childCount: currentMessagesList.length,
                            ),
                          ),
                        ) :

                        SliverFillRemaining(
                          child: Center(child: Text('אין תוצאות')),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        );
      }
    );
  }

  Widget buildImageIconWithTitle(String aTitle, IconData aIcon, Function aExecuteFunc, SearchTypeEnum aSearchType, Color aButtonColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
          textDirection: TextDirection.rtl,
          children: <Widget>[
            buildImageIcon(aIcon, aExecuteFunc, aSearchType, aButtonColor),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: buildTitle(aTitle),
            ),
          ]
      ),
    );
  }

  MaterialButton buildImageIcon(IconData aIcon, Function aExecuteFunc, SearchTypeEnum aSearchType, Color aButtonColor) {
    return MaterialButton(
      color: aButtonColor,
      onPressed: () {
        aExecuteFunc(searchController.text, aSearchType);
      },
      shape: CircleBorder(side: BorderSide(color: Colors.blue, width: 2.0)),
      padding: EdgeInsets.all(10),
      child: IconTheme(
        data: IconThemeData(
            color: Colors.blue[500]
        ),
        child: Icon(
          aIcon,
          size: 50,
        ),
      ),
    );
  }

  Widget buildTitle(String aTitle) {
    return Text(
      aTitle,
      style: TextStyle(
          fontSize: 16.0,
          height: 0.8,
          color: Colors.blue,
          fontWeight: FontWeight.bold
      ),
    );
  }

  Widget buildAddEventImageIconWithTitle(String aTitle, IconData aIcon, Function aFunc, Color aButtonColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
      child: Column(
          textDirection: TextDirection.rtl,
          children: <Widget>[
            MaterialButton(
              color: aButtonColor,
              onPressed: () {
                aFunc();
              },
              shape: CircleBorder(side: BorderSide(color: Colors.blue, width: 2.0)),
              padding: EdgeInsets.all(10),
              child: IconTheme(
                data: IconThemeData(
                    color: Colors.blue[500]
                ),
                child: Icon(
                  aIcon,
                  size: 50,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                aTitle,
                style: TextStyle(
                    fontSize: 16.0,
                    height: 0.8,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ]
      ),
    );
  }

  Widget buildApplicationMenuRow() {
    /// ----------- Header - Application Menu -----------------
    return SafeArea(
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
              icon: Icon(Icons.build, color: Colors.white),
              onPressed: () async {await openDebugSettings();},
            ),
          ),
        ],
      ),
    );
  }
}

