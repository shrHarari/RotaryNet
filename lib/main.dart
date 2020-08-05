import 'package:flutter/material.dart';
import 'package:rotary_net/services/route_generator_service.dart';

void main() => runApp(RotaryNetApp());

class RotaryNetApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'RotaryNet',
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
