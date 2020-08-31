import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:rotary_net/shared/decoration_style.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class BuildPersonalAreaPageTabUser extends StatefulWidget {
  final UserObject argUser;

  BuildPersonalAreaPageTabUser({Key key, @required this.argUser}) : super(key: key);

  @override
  _BuildPersonalAreaPageTabUserState createState() => _BuildPersonalAreaPageTabUserState();
}

class _BuildPersonalAreaPageTabUserState extends State<BuildPersonalAreaPageTabUser> {

  final UserService userService = UserService();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setPersonCardVariables(widget.argUser);
    super.initState();
  }

  //#region Declare Variables
  bool newStayConnected;

  TextEditingController eMailIdController;
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController passwordController;

  String error = '';
  bool loading = false;
  String updateStatus;
  //#endregion

  //#region Set PersonCard Variables
  Future<void> setPersonCardVariables(UserObject aUserObj) async {
    eMailIdController = TextEditingController(text: aUserObj.emailId);
    firstNameController = TextEditingController(text: aUserObj.firstName);
    lastNameController = TextEditingController(text: aUserObj.lastName);
    passwordController = TextEditingController(text: aUserObj.password);
    newStayConnected = aUserObj.stayConnected;
  }
  //#endregion

  //#region Check Validation
  Future<bool> checkValidation() async {
    bool validationVal = true;

    if (formKey.currentState.validate()){
    }
    return validationVal;
  }
  //#endregion

  //#region Update User
  Future updateUser() async {
    bool validationVal = await checkValidation();

    if (validationVal){
      String _email = (eMailIdController.text != null) ? (eMailIdController.text) : '';
      String _firstName = (firstNameController.text != null) ? (firstNameController.text) : '';
      String _lastName = (lastNameController.text != null) ? (lastNameController.text) : '';
      String _password = (passwordController.text != null) ? (passwordController.text) : '';

      UserObject newUserObj = userService.createUserAsObject(
          '', _email, _firstName, _lastName, _password, widget.argUser.userType, newStayConnected);

      await userService.writeUserObjectDataToSharedPreferences(newUserObj);
      Navigator.pop(context, newUserObj);
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
                            buildEnabledTextInputWithImageIcon(eMailIdController, 'Email ID', Icons.mail_outline, false, aEnabled: false),
                            buildEnabledDoubleTextInputWithImageIcon(
                                firstNameController, 'First Name',
                                lastNameController, 'Last Name',
                                Icons.person, false),
                            buildEnabledTextInputWithImageIcon(passwordController, 'Password', Icons.lock, false, isPassword: true),
                            buildStayConnectedCheckBox(),
                            buildUserTypeRadioButton(),
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
                    buildUpdateImageButton('עדכון', updateUser, Icons.update),
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

  Widget buildEnabledTextInputWithImageIcon(TextEditingController aController, String textInputName, IconData aIcon, bool aMultiLine, {bool aEnabled = true, bool isPassword = false}) {
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
                child: buildTextFormField(aController, textInputName, aMultiLine, aEnabled: aEnabled, isPassword: isPassword),
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
      bool aMultiLine,
      {bool aEnabled = true, bool isPassword = false}) {
    return TextFormField(
      keyboardType: aMultiLine ? TextInputType.multiline : null,
      maxLines: aMultiLine ? null : 1,
      textAlign: TextAlign.right,
      controller: aController,
      style: TextStyle(fontSize: 16.0),
      enabled: aEnabled ? true : false,
      obscureText: isPassword,
      decoration: aEnabled ?
          TextInputDecoration.copyWith(hintText: textInputName) :
          DisabledTextInputDecoration.copyWith(hintText: textInputName), // Disabled Field
      validator: (val) => val.isEmpty ? 'Enter $textInputName' : null,
    );
  }

  Widget buildStayConnectedCheckBox() {
    return InkWell(
      onTap: () {
        setState(() {
          newStayConnected = !newStayConnected;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    border: Border.all(color: Colors.black, width: 1.0),
                    color: Color(0xfff3f3f4)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: newStayConnected ?
                  Icon(Icons.check, size: 15.0, color: Colors.black,) :
                  Icon(Icons.check_box_outline_blank, size: 15.0, color: Colors.white,),
                ),
              ),
            ),
            Text(
              'הישאר מחובר',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserTypeRadioButton() {
    String userTypeTitle;
    switch (widget.argUser.userType) {
      case Constants.UserTypeEnum.SystemAdmin:
        userTypeTitle = "מנהל מערכת";
        break;
      case Constants.UserTypeEnum.RotaryMember:
        userTypeTitle = "חבר מועדון רוטרי";
        break;
      case Constants.UserTypeEnum.Guest:
        userTypeTitle = "אורח";
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.0),
                  color: Color(0xfff3f3f4)
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Icon(Icons.check, size: 15.0, color: Colors.black,),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'סוג משתמש:',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),

          Text(
            userTypeTitle,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
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
      color: Colors.blue[400],
    );
  }
}
