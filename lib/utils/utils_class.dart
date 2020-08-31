import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

class Utils {

  static Future<void> makePhoneCall(String aPhoneNumber) async {
    try {
      final String _phoneCommand = "tel:$aPhoneNumber";
      if (await canLaunch(_phoneCommand)) {
        await launch(_phoneCommand);
      } else {
        throw 'Could not Make a Phone Call: $aPhoneNumber';
      }
    }
    catch (ex) {
      print ('${ex.toString()}');
    }
  }

  static Future<void> sendSms(String aPhoneNumber) async {
    try {
      final String _phoneCommand = "sms:$aPhoneNumber";
      if (await canLaunch(_phoneCommand)) {
        await launch(_phoneCommand);
      } else {
        throw 'Could not Send an SMS to: $aPhoneNumber';
      }
    }
    catch (ex) {
      print ('${ex.toString()}');
    }
  }

  static Future<void> sendEmail(String aMail) async {
    try {
      final Uri _emailLaunchUri = Uri(
          scheme: 'mailto',
          path: aMail,
          queryParameters: {
            'subject': 'Enter Subject...'
          }
      );
      launch(_emailLaunchUri.toString());
    }
    catch (ex) {
      print ('Could not send an Email To: ${ex.toString()}');
    }
  }

  static Future<void> launchInBrowser(String aUrl) async {
    try {
      if (await canLaunch(aUrl)) {
        await launch(
          aUrl,
          forceSafariVC: false,
          forceWebView: false,
//        headers: <String, String>{'my_header_key': 'my_header_value'},
        );
      } else {
        throw 'Could not Launch In Browser: $aUrl';
      }
    }
    catch (ex){
      print ('${ex.toString()}');
    }
  }

  static Future<void> launchInMapByAddress(String aAddress) async {
    try {
      final url = 'https://www.google.com/maps/search/${Uri.encodeFull(aAddress)}';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    catch (ex){
      print ('${ex.toString()}');
    }
  }

  Future<void> launchInMapByPosition(String aAddress) async {
    try {
      List<Placemark> placeMarksList = await Geolocator().placemarkFromAddress(aAddress);
//      print ('>>>>>>>> Placemarks: ${placemarks[0].toJson()}');

      if (placeMarksList != null && placeMarksList.isNotEmpty) {
        final List<String>position = placeMarksList.map((placeMark) =>
        placeMark.position?.latitude.toString() + ', ' + placeMark.position?.longitude.toString()).toList();
//        print ('>>>>>>>> coords: ${position}');

        final Placemark pos = placeMarksList[0];
        double latitude = pos.position?.latitude;
        double longitude = pos.position?.longitude;
//        print ('>>>>>>>> Latitude: $latitude, Longitude: $longitude');

        String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
        if (await canLaunch(googleUrl)) {
          await launch(googleUrl);
        } else {
          throw 'Could not open the map.';
        }
      }
    }
    catch (ex){
      print ('${ex.toString()}');
    }
  }

  static Future<void> openCalendar(String aDateTime) async {
    try {
      // final String _dateTimeCommand = "content://com.android.calendar/time/$aDateTime";
      // final String _dateTimeCommand = "content://com.android.calendar/time/2015-05-28T09:00:00-07:00";
      final String _dateTimeCommand = "content://com.android.calendar/time/";
      if (await canLaunch(_dateTimeCommand)) {
        await launch(_dateTimeCommand);
      } else {
        throw 'Could not open Calendar: $aDateTime';
      }
    }
    catch (ex) {
      print ('${ex.toString()}');
    }
  }

  static Future<void> addEventToCalendar(String aTitle, String aDescription, String aLocation, DateTime aStartDateTime, DateTime aEndDateTime) async {
    try {

      final Event event = Event(
        title: aTitle,
        description: aDescription,
        location: aLocation,
        startDate: aStartDateTime,
        endDate: aEndDateTime,
        //   endDate: DateTime.now().add(Duration(days: 1)),
      );

      Add2Calendar.addEvent2Cal(event);
    }
    catch (ex) {
      print ('${ex.toString()}');
    }
  }
}