import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class PersonCardSearchResultPageHeader implements SliverPersistentHeaderDelegate {
  PersonCardSearchResultPageHeader({
    this.minExtent,
    @required this.maxExtent,
    @required this.openMenuDrawerFunc,
  });
  final double minExtent;
  final double maxExtent;
  final Function openMenuDrawerFunc;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController searchController = new TextEditingController();

  Future<void> openMenu() async {
    // Open Menu from Left side
    openMenuDrawerFunc();
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.lightBlue[400],
      child: SafeArea(
        child: Column(
          children: <Widget>[
            /// --------------- First line - Menu Area ---------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: <Widget>[
                /// Menu Icon
                Expanded(
                  flex: 3,
                  child: IconButton(
                    icon: Icon(Icons.menu, color: Colors.white),
                    onPressed: () async {await openMenu();},
                  ),
                ),

                Expanded(
                  flex: 8,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      MaterialButton(
                        elevation: 0.0,
                        onPressed: () {},
                        color: Colors.lightBlue,
                        textColor: Colors.white,
                        child: Icon(
                          Icons.account_balance,
                          size: 30,
                        ),
                        padding: EdgeInsets.all(20),
                        shape: CircleBorder(side: BorderSide(color: Colors.white)),
                      ),
                      SizedBox(height: 10.0,),

                      Text(Constants.rotaryApplicationName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),

                    ],
                  ),
                ),

                /// Back Icon --->>> Back to previous screen
                Expanded(
                  flex: 3,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () {Navigator.pop(context);},
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0,),

            /// --------------- Second line - Search Box Area ---------------------
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 30.0,),
                Flexible(
                  child: TextField(
                    maxLines: 1,
                    controller: searchController,
                    textAlign: TextAlign.right,
                    textInputAction: TextInputAction.search,
                    //onSubmitted: (value) async {await executeSearch(value);},
                    style: TextStyle(
                        fontSize: 14.0,
                        height: 0.8,
                        color: Colors.black
                    ),
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                          color: Colors.blue,
                          icon: Icon(Icons.search),
                          onPressed: () async {Navigator.pop(context);},
                        ),
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "מילת חיפוש",
                        fillColor: Colors.white
                    ),
                  ),
                ),
                SizedBox(width: 30.0,),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double titleOpacity(double shrinkOffset) {
    // simple formula: fade out text as soon as shrinkOffset > 0
    return 1.0 - max(0.0, shrinkOffset) / maxExtent;
    // more complex formula: starts fading out text when shrinkOffset > minExtent
    //return 1.0 - max(0.0, (shrinkOffset - minExtent)) / (maxExtent - minExtent);
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
