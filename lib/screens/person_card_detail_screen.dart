import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/screens/person_card_detail_edit_screen.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/bubbles_box_decoration.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/widgets/side_menu_widget.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/utils/utils_class.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class PersonCardDetailScreen extends StatefulWidget {
  static const routeName = '/PersonCardDetailScreen';
  final ArgDataPersonCardObject argDataObject;

  PersonCardDetailScreen({Key key, @required this.argDataObject}) : super(key: key);

  @override
  _PersonCardDetailScreenState createState() => _PersonCardDetailScreenState();
}

class _PersonCardDetailScreenState extends State<PersonCardDetailScreen> {

  final PersonCardService personCardService = PersonCardService();
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

  Future<void> makePhoneCall(String aPhoneNumber) async {
    try {
      final String _phoneCommand = "tel:$aPhoneNumber";
      if (await canLaunch(_phoneCommand)) {
        await launch(_phoneCommand);
      } else {
        throw 'Could not Make a Phone Call: $aPhoneNumber';
      }
    }
    catch (ex) {
      print ('$ex.toString()');
    }
  }

  Future<void> sendSms(String aPhoneNumber) async {
    try {
      final String _phoneCommand = "sms:$aPhoneNumber";
      if (await canLaunch(_phoneCommand)) {
        await launch(_phoneCommand);
      } else {
        throw 'Could not Send an SMS to: $aPhoneNumber';
      }
    }
    catch (ex) {
      print ('$ex.toString()');
    }
  }

  Future<void> sendEmail(String aMail) async {
    try {
      final Uri _emailLaunchUri = Uri(
          scheme: 'mailto',
          path: aMail,
          queryParameters: {
            'subject': 'Enter Subject...'
          }
      );
      launch(_emailLaunchUri.toString());
    }
    catch (ex) {
      print ('Could not send an Email To: $ex.toString()');
    }
  }

  Future<void> launchInBrowser(String aUrl) async {
    try {
      if (await canLaunch(aUrl)) {
        await launch(
          aUrl,
          forceSafariVC: false,
          forceWebView: false,
//        headers: <String, String>{'my_header_key': 'my_header_value'},
        );
      } else {
        throw 'Could not Launch In Browser: $aUrl';
      }
    }
    catch (ex){
      print ('$ex.toString()');
    }
  }

  Future<void> launchInMap(String aAddress) async {
    try {
      List<Placemark> placeMarksList = await Geolocator().placemarkFromAddress(aAddress);
//      print ('>>>>>>>> Placemarks: ${placemarks[0].toJson()}');

      if (placeMarksList != null && placeMarksList.isNotEmpty) {
        final List<String>position = placeMarksList.map((placeMark) =>
              placeMark.position?.latitude.toString() + ', ' + placeMark.position?.longitude.toString()).toList();
//        print ('>>>>>>>> coords: ${position}');

        final Placemark pos = placeMarksList[0];
        double latitude = pos.position?.latitude;
        double longitude = pos.position?.longitude;
        print ('>>>>>>>> Latitude: $latitude, Longitude: $longitude');
        GoogleMapUtil.openMap(latitude,longitude);
      }
    }
    catch (ex){
      print ('$ex.toString()');
    }
  }

  openPersonCardDetailEditScreen(PersonCardObject aPersonCardObj) async {
    ArgDataPersonCardObject argDataPersonCardObject;
    argDataPersonCardObject = ArgDataPersonCardObject(widget.argDataObject.passUserObj, aPersonCardObj, widget.argDataObject.passLoginObj);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonCardDetailEditScreen(argDataObject: argDataPersonCardObject),
      ),
    );

    if (result != null) {
      setState(() {
        displayPersonCardObject = result;
      });
    };
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        /// Menu Icon
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 0.0, bottom: 0.0),
                          child: IconButton(
                            icon: Icon(Icons.menu, color: Colors.white),
                            onPressed: () async {await openMenu();},
                          ),
                        ),
                        Spacer(flex: 8),
                        /// Debug Icon --->>> Remove before Production
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 10.0, bottom: 0.0),
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
    personCardImage = AssetImage('assets/images/${aPersonCardObj.pictureUrl}');

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
//              crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (aPersonCardObj.email != "") buildDetailImageIcon(Icons.mail_outline, aPersonCardObj.email, sendEmail),
                      if (aPersonCardObj.phoneNumber != "") buildDetailImageIcon(Icons.phone, aPersonCardObj.phoneNumber, makePhoneCall),
                      if (aPersonCardObj.phoneNumber != "") buildDetailImageIcon(Icons.sms, aPersonCardObj.phoneNumber, sendSms),
                      if (aPersonCardObj.address != "") buildDetailImageIcon(Icons.home, aPersonCardObj.address, launchInMap),
                      if (aPersonCardObj.internetSiteUrl != "") buildDetailImageIcon(Icons.alternate_email, aPersonCardObj.internetSiteUrl, launchInBrowser),
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
              textColor: Colors.white,
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
