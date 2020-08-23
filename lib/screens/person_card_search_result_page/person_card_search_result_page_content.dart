import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/screens/person_card_detail_screen.dart';

class PersonCardSearchResultPageContent extends StatefulWidget {
  final ArgDataUserObject argDataObject;
  final List<PersonCardObject> personCardsList;

  PersonCardSearchResultPageContent({Key key, @required this.argDataObject, @required this.personCardsList}) : super(key: key);

  @override
  _PersonCardSearchResultPageContentState createState() => _PersonCardSearchResultPageContentState();
}

class _PersonCardSearchResultPageContentState extends State<PersonCardSearchResultPageContent> {

  @override
  void initState() {
    super.initState();
  }

  openPersonCardDetailScreen(PersonCardObject aPersonCardObj) {
    ArgDataPersonCardObject argDataPersonCardObject;
    argDataPersonCardObject = ArgDataPersonCardObject(widget.argDataObject.passUserObj, aPersonCardObj, widget.argDataObject.passLoginObj);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonCardDetailScreen(argDataObject: argDataPersonCardObject),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BuildPersonCardListView(
              personCardObjectsList: widget.personCardsList,
              funcOpenPersonCardDetail: openPersonCardDetailScreen,
    );
  }
}

class BuildPersonCardListView extends StatelessWidget {
  const BuildPersonCardListView({Key key, this.personCardObjectsList, this.funcOpenPersonCardDetail}) : super(key: key);
  final List<PersonCardObject> personCardObjectsList;
  final Function funcOpenPersonCardDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 0.0, bottom: 10.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: personCardObjectsList.length,
          itemBuilder: (context, index){
            return Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0 ),
                child: buildPersonCard(personCardObjectsList[index], funcOpenPersonCardDetail),
              ),
            );
          }
      ),
    );
  }

  GestureDetector buildPersonCard(PersonCardObject aPersonCardObj, Function aFuncOpenPersonCardDetail) {

    AssetImage personCardImage = AssetImage('assets/images/${aPersonCardObj.pictureUrl}');

    return GestureDetector(
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
    );
  }
}
