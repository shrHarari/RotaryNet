import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rotary_net/shared/constants.dart';

class RotaryMainPageActionImageIcons extends StatelessWidget {
  final TextEditingController searchController;
  final Function argExecuteSearchFunc;
  final Function argOpenEventDetailFunc;
  final bool argUserHasPermission;
  final Color argPersonCardBackgroundColor;
  final Color argEventsBackgroundColor;

  RotaryMainPageActionImageIcons({
    this.searchController,
    this.argExecuteSearchFunc,
    this.argOpenEventDetailFunc,
    this.argUserHasPermission,
    this.argPersonCardBackgroundColor,
    this.argEventsBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {

    /// ----------- Body - Action Image Icons -----------------
    final height = MediaQuery.of(context).size.height;

    return Container(
      // color: Colors.green,
      // height: height * .5,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 30.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // if (argUserHasPermission)
              //   buildAddEventImageIconWithTitle('הוסף אירוע', Icons.plus_one, argOpenEventDetailFunc, Colors.white),

              buildImageIconWithTitle('אירועים', Icons.event, argExecuteSearchFunc, SearchTypeEnum.Event, argEventsBackgroundColor),

              buildImageIconWithTitle('כרטיס ביקור', Icons.person, argExecuteSearchFunc, SearchTypeEnum.PersonCard, argPersonCardBackgroundColor),
            ]
        ),
      ),
    );
  }

  Widget buildImageIconWithTitle(String aTitle, IconData aIcon, Function aExecuteFunc, SearchTypeEnum aSearchType, Color aButtonColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
          textDirection: TextDirection.rtl,
          children: <Widget>[
            buildImageIcon(aIcon, aExecuteFunc, aSearchType, aButtonColor),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: buildTitle(aTitle),
            ),
          ]
      ),
    );
  }

  MaterialButton buildImageIcon(IconData aIcon, Function aExecuteFunc, SearchTypeEnum aSearchType, Color aButtonColor) {
    return MaterialButton(
      color: aButtonColor,
      onPressed: () {
        aExecuteFunc(searchController.text, aSearchType);
      },
      shape: CircleBorder(side: BorderSide(color: Colors.blue, width: 2.0)),
      padding: EdgeInsets.all(10),
      child: IconTheme(
        data: IconThemeData(
            color: Colors.blue[500]
        ),
        child: Icon(
          aIcon,
          size: 50,
        ),
      ),
    );
  }

  Widget buildTitle(String aTitle) {
    return Text(
      aTitle,
      style: TextStyle(
          fontSize: 16.0,
          height: 0.8,
          color: Colors.blue,
          fontWeight: FontWeight.bold
      ),
    );
  }

  Widget buildAddEventImageIconWithTitle(String aTitle, IconData aIcon, Function aFunc, Color aButtonColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
      child: Column(
          textDirection: TextDirection.rtl,
          children: <Widget>[
            MaterialButton(
              color: aButtonColor,
              onPressed: () {
                aFunc();
              },
              shape: CircleBorder(side: BorderSide(color: Colors.blue, width: 2.0)),
              padding: EdgeInsets.all(10),
              child: IconTheme(
                data: IconThemeData(
                    color: Colors.blue[500]
                ),
                child: Icon(
                  aIcon,
                  size: 50,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                aTitle,
                style: TextStyle(
                    fontSize: 16.0,
                    height: 0.8,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ]
      ),
    );
  }
}
