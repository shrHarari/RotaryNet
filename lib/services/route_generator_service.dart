import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/screens/rotary_main_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/register_screen.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/wrapper/wrapper.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){

    /// Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch(settings.name) {
      case '/':
      case Wrapper.routeName:
        return MaterialPageRoute(builder: (_) => Wrapper());

//      case RegistrationScreen.routeName:
//        return MaterialPageRoute(builder: (_) => RegistrationScreen());

      case RegisterScreen.routeName:
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      case RotaryMainScreen.routeName:
        if (args is ArgDataUserObject) {
          return MaterialPageRoute(builder: (_) => RotaryMainScreen(argDataObject: args)
          );
        } else {
          return MaterialPageRoute(builder: (_) => ErrorMessageScreen(
              errTitle: 'Rotary Message',
              errMsg: 'Unable to read Person Card data')
          );
        }
        break;

      default:
        return MaterialPageRoute(builder: (_) => ErrorMessageScreen(
            errTitle: 'Registration Message',
            errMsg: 'Unable to read data')
        );
    }
  }
}
