import 'package:flutter/material.dart';
import 'package:rotary_net/objects/login_object.dart';
import 'package:rotary_net/screens/rotary_main_pages/rotary_main_page_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/login_screen.dart';
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

      case RegisterScreen.routeName:
        return MaterialPageRoute(builder: (_) => RegisterScreen(argLoginObject: args,));

      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (_) => LoginScreen(argLoginObject: args));

      case RotaryMainPageScreen.routeName:
        if (args is LoginObject) {
          return MaterialPageRoute(builder: (_) => RotaryMainPageScreen(argLoginObject: args)
          );
        } else {
          return MaterialPageRoute(builder: (_) => RotaryErrorMessageScreen(
              errTitle: 'Rotary Message',
              errMsg: 'Unable to read Person Card data')
          );
        }
        break;

      default:
        return MaterialPageRoute(builder: (_) => RotaryErrorMessageScreen(
            errTitle: 'Registration Message',
            errMsg: 'Unable to read data')
        );
    }
  }
}
