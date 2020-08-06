import 'package:flutter/material.dart';
import 'package:rotary_net/screens/person_card_detail_screen.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/services/person_card_service.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/widgets/side_menu_widget.dart';

class PersonCardsSearchResultScreen extends StatefulWidget {
  static const routeName = '/PersonCardsSearchResultScreen';
  final ArgDataUserObject argDataObject;
  final String searchText;

  PersonCardsSearchResultScreen({Key key, @required this.argDataObject, @required this.searchText}) : super(key: key);

  @override
  _PersonCardsSearchResultScreen createState() => _PersonCardsSearchResultScreen();
}

class _PersonCardsSearchResultScreen extends State<PersonCardsSearchResultScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String appBarTitle = 'Rotary';
  bool loading = true;
  String error = '';
  bool isShowDataForDebug = false;
  TextEditingController searchController = new TextEditingController();

  final PersonCardService personCardService = PersonCardService();
  Future<List<PersonCardObject>> personCardsForBuild;

  @override
  void initState() {
    personCardsForBuild = getPersonCardsListFromServer();

    super.initState();
  }

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  Future<List<PersonCardObject>> getPersonCardsListFromServer() async {
    dynamic personCardsList = await personCardService.getPersonCardListSearchFromServer(widget.searchText);

    if (personCardsList == null) {
      setState(() {
        error = 'Could not get Person Cards List';
        loading = false;
      });
      return null;
    } else {
      setState(() {
        error = 'Person Cards List OK';
        loading = false;
      });
      return personCardsList;
    }
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

    return loading ? Loading() :
    Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue[50],

      drawer: Container(
        width: 250,
        child: Drawer(
          child: SideMenuDrawer(userObj: widget.argDataObject.passUserObj),
        ),
      ),

      body: FutureBuilder<List<PersonCardObject>>(
        future: personCardsForBuild,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PersonCardObject> currentPersonCardsList = snapshot.data;

            return buildMainScaffoldBody(currentPersonCardsList);
          } else {
            if (snapshot.hasError) {
              print('PersonCardsSearchResultScreen / Snapshot Error Message: ${snapshot.error}');
              return Text("${snapshot.error}", style: Theme.of(context).textTheme.headline);
            } else {
              print('PersonCardsSearchResultScreen / Error Message: Unable to read PersonCards data');
              return Loading();
            }
          }
        }
      ),
    );
  }

  Widget buildMainScaffoldBody(List<PersonCardObject> aPersonCardObjectsList) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// --------------- Title Area ---------------------
          Container(
            height: 230,
            color: Colors.blue[500],
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
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Icon(
                                Icons.account_balance,
                                size: 30,
                              ),
                              padding: EdgeInsets.all(20),
                              shape: CircleBorder(side: BorderSide(color: Colors.white)),
                            ),
                            SizedBox(height: 10.0,),

                            Text(appBarTitle,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0),
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
                                  //onPressed: () async {await executeSearch(searchController.text);},
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
          ),
          SizedBox(height: 30.0,),

          /// --------------- Result Area ---------------------
          Container(
             height: 400,
             width: 330,
             margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
             child: buildPersonCardsListDisplay(aPersonCardObjectsList)
            ),
            SizedBox(height: 20.0,),
          ]
      ),
    );
  }


  ListView buildPersonCardsListDisplay(List<PersonCardObject> aPersonCardObjectsList) {
    return ListView.builder(
        itemCount: aPersonCardObjectsList.length,
        itemBuilder: (context, index){
          return Container(
            height: 70.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0 ),
              child: Card(
                shape:
                RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(4.0)
                ),
                color: Colors.blue[100],
                child: ListTile(
                  title: Text(aPersonCardObjectsList[index].firstName),
                  leading: Icon(Icons.radio_button_checked, color: Colors.blue),
                  onTap: ()
                  {
                    openPersonCardDetailScreen(aPersonCardObjectsList[index]);
                  },
                ),
              ),
            ),
          );
        }
    );
  }
}

