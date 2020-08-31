import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/objects/event_object.dart';
import 'package:rotary_net/screens/event_detail_pages/event_detail_page_screen.dart';
import 'package:rotary_net/screens/event_search_result_pages/event_search_result_page_event_tile.dart';
import 'package:rotary_net/screens/event_search_result_pages/event_search_result_page_header_search_box.dart';
import 'package:rotary_net/screens/event_search_result_pages/event_search_result_page_header_title.dart';
import 'package:rotary_net/services/event_service.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';
import 'package:intl/date_symbol_data_local.dart' as SymbolData;
import 'package:intl/intl.dart' as Intl;

class EventSearchResultPage extends StatefulWidget {
  static const routeName = '/PersonCardSearchResultPage';
  final ArgDataUserObject argDataObject;
  final String searchText;

  EventSearchResultPage({Key key, @required this.argDataObject, @required this.searchText}) : super(key: key);

  @override
  _EventSearchResultPageState createState() => _EventSearchResultPageState();
}

class _EventSearchResultPageState extends State<EventSearchResultPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();

  final EventService eventService = EventService();
  Future<List<EventObject>> eventsListForBuild;
  List<EventObject> currentEventsList;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController(text: widget.searchText);
    eventsListForBuild = getEventsListFromServer(widget.searchText);
  }

  void renderSearch(String aSearchText){
    // Hide Keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      searchController = TextEditingController(text: aSearchText);
      eventsListForBuild = getEventsListFromServer(aSearchText);
    });
  }

  Future<List<EventObject>> getEventsListFromServer(String aSearchText) async {

//    await Future<void>.delayed(Duration(seconds: 1));

    dynamic eventsList = await eventService.getEventsListSearchFromServer(widget.searchText);
    return eventsList;
  }

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  Future <Widget> buildEventTimeLabel(EventObject aEventObj) async {
    // String eventDay = Intl.DateFormat('EEEE, d MMM, yyyy').format(aEventObj.eventStartDateTime); // prints Tuesday, 10 Dec, 2019
    // String eventStartTime = Intl.DateFormat('hh:mm').format(aEventObj.eventStartDateTime); // prints 10:02 AM
    // String eventEndTime = Intl.DateFormat('hh:mm').format(aEventObj.eventEndDateTime); // prints 10:02 AM

    await SymbolData.initializeDateFormatting("he", null);
    var formatterDateTime = Intl.DateFormat.yMMMMEEEEd('he');
    String hebrewDateTime = formatterDateTime.format(aEventObj.eventStartDateTime);
    print(hebrewDateTime);

    var formatterStartTime = Intl.DateFormat.Hm('he');
    String hebrewStartDateTime = formatterStartTime.format(aEventObj.eventStartDateTime);
    print(hebrewStartDateTime);

    var formatterEndTime = Intl.DateFormat.Hm('he');
    String hebrewEndDateTime = formatterEndTime.format(aEventObj.eventEndDateTime);
    print(hebrewEndDateTime);

    return RichText(
      textDirection: TextDirection.rtl,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'האירוע יערך ב',
            style: TextStyle(
                color: Colors.blue[700],
                fontSize: 14.0),
          ),
          TextSpan(
            text: hebrewDateTime,
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: '\nבין השעות: ',
            style: TextStyle(
                color: Colors.blue[700],
                fontSize: 14.0),
          ),
          TextSpan(
            text: '$hebrewStartDateTime - $hebrewEndDateTime',
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  openEventDetailScreen(EventObject aEventObj) async {
    Widget hebrewEventTimeLabel = await buildEventTimeLabel(aEventObj);
    print(hebrewEventTimeLabel);

    ArgDataEventObject argDataEventObject;
    argDataEventObject = ArgDataEventObject(widget.argDataObject.passUserObj, aEventObj, widget.argDataObject.passLoginObj);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPageScreen(argDataObject: argDataEventObject, argHebrewEventTimeLabel: hebrewEventTimeLabel),
      ),
    );
  }

  // openEventDetailScreen(EventObject aEventObj) {
  //   ArgDataEventObject argDataEventObject;
  //   argDataEventObject = ArgDataEventObject(widget.argDataObject.passUserObj, aEventObj, widget.argDataObject.passLoginObj);
  //
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => EventDetailPageScreen(argDataObject: argDataEventObject),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventObject>>(
      future: eventsListForBuild,
      builder: (context, snapshot) {
        if (snapshot.hasData) currentEventsList = snapshot.data;

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
                      delegate: EventSearchResultPageHeaderTitle(
                        minExtent: 140.0,
                        maxExtent: 140.0,
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: EventSearchResultPageHeaderSearchBox(
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
                        errorText: 'שגיאה בשליפת אירועים',
                        buttonText: 'נסה שוב',
                        onPressed: () {renderSearch(searchController.text);},
                      ),
                    ) :

                    (snapshot.hasData) ?
                    SliverFixedExtentList(
                      itemExtent: 200.0,
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return BuildEventTile(
                            aEventObj: currentEventsList[index],
                            aFuncOpenEventDetail: openEventDetailScreen,
                          );
                        },
                        childCount: currentEventsList.length,
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
