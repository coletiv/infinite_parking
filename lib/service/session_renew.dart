import 'package:coletiv_infinite_parking/data/model/fare.dart';
import 'package:coletiv_infinite_parking/data/model/session.dart';
import 'package:coletiv_infinite_parking/network/client/fare_client.dart';
import 'package:coletiv_infinite_parking/network/client/session_client.dart';
import 'package:coletiv_infinite_parking/data/session_manager.dart';
import 'package:coletiv_infinite_parking/service/push_notifications.dart';
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
    await pushNotifications.show(
      "Your parking session was scheduled to renew automatically",
      "It will be renewed at ${session.getFormattedFinalDate()}",
    );
    print("Session will be renewed at ${session.getFinalDate()}");
  } else {
    await pushNotifications.show(
      "Your parking session will not renew automatically",
      "Once it's over you must open the app to renewed it manually",
    );
    await sessionManager.deleteParkingSession();
    print("Session was not scheduled to auto renew");
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
    await pushNotifications.show(
      "Your parking session was not renewed",
      "Please, open the app and renew it manually",
    );
    await sessionManager.deleteParkingSession();
    print("Session not renewed - Fare is invalid");
    return;
  }

  Session session = await sessionClient.refreshSession(fare);

  if (session != null) {
    scheduleSessionRenew(session);
    await pushNotifications.show(
      "Your parking session was successfully renewed",
      "It will last until ${session.getFormattedFinalDate()}",
    );
    print("Session renewed successfully until ${session.getFinalDate()}");
  } else {
    await pushNotifications.show(
      "Your parking session was not renewed",
      "Please, open the app and renew it manually",
    );
    await sessionManager.deleteParkingSession();
    print("Session not renewed");
  }
}
