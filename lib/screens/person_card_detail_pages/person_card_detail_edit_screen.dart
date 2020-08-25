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
  String updateStatus;

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
    bool validationVal = true;
    isPhoneNumberEnteredOK = true;

    if (formKey.currentState.validate()){
      if (isPhoneNumberEnteredOK) {
        validationVal = true;
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
    print('Validation Val: $validationVal');
    return validationVal;
  }

  Future updatePersonCard() async {
//    bool returnVal = false;
    bool validationVal = await checkValidation();

    if (validationVal){

      String _email = (eMailController.text != null) ? (eMailController.text) : '';
      String _firstName = (firstNameController.text != null) ? (firstNameController.text) : '';
      String _lastName = (lastNameController.text != null) ? (lastNameController.text) : '';
      String _firstNameEng = (firstNameEngController.text != null) ? (firstNameEngController.text) : '';
      String _lastNameEng = (lastNameEngController.text != null) ? (lastNameEngController.text) : '';
      String _phoneNumber = (phoneNumberController.text != null) ? (phoneNumberController.text) : '';
      String _phoneNumberDialCode = (phoneNumberDialCodeController.text != null) ? (phoneNumberDialCodeController.text) : '';
      String _phoneNumberParse = (phoneNumberParseController.text != null) ? (phoneNumberParseController.text) : '';
      String _phoneNumberCleanLongFormat = (phoneNumberCleanLongFormatController.text != null) ? (phoneNumberCleanLongFormatController.text) : '';
      String _pictureUrl = (pictureUrlController.text != null) ? (pictureUrlController.text) : '';
      String _cardDescription = (cardDescriptionController.text != null) ? (cardDescriptionController.text) : '';
      String _internetSiteUrl = (internetSiteUrlController.text != null) ? (internetSiteUrlController.text) : '';
      String _address = (addressController.text != null) ? (addressController.text) : '';

      PersonCardObject newPersonCardObj =
      personCardService.createPersonCardAsObject(
          _email,
          _firstName, _lastName, _firstNameEng, _lastNameEng,
          _phoneNumber, _phoneNumberDialCode, _phoneNumberParse, _phoneNumberCleanLongFormat,
          _pictureUrl, _cardDescription, _internetSiteUrl, _address);

      String updateVal = await personCardService.updatePersonCardObjectDataToDataBase(newPersonCardObj);

      if (int.parse(updateVal) > 0) {
          updateStatus = 'נתוני הכרטיס עודכנו';
          print('Update Status: $updateStatus');

          Navigator.pop(context, newPersonCardObj);
      } else {
        setState(() {
          updateStatus = 'עדכון נתוני הכרטיס נכשל, נסה שנית';
        });
      }
    }
//    return returnVal;
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
              height: 180,
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
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
                width: double.infinity,
                child: buildPersonCardDetailDisplay(),
              ),
            ),
          ]
      ),
    );
  }

  Widget buildPersonCardDetailDisplay() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              /// ------------------- Input Text Fields ----------------------
              buildEnabledTextInputWithImageIcon(eMailController, 'Email', setEmailValueFunc, Icons.mail_outline, false),
              buildEnabledDoubleTextInputWithImageIcon(
                  firstNameController, 'First Name', setFirstNameValueFunc,
                  lastNameController, 'Last Name', setLastNameValueFunc,
                  Icons.person, false),
              buildEnabledDoubleTextInputWithImageIcon(
                  firstNameEngController, 'First Name Eng', setFirstNameEngValueFunc,
                  lastNameEngController, 'Last NameEng', setLastNameEngValueFunc,
                  Icons.person_outline, false),
              buildEnabledTextInputWithImageIcon(addressController, 'Address', setAddressValueFunc, Icons.home, false),
              buildEnabledTextInputWithImageIcon(phoneNumberController, 'Phone Number', setPhoneNumberValueFunc, Icons.phone, false),
              buildEnabledTextInputWithImageIcon(pictureUrlController, 'Picture Url', setPictureUrlValueFunc, Icons.camera_alt, false),
              buildEnabledTextInputWithImageIcon(cardDescriptionController, 'Card Description', setCardDescriptionValueFunc, Icons.description, true),
              buildEnabledTextInputWithImageIcon(internetSiteUrlController, 'Internet Site Url', setInternetSiteUrlValueFunc, Icons.alternate_email, false),
              buildUpdateImageButton('עדכון', updatePersonCard, Icons.update),
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

  Widget buildEnabledTextInputWithImageIcon(TextEditingController aController, String textInputName, Function setValFunc, IconData aIcon, bool aMultiLine) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: buildImageIconForTextField(aIcon),
            ),

            Expanded(
              flex: 12,
              child:
              Container(
                child: buildTextFormFieldEnabled(aController, textInputName, setValFunc, aMultiLine),
              ),
            ),
          ]
      ),
    );
  }

  Widget buildEnabledDoubleTextInputWithImageIcon(
      TextEditingController aController1, String textInputName1, Function setValFunc1,
      TextEditingController aController2, String textInputName2, Function setValFunc2,
      IconData aIcon, bool aMultiLine) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: buildImageIconForTextField(aIcon),
            ),

            Expanded(
              flex: 6,
              child:
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: buildTextFormFieldEnabled(aController1, textInputName1, setValFunc1, aMultiLine),
                ),
              ),
            ),

            Expanded(
              flex: 6,
              child:
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: buildTextFormFieldEnabled(aController2, textInputName2, setValFunc2, aMultiLine),
                ),
              ),
            ),
          ]
      ),
    );
  }

  Widget buildUpdateImageButton(String buttonText, Function aFunc, IconData aIcon) {
    return Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton.icon(
            onPressed: (){ aFunc(); },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
            label: Text(
              buttonText,
              style: TextStyle(
                  color: Colors.white,fontSize: 16.0
              ),
            ),
            icon: Icon(
              aIcon,
              color:Colors.white,
            ),
            textColor: Colors.white,
            splashColor: Colors.red,
            color: Colors.blue[400],
          ),
//          FlatButton.icon(
//            color: Colors.blue[10],
//              icon: Icon(
//                aIcon,
//                size: 20,
//              ),
//              label: Text(
//                buttonText,
//                style: TextStyle(
//                    color: Colors.blue[700],
//                    fontSize: 16.0),
//              ),
//            onPressed: () {aFunc();},
//        ),
        ]
    );
  }

  MaterialButton buildImageIconForTextField(IconData aIcon) {
    return MaterialButton(
      elevation: 0.0,
      onPressed: () {},
      color: Colors.blue[10],
      textColor: Colors.white,
      padding: EdgeInsets.all(10),
      shape: CircleBorder(
          side: BorderSide(color: Colors.blue)
      ),
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
    );
  }

  TextFormField buildTextFormFieldEnabled(TextEditingController aController, String textInputName, Function setValFunc, bool aMultiLine) {
    return TextFormField(
      keyboardType: aMultiLine ? TextInputType.multiline : null,
      maxLines: aMultiLine ? null : 1,
      textAlign: TextAlign.right,
      controller: aController,
      style: TextStyle(fontSize: 16.0),
      decoration: myTextInputDecoration.copyWith(hintText: textInputName),
      validator: (val) => val.isEmpty ? 'Enter $textInputName' : null,
      onChanged: (val){
        setState(() {
          setValFunc(val);
        });
      },
    );
  }

  TextFormField buildTextInputDisabled(TextEditingController aController, String textInputName) {
    return TextFormField(
      controller: aController,
      style: TextStyle(fontSize: 16.0),
      decoration: myDisabledTextInputDecoration.copyWith(hintText: textInputName), // Disabled Field
      enabled: false,
    );
  }
}
