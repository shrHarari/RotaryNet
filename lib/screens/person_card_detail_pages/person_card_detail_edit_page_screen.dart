import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/decoration_style.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class PersonCardDetailEditPageScreen extends StatefulWidget {
  static const routeName = '/PersonCardDetailEditScreen';
  final ArgDataPersonCardObject argDataObject;

  PersonCardDetailEditPageScreen({Key key, @required this.argDataObject}) : super(key: key);

  @override
  _PersonCardDetailEditPageScreenState createState() => _PersonCardDetailEditPageScreenState();
}

class _PersonCardDetailEditPageScreenState extends State<PersonCardDetailEditPageScreen> {

  final PersonCardService personCardService = PersonCardService();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setPersonCardVariables(widget.argDataObject.passPersonCardObj);
    super.initState();
  }

  //#region Declare Variables
  String emailId;
  String pictureFileName;
  AssetImage personCardImage;
  File picFile;

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

  String error = '';
  bool loading = false;
  bool isPhoneNumberEnteredOK = false;
  String phoneNumberHintText = 'Phone Number';
  String updateStatus;
  //#endregion

  //#region Set PersonCard Variables
  Future<void> setPersonCardVariables(PersonCardObject aPersonCard) async {
    emailId = aPersonCard.emailId;
    pictureFileName = aPersonCard.pictureUrl;
    personCardImage = AssetImage('assets/images/person_cards/$pictureFileName');

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

      print ('firstNameController.text: ${firstNameController.text}');

      PersonCardObject newPersonCardObj =
      personCardService.createPersonCardAsObject(
          emailId, _email,
          _firstName, _lastName, _firstNameEng, _lastNameEng,
          _phoneNumber, _phoneNumberDialCode, _phoneNumberParse, _phoneNumberCleanLongFormat,
          pictureFileName, _cardDescription, _internetSiteUrl, _address);

      String updateVal = await personCardService.updatePersonCardObjectDataToDataBase(newPersonCardObj);

      if (int.parse(updateVal) > 0) {
          updateStatus = 'נתוני הכרטיס עודכנו';

          Navigator.pop(context, newPersonCardObj);
      } else {
        setState(() {
          updateStatus = 'עדכון נתוני הכרטיס נכשל, נסה שנית';
        });
      }
    }
//    return returnVal;
  }
  //#endregion

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  Future <void> pickImageFile() async {
//    File _pictureFile = await FilePicker.getFile(type: FileType.image);
//    setState(() {
//      picFile = _pictureFile;
//      pictureFileName = _pictureFile.path;
//      pictureUrlController.text = pictureFileName;
//    });

    ImagePicker imagePicker = ImagePicker();
    PickedFile _compressedImage = await imagePicker.getImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 800
    );
    File _pictureFile = File(_compressedImage.path);

    setState(() {
      picFile = _pictureFile;
      pictureFileName = _pictureFile.path;
      pictureUrlController.text = pictureFileName;
    });

//    await _pictureFile.delete();
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
      // width: double.infinity,
      child: Column(
          children: <Widget>[
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
                      children: <Widget>[
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
              child: buildPersonCardDetailDisplay(),
            ),
          ]
      ),
    );
  }

  /// ====================== Event All Fields ==========================
  Widget buildPersonCardDetailDisplay() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
        width: double.infinity,
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              /// ------------------- Input Text Fields ----------------------
              buildPersonCardImage(personCardImage),
              buildEnabledDoubleTextInputWithImageIcon(
                  firstNameController, 'First Name',
                  lastNameController, 'Last Name',
                  Icons.person, false),
              buildEnabledDoubleTextInputWithImageIcon(
                  firstNameEngController, 'First Name Eng',
                  lastNameEngController, 'Last NameEng',
                  Icons.person_outline, false),
              buildEnabledTextInputWithImageIcon(eMailController, 'Email', Icons.mail_outline, false),
              buildEnabledTextInputWithImageIcon(addressController, 'Address', Icons.home, false),
              buildEnabledTextInputWithImageIcon(phoneNumberController, 'Phone Number', Icons.phone, false),
//              buildEnabledTextInputWithImageIcon(pictureUrlController, 'Picture Url', Icons.camera_alt, false),
              buildEnabledTextInputWithImageIcon(cardDescriptionController, 'Card Description', Icons.description, true),
              buildEnabledTextInputWithImageIcon(internetSiteUrlController, 'Internet Site Url', Icons.alternate_email, false),
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

  Widget buildPersonCardImage(AssetImage aPictureAssetImage) {
    return InkWell(
      onTap: () async{await pickImageFile();},
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.blue[900],
          backgroundImage: picFile == null ? aPictureAssetImage : FileImage(picFile),
        )
      ),
    );
  }

  Widget buildEnabledTextInputWithImageIcon(TextEditingController aController, String textInputName, IconData aIcon, bool aMultiLine) {
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
                child: buildTextFormField(aController, textInputName, aMultiLine),
              ),
            ),
          ]
      ),
    );
  }

  Widget buildEnabledDoubleTextInputWithImageIcon(
      TextEditingController aController1, String textInputName1,
      TextEditingController aController2, String textInputName2,
      IconData aIcon, bool aMultiLine) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
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
                  child: buildTextFormField(aController1, textInputName1, aMultiLine),
                ),
              ),
            ),

            Expanded(
              flex: 6,
              child:
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: buildTextFormField(aController2, textInputName2, aMultiLine),
                ),
              ),
            ),
          ]
      ),
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

  TextFormField buildTextFormField(
      TextEditingController aController,
      String textInputName,
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
    );
  }

  Widget buildUpdateImageButton(String buttonText, Function aFunc, IconData aIcon) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: RaisedButton.icon(
        onPressed: () {aFunc(); },
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
        color: Colors.blue[400],
      ),
    );
  }
}
