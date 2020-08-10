import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/bubbles_box_decoration.dart';
import 'package:rotary_net/shared/decoration_style.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/widgets/side_menu_widget.dart';

class PersonCardDetailScreen extends StatefulWidget {
  static const routeName = '/PersonCardDetailScreen';
  final ArgDataPersonCardObject argDataObject;

  PersonCardDetailScreen({Key key, @required this.argDataObject}) : super(key: key);

  @override
  _PersonCardDetailScreenState createState() => _PersonCardDetailScreenState();
}

class _PersonCardDetailScreenState extends State<PersonCardDetailScreen> {

  final PersonCardService personCardService = PersonCardService();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  AssetImage personCardImage;

  String appBarTitle = 'Rotary';

  String error = '';
  bool loading = false;
  bool isPhoneNumberEnteredOK = false;
  String phoneNumberHintText = 'Phone Number';

  @override
  void initState() {
    super.initState();
  }

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :
    Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue[50],

      drawer: Container(
        width: 250,
        child: Drawer(
          child: SideMenuDrawer(userObj: widget.argDataObject.passUserObj),
        ),
      ),

      body: buildMainScaffoldBody(),
    );
  }

  Widget buildMainScaffoldBody() {

    return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// --------------- Title Area ---------------------
            Container(
              height: 160,
              color: Colors.blue[500],
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    /// --------------- First line - Menu Area ---------------------
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: <Widget>[
                        /// Menu Icon
                        Expanded(
                          flex: 3,
                          child: IconButton(
                            icon: Icon(Icons.menu, color: Colors.white),
                            onPressed: () async {await openMenu();},
                          ),
                        ),

                        Expanded(
                          flex: 8,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 10.0,),
                              MaterialButton(
                                elevation: 0.0,
                                onPressed: () {},
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Icon(
                                  Icons.account_balance,
                                  size: 30,
                                ),
                                padding: EdgeInsets.all(20),
                                shape: CircleBorder(side: BorderSide(color: Colors.white)),
                              ),
                              SizedBox(height: 10.0,),

                              Text(appBarTitle,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0),
                              ),

                            ],
                          ),
                        ),

                        /// Back Icon --->>> Back to previous screen
                        Expanded(
                          flex: 3,
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward, color: Colors.white),
                            onPressed: () {Navigator.pop(context);},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Container(
              height: 500,
              child: buildPersonCardDetailDisplay(widget.argDataObject.passPersonCardObj),
              ),
          ]
      );
  }

  /// ====================== Person Card All Fields ==========================
  Widget buildPersonCardDetailDisplay(PersonCardObject aPersonCardObj) {
    personCardImage = AssetImage('assets/images/${aPersonCardObj.pictureUrl}');
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
        child: Column(
          children: <Widget>[
            /// ------------------- Image + card name -------------------------
            Row(
              textDirection: TextDirection.rtl,
              children: <Widget>[
                CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Colors.blue[900],
                      backgroundImage: personCardImage,
                    ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Column(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            aPersonCardObj.firstName + " " + aPersonCardObj.lastName,
                            style: TextStyle(color: Colors.grey[900], fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          aPersonCardObj.firstNameEng + " " + aPersonCardObj.lastNameEng,
                          style: TextStyle(color: Colors.grey[900], fontSize: 16.0, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50.0,),

            /// --------------------- Card Description -------------------------
            Row(
              textDirection: TextDirection.rtl,
              children: <Widget>[
                BubblesBoxDecoration(
                  aText: aPersonCardObj.cardDescription,
                  bubbleColor: Colors.blue[100],
                  isWithShadow: false,
                  isWithGradient: false,
                ),
              ],
            ),
            SizedBox(height: 40.0,),

            /// ---------------- Card Details (Icon Images) --------------------
            Column(
              textDirection: TextDirection.rtl,
//              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (aPersonCardObj.email != "") buildDetailImageIcon(Icons.mail_outline, aPersonCardObj.email),
                if (aPersonCardObj.phoneNumber != "") buildDetailImageIcon(Icons.phone, aPersonCardObj.phoneNumber),
                if (aPersonCardObj.address != "") buildDetailImageIcon(Icons.home, aPersonCardObj.address),
                if (aPersonCardObj.internetSiteUrl != "") buildDetailImageIcon(Icons.alternate_email, aPersonCardObj.internetSiteUrl),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row buildDetailImageIcon(IconData aIcon, String aTitle) {
    return Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: MaterialButton(
              elevation: 0.0,
              onPressed: () {},
              color: Colors.blue[10],
              textColor: Colors.white,
              child:
              IconTheme(
                data: IconThemeData(
                    color: Colors.blue[300]
                ),
                child: Icon(
                  aIcon,
                  size: 20,
                ),
              ),
              padding: EdgeInsets.all(10),
              shape: CircleBorder(side: BorderSide(color: Colors.blue)),
            ),
          ),

          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
//            width: 150,
              child: Text(
                aTitle,
                style: TextStyle(
                    color: Colors.blue[300],
                    fontSize: 12.0),
              ),
            ),
          ),
        ]
    );
  }
}
