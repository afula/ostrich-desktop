import 'package:flutter/material.dart';
// import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
// import 'package:tray_manager/tray_manager.dart' as tray_manager;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ostrich_flutter/node/bloc/node_bloc.dart';
import '../../generated/l10n.dart';
import 'login.dart';
import 'node_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  final List<Widget> _pages = [const LoginService(), const NodelistPage()];

  void _closeApp() async {
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    windowManager.addListener(this);
    _closeApp();
    // _initSystemTray();
    // _setMenu();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    // bool _isClose = await windowManager.isPreventClose();
    windowManager.hide();
/*     if (!_isClose) {
      // Navigator.of(context).pop(); // Dismiss alert dialog
      await windowManager.hide();
    } else {
      showDialog<void>(
        context: context,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('警告'),
            content: const Text('即将关闭代理，是否继续？'),
            actions: <Widget>[
              TextButton(
                child: const Text('不关闭'),
                onPressed: () async {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  await windowManager.hide();
                },
              ),
              TextButton(
                child: const Text('关闭'),
                onPressed: () async {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  var running = await nativeApi.isRunning();
                  if (running) {
                    await _winKillPid();
                  }
                  Future.delayed(const Duration(milliseconds: 1500), () {
                    exit(0);
                  });
                },
              ),
            ],
          );
        },
      );
    } */
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _titles = [
      S.of(context).setting,
      S.of(context).node,
    ];
    return Scaffold(body: BlocBuilder<NodeBloc, NodeState>(
        // bloc:,
        builder: (context, state) {
      return Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (index != state.currentMenuIndex) {
                        context.read<NodeBloc>().add(
                              UpdateMenuIndexEvent(index: index),
                            );
                      }
                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        _titles[index],
                        style: TextStyle(
                            color: state.currentMenuIndex == index
                                ? Colors.white
                                : Colors.black),
                      ),
                      color: state.currentMenuIndex == index
                          ? Colors.blue.withOpacity(.8)
                          : Colors.white,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    height: 1,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Divider(color: Colors.grey[200]),
                  );
                },
                itemCount: _titles.length,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: IndexedStack(
              index: state.currentMenuIndex,
              children: _pages,
            ),
          )
        ],
      );
    }));
  }

  @override
  void onWindowMinimize() {
    windowManager.hide();
  }
}
