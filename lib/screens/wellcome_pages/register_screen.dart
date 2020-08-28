import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/screens/debug_setting_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/login_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/login_state_message_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/wellcome_decoration_style.dart';
import 'package:rotary_net/services/login_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/objects/login_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:rotary_net/services/registration_service.dart';
import 'package:rotary_net/shared/loading.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/RegisterScreen';
  final ArgDataUserObject argDataObject;

  RegisterScreen({Key key, @required this.argDataObject}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final RegistrationService registrationService = RegistrationService();
  final UserService userService = UserService();
  final formKey = GlobalKey<FormState>();
  UserObject newUserObj;
  LoginObject newLoginObject;

  /// Fields Param
  TextEditingController eMailController;
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController passwordController;

  String newEmail;
  String newFirstName;
  String newLastName;
  String newPassword;
  bool newStayConnected;

  bool registrationConfirmationCheck;
  String error = '';
  bool loading = false;

  @override
  void initState() {
    setAsRegisterState();
    super.initState();
  }

  void setAsRegisterState() {
    newUserObj = widget.argDataObject.passUserObj;
    newLoginObject = widget.argDataObject.passLoginObj;

    eMailController = TextEditingController(text: '');
    firstNameController = TextEditingController(text: '');
    lastNameController = TextEditingController(text: '');
    passwordController = TextEditingController(text: '');
    newStayConnected = false;
    registrationConfirmationCheck = true;
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
  void setPasswordValueFunc(String aPassword){
    newPassword = aPassword;
  }

  Future<bool> checkValidation() async {
    bool _validationVal = false;

    if (formKey.currentState.validate()){
      _validationVal = true;
    } else {
    }
    return _validationVal;
  }

  Future performRegistrationProcess() async {
    if (formKey.currentState.validate()){
      setState(() {
        loading = true;
      });

      newUserObj = userService.createUserAsObject(
          '',
          newEmail.trim(),
          newFirstName.trim(),
          newLastName.trim(),
          newPassword.trim(),
          newStayConnected);

      newLoginObject = LoginService.createLoginAsObject(Constants.LoginStatusEnum.NoRequest);

      /// Send User Registration Request
      dynamic _userRequestID = await registrationService.sendUserRegistrationRequestToServer(newUserObj);
      if (_userRequestID == null) {
        setState(() {
          registrationConfirmationCheck = false;
          error = 'Unable to send Request';
          loading = false;
        });
      } else {
        registrationConfirmationCheck = true;
        /// Update UserObject.RequestId >>> {_userRequestID}
        newUserObj.setRequestId(_userRequestID);
        /// Update LoginObject.loginStatus >>> LoginStatusEnum.Waiting
        newLoginObject.setLoginStatus(Constants.LoginStatusEnum.Waiting);

        /// Write UserObject with new data to SharedPreferences
        await userService.writeUserObjectDataToSharedPreferences(newUserObj);
        /// Write LoginObject with new data to SharedPreferences
        await LoginService.writeLoginObjectDataToSharedPreferences(Constants.LoginStatusEnum.Waiting);

        openLoginStateMessageScreen();
      }
    }
  }

  ///--- If Registration succeeded --->> wait for Approve --->> Open Message Screen
  ///------------------------------------------------------------------------------
  void openLoginStateMessageScreen() {
    /// Create ArgDataObject to pass to MessageTrackerRequest Screen
    ArgDataUserObject argToLoginStateMessageScreen;
    argToLoginStateMessageScreen = ArgDataUserObject(newUserObj, newLoginObject);

    /// Navigate to MessageTrackerRequest Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginStateMessageScreen(argDataObject: argToLoginStateMessageScreen),
      ),
    );
  }

  ///------>> Open Debug Settings Screen
  ///------------------------------------------------------------------------------
  Future<void> openDebugSettingsScreen() async {
    /// Create ArgDataObject to pass to DebugSettings Screen
    ArgDataUserObject argToDebugSettingsScreen;
    argToDebugSettingsScreen = ArgDataUserObject(newUserObj, newLoginObject);

    /// Navigate to DebugSettings Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DebugSettings(argDataObject: argToDebugSettingsScreen),
      ),
    );
  }

  /// ============================== Main Screen ==============================
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return loading ? Loading() :
    Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .1),
                    rotaryTitle(context),
                    SizedBox(height: 30,),
                    emailPasswordWidget(),
                    buildStayConnectedCheckBox(),
                    SizedBox(height: 20,),
                    buildActionButton('הירשם כעת', performRegistrationProcess),
                    buildRegistrationFailedErrorMessage('שגיאה ברישום, נסה שוב...', registrationConfirmationCheck),
                    SizedBox(height: height * .05),
                    createAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 20, child: openDebugButton()),
            Positioned(top: 40, right: 20, child: exitButton()),
          ],
        ),
      ),
    );
  }

  ///------>> Build All Page Widgets
  ///==============================================================================
  Widget openDebugButton() {
    return InkWell(
      onTap: () async{await openDebugSettingsScreen();},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.build, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget exitButton() {
    return InkWell(
      onTap: () {exit(0);},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.exit_to_app, color: Colors.black),
            ),
            Text('יציאה',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget emailPasswordWidget() {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          buildEnabledTextEditField(eMailController, 'דוא"ל', TextDirection.ltr, setEmailValueFunc),
          buildEnabledTextEditField(firstNameController, 'שם פרטי', TextDirection.rtl, setFirstNameValueFunc),
          buildEnabledTextEditField(lastNameController, 'שם משפחה', TextDirection.rtl, setLastNameValueFunc),
          buildEnabledTextEditField(passwordController, 'סיסמה', TextDirection.ltr, setPasswordValueFunc, isPassword: true),
        ],
      ),
    );
  }

  Widget buildEnabledTextEditField(TextEditingController aController, String title, TextDirection aTextDirection, Function setValFunc, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),
          ),
          SizedBox(height: 10,),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              controller: aController,
              textDirection: aTextDirection,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true
              ),
              validator: (val) => val.isEmpty ? 'חובה להקליד $title' : null,
              onChanged: (val){
                setState(() {
                  setValFunc(val);
                });
              },
            ),
          )
        ],
      ),
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
        padding: const EdgeInsets.only(top: 5.0),
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  ///------>> Build ActionButton: SignUp [הירשם כעת]
  ///------------------------------------------------------------------------------
  Widget buildActionButton(String label, Function aButtonFunc) {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: actionButtonBoxDecoration(),
        child: Text(
          label,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      onTap: () => aButtonFunc(),
    );
  }

  Widget buildRegistrationFailedErrorMessage(String errorMessage, bool aLoginConfirmationCheck) {
    return aLoginConfirmationCheck ? Container() :
    Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Text(
          errorMessage,
          style: TextStyle(
              color: Colors.red,
              fontSize: 15
          ),
        ),
      ),
    );
  }

  Widget createAccountLabel() {
    return InkWell(
      onTap: () {
        /// Create ArgDataObject to pass to DebugSettings Screen
        ArgDataUserObject argToLoginScreen;
        argToLoginScreen = ArgDataUserObject(newUserObj, newLoginObject);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen(argDataObject: argToLoginScreen)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(5),
        alignment: Alignment.bottomCenter,
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '? חשבון לקוח קיים',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 10,),
            Text(
              'התחברות',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}