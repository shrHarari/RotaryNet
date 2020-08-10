import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/screens/person_cards_search_result_screen.dart';
import 'package:rotary_net/screens/debug_setting_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/widgets/side_menu_widget.dart';

class RotaryMainScreen extends StatefulWidget {
  static const routeName = '/RotaryMainScreen';
  final ArgDataUserObject argDataObject;

  RotaryMainScreen({Key key, @required this.argDataObject}) : super(key: key);

  @override
  _RotaryMainScreen createState() => _RotaryMainScreen();
}

class _RotaryMainScreen extends State<RotaryMainScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String appBarTitle = 'Rotary';
  String messageTitle = '';
  String messageBody = '';
  bool loading = true;
  bool isShowDataForDebug = false;

  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    createDataToDisplay();

    /// Lock Screen orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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

  Future<Null> createDataToDisplay() async {

    if (widget.argDataObject.passUserObj.phoneNumberCleanLongFormat == null)
    {
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        messageTitle = 'Dear ${widget.argDataObject.passUserObj.firstName} ${widget.argDataObject.passUserObj.lastName},';
        messageBody = 'TODO: Design Main Screen.\n';

        loading = false;
      });
    }
  }

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  Future<void> openDebugSettings() async {
    // Navigate to DebugSettings Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DebugSettings(argDataObject: widget.argDataObject),
      ),
    );
  }

  Future<void> openPersonCardsSearchResultScreen(String aValueToSearch) async {
    /// Navigate to PersonCardsSearchResultScreen Screen
    if (searchController.text != "")
      {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonCardsSearchResultScreen(argDataObject: widget.argDataObject, searchText: aValueToSearch),
          ),
        );
      }
  }

  Future<void> executeSearch(String aValueToSearch) async {
    // Hide Keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    if (searchController.text != "")
    {
      openPersonCardsSearchResultScreen(aValueToSearch);
    }
  }

  @override
  Widget build(BuildContext context) {

    return loading ? Loading() :
    Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.blue[50],

        drawer: Container(
          width: 250,
          child: Drawer(
            child: SideMenuDrawer(userObj: widget.argDataObject.passUserObj),
          ),
        ),

        body: buildMainScaffoldBody()
    );
  }

  Widget buildMainScaffoldBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// --------------- Title Area ---------------------
            Container(
              height: 230,
              color: Colors.blue[500],
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    /// --------------- First line - Menu Area ---------------------
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: <Widget>[
                        /// Menu Icon
                        Expanded(
                          flex: 3,
                          child: IconButton(
                            icon: Icon(Icons.menu, color: Colors.white),
                            onPressed: () async {await openMenu();},
                          ),
                        ),

                        Expanded(
                          flex: 8,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 10.0,),
                              MaterialButton(
                                elevation: 0.0,
                                onPressed: () {},
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Icon(
                                  Icons.account_balance,
                                  size: 30,
                                ),
                                padding: EdgeInsets.all(20),
                                shape: CircleBorder(side: BorderSide(color: Colors.white)),
                              ),
                              SizedBox(height: 10.0,),

                              Text(appBarTitle,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),

                        /// Debug Icon --->>> Remove before Production
                        Expanded(
                          flex: 3,
                          child: IconButton(
                            icon: Icon(Icons.build, color: Colors.white),
                            onPressed: () async {await openDebugSettings();},
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0,),

                    /// --------------- Second line - Search Box Area ---------------------
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 30.0,),
                        Flexible(
                          child: TextField(
                            maxLines: 1,
                            controller: searchController,
                            textAlign: TextAlign.right,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) async {await executeSearch(value);},
                            style: TextStyle(
                                fontSize: 14.0,
                                height: 0.8,
                                color: Colors.black
                            ),
                            decoration: InputDecoration(
                                prefixIcon: IconButton(
                                  color: Colors.blue,
                                  icon: Icon(Icons.search),
                                  onPressed: () async {await executeSearch(searchController.text);},
                                ),
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(30.0),
                                  ),
                                ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              hintText: "מילת חיפוש",
                              fillColor: Colors.white
                            ),
                          ),
                        ),
                        SizedBox(width: 30.0,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]
      ),
    );
  }
}

