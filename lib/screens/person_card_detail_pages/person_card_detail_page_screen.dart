import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/screens/person_card_detail_pages/person_card_detail_edit_page_screen.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/bubbles_box_decoration.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/utils/utils_class.dart';

class PersonCardDetailPageScreen extends StatefulWidget {
  static const routeName = '/PersonCardDetailScreen';
  final ArgDataPersonCardObject argDataObject;

  PersonCardDetailPageScreen({Key key, @required this.argDataObject}) : super(key: key);

  @override
  _PersonCardDetailPageScreenState createState() => _PersonCardDetailPageScreenState();
}

class _PersonCardDetailPageScreenState extends State<PersonCardDetailPageScreen> {

  PersonCardObject displayPersonCardObject;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  AssetImage personCardImage;

  String error = '';
  bool loading = false;
  bool isPhoneNumberEnteredOK = false;
  String phoneNumberHintText = 'Phone Number';

  @override
  void initState() {
    displayPersonCardObject = widget.argDataObject.passPersonCardObj;
    super.initState();
  }

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  openPersonCardDetailEditScreen(PersonCardObject aPersonCardObj) async {
    ArgDataPersonCardObject argDataPersonCardObject;
    argDataPersonCardObject = ArgDataPersonCardObject(widget.argDataObject.passUserObj, aPersonCardObj, widget.argDataObject.passLoginObj);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonCardDetailEditPageScreen(argDataObject: argDataPersonCardObject),
      ),
    );

    if (result != null) {
      setState(() {
        displayPersonCardObject = result;
      });
    };
  }

  closeAndReturnUpdatedPersonCardObject() async {
    /// Return  displayEventObject
    Navigator.pop(context, displayPersonCardObject);
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
            child: ApplicationMenuDrawer(argUserObj: widget.argDataObject.passUserObj),
          ),
        ),
      body: buildMainScaffoldBody(),
    );
  }

  Widget buildMainScaffoldBody() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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

                        /// Debug Icon --->>> Remove before Production
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 10.0, bottom: 0.0),
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward, color: Colors.white),
                            onPressed: () {
                              closeAndReturnUpdatedPersonCardObject();
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
                  padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
                  width: double.infinity,
                  child: buildPersonCardDetailDisplay(displayPersonCardObject),
                  ),
            ),
        ]
      ),
    );
  }

  /// ====================== Person Card All Fields ==========================
  Widget buildPersonCardDetailDisplay(PersonCardObject aPersonCardObj) {
    personCardImage = AssetImage('assets/images/person_cards/${aPersonCardObj.pictureUrl}');

    return Column(
      children: <Widget>[
        /// ------------------- Image + Card Name -------------------------
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
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
              Padding(
                padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 10.0, bottom: 0.0),
                child: IconButton(
                  icon: Icon(Icons.mode_edit, color: Colors.grey[900]),
                  onPressed: () {openPersonCardDetailEditScreen(aPersonCardObj);},
                ),
              ),
            ],
          ),
        ),

        /// --------------------- Card Description -------------------------
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.only(left: 0.0, top: 20.0, right: 0.0, bottom: 20.0),
              child: Column(
                children: <Widget>[
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
                  SizedBox(height: 20.0,),

                  /// ---------------- Card Details (Icon Images) --------------------
                  Column(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      if (aPersonCardObj.email != "") buildDetailImageIcon(Icons.mail_outline, aPersonCardObj.email, Utils.sendEmail),
                      if (aPersonCardObj.phoneNumber != "") buildDetailImageIcon(Icons.phone, aPersonCardObj.phoneNumber, Utils.makePhoneCall),
                      if (aPersonCardObj.phoneNumber != "") buildDetailImageIcon(Icons.sms, aPersonCardObj.phoneNumber, Utils.sendSms),
                      if (aPersonCardObj.address != "") buildDetailImageIcon(Icons.home, aPersonCardObj.address, Utils.launchInMapByAddress),
                      if (aPersonCardObj.internetSiteUrl != "") buildDetailImageIcon(Icons.alternate_email, aPersonCardObj.internetSiteUrl, Utils.launchInBrowser),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildDetailImageIcon(IconData aIcon, String aTitle, Function aFunc) {
    return Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: MaterialButton(
              elevation: 0.0,
              onPressed: () {aFunc(aTitle);},
              color: Colors.blue[10],
              child:
              IconTheme(
                data: IconThemeData(
                    color: Colors.blue[500]
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
              child: Text(
                aTitle,
                style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 14.0),
              ),
            ),
          ),
        ]
    );
  }
}
