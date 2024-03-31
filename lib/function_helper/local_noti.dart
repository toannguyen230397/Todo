import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';

void setNoti(String date, String title, String desc, int notiID) async {
    final alarmSettings = AlarmSettings(
    id: notiID,
    dateTime: DateTime.parse(date),
    assetAudioPath: 'assets/alarm.mp3',
    loopAudio: true,
    vibrate: true,
    fadeDuration: 3.0,
    notificationTitle: title,
    notificationBody: desc,
    enableNotificationOnKill: true,
    );
    await Alarm.set(alarmSettings: alarmSettings);
  }