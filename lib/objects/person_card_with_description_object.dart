import 'dart:convert';

class PersonCardWithDescriptionObject {
  final String userGuidId;
  final String email;
  final String firstName;
  final String lastName;
  final String firstNameEng;
  final String lastNameEng;
  final String phoneNumber;
  final String phoneNumberDialCode;
  final String phoneNumberParse;
  final String phoneNumberCleanLongFormat;
  final String pictureUrl;
  final String cardDescription;
  final String internetSiteUrl;
  final String address;
  final int roleId;
  final String roleName;
  final int areaId;
  final String areaName;
  final int clusterId;
  final String clusterName;
  final int clubId;
  final String clubName;
  final String clubAddress;
  final String clubMail;
  final String clubManagerGuidId;

  PersonCardWithDescriptionObject({
    this.userGuidId,
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
    this.roleId,
    this.roleName,
    this.areaId,
    this.areaName,
    this.clusterId,
    this.clusterName,
    this.clubId,
    this.clubName,
    this.clubAddress,
    this.clubMail,
    this.clubManagerGuidId,
  });

  /// Convert JsonStringStructure to String
  @override
  String toString() {
    return
      '{'
          ' ${this.userGuidId},'
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
          ' ${this.roleId},'
          ' ${this.roleName},'
          ' ${this.areaId},'
          ' ${this.areaName},'
          ' ${this.clusterId},'
          ' ${this.clusterName},'
          ' ${this.clubId},'
          ' ${this.clubName},'
          ' ${this.clubAddress},'
          ' ${this.clubMail},'
          ' ${this.clubManagerGuidId},'
          '}';
  }

  /// Used for jsonDecode Function
  Map toJson() => {
    'userGuidId': userGuidId,
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
    'roleId': roleId,
    'roleName': roleName,
    'areaId': areaId,
    'areaName': areaName,
    'clusterId': clusterId,
    'clusterName': clusterName,
    'clubId': clubId,
    'clubName': clubName,
    'clubAddress': clubAddress,
    'clubMail': clubMail,
    'clubManagerGuidId': clubManagerGuidId,
  };

  factory PersonCardWithDescriptionObject.fromJson(Map<String, dynamic> parsedJson){

    return PersonCardWithDescriptionObject(
      userGuidId: parsedJson['userGuidId'],
      email: parsedJson['email'],
      firstName: parsedJson['firstName'],
      lastName: parsedJson['lastName'],
      firstNameEng: parsedJson['firstNameEng'],
      lastNameEng: parsedJson['lastNameEng'],
      phoneNumber: parsedJson['phoneNumber'],
      phoneNumberDialCode: parsedJson['phoneNumberDialCode'],
      phoneNumberParse: parsedJson['phoneNumberParse'],
      phoneNumberCleanLongFormat: parsedJson['phoneNumberCleanLongFormat'],
      pictureUrl: parsedJson['pictureUrl'],
      cardDescription: parsedJson['cardDescription'],
      internetSiteUrl: parsedJson['internetSiteUrl'],
      address: parsedJson['address'],
      roleId: parsedJson['roleId'],
      roleName: parsedJson['roleName'],
      areaId: parsedJson['areaId'],
      areaName: parsedJson['areaName'],
      clusterId: parsedJson['clusterId'],
      clusterName: parsedJson['clusterName'],
      clubId: parsedJson['clubId'],
      clubName: parsedJson['clubName'],
      clubAddress: parsedJson['clubAddress'],
      clubMail: parsedJson['clubMail'],
      clubManagerGuidId: parsedJson['clubManagerGuidId'],
    );
  }

  /// DataBase: Madel for PersonCardWithDescriptionObject
  ///----------------------------------------------------
  PersonCardWithDescriptionObject personCardObjectFromJson(String str) {
    final jsonData = json.decode(str);
    return PersonCardWithDescriptionObject.fromMap(jsonData);
  }

  String messageObjectToJson(PersonCardWithDescriptionObject aPersonCardWithDescriptionObject) {
    final dyn = aPersonCardWithDescriptionObject.toMap();
    return json.encode(dyn);
  }

  factory PersonCardWithDescriptionObject.fromMap(Map<String, dynamic> jsonFromMap) {

    return PersonCardWithDescriptionObject(
      userGuidId: jsonFromMap['userGuidId'],
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
      roleId: jsonFromMap['roleId'],
      roleName: jsonFromMap['roleName'],
      areaId: jsonFromMap['areaId'],
      areaName: jsonFromMap['areaName'],
      clusterId: jsonFromMap['clusterId'],
      clusterName: jsonFromMap['clusterName'],
      clubId: jsonFromMap['clubId'],
      clubName: jsonFromMap['clubName'],
      clubAddress: jsonFromMap['clubAddress'],
      clubMail: jsonFromMap['clubMail'],
      clubManagerGuidId: jsonFromMap['clubManagerGuidId'],
    );
  }

  Map<String, dynamic> toMap() {

    return {
      'userGuidId': userGuidId,
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
      'roleId': roleId,
      'roleName': roleName,
      'areaId': areaId,
      'areaName': areaName,
      'clusterId': clusterId,
      'clusterName': clusterName,
      'clubId': clubId,
      'clubName': clubName,
      'clubAddress': clubAddress,
      'clubMail': clubMail,
      'clubManagerGuidId': clubManagerGuidId,
    };
  }
}
