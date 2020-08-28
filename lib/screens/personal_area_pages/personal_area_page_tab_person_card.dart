import 'package:flutter/material.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/decoration_style.dart';

class BuildPersonalAreaPageTabPersonCard extends StatefulWidget {
  final PersonCardObject argPersonCard;

  BuildPersonalAreaPageTabPersonCard({Key key, @required this.argPersonCard}) : super(key: key);

  @override
  _BuildPersonalAreaPageTabPersonCardState createState() => _BuildPersonalAreaPageTabPersonCardState();
}

class _BuildPersonalAreaPageTabPersonCardState extends State<BuildPersonalAreaPageTabPersonCard> {

  final PersonCardService personCardService = PersonCardService();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setPersonCardVariables(widget.argPersonCard);
    super.initState();
  }

  //#region Declare Variables
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

  String emailId;
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
  //#endregion

  //#region Set PersonCard Variables
  Future<void> setPersonCardVariables(PersonCardObject aPersonCard) async {
    emailId = aPersonCard.emailId;
    eMailController = TextEditingController(text: aPersonCard.email);
    firstNameController = TextEditingController(text: aPersonCard.firstName);
    lastNameController = TextEditingController(text: aPersonCard.lastName);
    firstNameEngController = TextEditingController(text: aPersonCard.firstNameEng);
    lastNameEngController = TextEditingController(text: aPersonCard.lastNameEng);
    phoneNumberController = TextEditingController(text: aPersonCard.phoneNumber);
    phoneNumberDialCodeController = TextEditingController(text: aPersonCard.phoneNumberDialCode);
    phoneNumberParseController = TextEditingController(text: aPersonCard.phoneNumberParse);
    phoneNumberCleanLongFormatController = TextEditingController(text: aPersonCard.phoneNumberCleanLongFormat);
    pictureUrlController = TextEditingController(text: aPersonCard.pictureUrl);
    cardDescriptionController = TextEditingController(text: aPersonCard.cardDescription);
    internetSiteUrlController = TextEditingController(text: aPersonCard.internetSiteUrl);
    addressController = TextEditingController(text: aPersonCard.address);
  }
  //#endregion

  //#region Value Functions
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

  void setCardDescriptionValueFunc(String aCardDescription){
    newCardDescription = aCardDescription;
  }

  void setInternetSiteUrlValueFunc(String aInternetSiteUrl){
    newInternetSiteUrl = aInternetSiteUrl;
  }

  void setAddressValueFunc(String aAddress){
    newAddress = aAddress;
  }
  //#endregion

  //#region Check Validation
  Future<bool> checkValidation() async {
    bool validationVal = true;
    isPhoneNumberEnteredOK = true;        // *** until PhoneNumber will be handled

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
  //#endregion

  //#region Update PersonCard
  Future updatePersonCard() async {
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
          emailId, _email,
          _firstName, _lastName, _firstNameEng, _lastNameEng,
          _phoneNumber, _phoneNumberDialCode, _phoneNumberParse, _phoneNumberCleanLongFormat,
          _pictureUrl, _cardDescription, _internetSiteUrl, _address);

      String updateVal = await personCardService.updatePersonCardObjectDataToDataBase(newPersonCardObj);

      if (int.parse(updateVal) > 0) {
        updateStatus = 'נתוני הכרטיס עודכנו';
        print('Update Status: $updateStatus');

        Navigator.pop(context);
      } else {
        setState(() {
          updateStatus = 'עדכון נתוני הכרטיס נכשל, נסה שנית';
        });
      }
    }
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: IntrinsicHeight(
        child: Column(
        mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 15,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 30, top: 30.0, right: 30.0, bottom: 0.0),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    buildUpdateImageButton('עדכון', updatePersonCard, Icons.update),
                  ],
                ),
              ),
            ),

            /// ---------------------- Display Error -----------------------
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      error,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.0
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
              child: Container(
                  child: buildImageIconForTextField(aIcon)
              ),
            ),

            Expanded(
              flex: 12,
              child:
              Container(
                child: buildTextFormField(aController, textInputName, setValFunc, aMultiLine),
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
          mainAxisAlignment: MainAxisAlignment.end,
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
                  child: buildTextFormField(aController1, textInputName1, setValFunc1, aMultiLine),
                ),
              ),
            ),

            Expanded(
              flex: 6,
              child:
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: buildTextFormField(aController2, textInputName2, setValFunc2, aMultiLine),
                ),
              ),
            ),
          ]
      ),
    );
  }

  MaterialButton buildImageIconForTextField(IconData aIcon) {
    return MaterialButton(
      onPressed: () {},
      padding: EdgeInsets.all(5),
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

  TextFormField buildTextFormField(
      TextEditingController aController,
      String textInputName,
      Function setValFunc,
      bool aMultiLine,
      {bool aEnabled = true}) {
    return TextFormField(
      keyboardType: aMultiLine ? TextInputType.multiline : null,
      maxLines: aMultiLine ? null : 1,
      textAlign: TextAlign.right,
      controller: aController,
      style: TextStyle(fontSize: 16.0),
      decoration: aEnabled ?
      TextInputDecoration.copyWith(hintText: textInputName) :
      DisabledTextInputDecoration.copyWith(hintText: textInputName), // Disabled Field
      validator: (val) => val.isEmpty ? 'Enter $textInputName' : null,
      onChanged: (val){
        setState(() {
          setValFunc(val);
        });
      },
    );
  }

  Widget buildUpdateImageButton(String buttonText, Function aFunc, IconData aIcon) {
    return RaisedButton.icon(
      onPressed: () {aFunc();},
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
    );
  }
}
