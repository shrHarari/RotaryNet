import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/decoration_style.dart';
import 'package:rotary_net/utils/utils_class.dart';
import 'package:path/path.dart' as Path;

class BuildPersonalAreaPageTabPersonCard extends StatefulWidget {
  final PersonCardObject argPersonCard;
  final String argConnectedUserGuidId;

  BuildPersonalAreaPageTabPersonCard({Key key,
    @required this.argPersonCard, @required this.argConnectedUserGuidId}) : super(key: key);

  @override
  _BuildPersonalAreaPageTabPersonCardState createState() => _BuildPersonalAreaPageTabPersonCardState();
}

class _BuildPersonalAreaPageTabPersonCardState extends State<BuildPersonalAreaPageTabPersonCard> {

  final PersonCardService personCardService = PersonCardService();
  final formKey = GlobalKey<FormState>();

  //#region Declare Variables
  String currentPersonCardImage;
  bool isPersonCardExist = false;

  TextEditingController eMailController;
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController firstNameEngController;
  TextEditingController lastNameEngController;
  TextEditingController phoneNumberController;
  TextEditingController phoneNumberDialCodeController;
  TextEditingController phoneNumberParseController;
  TextEditingController phoneNumberCleanLongFormatController;
  TextEditingController cardDescriptionController;
  TextEditingController internetSiteUrlController;
  TextEditingController addressController;

  String error = '';
  bool loading = false;
  bool isPhoneNumberEnteredOK = false;
  String phoneNumberHintText = 'Phone Number';
  //#endregion

  @override
  void initState() {
    setPersonCardVariables(widget.argPersonCard);
    super.initState();
  }

  //#region Set PersonCard Variables
  Future<void> setPersonCardVariables(PersonCardObject aPersonCard) async {
    if (aPersonCard != null)
    {
      isPersonCardExist = true;   /// If Exist ? Update(has Guid) : Insert(copy Guid)

      currentPersonCardImage = aPersonCard.pictureUrl;

      eMailController = TextEditingController(text: aPersonCard.email);
      firstNameController = TextEditingController(text: aPersonCard.firstName);
      lastNameController = TextEditingController(text: aPersonCard.lastName);
      firstNameEngController = TextEditingController(text: aPersonCard.firstNameEng);
      lastNameEngController = TextEditingController(text: aPersonCard.lastNameEng);
      phoneNumberController = TextEditingController(text: aPersonCard.phoneNumber);
      phoneNumberDialCodeController =  TextEditingController(text: aPersonCard.phoneNumberDialCode);
      phoneNumberParseController = TextEditingController(text: aPersonCard.phoneNumberParse);
      phoneNumberCleanLongFormatController = TextEditingController(text: aPersonCard.phoneNumberCleanLongFormat);
      cardDescriptionController = TextEditingController(text: aPersonCard.cardDescription);
      internetSiteUrlController = TextEditingController(text: aPersonCard.internetSiteUrl);
      addressController = TextEditingController(text: aPersonCard.address);
    } else {
      isPersonCardExist = false;

      eMailController = TextEditingController(text: '');
      firstNameController = TextEditingController(text: '');
      lastNameController = TextEditingController(text: '');
      firstNameEngController = TextEditingController(text: '');
      lastNameEngController = TextEditingController(text: '');
      phoneNumberController = TextEditingController(text: '');
      phoneNumberDialCodeController =  TextEditingController(text: '');
      phoneNumberParseController = TextEditingController(text: '');
      phoneNumberCleanLongFormatController = TextEditingController(text: '');
      cardDescriptionController = TextEditingController(text: '');
      internetSiteUrlController = TextEditingController(text: '');
      addressController = TextEditingController(text: '');
    }
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
      validationVal = false;
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
      String _cardDescription = (cardDescriptionController.text != null) ? (cardDescriptionController.text) : '';
      String _internetSiteUrl = (internetSiteUrlController.text != null) ? (internetSiteUrlController.text) : '';
      String _address = (addressController.text != null) ? (addressController.text) : '';

      String _pictureUrl = '';
      if (currentPersonCardImage != null)
        _pictureUrl = currentPersonCardImage;

      /// If Exist ? Update(has Guid) : Insert(copy Connected User Guid)
      PersonCardObject newPersonCardObj =
          personCardService.createPersonCardAsObject(
              widget.argConnectedUserGuidId,
              _email, _firstName, _lastName, _firstNameEng, _lastNameEng,
              _phoneNumber, _phoneNumberDialCode, _phoneNumberParse, _phoneNumberCleanLongFormat,
              _pictureUrl, _cardDescription, _internetSiteUrl, _address);

      int returnVal;
      if (isPersonCardExist)
        returnVal = await personCardService.updatePersonCardToDataBase(newPersonCardObj);
      else
        returnVal = await personCardService.insertPersonCardToDataBase(newPersonCardObj);

      if (returnVal > 0) {
        Navigator.pop(context);
      } else {
        setState(() {
          error = 'עדכון נתוני הכרטיס נכשל, נסה שנית';
        });
      }
    }
  }
  //#endregion

  //#region pickImageFile
  Future <void> pickImageFile() async {

    ImagePicker imagePicker = ImagePicker();
    PickedFile _compressedImage = await imagePicker.getImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 800
    );
    if (_compressedImage != null)
    {
      if ((currentPersonCardImage != null) && (currentPersonCardImage != ''))
      {
        File originalImageFile = File(currentPersonCardImage);
        originalImageFile.delete();
      }

      File _pickedPictureFile = File(_compressedImage.path);
      String _newPersonCardImagesDirectory = await Utils.createDirectoryInAppDocDir('assets/images/person_card_images');
      String _newImageFileName =  Path.basename(_pickedPictureFile.path);

      String _copyFilePath = '$_newPersonCardImagesDirectory/$_newImageFileName';

      // copy the file to a new path
      await _pickedPictureFile.copy(_copyFilePath).then((File _newImageFile) {
        if (_newImageFile != null) {

          setState(() {
            currentPersonCardImage = _newImageFile.path;
          });
        }
      });
    }
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.only(left: 30, top: 30.0, right: 10.0, bottom: 0.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    /// ------------------- Input Text Fields ----------------------
                    buildPersonCardImage(),
                    buildEnabledDoubleTextInputWithImageIcon(
                        firstNameController, 'שם פרטי',
                        lastNameController, 'שם משפחה',
                        Icons.person, aValidation: true),
                    buildEnabledDoubleTextInputWithImageIcon(
                        firstNameEngController, 'שם פרטי באנגלית',
                        lastNameEngController, 'שם משפחה באנגלית',
                        Icons.person_outline, aValidation: true),
                    buildEnabledTextInputWithImageIcon(eMailController, 'דוא"ל', Icons.mail_outline, aValidation: true),
                    buildEnabledTextInputWithImageIcon(addressController, 'כתובת', Icons.home),
                    buildEnabledTextInputWithImageIcon(phoneNumberController, 'מספר טלפון', Icons.phone, aValidation: true),
                    buildEnabledTextInputWithImageIcon(cardDescriptionController, 'תיאור כרטיס ביקור', Icons.description, aMultiLine: true),
                    buildEnabledTextInputWithImageIcon(internetSiteUrlController, 'כתובת אתר אינטרנט', Icons.alternate_email),
                  ],
                ),
              ),
            ),
          ),
        ),

        buildUpdateImageButton('עדכון', updatePersonCard, Icons.update),

        /// ---------------------- Display Error -----------------------
        Text(
          error,
          style: TextStyle(
              color: Colors.red,
              fontSize: 14.0
          ),
        ),
      ],
    );
  }

  Widget buildPersonCardImage(){
    return InkWell(
      onTap: () async{await pickImageFile();},
      child: (currentPersonCardImage == null) || (currentPersonCardImage == '')
          ? Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: buildInsertSignImageIcon(Icons.person_add)
          )
          : Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.blue[900],
              backgroundImage: FileImage(File(currentPersonCardImage)),
            ),
      ),
    );
  }

  Widget buildInsertSignImageIcon(IconData aIcon, {Function aFunc}) {
    return Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xFFF05A22),
            style: BorderStyle.solid,
            width: 1.0,
          ),
        ),

        child: Center(
          child: Icon(aIcon,
            size: 30.0,
            color: Color(0xFFF05A22),
          ),
        )
    );
  }

  Widget buildEnabledTextInputWithImageIcon(
      TextEditingController aController,
      String textInputName, IconData aIcon,
      {bool aMultiLine = false, bool aEnabled = true, bool aValidation = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
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
                child: buildTextFormField(aController, textInputName, aMultiLine: aMultiLine,aEnabled: aEnabled, aValidation: aValidation),
              ),
            ),
          ]
      ),
    );
  }

  Widget buildEnabledDoubleTextInputWithImageIcon(
      TextEditingController aController1, String textInputName1,
      TextEditingController aController2, String textInputName2,
      IconData aIcon,
      {bool aMultiLine = false, bool aEnabled = true, bool aValidation = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.end,
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
                  child: buildTextFormField(aController1, textInputName1, aMultiLine: aMultiLine, aEnabled: aEnabled, aValidation: aValidation),
                ),
              ),
            ),

            Expanded(
              flex: 6,
              child:
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: buildTextFormField(aController2, textInputName2, aMultiLine: aMultiLine, aEnabled: aEnabled, aValidation: aValidation),
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
      {bool aMultiLine = false, bool aEnabled = true, bool aValidation = false}) {
    return TextFormField(
      keyboardType: aMultiLine
          ? TextInputType.multiline
          : null,
      maxLines: aMultiLine ? null : 1,
      textAlign: TextAlign.right,
      controller: aController,
      style: TextStyle(fontSize: 16.0),
      decoration: aEnabled
          ? TextInputDecoration.copyWith(
              hintText: textInputName,
              hintStyle: TextStyle(fontSize: 14.0)
          )
          : DisabledTextInputDecoration.copyWith(
              hintText: textInputName,
              hintStyle: TextStyle(fontSize: 14.0)
          ), // Disabled Field
      validator: aValidation
          ? (val) => val.isEmpty ? 'הקלד $textInputName' : null
          : null,
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
