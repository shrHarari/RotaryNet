import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/decoration_style.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/widgets/side_menu_widget.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class PersonCardDetailEditScreen extends StatefulWidget {
  static const routeName = '/PersonCardDetailEditScreen';
  final ArgDataPersonCardObject argDataObject;

  PersonCardDetailEditScreen({Key key, @required this.argDataObject}) : super(key: key);

  @override
  _PersonCardDetailEditScreenState createState() => _PersonCardDetailEditScreenState();
}

class _PersonCardDetailEditScreenState extends State<PersonCardDetailEditScreen> {

  final PersonCardService personCardService = PersonCardService();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  /// Fields Param
  TextEditingController eMailController;
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController firstNameEngController;
  TextEditingController lastNameEngController;
  TextEditingController phoneNumberController;
  TextEditingController phoneNumberDialCodeController;
  TextEditingController phoneNumberParseController;
  TextEditingController phoneNumberCleanLongFormatController;
  TextEditingController pictureUrlController;
  TextEditingController cardDescriptionController;
  TextEditingController internetSiteUrlController;
  TextEditingController addressController;

  String newEmail;
  String newFirstName;
  String newLastName;
  String newFirstNameEng;
  String newLastNameEng;
  String newPhoneNumber;
  String newPhoneNumberDialCode;
  String newPhoneNumberParse;
  String newPhoneNumberCleanLongFormat;
  String newPictureUrl;
  String newCardDescription;
  String newInternetSiteUrl;
  String newAddress;

  String error = '';
  bool loading = false;
  bool isPhoneNumberEnteredOK = false;
  String phoneNumberHintText = 'Phone Number';

  @override
  void initState() {
    setPersonCardVariables();
    super.initState();
  }

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  Future<void> setPersonCardVariables() async {
    eMailController = TextEditingController(text: widget.argDataObject.passPersonCardObj.email);
    firstNameController = TextEditingController(text: widget.argDataObject.passPersonCardObj.firstName);
    lastNameController = TextEditingController(text: widget.argDataObject.passPersonCardObj.lastName);
    firstNameEngController = TextEditingController(text: widget.argDataObject.passPersonCardObj.firstNameEng);
    lastNameEngController = TextEditingController(text: widget.argDataObject.passPersonCardObj.lastNameEng);
    phoneNumberController = TextEditingController(text: widget.argDataObject.passPersonCardObj.phoneNumber);
    phoneNumberDialCodeController = TextEditingController(text: widget.argDataObject.passPersonCardObj.phoneNumberDialCode);
    phoneNumberParseController = TextEditingController(text: widget.argDataObject.passPersonCardObj.phoneNumberParse);
    phoneNumberCleanLongFormatController = TextEditingController(text: widget.argDataObject.passPersonCardObj.phoneNumberCleanLongFormat);
    pictureUrlController = TextEditingController(text: widget.argDataObject.passPersonCardObj.pictureUrl);
    cardDescriptionController = TextEditingController(text: widget.argDataObject.passPersonCardObj.cardDescription);
    internetSiteUrlController = TextEditingController(text: widget.argDataObject.passPersonCardObj.internetSiteUrl);
    addressController = TextEditingController(text: widget.argDataObject.passPersonCardObj.address);
  }

  void setEmailValueFunc(String aEmail){
    newEmail = aEmail;
  }
  void setFirstNameValueFunc(String aFirstName){
    newFirstName = aFirstName;
  }
  void setLastNameValueFunc(String aLastName){
    newLastName = aLastName;
  }

  void setFirstNameEngValueFunc(String aFirstNameEng){
    newFirstNameEng = aFirstNameEng;
  }

  void setLastNameEngValueFunc(String aLastNameEng){
    newLastNameEng = aLastNameEng;
  }

  void setPhoneNumberValueFunc(String aPhoneNumber){
    newPhoneNumber = aPhoneNumber;
  }

  void setPhoneNumberDialCodeValueFunc(String aPhoneNumberDialCode){
    newPhoneNumberDialCode = aPhoneNumberDialCode;
  }

  void setPhoneNumberParseValueFunc(String aPhoneNumberParse){
    newPhoneNumberParse = aPhoneNumberParse;
  }

  void setPhoneNumberCleanLongFormatValueFunc(String aPhoneNumberCleanLongFormat){
    newPhoneNumberCleanLongFormat = aPhoneNumberCleanLongFormat;
  }

  void setPictureUrlValueFunc(String aPictureUrl){
    newPictureUrl = aPictureUrl;
  }

  void setCardDescriptionValueFunc(String aLastName){
    newLastName = aLastName;
  }

  void setInternetSiteUrlValueFunc(String aCardDescription){
    newCardDescription = aCardDescription;
  }

  void setAddressValueFunc(String aAddress){
    newAddress = aAddress;
  }

  Future<bool> checkValidation() async {
    bool _validationVal = false;

    if (formKey.currentState.validate()){
      if (isPhoneNumberEnteredOK) {
        _validationVal = true;
      } else {
        setState(() {
          phoneNumberHintText = 'Enter Number';
        });
      }
    } else {
      if (!isPhoneNumberEnteredOK) {
        setState(() {
          phoneNumberHintText = 'Enter Number';
        });
      }
    }
    return _validationVal;
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

                            Text(Constants.rotaryApplicationName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
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
            child: buildPersonCardDetailDisplay(),
          ),
        ]
    );
  }

  Widget buildPersonCardDetailDisplay() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              /// ------------------- Input Text Fields ----------------------
              buildEnabledTextInput(eMailController, 'Email', setEmailValueFunc),
              SizedBox(height: 10.0,),
              buildEnabledTextInput(firstNameController, 'First Name', setFirstNameValueFunc),
              SizedBox(height: 10.0,),
              buildEnabledTextInput(lastNameController, 'Last Name', setLastNameValueFunc),
              SizedBox(height: 10.0,),
              buildEnabledTextInput(firstNameEngController, 'First Name Eng', setFirstNameEngValueFunc),
              SizedBox(height: 10.0,),
              buildEnabledTextInput(lastNameEngController, 'Last NameEng', setLastNameEngValueFunc),
              SizedBox(height: 10.0,),
              buildEnabledTextInput(phoneNumberController, 'Phone Number', setPhoneNumberValueFunc),
              SizedBox(height: 10.0,),
              buildEnabledTextInput(phoneNumberDialCodeController, 'Phone Number Dial', setPhoneNumberDialCodeValueFunc),
              SizedBox(height: 10.0,),
              buildEnabledTextInput(phoneNumberParseController, 'Phone Number Parse', setPhoneNumberParseValueFunc),
              SizedBox(height: 10.0,),
              buildEnabledTextInput(phoneNumberCleanLongFormatController, 'Phone Number Clean Long Format', setPhoneNumberCleanLongFormatValueFunc),
              SizedBox(height: 10.0,),
              buildEnabledTextInput(pictureUrlController, 'Picture Url', setPictureUrlValueFunc),
              SizedBox(height: 10.0,),
              buildEnabledTextInput(cardDescriptionController, 'Card Description', setCardDescriptionValueFunc),
              SizedBox(height: 10.0,),
              buildEnabledTextInput(internetSiteUrlController, 'Internet Site Url', setInternetSiteUrlValueFunc),
              SizedBox(height: 10.0,),
              buildEnabledTextInput(addressController, 'Address', setAddressValueFunc),

              SizedBox(height: 20.0,),

              /// ---------------------- Display Error -----------------------
              Text(
                error,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildEnabledTextInput(TextEditingController aController, String textInputName, Function setValFunc) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60.0,
            child: TextFormField(
              controller: aController,
              style: TextStyle(fontSize: 16.0),
              decoration: myTextInputDecoration.copyWith(hintText: textInputName),
              validator: (val) => val.isEmpty ? 'Enter $textInputName' : null,
              onChanged: (val){
                setState(() {
                  setValFunc(val);
                });
              },
            ),
          ),
        ]
    );
  }

  Column buildDisabledTextInput(TextEditingController aController, String textInputName) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 60.0,
              child: TextFormField(
                controller: aController,
                style: TextStyle(fontSize: 16.0),
                decoration: myDisabledTextInputDecoration.copyWith(hintText: textInputName), // Disabled Field
                enabled: false,
              )
          )
        ]
    );
  }
}
