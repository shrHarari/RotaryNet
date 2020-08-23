import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/screens/person_card_search_result_page/person_card_search_result_page_content.dart';
import 'package:rotary_net/screens/person_card_search_result_page/person_card_search_result_page_header_textbox.dart';
import 'package:rotary_net/screens/person_card_search_result_page/person_card_search_result_page_header_title.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/loading.dart';
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

  final PersonCardService personCardService = PersonCardService();
  Future<List<PersonCardObject>> personCardsForBuild;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController(text: widget.searchText);
    personCardsForBuild = getPersonCardsListFromServer(widget.searchText);
  }

  void renderSearch(String aSearchText){
    // Hide Keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      searchController = TextEditingController(text: aSearchText);
      personCardsForBuild = getPersonCardsListFromServer(aSearchText);
    });
  }

  Future<List<PersonCardObject>> getPersonCardsListFromServer(String aSearchText) async {

//    await Future<void>.delayed(Duration(seconds: 1));

    dynamic personCardsList = await personCardService.getPersonCardListSearchFromServer(widget.searchText);
    return personCardsList;
  }

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<PersonCardObject>>(
      future: personCardsForBuild,
      builder: (context, snapshot) {
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
                          funcRenderSearch: renderSearch
                      ),
                    ),

                    (snapshot.connectionState == ConnectionState.waiting) ?
                    SliverFillRemaining(
                        child: Loading()
                    ) :

                    (snapshot.hasError)  ?
                      SliverFillRemaining(
                        child: DisplayErrorTextAndRetryButton(
                            errorText: 'שגיאה בשליפת כרטיסי הביקור',
                            buttonText: 'נסה שוב',
                            onPressed: () {renderSearch(searchController.text);},
                        ),
                      ) :

                      (snapshot.hasData)  ?
                      SliverToBoxAdapter(
                        child: PersonCardSearchResultPageContent(
                            argDataObject: widget.argDataObject,
                            personCardsList: snapshot.data
                        ),
                      ) :
                      SliverFillRemaining(
                        child: Center(child: Text('אין תוצאות')),
                      ),
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

class DisplayErrorTextAndRetryButton extends StatelessWidget {
  const DisplayErrorTextAndRetryButton({Key key, this.errorText, this.buttonText, this.onPressed})
      : super(key: key);
  final String errorText;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorText,
            style: Theme.of(context).textTheme.headline,
          ),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text(buttonText,
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(color: Colors.white)),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
