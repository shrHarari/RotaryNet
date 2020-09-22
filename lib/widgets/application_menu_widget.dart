import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/screens/menu_pages/about_screen.dart';
import 'package:rotary_net/screens/menu_pages/privacy_policy_screen.dart';
import 'package:rotary_net/screens/personal_area_pages/personal_area_page_screen.dart';
import 'package:rotary_net/screens/rotary_users_pages/rotary_users_list_page_screen.dart';
import 'package:rotary_net/services/connected_user_service.dart';

class ApplicationMenuDrawer extends StatefulWidget {

  ApplicationMenuDrawer({Key key}) : super(key: key);

  @override
  _ApplicationMenuDrawerState createState() => _ApplicationMenuDrawerState();
}

class _ApplicationMenuDrawerState extends State<ApplicationMenuDrawer> {

  ConnectedUserObject currentConnectedUserObj;

  @override
  void initState() {
    getConnectedUserObject().then((value) {
      setState(() {
        currentConnectedUserObj = value;
      });
    });
    super.initState();
  }

  Future<ConnectedUserObject> getConnectedUserObject() async {
    var _userGlobal = ConnectedUserGlobal();
    ConnectedUserObject _connectedUserObj = _userGlobal.getConnectedUserObject();
    return _connectedUserObj;
  }

  openPersonalAreaScreen(ConnectedUserObject aConnectedUserObj) async {

    // Drawer --> Close the drawer
    Navigator.of(context).pop();

    // Drawer --> Open PersonalAreaScreen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PersonalAreaScreen(argConnectedUserObject: aConnectedUserObj),
      ),
    );

  }

  void exitFromApp() async {
    /// Update SecureStorage [Remove StayConnected]
    final ConnectedUserService connectedUserService = ConnectedUserService();
    await connectedUserService.exitFromApplicationUpdateSecureStorage();

    exit(0);
  }

  @override
  Widget build(BuildContext context) {
//    final height = MediaQuery.of(context).size.height;
    return Drawer(
      elevation: 10.0,
      child:
        Column(
          children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
//              height: height * .28,
              child: DrawerHeader(
                child:
                Column(
                  children: <Widget>[
                    buildPersonalAreaIcon(),
                    buildUserWelcomeTitle(),  // שלום אורח
                    buildPersonalAreaTitle(context, currentConnectedUserObj), // לאיזור האישי
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.dvr),
                  title: Text('אודות'),
                  onTap: () => {
                    Navigator.of(context).pop(),
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AboutScreen(),
                      ),
                    )
                  },
                ),
                ListTile(
                  leading: Icon(Icons.verified_user),
                  title: Text('מדיניות הפרטיות'),
                  onTap: () => {
                    Navigator.of(context).pop(),
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicyScreen(),
                      ),
                    )
                  },
                ),
                ListTile(
                  leading: Icon(Icons.receipt),
                  title: Text('תנאי שימוש'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('הגדרות'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.verified_user),
                  title: Text('ניהול משתמשים'),
                  onTap: () => {
                    Navigator.of(context).pop(),

                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                        RotaryUsersListPageScreen(argConnectedUserObject: currentConnectedUserObj)
                      ),
                    ),
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('יציאה'),
                  onTap: () => {
                    exitFromApp()
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPersonalAreaIcon ()
  {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: MaterialButton(
        onPressed: () {},
        color: Colors.lightBlue,
        textColor: Colors.white,
        child: Icon(
          Icons.person_outline,
          size: 30,
        ),
        padding: EdgeInsets.all(16),
        shape: CircleBorder(),
      ),
    );
  }

  Widget buildUserWelcomeTitle ()
  {
    String userTitle = 'אורח';
    if (currentConnectedUserObj != null && currentConnectedUserObj.firstName != '') {
      userTitle = '${currentConnectedUserObj.firstName} ${currentConnectedUserObj.lastName}';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: RichText(
        text: new TextSpan(
            text: 'שלום ',
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
            ),
//            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
            TextSpan(
              text: userTitle,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPersonalAreaTitle (BuildContext context, ConnectedUserObject aConnectedUserObj)
  {
    return InkWell(
      onTap: () {openPersonalAreaScreen(aConnectedUserObj);},
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          'לאיזור האישי',
          style: TextStyle(color: Colors.blue, fontSize: 14),
        ),
      ),
    );
  }
}
