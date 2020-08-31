
import 'package:rotary_net/objects/event_object.dart';
import 'package:rotary_net/objects/login_object.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/user_object.dart';

class ArgDataUserObject {
  UserObject passUserObj;
  LoginObject passLoginObj;

  ArgDataUserObject(
      this.passUserObj,
      this.passLoginObj);
}

class ArgDataPersonCardObject {
  UserObject passUserObj;
  PersonCardObject passPersonCardObj;
  LoginObject passLoginObj;

  ArgDataPersonCardObject(
      this.passUserObj,
      this.passPersonCardObj,
      this.passLoginObj);
}

class ArgDataEventObject {
  UserObject passUserObj;
  EventObject passEventObj;
  LoginObject passLoginObj;

  ArgDataEventObject(
      this.passUserObj,
      this.passEventObj,
      this.passLoginObj);
}