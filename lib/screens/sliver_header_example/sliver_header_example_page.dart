import 'package:flutter/material.dart';
import 'package:rotary_net/screens/sliver_header_example/sliver_header_example_page_content.dart';
import 'package:rotary_net/screens/sliver_header_example/sliver_header_example_page_header.dart';

class SliverHeaderExamplePage extends StatefulWidget {
  @override
  _SliverHeaderExamplePageState createState() => _SliverHeaderExamplePageState();
}

class _SliverHeaderExamplePageState extends State<SliverHeaderExamplePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: false,
            floating: true,
            delegate: SliverHeaderExamplePageHeader(
              minExtent: 150.0,
              maxExtent: 250.0,
            ),
          ),
          SliverHeaderExamplePageContent(),
        ],
      ),
    );
  }
}
