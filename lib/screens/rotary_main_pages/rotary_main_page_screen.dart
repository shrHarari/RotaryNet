import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/login_object.dart';
import 'package:rotary_net/screens/debug_setting_screen.dart';
import 'package:rotary_net/screens/event_detail_pages/event_detail_edit_page_screen.dart';
import 'package:rotary_net/screens/event_search_result_pages/event_search_result_page_screen.dart';
import 'package:rotary_net/screens/person_card_search_result_pages/person_card_search_result_page_screen.dart';
import 'package:rotary_net/screens/rotary_main_pages/rotary_main_page_header_search_box.dart';
import 'package:rotary_net/screens/rotary_main_pages/rotary_main_page_header_title.dart';
import 'package:rotary_net/shared/constants.dart';
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

  Future<DataRequiredForBuild> dataRequiredForBuild;
  DataRequiredForBuild currentDataRequired;

  bool loading = false;

  SearchTypeEnum currentSearchType = SearchTypeEnum.PersonCard;
  Color personCardBackgroundColor = Colors.amberAccent;
  Color eventsBackgroundColor = Colors.white;

  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {

    /// Lock Screen orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    dataRequiredForBuild = _fetchAllRequiredForBuild();
    super.initState();
  }

  Future<DataRequiredForBuild> _fetchAllRequiredForBuild() async {
    return DataRequiredForBuild(
      allowUpdate: await getUpdatePermission(),
    );
  }

  Future<ConnectedUserObject> getConnectedUserObject() async {
    var _userGlobal = ConnectedUserGlobal();
    ConnectedUserObject _connectedUserObj = _userGlobal.getConnectedUserObject();
    return _connectedUserObj;
  }

  Future <bool> getUpdatePermission() async {
    ConnectedUserObject _connectedUserObj = await getConnectedUserObject();
    bool _allowUpdate = false;

    switch (_connectedUserObj.userType) {
      case Constants.UserTypeEnum.SystemAdmin:
        _allowUpdate = true;
        break;
      case  Constants.UserTypeEnum.RotaryMember:
        _allowUpdate = true;
        break;
      case  Constants.UserTypeEnum.Guest:
        _allowUpdate = false;
    }
    return _allowUpdate;
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

  //#region Open Debug Settings
  Future<void> openDebugSettings() async {
    // Navigate to DebugSettings Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DebugSettings(argLoginObject: widget.argLoginObject,),
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
  Future<void> executeSearchByType(String aValueToSearch) async {
    // Hide Keyboard
    FocusScope.of(context).requestFocus(FocusNode());

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
    Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background/main_screen.jpg"),
              fit: BoxFit.cover
          )
      ),
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,

          drawer: Container(
            width: 250,
            child: Drawer(
              child: ApplicationMenuDrawer(),
            ),
          ),

          body: FutureBuilder<DataRequiredForBuild>(
            future: dataRequiredForBuild,
            builder: (context, snapshot) {

              if (snapshot.hasData)
              {
                currentDataRequired = snapshot.data;
                return buildMainScaffoldBody();
              }
              else
                return Loading();
            }
          ),
      ),
    );
  }

  Widget buildMainScaffoldBody() {
    final height = MediaQuery.of(context).size.height;

    return Container(
      child: Stack(
        children: [
          /// ----------- Header - Application Logo [Title] & Search Box Area [TextBox] -----------------
          CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: RotaryMainPageHeaderTitle(
                  minExtent: 140.0,
                  maxExtent: 140.0,
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: RotaryMainPageHeaderSearchBox(
                    minExtent: 90.0,
                    maxExtent: 90.0,
                    searchController: searchController,
                    funcExecuteSearch: executeSearchByType
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  // color: Colors.green,
                  // height: height * .5,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 80.0, right: 20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: [
                              buildImageIconWithTitle('אירועים', Icons.event, executeSearchByType, SearchTypeEnum.Event, eventsBackgroundColor),

                              if (currentDataRequired.allowUpdate)
                                buildAddEventImageIconWithTitle('הוסף אירוע', Icons.plus_one, openEventDetailEditScreen, Colors.white),
                            ],
                          ),
                          buildImageIconWithTitle('כרטיס ביקור', Icons.person, executeSearchByType, SearchTypeEnum.PersonCard, personCardBackgroundColor),
                        ]
                    ),
                  ),
                ),
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
                    icon: Icon(Icons.build, color: Colors.white),
                    onPressed: () async {await openDebugSettings();},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImageIconWithTitle(String aTitle, IconData aIcon, Function aExecuteFunc, SearchTypeEnum aSearchType, Color aButtonColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
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
        setState(() {
          currentSearchType = aSearchType;
        });
        aExecuteFunc(searchController.text);
      },
      shape: CircleBorder(side: BorderSide(color: Colors.blue, width: 2.0)),
      padding: EdgeInsets.all(20),
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
          fontSize: 18.0,
          height: 0.8,
          color: Colors.blue,
          fontWeight: FontWeight.bold
      ),
    );
  }

  Widget buildAddEventImageIconWithTitle(String aTitle, IconData aIcon, Function aFunc, Color aButtonColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 30.0, right: 30.0),
      child: Column(
          textDirection: TextDirection.rtl,
          children: <Widget>[
            MaterialButton(
            color: aButtonColor,
              onPressed: () {
                aFunc();
              },
              shape: CircleBorder(side: BorderSide(color: Colors.blue, width: 2.0)),
              padding: EdgeInsets.all(20),
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
                    fontSize: 18.0,
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
}

class DataRequiredForBuild {
  bool allowUpdate;

  DataRequiredForBuild({
    this.allowUpdate,
  });
}

