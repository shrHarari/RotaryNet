
class PersonCardObject {
  String email;
  final String firstName;
  final String lastName;
  final String firstNameEng;
  final String lastNameEng;
  final String phoneNumber;
  final String phoneNumberDialCode;
  final String phoneNumberParse;
  final String phoneNumberCleanLongFormat;
  final String pictureUrl;
  String cardDescription;
  String internetSiteUrl;
  String address;

  PersonCardObject({
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
  });

  // Set PersonCard Email
  //=====================================
  Future <void> setEmail(String aEmail) async {
    email = aEmail;
  }

  factory PersonCardObject.fromJson(Map<String, dynamic> parsedJson){
    return PersonCardObject(
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
        address : parsedJson['address']
    );
  }

  @override
  String toString() {
    return '{'
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
        ' }';
  }

  Map toJson() => {
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
  };
}

//{
//  "email": "shr.harari@gmail.com",
//  "firstName": "שחר",
//  "lastName": "הררי",
//  "firstNameEng": "Shahar",
//  "lastNameEng": "Harari",
//  "phoneNumber": "+972525464640",
//  "phoneNumberDialCode": "972",
//  "phoneNumberParse": "525464640",
//  "phoneNumberCleanLongFormat": "972525464640",
//  "pictureUrl": "",
//  "cardDescription": "תיאור מפורט של כרטיס הביקור",
//  "internetSiteUrl": "",
//  "address": "הנשיאים 6, הוד-השרון"
//}