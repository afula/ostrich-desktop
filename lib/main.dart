import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ostrich_flutter/unit/http.dart';
import 'package:ostrich_flutter/unit/init.dart';
import 'package:ostrich_flutter/view/home/home/home.dart';
import 'package:ostrich_flutter/view/home/home/server_list.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'node/bloc/node_bloc.dart';
import 'package:local_notifier/local_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localNotifier.setup(
    appName: Platform.isWindows ? 'Ostrich_Windows' : 'Ostrich_Macos',
    shortcutPolicy: ShortcutPolicy.requireCreate,
  );
  InitBeforeLaunch().platformInit();
  await windowManager.ensureInitialized();
  await windowManager.setPreventClose(true);
  await windowManager.setMinimizable(true);
  HttpNetwork.init();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    center: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    print("waitUntilReadyToShow");
    await windowManager.focus();
  });

  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 3000)
    ..loadingStyle = EasyLoadingStyle.light
    ..radius = 8.0;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NodeBloc(),
      child: MaterialApp(
        title: 'Ostrich Desktop',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          fontFamily: 'Microsoft YaHei',
        ),
        routes: {
          "/main_menu_setting": (context) => const HomePage(),
          "/main_menu_server_list": (context) => const ServerlistPage(),
          // "/home_page": (context) => const MyHomePage(title: "Ostrich")
        },
        home: const HomePage(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
