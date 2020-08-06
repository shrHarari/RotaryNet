import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/screens/debug_setting_screen.dart';
import 'package:rotary_net/screens/login_state_message_screen.dart';
import 'package:rotary_net/services/login_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/objects/login_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/objects/phone_object.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:rotary_net/services/phone_service.dart';
import 'package:rotary_net/services/registration_service.dart';
import 'package:rotary_net/shared/decoration_style.dart';
import 'package:rotary_net/shared/loading.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = '/RegistrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final RegistrationService registrationService = RegistrationService();
  final UserService userService = UserService();
  final formKey = GlobalKey<FormState>();
  UserObject newUserObj;
  LoginObject newLoginObject;

  String appBarTitle;
  String iconBarTitle;

  /// Fields Param
  TextEditingController eMailController;
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController phoneParseController;

  String newEmail;
  String newFirstName;
  String newLastName;
  String newPhoneNumber;
  String newPhoneNumberParse;

  String error = '';
  bool loading = false;
  bool isPhoneNumberEnteredOK = false;
  String phoneNumberHintText = 'Phone Number';

  @override
  void initState() {
    setAsRegisterState();
    super.initState();
  }

  void setAsRegisterState() {
    appBarTitle = 'Register';
    iconBarTitle = 'Exit';
    eMailController = TextEditingController(text: '');
    firstNameController = TextEditingController(text: '');
    lastNameController = TextEditingController(text: '');
    phoneParseController = TextEditingController(text: '');
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

  Future registerPersonCardFunc() async {
    if (formKey.currentState.validate()){
      setState(() {
        loading = true;
      });

      PhoneObject phoneObjectInstance = new PhoneObject();
      await phoneObjectInstance.setPhoneNumberParse(newPhoneNumber);

      PhoneService phoneService = PhoneService();
      Map mapPhone = await phoneService.getPhoneIdentifiers();

      newUserObj = userService.createUserAsObject(
          '',
          newEmail.trim(),
          newFirstName.trim(),
          newLastName.trim(),
          newPhoneNumber,
          phoneObjectInstance.phoneNumberDialCode,
          phoneObjectInstance.phoneNumberParse,
          phoneObjectInstance.phoneNumberCleanLongFormat);

      newLoginObject = LoginService.createLoginAsObject(Constants.LoginStatusEnum.NoRequest);

      /// Send User Registration Request
      dynamic _userRequestID = await registrationService.sendUserRegistrationRequestToServer(newUserObj);
      if (_userRequestID == null) {
        setState(() {
          error = 'Unable to send Request';
          loading = false;
          phoneParseController = TextEditingController(text: newPhoneNumberParse);
        });
      } else {
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

  @override
  Widget build(BuildContext context) {

    String initialCountry = 'IL';
    PhoneNumber initNumber = PhoneNumber(isoCode: 'IL');

    Widget scaffoldRegistrationBody() {
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
                /// -------------------- Phone Number --------------------------
                Container(
                  height: 80.0,
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      if (isPhoneNumberEnteredOK) {
                        newPhoneNumber = number.phoneNumber;
                        newPhoneNumberParse = number.parseNumber();
                      }
                    },
                    onInputValidated: (bool value) {
                      setState(() {
                        if (value) {
                          isPhoneNumberEnteredOK = true;
                        } else {
                          isPhoneNumberEnteredOK = false;
                        }
                      });
                    },
                    textStyle: TextStyle(color: isPhoneNumberEnteredOK ? Colors.black : Colors.red),
                    isEnabled: true,
                    autoValidate: false,
                    formatInput: true,
                    selectorTextStyle: TextStyle(color: Colors.black),
                    initialValue: initNumber,
                    textFieldController: phoneParseController,
                    inputBorder: OutlineInputBorder(),

                    //initialCountry2LetterCode: 'IL',
                    inputDecoration: myTextInputDecoration.copyWith(hintText: phoneNumberHintText),
                  ),
                ),

                SizedBox(height: 20.0,),
                /// --------------------- Register Button ----------------------
                Visibility(
                  visible: true,
                  child: Container(
                    child: buildActionButton('Register', Colors.pink[400], registerPersonCardFunc),
                  ),
                ),

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

    return loading ? Loading() :
    Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          backgroundColor: Colors.blue[500],
          elevation: 5.0,
          title: Text(appBarTitle),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.open_with, color: Colors.white),
              onPressed: () async {await openDebugSettingsScreen();},
            ),
            FlatButton.icon(
                onPressed: () {
                  exit(0);
                },
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                label: Text(iconBarTitle,
                  style: TextStyle(color: Colors.white),
                )
            )
          ],
        ),

        body: scaffoldRegistrationBody()
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

  Column buildActionButton(String label, Color color, Function func) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            color: color,
            child: Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => func(),
          ),
        ]
    );
  }
}
