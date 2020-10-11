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
  int areaId;
  int clusterId;
  int clubId;
  Constants.RotaryRolesEnum roleId;
  // int roleId;

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
  });

  // Set PersonCard Email
  Future <void> setEmail(String aEmail) async {
    email = aEmail;
  }

  // Set PersonCard Email
  Future <void> setPictureUrl(String aPictureUrl) async {
    pictureUrl = aPictureUrl;
  }

  factory PersonCardObject.fromJson(Map<String, dynamic> parsedJson){
    // RoleId: Convert [int] to [Enum]
    Constants.RotaryRolesEnum _roleEnum;
    Constants.RotaryRolesEnum _roleEnumValue = _roleEnum.convertToEnum(parsedJson['roleId']);

    return PersonCardObject(
      personCardGuidId: parsedJson['personCardGuidId'],
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
        roleId : _roleEnumValue,
    );
  }

  @override
  String toString() {
    return '{'
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
    ' }';
  }

  // Map toJson() => {
  //   'personCardGuidId': personCardGuidId,
  //   'email': email,
  //   'firstName': firstName,
  //   'lastName': lastName,
  //   'firstNameEng': firstNameEng,
  //   'lastNameEng': lastNameEng,
  //   'phoneNumber': phoneNumber,
  //   'phoneNumberDialCode': phoneNumberDialCode,
  //   'phoneNumberParse': phoneNumberParse,
  //   'phoneNumberCleanLongFormat': phoneNumberCleanLongFormat,
  //   'pictureUrl': pictureUrl,
  //   'cardDescription': cardDescription,
  //   'internetSiteUrl': internetSiteUrl,
  //   'address': address,
  //   'areaId': areaId,
  //   'clusterId': clusterId,
  //   'clubId': clubId,
  //   'roleId': roleId,
  // };

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
    Constants.RotaryRolesEnum _roleEnumValue = _roleEnum.convertToEnum(jsonFromMap['roleId']);

    return PersonCardObject(
      personCardGuidId: jsonFromMap['personCardGuidId'],
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
      roleId: _roleEnumValue,
    );
  }

  Map<String, dynamic> toMap() {

    // RoleEnum: Convert [Enum] to [int]
    Constants.RotaryRolesEnum _roleEnum = roleId;
    int _roleEnumValue = _roleEnum.value;

    return {
      'personCardGuidId': personCardGuidId,
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
      'roleId': _roleEnumValue,
    };
  }
}
