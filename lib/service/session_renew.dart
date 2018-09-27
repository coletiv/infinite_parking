import 'package:coletiv_infinite_parking/data/model/fare.dart';
import 'package:coletiv_infinite_parking/data/model/session.dart';
import 'package:coletiv_infinite_parking/network/client/fare_client.dart';
import 'package:coletiv_infinite_parking/network/client/session_client.dart';
import 'package:coletiv_infinite_parking/data/session_manager.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

const int _sessionScheduleId = 1;

void scheduleSessionRenew(Session session) async {
  if (!await _needToRenewSession()) {
    await sessionManager.deleteParkingSession();
    return;
  }

  Duration delay = session.getDuration() + Duration(seconds: 30);

  bool isScheduled = await AndroidAlarmManager.oneShot(
    delay,
    _sessionScheduleId,
    _renewSession,
    exact: true,
    wakeup: true,
  );

  if (isScheduled) {
    // TODO: show push notification saying that his session will renew
    print(
        "Session will be renewed in ${session.getDuration().inMinutes} minutes");
  } else {
    // TODO: show push notification saying that his session will not renew
    await sessionManager.deleteParkingSession();
    print("Session renew could not be scheduled");
  }
}

Future cancelSessionRenew() async =>
    AndroidAlarmManager.cancel(_sessionScheduleId);

Future<bool> _needToRenewSession() async {
  DateTime selectedTime = await sessionManager.getSelectedTime();
  if (DateTime.now().isAfter(selectedTime)) {
    return false;
  }

  Fare fare = await fareClient.getSelectedFare();
  if (fare == null || fare.getSelectedFares(selectedTime).isEmpty) {
    return false;
  }

  return true;
}

void _renewSession() async {
  DateTime selectedTime = await sessionManager.getSelectedTime();
  if (DateTime.now().isAfter(selectedTime)) {
    await sessionManager.deleteParkingSession();
    return;
  }

  Fare fare = await fareClient.getSelectedFare();
  if (fare == null) {
    // TODO: show push notification saying that there was a problem renewing
    print("Couldn't get fare");
    return;
  }

  Session session = await sessionClient.refreshSession(fare);

  if (session != null) {
    scheduleSessionRenew(session);
    // TODO: show push notification saying that his session is being renewed
    print("Session renewed successfully until ${session.getFinalDate()}");
  } else {
    // TODO: show push notification saying that there was a problem renewing
    await sessionManager.deleteParkingSession();
    print("Session not renewed");
  }
}
