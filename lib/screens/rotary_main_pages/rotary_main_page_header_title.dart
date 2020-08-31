import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class RotaryMainPageHeaderTitle implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;

  RotaryMainPageHeaderTitle({
    this.minExtent,
    @required this.maxExtent,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      // color: Colors.lightBlue[400],
      color: Colors.transparent,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            /// ----------- Header - First line - Application Logo -----------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: MaterialButton(
                          elevation: 0.0,
                          onPressed: () {},
                          color: Colors.lightBlue,
                          textColor: Colors.white,
                          child: Icon(
                            Icons.account_balance,
                            size: 30,
                          ),
                          padding: EdgeInsets.all(20),
                          shape: CircleBorder(
                              side: BorderSide(
                                color: Colors.white,
                              )
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(Constants.rotaryApplicationName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
