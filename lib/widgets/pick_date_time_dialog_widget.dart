import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart' as SymbolData;
import 'package:intl/intl.dart' as Intl;

class PickDateTimeDialogWidget extends StatefulWidget {
  final DateTime argStartDateTime;
  final DateTime argEndDateTime;
  final Map argDatesMapObj;

  PickDateTimeDialogWidget({Key key, @required this.argStartDateTime, @required this.argEndDateTime,
    this.argDatesMapObj});

  @override
  _PickDateTimeDialogWidgetState createState() => _PickDateTimeDialogWidgetState();
}

class _PickDateTimeDialogWidgetState extends State<PickDateTimeDialogWidget> {
  DateTime pickedStartDateTime;
  DateTime pickedEndDateTime;

  String hebrewStartDate;
  String hebrewStartTime;
  String hebrewEndDate;
  String hebrewEndTime;

  @override
  void initState() {
    super.initState();
    setEventVariables();
  }

  //#region Set event Variables
  Future<void> setEventVariables() async {

    pickedStartDateTime = widget.argStartDateTime;
    pickedEndDateTime = widget.argEndDateTime;

    hebrewStartDate = widget.argDatesMapObj["HebrewStartDate"];
    hebrewEndDate = widget.argDatesMapObj["HebrewEndDate"];
    hebrewStartTime = widget.argDatesMapObj["HebrewStartTime"];
    hebrewEndTime = widget.argDatesMapObj["HebrewEndTime"];
  }
  //#endregion

  //#region Close Picker And Return EventDateTime Values Event
  Future closePickerEventAndReturnDateTimeValues() async {
    /// Return multiple data using MAP
    final returnDataDateTimeMap = {
      "EventPickedStartDateTime": pickedStartDateTime,
      "EventPickedEndDateTime": pickedEndDateTime,
    };
    Navigator.pop(context, returnDataDateTimeMap);
  }
  //#endregion

  @override
  Widget build(BuildContext context){

    var radius = Radius.circular(5);

    return AlertDialog(
      content: Container(
        height: 300,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              right: -40.0,
              top: -40.0,
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  child: Icon(Icons.close),
                  backgroundColor: Colors.red,
                ),
              ),
            ),

            Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      initialIndex: 0,
                      child: Scaffold(
                        appBar: PreferredSize(
                          preferredSize: Size.fromHeight(50),
                          child: Container(
                            color: Colors.lightBlue[400],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TabBar(
                                  indicatorColor: Colors.white,
                                  labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),   //For Selected tab
                                  unselectedLabelStyle: TextStyle(fontSize: 12.0),                      //For Un-selected Tabs
                                  tabs: <Widget>[
                                    Tab(text :"מועד התחלה"),
                                    Tab(text :"מועד סיום"),
                                  ],
                                  indicator: ShapeDecoration(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: radius, topLeft: radius)),
                                      color: Colors.lightBlue[700]
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        body: TabBarView(
                          children: <Widget>[
                            /// --------------- TAB: Start Event Time ---------------------
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
                              child: Column(
                                textDirection: TextDirection.rtl,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      hebrewStartDate,
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    leading: Icon(Icons.calendar_today, color: Colors.blue),
                                    onTap: pickStartDate,
                                  ),
                                  ListTile(
                                    title: Text(
                                      hebrewStartTime,
                                      // "${pickedStartTime.hour}:${pickedStartTime.minute}",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    leading: Icon(Icons.access_time, color: Colors.blue),
                                    onTap: pickStartTime,
                                  ),
                                ],
                              ),
                            ),

                            /// --------------- TAB: End Event Time ---------------------
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
                              child: Column(
                                textDirection: TextDirection.rtl,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      hebrewEndDate,
                                      // "${pickedEndDate.year}, ${pickedEndDate.month}, ${pickedEndDate.day}",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    leading: Icon(Icons.calendar_today, color: Colors.blue),
                                    onTap: pickEndDate,
                                  ),
                                  ListTile(
                                    title: Text(
                                      hebrewEndTime,
                                      // "${pickedEndTime.hour}:${pickedEndTime.minute}",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    leading: Icon(Icons.access_time, color: Colors.blue,),
                                    onTap: pickEndTime,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  buildUpdateImageButton('אישור', closePickerEventAndReturnDateTimeValues, Icons.check_circle_outline),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  pickStartDate() async {
    DateTime _dateTime = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year-5),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: pickedStartDateTime,
    );

    await SymbolData.initializeDateFormatting("he", null);
    var formatterDateTime = Intl.DateFormat.yMMMMEEEEd('he');
    String _hebrewDateTime = formatterDateTime.format(_dateTime);
    if(_dateTime != null)
      setState(() {
        pickedStartDateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day, pickedStartDateTime.hour, pickedStartDateTime.minute);
        hebrewStartDate = _hebrewDateTime;
      });
  }

  pickEndDate() async {
    DateTime _dateTime = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year-5),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: pickedEndDateTime,
    );

    await SymbolData.initializeDateFormatting("he", null);
    var formatterDateTime = Intl.DateFormat.yMMMMEEEEd('he');
    String _hebrewDateTime = formatterDateTime.format(_dateTime);
    if(_dateTime != null)
      setState(() {
        pickedEndDateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day, pickedEndDateTime.hour, pickedEndDateTime.minute);
        hebrewEndDate = _hebrewDateTime;
      });
  }

  pickStartTime() async {
    TimeOfDay _currentStartTime = TimeOfDay.fromDateTime(pickedStartDateTime);
    TimeOfDay _time = await showTimePicker(
        context: context,
        initialTime: _currentStartTime
    );

    DateTime _dateTime = DateTime(pickedStartDateTime.year, pickedStartDateTime.month, pickedStartDateTime.day, _time.hour, _time.minute);
    await SymbolData.initializeDateFormatting("he", null);
    var formatterStartTime = Intl.DateFormat.Hm('he');
    String _hebrewStartTime = formatterStartTime.format(_dateTime);

    if(_time != null)
      setState(() {
        pickedStartDateTime = _dateTime;
        hebrewStartTime = _hebrewStartTime;
      });
  }

  pickEndTime() async {
    TimeOfDay _currentEndTime = TimeOfDay.fromDateTime(pickedEndDateTime);
    TimeOfDay _time = await showTimePicker(
        context: context,
        initialTime: _currentEndTime
    );

    DateTime _dateTime = DateTime(pickedEndDateTime.year, pickedEndDateTime.month, pickedEndDateTime.day, _time.hour, _time.minute);
    await SymbolData.initializeDateFormatting("he", null);
    var formatterStartTime = Intl.DateFormat.Hm('he');
    String _hebrewEndTime = formatterStartTime.format(_dateTime);

    if(_time != null)
      setState(() {
        pickedEndDateTime = _dateTime;
        hebrewEndTime = _hebrewEndTime;
      });
  }

  Widget buildUpdateImageButton(String buttonText, Function aFunc, IconData aIcon) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
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
