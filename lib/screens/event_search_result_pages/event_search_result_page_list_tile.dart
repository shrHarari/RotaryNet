import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/event_object.dart';

class BuildEventTileRectangle extends StatelessWidget {
  const BuildEventTileRectangle({Key key, this.argEventObj, this.argFuncOpenEventDetail, this.argIndexOfEventObj})
      : super(key: key);
  final EventObject argEventObj;
  final Function argFuncOpenEventDetail;
  final int argIndexOfEventObj;

  @override
  Widget build(BuildContext context) {

    AssetImage eventImage = AssetImage('assets/images/events/${argEventObj.eventPictureUrl}');

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 5.0),
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                ),
                image: DecorationImage(
                    image: eventImage,
                    fit: BoxFit.cover
                ),
              ),
            ),

            Container(
              width: double.infinity,
              decoration:BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.grey[600].withOpacity(0.4), Colors.transparent.withOpacity(0.2)]
                  )
              ),
            ),

            Container(
              child: Row(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top:15.0, right: 20.0, left: 20.0),
                      child: Column(
                        textDirection: TextDirection.rtl,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Text(
                              argEventObj.eventName,
                              style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              argEventObj.eventLocation,
                              style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: ()
        {
          argFuncOpenEventDetail(argEventObj, argIndexOfEventObj);
        },
      ),
    );
  }
}

class BuildEventTileCircular extends StatelessWidget {
  const BuildEventTileCircular({Key key, this.argEventObj, this.argFuncOpenEventDetail, this.argIndexOfEventObj})
      : super(key: key);
  final EventObject argEventObj;
  final Function argFuncOpenEventDetail;
  final int argIndexOfEventObj;

  @override
  Widget build(BuildContext context) {

    AssetImage eventImage = AssetImage('assets/images/events/${argEventObj.eventPictureUrl}');
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 5.0),
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                image: DecorationImage(
                    colorFilter:
                    ColorFilter.mode(Colors.white.withOpacity(0.6), BlendMode.dstATop),
                    image: eventImage,
                    fit: BoxFit.cover
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[600],
                    offset: Offset(5.0, 10.0),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top:10.0, right: 30.0),
                      child: Column(
                        textDirection: TextDirection.rtl,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              argEventObj.eventName,
                              style: TextStyle(color: Colors.grey[900], fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              argEventObj.eventLocation,
                              style: TextStyle(color: Colors.grey[900], fontSize: 16.0, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: ()
        {
          argFuncOpenEventDetail(argEventObj, argIndexOfEventObj);
        },
      ),
    );
  }
}
