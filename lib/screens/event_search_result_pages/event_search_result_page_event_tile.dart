import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/event_object.dart';

class BuildEventTile extends StatelessWidget {
  const BuildEventTile({Key key, this.aEventObj, this.aFuncOpenEventDetail})
      : super(key: key);
  final EventObject aEventObj;
  final Function aFuncOpenEventDetail;

  @override
  Widget build(BuildContext context) {

    AssetImage eventImage = AssetImage('assets/images/events/${aEventObj.eventPictureUrl}');
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
                              aEventObj.eventName,
                              style: TextStyle(color: Colors.grey[900], fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              aEventObj.eventLocation,
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
          aFuncOpenEventDetail(aEventObj);
        },
      ),
    );
  }
}
