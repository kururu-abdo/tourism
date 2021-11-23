import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationProvider {
bool isAlowed;
void   requestNotification() {
AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((value){

                        isAlowed=value;
                      });

}
NotificationProvider(){
 AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
   isAlowed=isAllowed;

 });

}

}