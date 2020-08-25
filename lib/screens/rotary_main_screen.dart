import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/screens/debug_setting_screen.dart';
import 'package:rotary_net/screens/person_card_search_result_pages/person_card_search_result_page.dart';
import 'package:rotary_net/widgets/side_menu_widget.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class RotaryMainScreen extends StatefulWidget {
  static const routeName = '/RotaryMainScreen';
  final ArgDataUserObject argDataObject;

  RotaryMainScreen({Key key, @required this.argDataObject}) : super(key: key);

  @override
  _RotaryMainScreenState createState() => _RotaryMainScreenState();
}

class _RotaryMainScreenState extends State<RotaryMainScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String messageTitle = '';
  String messageBody = '';
  bool loading = true;
  bool isShowDataForDebug = false;

  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();

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
    if (searchController.text != "") {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PersonCardSearchResultPage(argDataObject: widget.argDataObject,
                  searchText: aValueToSearch),
        ),
      );

      if (result == null) {
        setState(() {
          searchController.text = '';
        });
      } else {
        setState(() {
          searchController.text = result;
//          searchController.text = '';
        });
      };
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
    return Scaffold(
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
    return Container(
      height: 230,
      color: Colors.lightBlue[400],
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            /// ----------- Header - First line - Application Logo -----------------
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: MaterialButton(
                    elevation: 0.0,
                    onPressed: () {},
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    child: Icon(
                      Icons.account_balance,
                      size: 30,
                    ),
                    padding: EdgeInsets.all(20),
                    shape: CircleBorder(side: BorderSide(color: Colors.white)),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(Constants.rotaryApplicationName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                /// ----------- Header - Second line - Search Box Area -----------------
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50.0, top: 10.0, right: 50.0, bottom: 10.0),
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
                ),
              ],
            ),

            /// --------------- Application Menu ---------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /// Menu Icon
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 0.0, bottom: 0.0),
                  child: IconButton(
                    icon: Icon(Icons.menu, color: Colors.white),
                    onPressed: () async {await openMenu();},
                  ),
                ),
                Spacer(flex: 8),
                /// Debug Icon --->>> Remove before Production
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 10.0, bottom: 0.0),
                  child: IconButton(
                    icon: Icon(Icons.build, color: Colors.white),
                    onPressed: () async {await openDebugSettings();},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

