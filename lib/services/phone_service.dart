import 'package:android_multiple_identifier/android_multiple_identifier.dart';

class PhoneService {

  Future<Map> getPhoneIdentifiers() async {
    Map idMap;

    bool requestResponse = await AndroidMultipleIdentifier.requestPermission();
    //print("NEVER ASK AGAIN SET TO: ${AndroidMultipleIdentifier.neverAskAgain}");

    try {
      /// Get device information async
      idMap = await AndroidMultipleIdentifier.idMap;
    } catch (e) {
      idMap = Map();
      idMap["imei"] = 'Failed to get IMEI.';
      idMap["serial"] = 'Failed to get Serial Code.';
      idMap["androidId"] = 'Failed to get Android id.';
    }
    return idMap;
  }
}
