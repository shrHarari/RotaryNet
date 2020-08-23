import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/screens/person_card_detail_screen.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/loading.dart';

class PersonCardSearchResultPageContent extends StatefulWidget {
  final ArgDataUserObject argDataObject;
  final String searchText;

  PersonCardSearchResultPageContent({Key key, @required this.argDataObject, @required this.searchText}) : super(key: key);

  @override
  _PersonCardSearchResultPageContentState createState() => _PersonCardSearchResultPageContentState();
}

class _PersonCardSearchResultPageContentState extends State<PersonCardSearchResultPageContent> {

  final PersonCardService personCardService = PersonCardService();
  Future<List<PersonCardObject>> personCardsForBuild;
  bool _shouldFail = false;

  @override
  void initState() {
    super.initState();
    personCardsForBuild = getPersonCardsListFromServer(_shouldFail);
  }

  Future<List<PersonCardObject>> getPersonCardsListFromServer(bool shouldFail) async {
    print('>>>>>>>>>>>>>>>>>>>>>getPersonCardsListFromServer');
    await Future<void>.delayed(Duration(seconds: 1));
    if (shouldFail) {
      throw PlatformException(code: '404');
    }
    dynamic personCardsList = await personCardService.getPersonCardListSearchFromServer(widget.searchText);
    return personCardsList;
  }

  void retryGetData() {
    personCardsForBuild = getPersonCardsListFromServer(!_shouldFail);
    setState(() => _shouldFail = !_shouldFail);
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
    return FutureBuilder<List<PersonCardObject>>(
      future: personCardsForBuild,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverFillRemaining(
//            child: Center(child: CircularProgressIndicator()),
            child: Loading(),
          );
        }
        if (snapshot.hasError) {
          print('PersonCardSearchResultPageContent / Snapshot Error Message: ${snapshot.error}');
          return SliverFillRemaining(
            child: DisplayErrorTextAndRetryButton(
              errorText: 'שגיאה בשליפת כרטיסי הביקור',
              buttonText: 'נסה שוב',
              onPressed: retryGetData,
            ),
          );
        }
        if (snapshot.hasData) {
          return SliverToBoxAdapter(
            child: BuildPersonCardListView(
              personCardObjectsList: snapshot.data,
              openPersonCardDetail: openPersonCardDetailScreen,
            ),
          );
        }
        return SliverFillRemaining(
          child: Center(child: Text('אין תוצאות')),
        );
      },
    );
  }
}

class BuildPersonCardListView extends StatelessWidget {
  const BuildPersonCardListView({Key key, this.personCardObjectsList, this.openPersonCardDetail}) : super(key: key);
  final List<PersonCardObject> personCardObjectsList;
  final Function openPersonCardDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: personCardObjectsList.length,
          itemBuilder: (context, index){
            return Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0 ),
                  child: buildPersonCard(personCardObjectsList[index], openPersonCardDetail),
              ),
            );
          }
      ),
    );
  }

  GestureDetector buildPersonCard(PersonCardObject aPersonCardObj, Function aFunc) {

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
        aFunc(aPersonCardObj);
      },
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
