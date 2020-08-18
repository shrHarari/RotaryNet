import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/screen_about/about_screen.dart';
import 'package:rotary_net/screen_about/privacy_policy_screen.dart';

class SideMenuDrawer extends StatelessWidget {
  static const routeName = '/RotaryMainScreen';
  final  UserObject userObj;

  SideMenuDrawer({Key key, @required this.userObj}) : super(key: key);

  Text getUserTitle() {
    String userTitle = 'שלום אורח';

    if (this.userObj.firstName.toString() != '') {
      userTitle = 'שלום ${userObj.firstName} ${userObj.lastName}';
    }

    return Text(
        userTitle,
        style: TextStyle(color: Colors.black, fontSize: 16)
    );
  }

  void exitFromApp() {
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10.0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
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
                SizedBox(height: 10.0,),

                // שלום אורח
                getUserTitle(),

                Text(
                  'התחברות',
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ],
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
}