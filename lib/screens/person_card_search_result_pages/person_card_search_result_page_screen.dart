import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/screens/person_card_detail_pages/person_card_detail_page_screen.dart';
import 'package:rotary_net/screens/person_card_search_result_pages/person_card_search_result_page_list_tile.dart';
import 'package:rotary_net/screens/person_card_search_result_pages/person_card_search_result_page_header_search_box.dart';
import 'package:rotary_net/screens/person_card_search_result_pages/person_card_search_result_page_header_title.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';

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

  final PersonCardService personCardService = PersonCardService();
  Future<List<PersonCardObject>> personCardsListForBuild;
  List<PersonCardObject> currentPersonCardsList;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController(text: widget.searchText);
    personCardsListForBuild = getPersonCardsListFromServer(widget.searchText);
  }

  void renderSearch(String aSearchText){
    // Hide Keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      searchController = TextEditingController(text: aSearchText);
      personCardsListForBuild = getPersonCardsListFromServer(aSearchText);
    });
  }

  Future<List<PersonCardObject>> getPersonCardsListFromServer(String aSearchText) async {

//    await Future<void>.delayed(Duration(seconds: 1));

    dynamic personCardsList = await personCardService.getPersonCardsListSearchFromServer(widget.searchText);
    return personCardsList;
  }

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  openPersonCardDetailScreen(PersonCardObject aPersonCardObj, int indexOfPersonCardObj) async {
    ArgDataPersonCardObject argDataPersonCardObject;
    argDataPersonCardObject = ArgDataPersonCardObject(widget.argDataObject.passUserObj, aPersonCardObj, widget.argDataObject.passLoginObj);

    final resultDataObj = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonCardDetailPageScreen(argDataObject: argDataPersonCardObject),
      ),
    );

    /// When return from Page >>> Update PersonCardObject in the List[pos: indexOfPersonCardObj]
    if (resultDataObj != null) {
      setState(() {
        currentPersonCardsList[indexOfPersonCardObj] = resultDataObj;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PersonCardObject>>(
      future: personCardsListForBuild,
      builder: (context, snapshot) {
        if (snapshot.hasData) currentPersonCardsList = snapshot.data;

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
                      delegate: PersonCardSearchResultPageHeaderTitle(
                        minExtent: 140.0,
                        maxExtent: 140.0,
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: PersonCardSearchResultPageHeaderSearchBox(
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
                                  return BuildPersonCardTile(
                                      argPersonCardObj: currentPersonCardsList[index],
                                      argFuncOpenPersonCardDetail: openPersonCardDetailScreen,
                                      argIndexOfPersonCardObj: index,
                                  );
                                },
                            childCount: currentPersonCardsList.length,
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
