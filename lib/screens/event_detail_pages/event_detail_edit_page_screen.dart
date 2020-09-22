import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:rotary_net/BLoCs/bloc_provider.dart';
import 'package:rotary_net/BLoCs/events_list_bloc.dart';
import 'package:rotary_net/objects/event_object.dart';
import 'package:rotary_net/screens/event_detail_pages/event_detail_page_widgets.dart';
import 'package:rotary_net/services/event_service.dart';
import 'package:rotary_net/shared/decoration_style.dart';
import 'package:rotary_net/shared/loading.dart';
import 'package:rotary_net/utils/hebrew_syntax_format.dart';
import 'package:rotary_net/widgets/application_menu_widget.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/widgets/pick_date_time_dialog_widget.dart';
import 'package:rotary_net/utils/utils_class.dart';
import 'package:path/path.dart' as Path;

class EventDetailEditPageScreen extends StatefulWidget {
  static const routeName = '/EventDetailEditPageScreen';
  final EventObject argEventObject;
  final Widget argHebrewEventTimeLabel;

  EventDetailEditPageScreen({Key key, @required this.argEventObject, this.argHebrewEventTimeLabel}) : super(key: key);

  @override
  _EventDetailEditPageScreenState createState() => _EventDetailEditPageScreenState();
}

class _EventDetailEditPageScreenState extends State<EventDetailEditPageScreen> {

  final EventService eventService = EventService();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  //#region Declare Variables
  String currentEventImage;
  bool isEventExist = false;
  Widget currentHebrewEventTimeLabel;

  AssetImage eventImageDefaultAsset;
  DateTime selectedPickStartDateTime;
  DateTime selectedPickEndDateTime;

  TextEditingController eventNameController;
  TextEditingController eventDescriptionController;
  TextEditingController eventLocationController;
  TextEditingController eventManagerController;

  String error = '';
  bool loading = false;
  //#endregion

  @override
  void initState() {
    setEventVariables(widget.argEventObject);

    super.initState();
  }

  //#region Set event Variables
  Future<void> setEventVariables(EventObject aEvent) async {
    eventImageDefaultAsset = AssetImage('assets/images/events/EventImageDefaultPicture.jpg');

    if (aEvent != null)
    {
      isEventExist = true;   /// If Exist ? Update(has Guid) : Insert(copy Guid)

      currentEventImage = aEvent.eventPictureUrl;
      currentHebrewEventTimeLabel = widget.argHebrewEventTimeLabel;

      eventNameController = TextEditingController(text: aEvent.eventName);
      eventDescriptionController = TextEditingController(text: aEvent.eventDescription);
      eventLocationController = TextEditingController(text: aEvent.eventLocation);
      eventManagerController = TextEditingController(text: aEvent.eventManager);

      selectedPickStartDateTime = aEvent.eventStartDateTime;
      selectedPickEndDateTime = aEvent.eventEndDateTime;
    } else {
      isEventExist = false;

      eventNameController = TextEditingController(text: '');
      eventDescriptionController = TextEditingController(text: '');
      eventLocationController = TextEditingController(text: '');
      eventManagerController = TextEditingController(text: '');
    }
  }
  //#endregion

  Future<void> openMenu() async {
    // Open Menu from Left side
    _scaffoldKey.currentState.openDrawer();
  }

  //#region Check Validation
  Future<bool> checkValidation() async {
    bool validationVal = false;

    if (formKey.currentState.validate()){
      if (selectedPickStartDateTime == null)
      {
        validationVal = false;
        setState(() {
          error = "יש להגדיר מועד ושעה לאירוע";
        });
      } else
        validationVal = true;
    }

    return validationVal;
  }
  //#endregion

  //#region Update Event
  Future updateEvent(EventsListBloc aEventBloc) async {

    bool validationVal = await checkValidation();

    if (validationVal){

      String _eventName = (eventNameController.text != null) ? (eventNameController.text) : '';
      String _eventDescription = (eventDescriptionController.text != null) ? (eventDescriptionController.text) : '';
      String _eventLocation = (eventLocationController.text != null) ? (eventLocationController.text) : '';
      String _eventManager = (eventManagerController.text != null) ? (eventManagerController.text) : '';

      String _pictureUrl = '';
      if (currentEventImage != null) _pictureUrl = currentEventImage;

      EventObject _newEventObj;
      if (isEventExist) {
        _newEventObj = eventService.createEventAsObject(
            widget.argEventObject.eventGuidId,
            _eventName, _pictureUrl, _eventDescription,
            selectedPickStartDateTime, selectedPickEndDateTime,
            _eventLocation, _eventManager,);

        await aEventBloc.updateEvent(widget.argEventObject, _newEventObj);
      }
      else {
        String _eventGuidId = await Utils.createGuidUserId();
        _newEventObj = eventService.createEventAsObject(
            _eventGuidId,
            _eventName, _pictureUrl, _eventDescription,
            selectedPickStartDateTime, selectedPickEndDateTime,
            _eventLocation, _eventManager,);

        await aEventBloc.insertEvent(_newEventObj);
      }

      Navigator.pop(context, _newEventObj);
    }
  }
  //#endregion

  //#region Pick DateTime Dialog
  Future<void> openDateTimePickerDialog(BuildContext context) async {

    if (selectedPickStartDateTime == null) selectedPickStartDateTime = DateTime.now();
    if (selectedPickEndDateTime == null) selectedPickEndDateTime = DateTime.now();

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

      setState(() {
        selectedPickStartDateTime = _startDateTime;
        selectedPickEndDateTime = _endDateTime;
        currentHebrewEventTimeLabel = _displayHebrewDateTime;
      });
    }
  }
  //#endregion

  //#region Pick Image File
  Future <void> pickImageFile() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile _compressedImage = await imagePicker.getImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 800
    );

    if (_compressedImage != null)
    {
      if ((currentEventImage != null) && (currentEventImage != ''))
      {
        File originalImageFile = File(currentEventImage);
        originalImageFile.delete();
      }

      File _pickedPictureFile = File(_compressedImage.path);
      String _newEventImagesDirectory = await Utils.createDirectoryInAppDocDir('assets/images/event_images');
      String _newImageFileName =  Path.basename(_pickedPictureFile.path);

      String _copyFilePath = '$_newEventImagesDirectory/$_newImageFileName';

      // copy the file to a new path
      await _pickedPictureFile.copy(_copyFilePath).then((File _newImageFile) {
        if (_newImageFile != null) {

          setState(() {
            currentEventImage = _newImageFile.path;
          });
        }
      });
    }
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :
    Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue[50],

      drawer: Container(
        width: 250,
        child: Drawer(
          child: ApplicationMenuDrawer(),
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
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode()); // Hide Keyboard
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: buildEventDetailDisplay(),
            ),
          ]
      ),
    );
  }

  /// ====================== Event All Fields ==========================
  Widget buildEventDetailDisplay() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                children: <Widget>[
                  /// ------------------- Event Image -------------------------
                  buildEventImage(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          /// ------------------- Input Text Fields ----------------------
                          buildEnabledTextInputWithImageIcon(eventNameController, 'שם אירוע', Icons.description, false),
                          buildEnabledTextInputWithImageIcon(eventManagerController, 'מנהל ואיש קשר', Icons.person, false),
                          buildEnabledTextInputWithImageIcon(eventDescriptionController, 'תיאור האירוע', Icons.view_list, true),
                          buildEnabledTextInputWithImageIcon(eventLocationController, 'מיקום האירוע', Icons.location_on, false),
                          buildEventDetailImageIcon(Icons.event_available, currentHebrewEventTimeLabel, openDateTimePickerDialog),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        buildUpdateButton('עדכון', updateEvent, Icons.update),
        /// ---------------------- Display Error -----------------------
        Text(
          error,
          style: TextStyle(
              color: Colors.red,
              fontSize: 14.0),
        ),
      ],
    );
  }

  Widget buildEventImage() {
    return Stack(
      children: <Widget>[
        Container(
          height: 200.0,
          width: double.infinity,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: (currentEventImage == null) || (currentEventImage == '')
                    ? eventImageDefaultAsset
                    : FileImage(File(currentEventImage)),
                fit: BoxFit.cover
            ),
          ),
        ),
        Positioned(
          bottom: 30.0,
          child: buildUpdateEventImageButton(pickImageFile),
        ),
      ]
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
      validator: (val) => val.isEmpty ? 'הקלד $textInputName' : null,
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
            child: buildUpdateDateTimeButton(aFunc),
          ),
        ]
    );
  }

  Widget buildUpdateEventImageButton(Function aFunc) {
    return MaterialButton(
      elevation: 0.0,
      onPressed: () async {
        await aFunc();
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
          Icons.add_photo_alternate,
          size: 30,
        ),
      ),
    );
  }

  Widget buildUpdateDateTimeButton(Function aFunc) {
    return MaterialButton(
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
    );
  }

  Widget buildUpdateButton(String buttonText, Function aFunc, IconData aIcon) {

    final eventsBloc = BlocProvider.of<EventsListBloc>(context);

    return StreamBuilder<List<EventObject>>(
        stream: eventsBloc.eventsStream,
        initialData: eventsBloc.eventsList,
        builder: (context, snapshot) {
          List<EventObject> currentEventsList =
          (snapshot.connectionState == ConnectionState.waiting)
              ? eventsBloc.eventsList
              : snapshot.data;

        return RaisedButton.icon(
          onPressed: () {
            aFunc(eventsBloc);
          },
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
        );
      }
    );
  }
}
