import 'dart:convert';
import 'package:rotary_net/shared/constants.dart' as Constants;

class PersonCardObject {
  final String personCardGuidId;
  String email;
  final String firstName;
  final String lastName;
  final String firstNameEng;
  final String lastNameEng;
  final String phoneNumber;
  final String phoneNumberDialCode;
  final String phoneNumberParse;
  final String phoneNumberCleanLongFormat;
  String pictureUrl;
  String cardDescription;
  String internetSiteUrl;
  String address;
  String areaId;
  String clusterId;
  String clubId;
  String roleId;
  // Constants.RotaryRolesEnum roleEnum;

  PersonCardObject({
    this.personCardGuidId,
    this.email,
    this.firstName,
    this.lastName,
    this.firstNameEng,
    this.lastNameEng,
    this.phoneNumber,
    this.phoneNumberDialCode,
    this.phoneNumberParse,
    this.phoneNumberCleanLongFormat,
    this.pictureUrl,
    this.cardDescription,
    this.internetSiteUrl,
    this.address,
    this.areaId,
    this.clusterId,
    this.clubId,
    this.roleId,
    // this.roleEnum,
  });

  //#region Update PersonCard Object with Sets Calls
  // Set PersonCard Email
  Future <void> setEmail(String aEmail) async {
    email = aEmail;
  }

  // Set PersonCard Email
  Future <void> setPictureUrl(String aPictureUrl) async {
    pictureUrl = aPictureUrl;
  }

  // Set PersonCard RoleId
  Future <void> setRoleId(String aRoleId) async {
    roleId = aRoleId;
  }

  // Set PersonCard AreaId
  Future <void> setAreaId(String aAreaId) async {
    areaId = aAreaId;
  }

  // Set PersonCard ClusterId
  Future <void> setClusterId(String aClusterId) async {
    clusterId = aClusterId;
  }

  // Set PersonCard ClubId
  Future <void> setClubId(String aClubId) async {
    clubId = aClubId;
  }
  //#endregion

  @override
  String toString() {
    return
      '{'
          ' ${this.personCardGuidId},'
          ' ${this.email},'
          ' ${this.firstName},'
          ' ${this.lastName},'
          ' ${this.firstNameEng},'
          ' ${this.lastNameEng},'
          ' ${this.phoneNumber},'
          ' ${this.phoneNumberDialCode},'
          ' ${this.phoneNumberParse},'
          ' ${this.phoneNumberCleanLongFormat},'
          ' ${this.pictureUrl},'
          ' ${this.cardDescription},'
          ' ${this.internetSiteUrl},'
          ' ${this.address},'
          ' ${this.areaId},'
          ' ${this.clusterId},'
          ' ${this.clubId},'
          ' ${this.roleId},'
        // ' ${this.roleEnum},'
      ' }';
  }

  factory PersonCardObject.fromJson(Map<String, dynamic> parsedJson){
    // RoleId: Convert [int] to [Enum]
    // Constants.RotaryRolesEnum _roleEnum;
    // Constants.RotaryRolesEnum _roleEnumValue = _roleEnum.convertToEnum(parsedJson['roleId']);

    return PersonCardObject(
      personCardGuidId: parsedJson['_id'],
      email: parsedJson['email'],
      firstName : parsedJson['firstName'],
      lastName : parsedJson['lastName'],
      firstNameEng : parsedJson['firstNameEng'],
      lastNameEng : parsedJson['lastNameEng'],
      phoneNumber : parsedJson['phoneNumber'],
      phoneNumberDialCode : parsedJson['phoneNumberDialCode'],
      phoneNumberParse : parsedJson['phoneNumberParse'],
      phoneNumberCleanLongFormat : parsedJson['phoneNumberCleanLongFormat'],
      pictureUrl : parsedJson['pictureUrl'],
      cardDescription : parsedJson['cardDescription'],
      internetSiteUrl : parsedJson['internetSiteUrl'],
      address : parsedJson['address'],
      areaId : parsedJson['areaId'],
      clusterId : parsedJson['clusterId'],
      clubId : parsedJson['clubId'],
      roleId : parsedJson['roleId'],
      // roleEnum : _roleEnumValue,
    );
  }

  /// DataBase: Madel for Person Card
  ///----------------------------------------------------
  PersonCardObject personCardFromJson(String str) {
    final jsonData = json.decode(str);
    return PersonCardObject.fromMap(jsonData);
  }

  String personCardToJson(PersonCardObject aPersonCard) {
    final dyn = aPersonCard.toMap();
    return json.encode(dyn);
  }

  factory PersonCardObject.fromMap(Map<String, dynamic> jsonFromMap) {

    // RoleId: Convert [int] to [Enum]
    Constants.RotaryRolesEnum _roleEnum;
    Constants.RotaryRolesEnum _roleEnumValue = _roleEnum.convertToEnum(jsonFromMap['roleEnum']);

    return PersonCardObject(
      personCardGuidId: jsonFromMap['_id'],
      email: jsonFromMap['email'],
      firstName: jsonFromMap['firstName'],
      lastName: jsonFromMap['lastName'],
      firstNameEng: jsonFromMap['firstNameEng'],
      lastNameEng: jsonFromMap['lastNameEng'],
      phoneNumber: jsonFromMap['phoneNumber'],
      phoneNumberDialCode: jsonFromMap['phoneNumberDialCode'],
      phoneNumberParse: jsonFromMap['phoneNumberParse'],
      phoneNumberCleanLongFormat: jsonFromMap['phoneNumberCleanLongFormat'],
      pictureUrl: jsonFromMap['pictureUrl'],
      cardDescription: jsonFromMap['cardDescription'],
      internetSiteUrl: jsonFromMap['internetSiteUrl'],
      address: jsonFromMap['address'],
      areaId: jsonFromMap['areaId'],
      clusterId: jsonFromMap['clusterId'],
      clubId: jsonFromMap['clubId'],
      roleId: jsonFromMap['roleId'],
      // roleEnum: _roleEnumValue,
    );
  }

  Map<String, dynamic> toMap() {

    // // RoleEnum: Convert [Enum] to [int]
    // Constants.RotaryRolesEnum _roleEnum = roleEnum;
    // int _roleEnumValue = _roleEnum.value;

    if (personCardGuidId == null) {
      return {
        // '_id': personCardGuidId,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'firstNameEng': firstNameEng,
        'lastNameEng': lastNameEng,
        'phoneNumber': phoneNumber,
        'phoneNumberDialCode': phoneNumberDialCode,
        'phoneNumberParse': phoneNumberParse,
        'phoneNumberCleanLongFormat': phoneNumberCleanLongFormat,
        'pictureUrl': pictureUrl,
        'cardDescription': cardDescription,
        'internetSiteUrl': internetSiteUrl,
        'address': address,
        'areaId': areaId,
        'clusterId': clusterId,
        'clubId': clubId,
        'roleId': roleId,
        // 'roleEnum': _roleEnumValue,
      };
    } else {
      return {
        '_id': personCardGuidId,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'firstNameEng': firstNameEng,
        'lastNameEng': lastNameEng,
        'phoneNumber': phoneNumber,
        'phoneNumberDialCode': phoneNumberDialCode,
        'phoneNumberParse': phoneNumberParse,
        'phoneNumberCleanLongFormat': phoneNumberCleanLongFormat,
        'pictureUrl': pictureUrl,
        'cardDescription': cardDescription,
        'internetSiteUrl': internetSiteUrl,
        'address': address,
        'areaId': areaId,
        'clusterId': clusterId,
        'clubId': clubId,
        'roleId': roleId,
        // 'roleEnum': _roleEnumValue,
      };
    }
  }
}
