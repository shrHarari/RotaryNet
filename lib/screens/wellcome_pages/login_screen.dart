import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/objects/login_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/screens/debug_setting_screen.dart';
import 'package:rotary_net/screens/rotary_main_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/register_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/wellcome_decoration_style.dart';
import 'package:rotary_net/services/registration_service.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  final ArgDataUserObject argDataObject;

  LoginScreen({Key key, @required this.argDataObject}) : super(key: key);


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final RegistrationService registrationService = RegistrationService();
  final UserService userService = UserService();
  final formKey = GlobalKey<FormState>();
  UserObject newUserObj;
  LoginObject newLoginObject;

  /// Fields Param
  TextEditingController eMailController;
  TextEditingController passwordController;

  String newEmail;
  String newPassword;
  Constants.UserTypeEnum newUserType;
  bool newStayConnected;

  bool loginConfirmationCheck;
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
    passwordController = TextEditingController(text: '');
    newUserType = newUserObj.userType;
    newStayConnected = false;
    loginConfirmationCheck = true;
  }

  void setEmailValueFunc(String aEmail){
    newEmail = aEmail;
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

  Future performLoginProcess() async {
    if (formKey.currentState.validate()){
      setState(() {
        loading = true;
      });

      newUserObj = userService.createUserAsObject(
          '',
          newEmail.trim(),
          '',
          '',
          newPassword.trim(),
          newUserType,
          newStayConnected);

      /// Send User Login Request ===>>> Check if Login Parameters are OK
      UserObject currentUserObj = await registrationService.userLoginConfirmAtServer(newUserObj);
      if (currentUserObj == null) {
        setState(() {
          loginConfirmationCheck = false;
          error = 'Unable to check confirmation';
          loading = false;
        });
      } else {
        if (int.parse(currentUserObj.requestId) < 0) {
          setState(() {
            loginConfirmationCheck = false;
            loading = false;
          });
        } else {
          setState(() {
            loginConfirmationCheck = true;
            loading = false;
          });
          /// Update UserObject.StayConnected
          currentUserObj.setStayConnected(newStayConnected);

          /// Write UserObject with new data [StayConnected] to SharedPreferences
          await userService.writeUserObjectDataToSharedPreferences(currentUserObj);

          openRotaryMainScreen(currentUserObj);
        }
      }
    }
  }

  ///--- If Login succeeded --->> Open Rotary Main Screen
  ///------------------------------------------------------------------------------
  void openRotaryMainScreen(UserObject aUserObj) {
    /// Create ArgDataObject to pass to MessageTrackerRequest Screen
    ArgDataUserObject argToMainScreen;
    argToMainScreen = ArgDataUserObject(aUserObj, newLoginObject);

    /// Navigate to MessageTrackerRequest Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RotaryMainScreen(argDataObject: argToMainScreen),
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
    return Scaffold(
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
                      SizedBox(height: 30),
                      emailPasswordWidget(),
                      buildStayConnectedCheckBox(),
                      SizedBox(height: 20,),
                      buildActionButton('התחבר', performLoginProcess),
                      buildLoginFailedErrorMessage('שגיאה בנתונים, נסה שוב...', loginConfirmationCheck),
                      buildForgotPasswordLabel(),
                      divider(),
                      facebookButton(),
                      SizedBox(height: height * .055),
                      createAccountLabel(),
                    ],
                  ),
                ),
              ),
              Positioned(top: 40, left: 20, child: openDebugButton()),
              Positioned(top: 40, right: 20, child: exitButton()),
            ],
          ),
        ));
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

  Widget buildForgotPasswordLabel() {
    return InkWell(
      onTap: () {
        setState(() {
        });
      },
      child:
      Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.centerRight,
        child: Text('? שכחת סיסמה',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500
            )
        ),
      ),
    );
  }

  ///------>> Build ActionButton: Login [התחבר]
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

  Widget buildLoginFailedErrorMessage(String errorMessage, bool aLoginConfirmationCheck) {
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

  Widget divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(width: 20,),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('או'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('f',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('התחבר עם פייסבוק',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget createAccountLabel() {
    return InkWell(
      onTap: () {
        /// Create ArgDataObject to pass to DebugSettings Screen
        ArgDataUserObject argToRegisterScreen;
        argToRegisterScreen = ArgDataUserObject(newUserObj, newLoginObject);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RegisterScreen(argDataObject: argToRegisterScreen)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '? חשבון לקוח לא קיים',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 10,),
            Text(
              'רישום',
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
