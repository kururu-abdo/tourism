import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:tourapp/core/models/trip.dart';
import 'package:tourapp/services/notification_utils.dart';
///TODO: change notification button lables :  ok:  حسنا
Future<void> createWaterReminderNotification(
   Trip      model) async {
  print("---------------------TIME-----------------------");
  print(model.date);


  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: model.id ,
      channelKey: 'scheduled_channel',
      title: "Trip Reminder",
      body: model.location,
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Mark Done',
      ),
    ],
    schedule: NotificationCalendar(
      year: getTime(model.date).year,
      month: getTime(model.date).month,
      day :getTime(model.date).day,
      hour :getTime(model.date).hour ,
      minute: getTime(model.date).minute,
      second: 0,
      repeats: true,
    ),
  );























}
Future<void> cancelScheduledNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
}
Future<void> cancelScheduledNotification(int id) async {
  await AwesomeNotifications().cancelSchedule(id);
}


DateTime  getTime(String date) {
var dateTime =  DateTime.parse(date);
  return  dateTime;
}