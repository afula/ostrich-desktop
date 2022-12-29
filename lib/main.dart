import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ostrich_flutter/unit/http.dart';
import 'package:ostrich_flutter/unit/init.dart';
import 'package:ostrich_flutter/view/addServerList.dart';
import 'package:ostrich_flutter/view/home/home/home.dart';
import 'package:window_manager/window_manager.dart';
import 'view/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'node/bloc/node_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await windowManager.setPreventClose(true);
  await windowManager.setMinimizable(true);
  InitBeforeLaunch().platformInit();
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
          "/add_server": (context) => const AddServerList(),
          "/main_menu": (context) => const HomePage(),
          "/home_page": (context) => const MyHomePage(title: "Ostrich")
        },
        home: const MyHomePage(title: 'Ostrich'),
        builder: EasyLoading.init(),
      ),
    );
  }
}
