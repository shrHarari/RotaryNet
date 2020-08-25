import 'package:flutter/material.dart';
import 'package:rotary_net/objects/person_card_object.dart';

class BuildPersonCardTile extends StatelessWidget {
  const BuildPersonCardTile({Key key, this.aPersonCardObj, this.aFuncOpenPersonCardDetail})
      : super(key: key);
  final PersonCardObject aPersonCardObj;
  final Function aFuncOpenPersonCardDetail;

  @override
  Widget build(BuildContext context) {

    AssetImage personCardImage = AssetImage('assets/images/${aPersonCardObj.pictureUrl}');

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 5.0, right: 15.0, bottom: 5.0),
      child: GestureDetector(
        child: Container(
          margin: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            color: Colors.blue[300],
          ),

          child: Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              color: Colors.grey[50],
            ),

            child: Row(
              textDirection: TextDirection.rtl,
              children: <Widget>[
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.blue[900],
                  backgroundImage: personCardImage,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Column(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            aPersonCardObj.firstName + " " + aPersonCardObj.lastName,
                            style: TextStyle(color: Colors.grey[900], fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          aPersonCardObj.address,
                          style: TextStyle(color: Colors.grey[900], fontSize: 16.0, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: ()
        {
          aFuncOpenPersonCardDetail(aPersonCardObj);
        },
      ),
    );
  }
}

class DisplayErrorTextAndRetryButton extends StatelessWidget {
  const DisplayErrorTextAndRetryButton({Key key, this.errorText, this.buttonText, this.onPressed})
      : super(key: key);
  final String errorText;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorText,
            style: Theme.of(context).textTheme.headline,
          ),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text(buttonText,
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(color: Colors.white)),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
