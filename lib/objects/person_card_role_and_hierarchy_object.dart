import 'package:flutter/material.dart';
import 'package:rotary_net/objects/rotary_area_object.dart';
import 'package:rotary_net/objects/rotary_club_object.dart';
import 'package:rotary_net/objects/rotary_cluster_object.dart';
import 'package:rotary_net/objects/rotary_role_object.dart';

class PersonCardRoleAndHierarchyObject {
  RotaryRoleObject rotaryRoleObject;
  RotaryAreaObject rotaryAreaObject;
  RotaryClusterObject rotaryClusterObject;
  RotaryClubObject rotaryClubObject;

  PersonCardRoleAndHierarchyObject({
    this.rotaryRoleObject,
    this.rotaryAreaObject,
    this.rotaryClusterObject,
    this.rotaryClubObject,
  });

  //#region Get Text styles
  static const TextStyle messageTextSpanStyleBold = TextStyle(
    fontFamily: 'Heebo-Light',
    fontSize: 18.0,
    height: 1.5,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle messageTextSpanStyle = TextStyle(
      fontFamily: 'Heebo-Light',
      fontSize: 17.0,
      height: 1.5,
      color: Colors.black87
  );
  //#endregion

  //#region Get PersonCard Hierarchy Title RichText
  static RichText getPersonCardHierarchyTitleRichText (
      String aRoleName, String aAreaName,
      String aClusterName, String aClubName) {

    return RichText(
      textDirection: TextDirection.rtl,
      text: TextSpan(
        children: [
          TextSpan(
            text: aRoleName,
            style: messageTextSpanStyleBold,
          ),
          TextSpan(
            text: ' מועדון ',
            style: messageTextSpanStyleBold,
          ),
          TextSpan(
            text: aClubName,
            style: messageTextSpanStyle,
          ),
          TextSpan(
            text: '\nבאשכול ',
            style: messageTextSpanStyle,
          ),
          TextSpan(
            text: aClusterName,
            style: messageTextSpanStyle,
          ),
          TextSpan(
            text: ' / ',
            style: messageTextSpanStyle,
          ),
          TextSpan(
            text: aAreaName,
            style: messageTextSpanStyle,
          ),
        ],
      ),
    );
  }
  //#endregion
}

class PersonCardRoleAndHierarchyListObject {
  List<RotaryRoleObject> rotaryRoleObjectList;
  List<RotaryAreaObject> rotaryAreaObjectList;
  List<RotaryClusterObject> rotaryClusterObjectList;
  List<RotaryClubObject> rotaryClubObjectList;

  PersonCardRoleAndHierarchyListObject({
    this.rotaryRoleObjectList,
    this.rotaryAreaObjectList,
    this.rotaryClusterObjectList,
    this.rotaryClubObjectList,
  });
}
