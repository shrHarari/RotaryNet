import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/screens/registration_screen.dart';
import 'package:rotary_net/screens/rotary_main_screen.dart';
import 'package:rotary_net/shared/error_message.dart';
import 'package:rotary_net/wrapper/wrapper.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){

    /// Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch(settings.name) {
      case '/':
      case Wrapper.routeName:
        return MaterialPageRoute(builder: (_) => Wrapper());

      case RegistrationScreen.routeName:
        return MaterialPageRoute(builder: (_) => RegistrationScreen());

      case RotaryMainScreen.routeName:
        if (args is ArgDataObject) {
          return MaterialPageRoute(builder: (_) => RotaryMainScreen(argDataObject: args)
          );
        } else {
          return MaterialPageRoute(builder: (_) => ErrorMessage(
              errTitle: 'Rotary Message',
              errMsg: 'Unable to read Person Card data')
          );
        }
        break;

      default:
        return MaterialPageRoute(builder: (_) => ErrorMessage(
            errTitle: 'Registration Message',
            errMsg: 'Unable to read data')
        );
    }
  }
}
