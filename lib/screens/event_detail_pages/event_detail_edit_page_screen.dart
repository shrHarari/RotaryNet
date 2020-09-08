import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/objects/event_object.dart';
import 'package:rotary_net/screens/event_detail_pages/event_detail_page_widgets.dart';
import 'package:rotary_net/services/event_service.dart';
import 'package:rotary_net/shared/decoration_style.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/utils/hebrew_syntax_format.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/widgets/pick_date_time_dialog_widget.dart';

class EventDetailEditPageScreen extends StatefulWidget {
  static const routeName = '/EventDetailEditPageScreen';
  final ArgDataEventObject argDataObject;
  final Widget argHebrewEventTimeLabel;

  EventDetailEditPageScreen({Key key, @required this.argDataObject, this.argHebrewEventTimeLabel}) : super(key: key);

  @override
  _EventDetailEditPageScreenState createState() => _EventDetailEditPageScreenState();
}

class _EventDetailEditPageScreenState extends State<EventDetailEditPageScreen> {

  final EventService eventService = EventService();
  EventObject currentDisplayEventObject;
  Widget currentHebrewEventTimeLabel;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    currentDisplayEventObject = widget.argDataObject.passEventObj;
    currentHebrewEventTimeLabel = widget.argHebrewEventTimeLabel;

    setEventVariables(currentDisplayEventObject);
    super.initState();
  }

  //#region Declare Variables
  String eventId;
  String pictureFileName;
  AssetImage eventImage;
  File picFile;
  DateTime selectedPickStartDateTime;
  DateTime selectedPickEndDateTime;

  TextEditingController eventNameController;
  TextEditingController eventDescriptionController;
  TextEditingController eventLocationController;
  TextEditingController eventManagerController;

  String error = '';
  bool loading = false;
  String updateStatus;
  //#endregion

  //#region Set event Variables
  Future<void> setEventVariables(EventObject aEvent) async {
    eventId = aEvent.eventId;
    pictureFileName = aEvent.eventPictureUrl;
    eventImage = AssetImage('assets/images/events/$pictureFileName');

    eventNameController = TextEditingController(text: aEvent.eventName);
    eventDescriptionController = TextEditingController(text: aEvent.eventDescription);
    eventLocationController = TextEditingController(text: aEvent.eventLocation);
    eventManagerController = TextEditingController(text: aEvent.eventManager);

    selectedPickStartDateTime = aEvent.eventStartDateTime;
    selectedPickEndDateTime = aEvent.eventEndDateTime;
  }
  //#endregion

  //#region Check Validation
  Future<bool> checkValidation() async {
    bool validationVal = true;

    if (formKey.currentState.validate()){
        validationVal = true;
    }
    return validationVal;
  }
  //#endregion

  //#region Update Event
  Future updateEvent() async {

    bool validationVal = await checkValidation();

    if (validationVal){

      String _eventName = (eventNameController.text != null) ? (eventNameController.text) : '';
      String _eventDescription = (eventDescriptionController.text != null) ? (eventDescriptionController.text) : '';
      String _eventLocation = (eventLocationController.text != null) ? (eventLocationController.text) : '';
      String _eventManager = (eventManagerController.text != null) ? (eventManagerController.text) : '';

      EventObject newEventObj =
          eventService.createEventAsObject(
              eventId, _eventName,
              pictureFileName, _eventDescription,
              selectedPickStartDateTime, selectedPickEndDateTime,
              _eventLocation, _eventManager,);

      String updateVal = await eventService.updateEventObjectDataToDataBase(newEventObj);

      if (int.parse(updateVal) > 0) {
        updateStatus = 'נתוני האירוע עודכנו';

        /// Return multiple data using MAP
        final returnDataMap = {
          "EventObject": newEventObj,
          "PickedPictureFile": picFile,
          "HebrewEventTimeLabel": currentHebrewEventTimeLabel
        };
        Navigator.pop(context, returnDataMap);
      } else {
        setState(() {
          updateStatus = 'עדכון נתוני האירוע נכשל, נסה שנית';
        });
      }
    }
//    return returnVal;
  }
  //#endregion

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  Future<void> openDateTimePickerDialog(BuildContext context) async {

    Map datesMapObj = await HebrewFormatSyntax.getHebrewDateTimeLabels(selectedPickStartDateTime, selectedPickEndDateTime);

    final returnDataMapFromPicker = await showDialog(
      context: context,
      builder: (context) {
        return PickDateTimeDialogWidget(
          argStartDateTime: selectedPickStartDateTime,
          argEndDateTime: selectedPickEndDateTime,
          argDatesMapObj: datesMapObj);
      }
    );

    if (returnDataMapFromPicker != null) {
      DateTime _startDateTime = returnDataMapFromPicker["EventPickedStartDateTime"];
      DateTime _endDateTime = returnDataMapFromPicker["EventPickedEndDateTime"];
      Widget _displayHebrewDateTime = await EventDetailWidgets.buildEventDateTimeLabel(_startDateTime, _endDateTime);
      // print('_startDateTime: $_startDateTime \n_endDateTime: $_endDateTime \n_displayHebrewDateTime: $_displayHebrewDateTime');

      setState(() {
        selectedPickStartDateTime = _startDateTime;
        selectedPickEndDateTime = _endDateTime;
        currentHebrewEventTimeLabel = _displayHebrewDateTime;
      });
    }
  }

  Future <void> pickImageFile() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile _compressedImage = await imagePicker.getImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 800
    );
    File _pictureFile = File(_compressedImage.path);

    setState(() {
      picFile = _pictureFile;
      pictureFileName = _pictureFile.path;
    });
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
          child: ApplicationMenuDrawer(argUserObj: widget.argDataObject.passUserObj),
        ),
      ),

      body: buildMainScaffoldBody(),
    );
  }

  Widget buildMainScaffoldBody() {
    return Container(
      // width: double.infinity,
      child: Column(
          children: <Widget>[
            /// --------------- Title Area ---------------------
            Container(
              height: 160,
              color: Colors.lightBlue[400],
              child: SafeArea(
                child: Stack(
                  children: <Widget>[
                    /// ----------- Header - First line - Application Logo -----------------
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                shape: CircleBorder(side: BorderSide(color: Colors.white)),
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
                      ],
                    ),

                    /// --------------- Application Menu ---------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        /// Menu Icon
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 0.0, bottom: 0.0),
                          child: IconButton(
                            icon: Icon(Icons.menu, color: Colors.white),
                            onPressed: () async {await openMenu();},
                          ),
                        ),

                        /// Debug Icon --->>> Remove before Production
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 10.0, right: 10.0, bottom: 0.0),
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward, color: Colors.white),
                            onPressed: () {Navigator.pop(context);},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: buildEventDetailDisplay(currentDisplayEventObject),
            ),
          ]
      ),
    );
  }

  /// ====================== Event All Fields ==========================
  Widget buildEventDetailDisplay(EventObject aEventObj) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          /// ------------------- Event Image -------------------------
          Stack(
            children: <Widget>[
              Container(
                height: 200.0,
                  width: double.infinity,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: picFile == null ? eventImage : FileImage(picFile),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
              Positioned(
                bottom: 30.0, left: 20.0,
                child: IconButton(
                  icon: Icon(Icons.add_photo_alternate, color: Colors.blue, size: 40.0,),
                  onPressed: () {pickImageFile();},
                ),
              ),
            ]
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            width: double.infinity,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  /// ------------------- Input Text Fields ----------------------
                  buildEnabledTextInputWithImageIcon(eventNameController, 'Event Name', Icons.description, false),
                  buildEnabledTextInputWithImageIcon(eventManagerController, 'Event Manager', Icons.person, false),
                  buildEnabledTextInputWithImageIcon(eventDescriptionController, 'Event Description', Icons.view_list, true),
                  buildEnabledTextInputWithImageIcon(eventLocationController, 'Event Location', Icons.location_on, false),
                  buildEventDetailImageIcon(Icons.event_available, currentHebrewEventTimeLabel, openDateTimePickerDialog),
                  buildUpdateImageButton('עדכון', updateEvent, Icons.update),
                  /// ---------------------- Display Error -----------------------
                  Text(
                    error,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEnabledTextInputWithImageIcon(TextEditingController aController, String textInputName, IconData aIcon, bool aMultiLine) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: buildImageIconForTextField(aIcon),
            ),

            Expanded(
              flex: 12,
              child:
              Container(
                child: buildTextFormField(aController, textInputName, aMultiLine),
              ),
            ),
          ]
      ),
    );
  }

  MaterialButton buildImageIconForTextField(IconData aIcon) {
    return MaterialButton(
      elevation: 0.0,
      onPressed: () {},
      color: Colors.blue[10],
      padding: EdgeInsets.all(10),
      shape: CircleBorder(
          side: BorderSide(color: Colors.blue)
      ),
      child:
      IconTheme(
        data: IconThemeData(
            color: Colors.blue[500]
        ),
        child: Icon(
          aIcon,
          size: 30,
        ),
      ),
    );
  }

  TextFormField buildTextFormField(
      TextEditingController aController,
      String textInputName,
      bool aMultiLine,
      {bool aEnabled = true}) {
    return TextFormField(
      keyboardType: aMultiLine ? TextInputType.multiline : null,
      maxLines: aMultiLine ? null : 1,
      textAlign: TextAlign.right,
      controller: aController,
      style: TextStyle(fontSize: 16.0),
      decoration: aEnabled ?
      TextInputDecoration.copyWith(hintText: textInputName) :
      DisabledTextInputDecoration.copyWith(hintText: textInputName), // Disabled Field
      validator: (val) => val.isEmpty ? 'Enter $textInputName' : null,
    );
  }

  Widget buildEventDetailImageIcon(IconData aIcon, Widget aDisplayWidgetDate, Function aFunc) {
    return Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: MaterialButton(
              elevation: 0.0,
              onPressed: () {},
              color: Colors.blue[10],
              padding: EdgeInsets.all(10),
              shape: CircleBorder(side: BorderSide(color: Colors.blue)),
              child:
              IconTheme(
                data: IconThemeData(
                  color: Colors.blue[500],
                ),
                child: Icon(
                  aIcon,
                  size: 30,
                ),
              ),
            ),
          ),

          Expanded(
            flex: 10,
            child: Container(
              alignment: Alignment.centerRight,
              child: aDisplayWidgetDate,
            ),
          ),

          Expanded(
            flex: 2,
            child: MaterialButton(
              elevation: 0.0,
              onPressed: () async {
                await aFunc(context);
              },
              color: Colors.white,
              padding: EdgeInsets.all(10),
              shape: CircleBorder(side: BorderSide(color: Colors.blue)),
              child:
              IconTheme(
                data: IconThemeData(
                  color: Colors.black,
                ),
                child: Icon(
                  Icons.edit,
                  size: 20,
                ),
              ),
            ),
          ),
        ]
    );
  }

  Widget buildUpdateImageButton(String buttonText, Function aFunc, IconData aIcon) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: RaisedButton.icon(
        onPressed: () {aFunc(); },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        label: Text(
          buttonText,
          style: TextStyle(
              color: Colors.white, fontSize: 16.0
          ),
        ),
        icon: Icon(
          aIcon,
          color:Colors.white,
        ),
        textColor: Colors.white,
        color: Colors.blue[400],
      ),
    );
  }
}