import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'node.dart';
import 'mouse.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  final List<Widget> _pages = [const NodeService(), const AboutMousePage()];

  final List<String> _titles = [
    '设置',
    '节点',
  ];

  int _currentIndex = 0;

  void _closeApp() async {
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    windowManager.addListener(this);
    _closeApp();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    bool _isClose = await windowManager.isPreventClose();
    if (_isClose) {
      showDialog<void>(
        context: context,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('警告'),
            content: const Text('即将关闭本程序，是否继续？'),
            actions: <Widget>[
              TextButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
              TextButton(
                child: const Text('关闭'),
                onPressed: () async {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  await windowManager.destroy();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(
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
                      _currentIndex = index;
                      setState(() {});
                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        _titles[index],
                        style: TextStyle(
                            color: _currentIndex == index
                                ? Colors.white
                                : Colors.black),
                      ),
                      color: _currentIndex == index
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
              index: _currentIndex,
              children: _pages,
            ),
          )
        ],
      ),
    );
  }
}
