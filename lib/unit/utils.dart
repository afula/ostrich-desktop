import 'package:local_notifier/local_notifier.dart';
import '../../generated/l10n.dart';

void ostrichStartSuccessNotification(String body) async {
  final notification = LocalNotification(
    // 用来生成通用唯一识别码
    identifier: '_ostrichStartNotification',
    title: 'Ostrich',
    body: body,
    // 用来设置是否静音
    silent: true,
    // actions: [
    //   LocalNotificationAction(
    //     text: 'Yes',
    //   ),
    //   LocalNotificationAction(
    //     text: 'No',
    //   ),
    // ],
  );
  notification.show();
}

void ostrichStartFailedNotification(String body) async {
  final notification = LocalNotification(
    // 用来生成通用唯一识别码
    identifier: '_ostrichStartNotification',
    title: 'Ostrich',
    body: body,
    // 用来设置是否静音
    silent: true,
    // actions: [
    //   LocalNotificationAction(
    //     text: 'Yes',
    //   ),
    //   LocalNotificationAction(
    //     text: 'No',
    //   ),
    // ],
  );
  notification.show();
}

void ostrichCloseSuccessNotification(String body) async {
  final notification = LocalNotification(
    // 用来生成通用唯一识别码
    identifier: '_ostrichCloseNotification',
    title: 'Ostrich',
    body: body,
    // 用来设置是否静音
    silent: true,
  );
  notification.show();
}

void ostrichCloseFailedNotification(String body) async {
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

void ostrichSwitchSuccessNotification(String body) async {
  final notification = LocalNotification(
    // 用来生成通用唯一识别码
    identifier: '_ostrichSwitchSuccessNotification',
    title: 'Ostrich',
    body: body,
    // 用来设置是否静音
    silent: true,
    // actions: [
    //   LocalNotificationAction(
    //     text: 'Yes',
    //   ),
    //   LocalNotificationAction(
    //     text: 'No',
    //   ),
    // ],
  );
  notification.show();
}

void ostrichSwitchFailedNotification(String body) async {
  final notification = LocalNotification(
    // 用来生成通用唯一识别码
    identifier: '_ostrichSwitchFailedNotification',
    title: 'Ostrich',
    body: body,
    // 用来设置是否静音
    silent: true,
    // actions: [
    //   LocalNotificationAction(
    //     text: 'Yes',
    //   ),
    //   LocalNotificationAction(
    //     text: 'No',
    //   ),
    // ],
  );
  notification.show();
}
