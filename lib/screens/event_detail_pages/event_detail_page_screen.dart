import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/event_object.dart';
import 'package:rotary_net/screens/event_detail_pages/event_detail_edit_page_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/utils/utils_class.dart';

class EventDetailPageScreen extends StatefulWidget {
  static const routeName = '/EventDetailPageScreen';
  final EventObject argEventObject;
  final Widget argHebrewEventTimeLabel;

  EventDetailPageScreen({Key key, @required this.argEventObject, @required this.argHebrewEventTimeLabel}) : super(key: key);

  @override
  _EventDetailPageScreenState createState() => _EventDetailPageScreenState();
}

class _EventDetailPageScreenState extends State<EventDetailPageScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  EventObject displayEventObject;
  Widget hebrewEventTimeLabel;
  AssetImage eventImageDefaultAsset;

  bool allowUpdate = false;
  String error = '';
  bool loading = false;

  @override
  void initState() {
    displayEventObject = widget.argEventObject;
    hebrewEventTimeLabel = widget.argHebrewEventTimeLabel;
    eventImageDefaultAsset = AssetImage('assets/images/events/EventImageDefaultPicture.jpg');

    allowUpdate = getUpdatePermission();

    super.initState();
  }

  //#region Get Update Permission
  bool getUpdatePermission()  {
    ConnectedUserObject _connectedUserObj = ConnectedUserGlobal.currentConnectedUserObject;
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
  //#endregion

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  //#region Open Event Detail Edit Screen
  openEventDetailEditScreen(EventObject aEventObj) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailEditPageScreen(
            argEventObject: displayEventObject,
            argHebrewEventTimeLabel: hebrewEventTimeLabel
        ),
      ),
    );

    if (result != null) {
      setState(() {
        displayEventObject = result;
      });
    }
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :
    Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue[50],

      drawer: Container(
        width: 250,
        child: Drawer(
          child: ApplicationMenuDrawer(),
        ),
      ),

      body: buildMainScaffoldBody(),
    );
  }

  Widget buildMainScaffoldBody() {
    return Container(
      width: double.infinity,
      child: Column(
          children: [
            /// --------------- Title Area ---------------------
            Container(
              height: 160,
              color: Colors.lightBlue[400],
              child: SafeArea(
                child: Stack(
                  children: <Widget>[
                    /// ----------- Header - First line - Application Logo -----------------
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                          ],
                        ),
                      ],
                    ),

                    /// --------------- Application Menu ---------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        /// Menu Icon
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 0.0, bottom: 0.0),
                          child: IconButton(
                            icon: Icon(Icons.menu, color: Colors.white),
                            onPressed: () async {await openMenu();},
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 10.0, bottom: 0.0),
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                              },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                child: buildEventDetailDisplay(displayEventObject),
              ),
            ),
          ]
      ),
    );
  }

  /// ====================== Event All Fields ==========================
  Widget buildEventDetailDisplay(EventObject aEventObj) {

    return Column(
      children: <Widget>[
        /// ------------------- Event Image -------------------------
        Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              height: 200.0,
              width: double.infinity,
              // clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: (aEventObj.eventPictureUrl == null) || (aEventObj.eventPictureUrl == '')
                        ? eventImageDefaultAsset
                        : FileImage(File('${aEventObj.eventPictureUrl}')),
                    fit: BoxFit.cover
                ),
              ),
            ),
            if (allowUpdate)
              Positioned(
                  left: 20.0,
                  bottom: -25.0,
                  child: buildEditEventButton(openEventDetailEditScreen, aEventObj)
              ),
          ],
        ),

        /// ------------------- Image + Event Name -------------------------
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 30.0, bottom: 20.0),
          child: Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                aEventObj.eventName,
                style: TextStyle(color: Colors.grey[900], fontSize: 20.0, fontWeight: FontWeight.bold),
              ),

              // if (allowUpdate)
              //   IconButton(
              //     icon: Icon(Icons.mode_edit, color: Colors.grey[900]),
              //     onPressed: () {openEventDetailEditScreen(aEventObj);},
              //   ),
            ],
          ),
        ),

        /// --------------------- Event Content -------------------------
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 30.0, bottom: 40.0),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          aEventObj.eventDescription,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              fontFamily: 'Heebo-Light',
                              fontSize: 20.0,
                              height: 1.5,
                              color: Colors.black87
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// ---------------- Card Details (Icon Images) --------------------
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 30.0, bottom: 20.0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          if (aEventObj.eventLocation != "") buildDetailImageIcon(Icons.location_on, aEventObj.eventLocation, Utils.launchInMapByAddress),
                          if (aEventObj.eventManager != "") buildDetailImageIcon(Icons.person, aEventObj.eventManager, Utils.sendEmail),
                          if (aEventObj.eventStartDateTime != null) buildEventDetailImageIcon(Icons.event_available, aEventObj, Utils.addEventToCalendar),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDetailImageIcon(IconData aIcon, String aTitle, Function aFunc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              elevation: 0.0,
              onPressed: () {aFunc(aTitle);},
              color: Colors.blue[10],
              child:
              IconTheme(
                data: IconThemeData(
                    color: Colors.blue[500],
                ),
                child: Icon(
                  aIcon,
                  size: 30,
                ),
              ),
              padding: EdgeInsets.all(10),
              shape: CircleBorder(side: BorderSide(color: Colors.blue)),
            ),

            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  aTitle,
                  style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 14.0),
                ),
              ),
            ),
          ]
      ),
    );
  }

  Widget buildEventDetailImageIcon(IconData aIcon, EventObject aEventObj, Function aFunc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              elevation: 0.0,
              onPressed: () {
                aFunc(
                    aEventObj.eventName, aEventObj.eventDescription, aEventObj.eventLocation,
                    aEventObj.eventStartDateTime, aEventObj.eventEndDateTime);
              },
              color: Colors.blue[10],
              child: IconTheme(
                  data: IconThemeData(
                    color: Colors.blue[500],
                  ),
                  child: Icon(
                    aIcon,
                    size: 30,
                  ),
                ),
              padding: EdgeInsets.all(10),
              shape: CircleBorder(side: BorderSide(color: Colors.blue)),
            ),

            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: hebrewEventTimeLabel,
              ),
            ),
          ]
      ),
    );
  }

  Widget buildEditEventButton(Function aFunc, EventObject aEventObj) {
    return MaterialButton(
      elevation: 0.0,
      onPressed: () async {
        await aFunc(aEventObj);
      },
      color: Colors.white,
      padding: EdgeInsets.all(10),
      shape: CircleBorder(side: BorderSide(color: Colors.blue)),
      child: IconTheme(
        data: IconThemeData(
          color: Colors.black,
        ),
        child: Icon(
          Icons.edit,
          size: 20,
        ),
      ),
    );
  }
}