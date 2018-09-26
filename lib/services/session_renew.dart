import 'package:coletiv_infinite_parking/data/model/session.dart';
import 'package:coletiv_infinite_parking/network/client/session_client.dart';
import 'package:coletiv_infinite_parking/data/session_manager.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

const int _sessionScheduleId = 1;

void scheduleSessionRenew(Session session) async {
  if (!await sessionManager.needToRenewSession()) {
    return;
  }

  Duration delay = session.getDuration() + Duration(seconds: 10);

  bool isScheduled = await AndroidAlarmManager.oneShot(
      delay, _sessionScheduleId, _onRenewSession);
  
  if (isScheduled) {
    print("Session to be renewed in ${delay.inMinutes} minutes");
  } else {
    print("There was a problem scheduling the session renew");
  }
}

void _onRenewSession() async {
  Session session = await sessionClient.refreshSession();
  
  if (session != null) {
    print("Session renewed successfully until ${session.getFinalDate()}");
  } else {
    print("There was a problem renewing your session");
  }
}
