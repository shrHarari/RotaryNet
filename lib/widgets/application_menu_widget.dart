import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/screens/menu_pages/about_screen.dart';
import 'package:rotary_net/screens/menu_pages/privacy_policy_screen.dart';
import 'package:rotary_net/screens/personal_area_pages/personal_area_page_screen.dart';
import 'package:rotary_net/screens/rotary_users_pages/rotary_users_list_page_screen.dart';
import 'package:rotary_net/services/user_service.dart';

class ApplicationMenuDrawer extends StatefulWidget {
  final  UserObject argUserObj;
  final Function argReturnDataFunc;

  ApplicationMenuDrawer({Key key, @required this.argUserObj, this.argReturnDataFunc }) : super(key: key);

  @override
  _ApplicationMenuDrawerState createState() => _ApplicationMenuDrawerState();
}

class _ApplicationMenuDrawerState extends State<ApplicationMenuDrawer> {

//  UserObject displayUserObj;

  @override
  void initState() {
//    displayUserObj = widget.argUserObj;
    super.initState();
  }

  openPersonalAreaScreen(UserObject aUserObj) async {

    // 1. Drawer --> open PersonalAreaScreen --> then get updated User Object
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PersonalAreaScreen(argUserObject: aUserObj),
      ),
    );

    // 2. We have to send User Object back to RotaryMainScreen
    // 3. so -->> Call RotaryMainScreen Function (callback function)
    if (result != null)
      widget.argReturnDataFunc(result);

    // 4. finally, close the Drawer
    Navigator.of(context).pop();
  }

  void exitFromApp() async {
    // Update SharedPreferences [Remove StayConnected]
    final UserService userService = UserService();
    await userService.exitFromApplicationUpdateSharedPreferences();

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
                    buildPersonalAreaTitle(context, widget.argUserObj), // לאיזור האישי
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
                      // RotaryUsersPageScreen(argUserObject: widget.argUserObj)
                      RotaryUsersListPageScreen(argUserObject: widget.argUserObj)
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
    if (widget.argUserObj.firstName.toString() != '') {
      userTitle = '${widget.argUserObj.firstName} ${widget.argUserObj.lastName}';
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

  Widget buildPersonalAreaTitle (BuildContext context, UserObject aUserObj)
  {
    return InkWell(
      onTap: () {openPersonalAreaScreen(aUserObj);},
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
