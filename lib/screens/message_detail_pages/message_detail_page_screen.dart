import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/message_with_description_object.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/screens/message_detail_pages/message_detail_edit_page_screen.dart';
import 'package:rotary_net/screens/person_card_detail_pages/person_card_detail_page_screen.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/utils/utils_class.dart';

class MessageDetailPageScreen extends StatefulWidget {
  static const routeName = '/MessageDetailPageScreen';
  final MessageWithDescriptionObject argMessageWithDescriptionObject;
  final Widget argHebrewMessageCreatedTimeLabel;

  MessageDetailPageScreen({Key key, @required this.argMessageWithDescriptionObject, this.argHebrewMessageCreatedTimeLabel}) : super(key: key);

  @override
  _MessageDetailPageScreenState createState() => _MessageDetailPageScreenState();
}

class _MessageDetailPageScreenState extends State<MessageDetailPageScreen> {

  MessageWithDescriptionObject displayMessageWithDescriptionObject;
  Widget hebrewMessageCreatedTimeLabel;

  bool allowUpdate = false;
  String error = '';
  bool loading = false;

  @override
  void initState() {
    displayMessageWithDescriptionObject = widget.argMessageWithDescriptionObject;
    hebrewMessageCreatedTimeLabel = widget.argHebrewMessageCreatedTimeLabel;

    allowUpdate = getUpdatePermission();

    super.initState();
  }

  //#region Get Update Permission
  bool getUpdatePermission()  {
    ConnectedUserObject _connectedUserObj = ConnectedUserGlobal.currentConnectedUserObject;
    bool _allowUpdate = false;

    switch (_connectedUserObj.userType) {
      case Constants.UserTypeEnum.SystemAdmin:
        _allowUpdate = true;
        break;
      case  Constants.UserTypeEnum.RotaryMember:
        _allowUpdate = true;
        break;
      case  Constants.UserTypeEnum.Guest:
        _allowUpdate = false;
    }
    return _allowUpdate;
  }
  //#endregion

  //#region Open Message Detail Edit Screen
  openMessageDetailEditScreen(MessageWithDescriptionObject aMessageObj) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetailEditPageScreen(
            argMessageWithDescriptionObject: displayMessageWithDescriptionObject,
            argHebrewMessageCreatedTimeLabel: hebrewMessageCreatedTimeLabel
        ),
      ),
    );

    if (result != null) {
      setState(() {
        displayMessageWithDescriptionObject = result;
      });
    }
  }
  //#endregion

  //#region Get Message Rich Text
  RichText getMessageRichText () {

    return RichText(
      textDirection: TextDirection.rtl,
      text: TextSpan(
        children: [
          TextSpan(
            text: '${displayMessageWithDescriptionObject.messageText} ',
            style: TextStyle(
                fontFamily: 'Heebo-Light',
                fontSize: 20.0,
                height: 1.5,
                color: Colors.black87
            ),
          ),
        ],
      ),
    );
  }
  //#endregion

  //#region Open Composer Person Card Detail Screen
  openComposerPersonCardDetailScreen(String aComposerGuidId) async {

    PersonCardService _personCardService = PersonCardService();
    PersonCardObject _personCardObj = await _personCardService.getPersonalCardByUserGuidIdFromServer(aComposerGuidId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonCardDetailPageScreen(
            argPersonCardObject: _personCardObj
        ),
      ),
    );
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :
    Scaffold(
      backgroundColor: Colors.blue[50],

      body: buildMainScaffoldBody(),
    );
  }

  Widget buildMainScaffoldBody() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          /// --------------- Title Area ---------------------
          Container(
            height: 160,
            color: Colors.lightBlue[400],
            child: SafeArea(
              child: Stack(
                overflow: Overflow.visible,
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      /// Exit Icon --->>> Close Screen
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 10.0, bottom: 0.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.close, color: Colors.white, size: 26.0,),
                            onPressed: () {
                              Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),

                  if (allowUpdate)
                    Positioned(
                      left: 20.0,
                      bottom: -25.0,
                      child: buildEditMessageButton(openMessageDetailEditScreen)
                    ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              child: buildMessageDetailDisplay(displayMessageWithDescriptionObject),
            ),
          ),
        ]
      ),
    );
  }

  /// ====================== Message All Fields ==========================
  Widget buildMessageDetailDisplay(MessageWithDescriptionObject aMessageObj) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          /// ---------------- Message Content ----------------------
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0, bottom: 50.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getMessageRichText(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// --------------- Message Details [Metadata]---------------------
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              // color: Colors.grey[200],
              padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 10.0),

              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border(
                  top: BorderSide(
                    color: Colors.amber,
                    width: 2.0,
                  ),
                ),
              ),

              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    if (aMessageObj.composerFirstName != "") buildComposerDetailName(Icons.person, aMessageObj, openComposerPersonCardDetailScreen),
                    if (aMessageObj.areaName != "") buildComposerDetailAreaClusterClub(Icons.location_on, aMessageObj, Utils.launchInMapByAddress),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
  }

  Widget buildComposerDetailName(IconData aIcon, MessageWithDescriptionObject aMessageObj, Function aFunc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              elevation: 0.0,
              onPressed: () {
                aFunc(aMessageObj.composerGuidId);
                },
              color: Colors.blue[10],
              child:
              IconTheme(
                data: IconThemeData(
                  color: Colors.black,
                ),
                child: Icon(
                  aIcon,
                  size: 20,
                ),
              ),
              padding: EdgeInsets.all(5),
              shape: CircleBorder(side: BorderSide(color: Colors.black)),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                aMessageObj.composerFirstName + ' ' + aMessageObj.composerLastName,
                style: TextStyle(color: Colors.grey[900], fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),

            Text(
              '[${aMessageObj.roleName}]',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0),
            ),
          ]
      ),
    );
  }

  Widget buildComposerDetailAreaClusterClub(IconData aIcon, MessageWithDescriptionObject aMessageObj, Function aFunc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              elevation: 0.0,
              onPressed: () {aFunc(aMessageObj.clubAddress);},
              color: Colors.blue[10],
              child:
              IconTheme(
                data: IconThemeData(
                  color: Colors.black,
                ),
                child: Icon(
                  aIcon,
                  size: 20,
                ),
              ),
              padding: EdgeInsets.all(5),
              shape: CircleBorder(side: BorderSide(color: Colors.black)),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        'מועדון:',
                        style: TextStyle(color: Colors.grey[900], fontSize: 14.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        '${aMessageObj.clubName}',
                        style: TextStyle(color: Colors.grey[900], fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        'אשכול:',
                        style: TextStyle(color: Colors.grey[900], fontSize: 14.0),
                      ),
                    ),

                    Text(
                      '${aMessageObj.areaName} / ${aMessageObj.clusterName}',
                      style: TextStyle(color: Colors.grey[900], fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          await Utils.sendEmail(aMessageObj.clubMail);
                        },
                        child: Text(
                          '${aMessageObj.clubMail}',
                          style: TextStyle(color: Colors.blue,
                              fontSize: 14.0,
                              decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]
      ),
    );
  }

  Widget buildEditMessageButton(Function aFunc) {
    return MaterialButton(
      elevation: 0.0,
      onPressed: () async {
        await aFunc(widget.argMessageWithDescriptionObject);
      },
      color: Colors.white,
      padding: EdgeInsets.all(10),
      shape: CircleBorder(side: BorderSide(color: Colors.blue)),
      child: IconTheme(
        data: IconThemeData(
          color: Colors.black,
        ),
        child: Icon(
          Icons.edit,
          size: 20,
        ),
      ),
    );
  }
}