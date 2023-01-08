import 'package:local_notifier/local_notifier.dart';

void ostrichStartNotification() async {
  final notification = LocalNotification(
    // 用来生成通用唯一识别码
    identifier: '_ostrichStartNotification',
    title: 'Ostrich',
    body: '代理已启动',
    // 用来设置是否静音
    silent: true,
    actions: [
      LocalNotificationAction(
        text: 'Yes',
      ),
      LocalNotificationAction(
        text: 'No',
      ),
    ],
  );
  notification.show();
}

void ostrichCloseNotification() async {
  final notification = LocalNotification(
    // 用来生成通用唯一识别码
    identifier: '_ostrichCloseNotification',
    title: 'Ostrich',
    body: '代理已关闭',
    // 用来设置是否静音
    silent: true,
  );
  notification.show();
}
