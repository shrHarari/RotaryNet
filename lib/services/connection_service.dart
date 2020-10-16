import 'package:connectivity/connectivity.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'dart:developer' as developer;

class ConnectionService {

//#region Check Connection [CHECK]
// =============================================================================
  static Future checkConnection() async{
    ConnectivityResult _connectivity;
    try {
      Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          _connectivity = result;
        });

      if(_connectivity != ConnectivityResult.none) {
        await LoggerService.log('<ConnectionService> Check Connection >>> OK');
        return true;
      } else {
        await LoggerService.log('<ConnectionService> Check Connection >>> Failed >>> $_connectivity');
        return false;
      }
    }
    catch  (e) {
      await LoggerService.log('<ConnectionService> Check Connection >>> ERROR: ${e.toString()}');
      developer.log(
        'checkConnection',
        name: 'ConnectionService',
        error: 'Check Connection >>> ERROR: ${e.toString()}',
      );
      return false;
    }
  }
  //#endregion

}
