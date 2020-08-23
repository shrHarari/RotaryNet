import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/screens/person_cards_search_result/person_cards_search_result_page_content.dart';
import 'package:rotary_net/screens/person_cards_search_result/person_cards_search_result_page_header_textbox.dart';
import 'package:rotary_net/screens/person_cards_search_result/person_cards_search_result_page_header_title.dart';
import 'package:rotary_net/widgets/side_menu_widget.dart';

class PersonCardSearchResultPage extends StatefulWidget {
  static const routeName = '/PersonCardSearchResultPage';
  final ArgDataUserObject argDataObject;
  final String searchText;

  PersonCardSearchResultPage({Key key, @required this.argDataObject, @required this.searchText}) : super(key: key);

  @override
  _PersonCardSearchResultPageState createState() => _PersonCardSearchResultPageState();
}

class _PersonCardSearchResultPageState extends State<PersonCardSearchResultPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.searchText);
  }

  void renderSearch(TextEditingController aSearchController){
    FocusScope.of(context).requestFocus(FocusNode());
    print('Render Search >>>>>>>>>>>>>>>>>>>> ${aSearchController.text}');
    setState(() => searchController = aSearchController);
//    searchController = aSearchController;
    // Hide Keyboard
  }

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Container(
        width: 250,
        child: Drawer(
          child: SideMenuDrawer(userObj: widget.argDataObject.passUserObj),
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
                  delegate: PersonCardSearchResultPageHeaderTitle(
                    minExtent: 140.0,
                    maxExtent: 140.0,
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: PersonCardSearchResultPageHeaderTextBox(
                    minExtent: 90.0,
                    maxExtent: 90.0,
                    searchController: searchController,
                    aFunc: renderSearch
                  ),
                ),
                PersonCardSearchResultPageContent(argDataObject: widget.argDataObject, searchText: searchController.text),
              ],
            ),

            /// --------------- Application Menu ---------------------
            SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /// Menu Icon --->>> Open Drawer Menu
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 0.0, bottom: 0.0),
                    child: IconButton(
                      icon: Icon(Icons.menu, color: Colors.white),
                      onPressed: () async {await openMenu();},
                    ),
                  ),
                  Spacer(flex: 8),
                  /// Back Icon --->>> Back to previous screen
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 10.0, bottom: 0.0),
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward, color: Colors.white),
                      onPressed: () {Navigator.pop(context);},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
