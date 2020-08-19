import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/screens/person_cards_search_result/person_cards_search_result_page_content.dart';
import 'package:rotary_net/screens/person_cards_search_result/person_cards_search_result_page_header.dart';
import 'package:rotary_net/widgets/side_menu_widget.dart';

class PersonCardSearchResultPage extends StatefulWidget {
  static const routeName = '/PersonCardsSearchResultScreen';
  final ArgDataUserObject argDataObject;
  final String searchText;

  PersonCardSearchResultPage({Key key, @required this.argDataObject, @required this.searchText}) : super(key: key);

  @override
  _PersonCardSearchResultPageState createState() => _PersonCardSearchResultPageState();
}

class _PersonCardSearchResultPageState extends State<PersonCardSearchResultPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> openMenuFunc() async {
    // Open Menu from Left side
    print('open drawer');
    print('${widget.argDataObject.passUserObj.firstName}');
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        width: 250,
        child: Drawer(
          child: SideMenuDrawer(userObj: widget.argDataObject.passUserObj),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: false,
            floating: true,
            delegate: PersonCardSearchResultPageHeader(
              minExtent: 220.0,
              maxExtent: 250.0,
              openMenuDrawerFunc: openMenuFunc,
            ),
          ),
          PersonCardSearchResultPageContent(argDataObject: widget.argDataObject, searchText: widget.searchText),
        ],
      ),
    );
  }
}
