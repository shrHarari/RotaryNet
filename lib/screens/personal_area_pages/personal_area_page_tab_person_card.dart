import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/person_card_role_and_hierarchy_object.dart';
import 'package:rotary_net/objects/rotary_area_object.dart';
import 'package:rotary_net/objects/rotary_club_object.dart';
import 'package:rotary_net/objects/rotary_cluster_object.dart';
import 'package:rotary_net/objects/rotary_role_object.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/services/rotary_area_service.dart';
import 'package:rotary_net/services/rotary_club_service.dart';
import 'package:rotary_net/services/rotary_cluster_service.dart';
import 'package:rotary_net/services/rotary_role_service.dart';
import 'package:rotary_net/shared/constants.dart';
import 'package:rotary_net/shared/decoration_style.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/utils/utils_class.dart';
import 'package:path/path.dart' as Path;

class PersonalAreaPageTabPersonCard extends StatefulWidget {
  final PersonCardObject argPersonCardObject;
  final String argConnectedUserGuidId;

  PersonalAreaPageTabPersonCard({Key key,
    @required this.argPersonCardObject, @required this.argConnectedUserGuidId}) : super(key: key);

  @override
  _PersonalAreaPageTabPersonCardState createState() => _PersonalAreaPageTabPersonCardState();
}

class _PersonalAreaPageTabPersonCardState extends State<PersonalAreaPageTabPersonCard> {

  final PersonCardService personCardService = PersonCardService();

  final formKey = GlobalKey<FormState>();

  Future<PersonCardRoleAndHierarchyListObject> personCardRoleAndHierarchyListObjectForBuild;
  PersonCardRoleAndHierarchyListObject displayPersonCardRoleAndHierarchyListObject;

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
    setPersonCardVariables(widget.argPersonCardObject);
    personCardRoleAndHierarchyListObjectForBuild = getPersonCardRoleAndHierarchyListForBuild();

    super.initState();
  }

  //#region Get PersonCard Role And Hierarchy List For Build
  Future<PersonCardRoleAndHierarchyListObject> getPersonCardRoleAndHierarchyListForBuild() async {
    setState(() {
      loading = true;
    });

    RotaryRoleService _rotaryRoleService = RotaryRoleService();
    List<RotaryRoleObject> _rotaryRoleObjList = await _rotaryRoleService.getAllRotaryRoleListFromServer();
    setRotaryRoleDropdownMenuItems(_rotaryRoleObjList);

    RotaryAreaService _rotaryAreaService = RotaryAreaService();
    List<RotaryAreaObject> _rotaryAreaObjList = await _rotaryAreaService.getAllRotaryAreaListFromServer();
    setRotaryAreaDropdownMenuItems(_rotaryAreaObjList);

    RotaryClusterService _rotaryClusterService = RotaryClusterService();
    List<RotaryClusterObject> _rotaryClusterObjList = await _rotaryClusterService.getAllRotaryClusterListFromServer();
    setRotaryClusterDropdownMenuItems(_rotaryClusterObjList);

    RotaryClubService _rotaryClubService = RotaryClubService();
    List<RotaryClubObject> _rotaryClubObjList = await _rotaryClubService.getAllRotaryClubListFromServer();
    setRotaryClubDropdownMenuItems(_rotaryClubObjList);

    setState(() {
      loading = false;
    });

    return PersonCardRoleAndHierarchyListObject(
      rotaryRoleObjectList: _rotaryRoleObjList,
      rotaryAreaObjectList: _rotaryAreaObjList,
      rotaryClusterObjectList: _rotaryClusterObjList,
      rotaryClubObjectList: _rotaryClubObjList,
    );
  }
  //#endregion

  //#region All DropDown UI Objects

  //#region RotaryRole DropDown
  List<DropdownMenuItem<RotaryRoleObject>> dropdownRotaryRoleItems;
  RotaryRoleObject selectedRotaryRoleObj;

  void setRotaryRoleDropdownMenuItems(List<RotaryRoleObject> aRotaryRoleObjectsList) {
    List<DropdownMenuItem<RotaryRoleObject>> _rotaryRoleDropDownItems = List();
    for (RotaryRoleObject _rotaryRoleObj in aRotaryRoleObjectsList) {
      _rotaryRoleDropDownItems.add(
        DropdownMenuItem(
          child: SizedBox(
            width: 100.0,
            child: Text(
              _rotaryRoleObj.roleName,
              textAlign: TextAlign.right,
            ),
          ),
          value: _rotaryRoleObj,
        ),
      );
    }
    dropdownRotaryRoleItems = _rotaryRoleDropDownItems;

    // Find the RoleObject Element in a RoleList By roleId ===>>> Set DropDown Initial Value
    int _initialListIndex;
    if (widget.argPersonCardObject.roleId != null) {
      _initialListIndex = aRotaryRoleObjectsList.indexWhere((listElement) => listElement.roleId == widget.argPersonCardObject.roleId.value);
      selectedRotaryRoleObj = dropdownRotaryRoleItems[_initialListIndex].value;
    } else {
      _initialListIndex = null;
      selectedRotaryRoleObj = null;
    }
  }

  onChangeDropdownRotaryRoleItem(RotaryRoleObject aSelectedRotaryRoleObject) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      selectedRotaryRoleObj = aSelectedRotaryRoleObject;
    });
  }
  //#endregion

  //#region RotaryArea DropDown
  List<DropdownMenuItem<RotaryAreaObject>> dropdownRotaryAreaItems;
  RotaryAreaObject selectedRotaryAreaObj;

  void setRotaryAreaDropdownMenuItems(List<RotaryAreaObject> aRotaryAreaObjectsList) {
    List<DropdownMenuItem<RotaryAreaObject>> _rotaryAreaDropDownItems = List();
    for (RotaryAreaObject _rotaryAreaObj in aRotaryAreaObjectsList) {
      _rotaryAreaDropDownItems.add(
        DropdownMenuItem(
          child: SizedBox(
            width: 100.0,
            child: Text(
              _rotaryAreaObj.areaName,
              textAlign: TextAlign.right,
            ),
          ),
          value: _rotaryAreaObj,
        ),
      );
    }
    dropdownRotaryAreaItems = _rotaryAreaDropDownItems;
    filterRotaryAreaDropdownMenuItems(widget.argPersonCardObject.areaId);
  }

  void filterRotaryAreaDropdownMenuItems(int aAreaId) {
    // Filter list & Find the ClusterObject Element in a ClusterList By clusterId ===>>> Set DropDown Initial Value
    int _initialListIndex;

    // Find the RoleObject Element in a RoleList By roleId ===>>> Set DropDown Initial Value
    if (aAreaId != null) {
      _initialListIndex = dropdownRotaryAreaItems.indexWhere((listElement) =>
      (listElement.value.areaId == aAreaId));

      selectedRotaryAreaObj = dropdownRotaryAreaItems[_initialListIndex].value;
    } else {
      _initialListIndex = null;
      selectedRotaryAreaObj = null;
    }
  }

  onChangeDropdownRotaryAreaItem(RotaryAreaObject aSelectedRotaryAreaObject) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      selectedRotaryAreaObj = aSelectedRotaryAreaObject;
      filterRotaryClusterDropdownMenuItems(selectedRotaryAreaObj.areaId, null);
      filterRotaryClubDropdownMenuItems(selectedRotaryAreaObj.areaId, null, null);
    });
  }
  //#endregion

  //#region RotaryCluster DropDown
  List<DropdownMenuItem<RotaryClusterObject>> dropdownRotaryClusterItems;
  List<DropdownMenuItem<RotaryClusterObject>> dropdownRotaryClusterFilteredItems;
  RotaryClusterObject selectedRotaryClusterObj;

  void setRotaryClusterDropdownMenuItems(List<RotaryClusterObject> aRotaryClusterObjectsList) {
    List<DropdownMenuItem<RotaryClusterObject>> _rotaryClusterDropDownItems = List();
    for (RotaryClusterObject _rotaryClusterObj in aRotaryClusterObjectsList) {
      _rotaryClusterDropDownItems.add(
        DropdownMenuItem(
          child: SizedBox(
            width: 100.0,
            child: Text(
              _rotaryClusterObj.clusterName,
              textAlign: TextAlign.right,
            ),
          ),
          value: _rotaryClusterObj,
        ),
      );
    }
    dropdownRotaryClusterItems = _rotaryClusterDropDownItems;
    filterRotaryClusterDropdownMenuItems(
        widget.argPersonCardObject.areaId,
        widget.argPersonCardObject.clusterId);
  }

  void filterRotaryClusterDropdownMenuItems(int aAreaId, int aClusterId) {
    // Filter list & Find the ClusterObject Element in a ClusterList By clusterId ===>>> Set DropDown Initial Value
    int _initialListIndex;
    dropdownRotaryClusterFilteredItems = dropdownRotaryClusterItems.where((item) =>
    (item.value.areaId == selectedRotaryAreaObj.areaId)).toList();

    if (aClusterId != null) {
      _initialListIndex = dropdownRotaryClusterFilteredItems.indexWhere((listElement) =>
      (listElement.value.areaId == aAreaId) &&
          (listElement.value.clusterId == aClusterId));
      selectedRotaryClusterObj = dropdownRotaryClusterFilteredItems[_initialListIndex].value;
    } else {
      _initialListIndex = null;
      selectedRotaryClusterObj = null;
    }
  }

  onChangeDropdownRotaryClusterItem(RotaryClusterObject aSelectedRotaryClusterObject) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      selectedRotaryClusterObj = aSelectedRotaryClusterObject;
      filterRotaryClubDropdownMenuItems(selectedRotaryAreaObj.areaId, selectedRotaryClusterObj.clusterId, null);
    });
  }
  //#endregion

  //#region RotaryClub DropDown
  List<DropdownMenuItem<RotaryClubObject>> dropdownRotaryClubItems;
  List<DropdownMenuItem<RotaryClubObject>> dropdownRotaryClubFilteredItems;
  RotaryClubObject selectedRotaryClubObj;

  void setRotaryClubDropdownMenuItems(List<RotaryClubObject> aRotaryClubObjectsList) {
    List<DropdownMenuItem<RotaryClubObject>> _rotaryClubDropDownItems = List();
    for (RotaryClubObject _rotaryClubObj in aRotaryClubObjectsList) {
      _rotaryClubDropDownItems.add(
        DropdownMenuItem(
          child: SizedBox(
            width: 100.0,
            child: Text(
              _rotaryClubObj.clubName,
              textAlign: TextAlign.right,
            ),
          ),
          value: _rotaryClubObj,
        ),
      );
    }
    dropdownRotaryClubItems = _rotaryClubDropDownItems;
    filterRotaryClubDropdownMenuItems(
        widget.argPersonCardObject.areaId,
        widget.argPersonCardObject.clusterId,
        widget.argPersonCardObject.clubId);
  }

  void filterRotaryClubDropdownMenuItems(int aAreaId, int aClusterId, int aClubId) {
    // Filter list & Find the ClubObject Element in a ClubList By clubId ===>>> Set DropDown Initial Value
    int _initialListIndex;
    if (aClusterId != null) {
      dropdownRotaryClubFilteredItems = dropdownRotaryClubItems.where((item) =>
      (item.value.areaId == selectedRotaryAreaObj.areaId) &&
          (item.value.clusterId == selectedRotaryClusterObj.clusterId)).toList();

      if (aClubId != null) {
        _initialListIndex = dropdownRotaryClubFilteredItems.indexWhere((listElement) =>
        (listElement.value.areaId == aAreaId) &&
            (listElement.value.clusterId == aClusterId) &&
            (listElement.value.clubId == aClubId));
        selectedRotaryClubObj = dropdownRotaryClubFilteredItems[_initialListIndex].value;
      } else {
        _initialListIndex = null;
        selectedRotaryClubObj = null;
      }
    } else {
      _initialListIndex = null;
      dropdownRotaryClubFilteredItems = [];
      selectedRotaryClubObj = null;
    }
  }

  onChangeDropdownRotaryClubItem(RotaryClubObject aSelectedRotaryClubObject) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      selectedRotaryClubObj = aSelectedRotaryClubObject;
    });
  }
  //#endregion

  //#endregion

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
      RotaryRolesEnum _rotaryRolesEnum;
      PersonCardObject newPersonCardObj =
          personCardService.createPersonCardAsObject(
              widget.argConnectedUserGuidId,
              _email, _firstName, _lastName, _firstNameEng, _lastNameEng,
              _phoneNumber, _phoneNumberDialCode, _phoneNumberParse, _phoneNumberCleanLongFormat,
              _pictureUrl, _cardDescription, _internetSiteUrl, _address,
              _rotaryRolesEnum.convertToEnum(selectedRotaryRoleObj.roleId),
              selectedRotaryAreaObj.areaId, selectedRotaryClusterObj.clusterId, selectedRotaryClubObj.clubId);

      int returnVal;
      if (isPersonCardExist)
        returnVal = await personCardService.updatePersonCardByGuidIdToDataBase(newPersonCardObj);
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

  //#region Pick Image File
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
    return loading ? Loading() :
      FutureBuilder<PersonCardRoleAndHierarchyListObject>(
        future: personCardRoleAndHierarchyListObjectForBuild,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Loading();
          else
          if (snapshot.hasError) {
            return RotaryErrorMessageScreen(
              errTitle: 'שגיאה בשליפת נתונים',
              errMsg: 'אנא פנה למנהל המערכת',
            );
          } else {
            if (snapshot.hasData)
            {
              displayPersonCardRoleAndHierarchyListObject = snapshot.data;
              return buildMainBody();
            }
            else
              return Center(child: Text('אין תוצאות'));
          }
        }
      );
  }

  Widget buildMainBody() {
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

                    buildDropDownRoleAndHierarchy(),
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

  //region PersonCard Image
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
  //#endregion

  //#region INPUT FIELDS

  //#region buildEnabledTextInputWithImageIcon
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
                child: buildTextFormField(aController, textInputName,
                          aMultiLine: aMultiLine,aEnabled: aEnabled, aValidation: aValidation),
              ),
            ),
          ]
      ),
    );
  }
  //#endregion

  //#region buildEnabledDoubleTextInputWithImageIcon
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
  //#endregion

  //#region buildImageIconForTextField
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
  //#endregion

  //region buildTextFormField
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
  //#endregion

  //#endregion

  //#region DROP DOWN Section

  //#region buildDropDownRoleAndHierarchy
  Widget buildDropDownRoleAndHierarchy() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(width: 0.0, height: 0.0),
                ),
                Expanded(
                  flex: 6,
                  child: buildRotaryRoleDropDownButton(),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  flex: 6,
                  child: buildRotaryAreaDropDownButton(),
                ),
              ],
            ),
          ),

          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                flex: 3,
                child: Container(width: 0.0, height: 0.0),
              ),
              Expanded(
                flex: 6,
                child: buildRotaryClusterDropDownButton(),
              ),
              SizedBox(width: 10.0,),
              Expanded(
                flex: 6,
                child: buildRotaryClubDropDownButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }
  //#endregion

  //#region Build Rotary Role DropDown Button
  Widget buildRotaryRoleDropDownButton() {
    return  Container(
      height: 45.0,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: DropdownButtonFormField(
        value: selectedRotaryRoleObj,
        items: dropdownRotaryRoleItems,
        onChanged: onChangeDropdownRotaryRoleItem,
        decoration: InputDecoration.collapsed(hintText: ''),
        hint: Text('בחר תפקיד'),
        validator: (value) => value == null ? 'בחר תפקיד' : null,
        // underline: SizedBox(),
      ),
    );
  }
  //#endregion

  //#region Build Rotary Area DropDown Button
  Widget buildRotaryAreaDropDownButton() {
    return  Container(
      height: 45.0,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: DropdownButtonFormField(
        value: selectedRotaryAreaObj,
        items: dropdownRotaryAreaItems,
        onChanged: onChangeDropdownRotaryAreaItem,
        decoration: InputDecoration.collapsed(hintText: ''),
        hint: Text('בחר אזור'),
        validator: (value) => value == null ? 'בחר אזור' : null,
        // underline: SizedBox(),
        // iconSize: 30,
      ),
    );
  }
  //#endregion

  //#region Build Rotary Cluster DropDown Button
  Widget buildRotaryClusterDropDownButton() {
    return Container(
      height: 45.0,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: DropdownButtonFormField(
        value: selectedRotaryClusterObj,
        items: dropdownRotaryClusterFilteredItems,
        onChanged: onChangeDropdownRotaryClusterItem,
        decoration: InputDecoration.collapsed(hintText: ''),
        hint: Text('בחר אשכול'),
        validator: (value) => value == null ? 'בחר אשכול' : null,
        // underline: SizedBox(),
      ),
    );
  }
  //#endregion

  //#region Build Rotary Club DropDown Button
  Widget buildRotaryClubDropDownButton() {
    return Container(
      height: 45.0,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: DropdownButtonFormField(
        value: selectedRotaryClubObj,
        items: dropdownRotaryClubFilteredItems,
        onChanged: onChangeDropdownRotaryClubItem,
        decoration: InputDecoration.collapsed(hintText: ''),
        hint: Text('בחר מועדון'),
        validator: (value) => value == null ? 'בחר מועדון' : null,
        // underline: SizedBox(),
      ),
    );
  }
  //#endregion

  //#endregion

  //#region UPDATE Button
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
  //#endregion
}
