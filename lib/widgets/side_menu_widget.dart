import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'file:///C:/FLUTTER_OCTIA/rotary_net/lib/screens/menu_pages/about_screen.dart';
import 'file:///C:/FLUTTER_OCTIA/rotary_net/lib/screens/menu_pages/privacy_policy_screen.dart';
import 'package:rotary_net/services/user_service.dart';

class SideMenuDrawer extends StatelessWidget {
  static const routeName = '/RotaryMainScreen';
  final  UserObject userObj;

  SideMenuDrawer({Key key, @required this.userObj}) : super(key: key);

  void exitFromApp() async {
    // Update SharedPreferences [Remove StayConnected]
    final UserService userService = UserService();
    await userService.exitFromApplicationUpdateSharedPreferences();

    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    print('height: $height');
    return Drawer(
      elevation: 10.0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: height * .28,
            child: DrawerHeader(
              child:
              Column(
                children: <Widget>[
                  SizedBox(height: 10.0,),
                  MaterialButton(
                    onPressed: () {},
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Icon(
                      Icons.person_outline,
                      size: 30,
                    ),
                    padding: EdgeInsets.all(16),
                    shape: CircleBorder(),
                  ),

                  buildUserWelcomeTitle(),  // שלום אורח
                  buildPersonalAreaTitle(context), // לאיזור האישי
                ],
              ),
            ),
          ),

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
            leading: Icon(Icons.exit_to_app),
            title: Text('יציאה'),
            onTap: () => {
              exitFromApp()
            },
          ),
        ],
      ),
    );
  }

  Widget buildUserWelcomeTitle ()
  {
    String userTitle = 'שלום אורח';

    if (this.userObj.firstName.toString() != '') {
      userTitle = 'שלום ${userObj.firstName} ${userObj.lastName}';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        userTitle,
        style: TextStyle(color: Colors.black, fontSize: 16)
      ),
    );
  }

  Widget buildPersonalAreaTitle (BuildContext context)
  {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
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