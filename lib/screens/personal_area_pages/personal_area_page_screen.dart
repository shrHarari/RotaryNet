import 'package:flutter/material.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/screens/personal_area_pages/personal_area_page_header.dart';
import 'package:rotary_net/screens/personal_area_pages/personal_area_page_tab_person_card.dart';
import 'package:rotary_net/screens/personal_area_pages/personal_area_page_tab_user.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class PersonalAreaScreen extends StatefulWidget {
  static const routeName = '/PersonalAreaScreen';
  final UserObject argUserObject;

  PersonalAreaScreen({Key key, @required this.argUserObject}) : super(key: key);

  @override
  _PersonalAreaScreenState createState() => _PersonalAreaScreenState();
}

class _PersonalAreaScreenState extends State<PersonalAreaScreen> {

  final PersonCardService personCardService = PersonCardService();
  Future<PersonCardObject> personCardForBuild;
  PersonCardObject currentPersonCard;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool loading = false;
  bool displayPersonCard = false;

  @override
  void initState() {
    personCardForBuild = getPersonalCardFromServer(widget.argUserObject.emailId);

    if(widget.argUserObject.userType == Constants.UserTypeEnum.Guest)
      displayPersonCard = false;
    else
      displayPersonCard = true;

    super.initState();
  }

  Future<PersonCardObject> getPersonalCardFromServer(String aEmailId) async {
    dynamic personCardsObj = await personCardService.getPersonalCardByEmailFromServer(aEmailId);
    return personCardsObj;
  }

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PersonCardObject>(
      future: personCardForBuild,
      builder: (context, snapshot) {
        if (snapshot.hasData) currentPersonCard = snapshot.data;

        var radius = Radius.circular(5);

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.blue[50],

          drawer: Container(
            width: 250,
            child: Drawer(
              child: ApplicationMenuDrawer(argUserObj: widget.argUserObject),
            ),
          ),

          body: Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                /// --------------- Screen Header Area ---------------------
                BuildPersonalAreaPageHeader(onPressed: () async {await openMenu();}),

                (snapshot.connectionState == ConnectionState.waiting) ?
                  Container(child: Loading()) :

                (snapshot.hasError) ?
                  Container(
                    child: DisplayErrorText(
                      errorText: 'כרטיס ביקור חסר',
                    ),
                  ) :

                (snapshot.hasData) ?
                Expanded(
                  child: DefaultTabController(
                      length: displayPersonCard ? 2 : 1,
                      initialIndex: displayPersonCard ? 1 : 0,
                      child: Scaffold(
                        appBar: PreferredSize(
                          preferredSize: Size.fromHeight(25),
                          child: Container(
                            color: Colors.lightBlue[400],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TabBar(
                                  indicatorColor: Colors.white,
                                  labelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),   //For Selected tab
                                  unselectedLabelStyle: TextStyle(fontSize: 14.0),                      //For Un-selected Tabs
                                  tabs: <Widget>[
                                    Tab(text :"כרטיס ביקור"),
                                    if (displayPersonCard) Tab(text :"פרטי משתמש"),
                                  ],
                                  indicator: ShapeDecoration(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: radius, topLeft: radius)),
                                      color: Colors.lightBlue[700]
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        body: TabBarView(
                          children: [
                            /// --------------- TAB: PersonCard ---------------------
                            if (displayPersonCard) BuildPersonalAreaPageTabPersonCard(argPersonCard: currentPersonCard),

                            /// --------------- TAB: User ---------------------
                            BuildPersonalAreaPageTabUser(argUser: widget.argUserObject),
//                            StretchExample(),
                          ],
                        ),
                      ),
                    ),
                ) :

                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
                    width: double.infinity,
                    child: Center(child: Text('אין תוצאות')),
                  ),
                ),
              ]
            ),
          ),
        );
      }
    );
  }
}

