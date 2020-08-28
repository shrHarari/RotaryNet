import 'package:flutter/material.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class BuildPersonalAreaPageHeader extends StatelessWidget {
  const BuildPersonalAreaPageHeader({Key key, this.onPressed}) : super(key: key);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {

    return Container(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /// Menu Icon --->>> Open Drawer Menu
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 0.0, bottom: 0.0),
                  child: IconButton(
                    icon: Icon(Icons.menu, color: Colors.white),
                    onPressed: onPressed,   // ===>>> onPressed: () async {await openMenu();},
                  ),
                ),
                Spacer(flex: 8),
                /// Back Icon --->>> Back to previous screen
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 10.0, bottom: 0.0),
                  child: IconButton(
                    icon:  Icon(Icons.close, color: Colors.white, size: 26.0,),
//                    icon: Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () {Navigator.pop(context);},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
