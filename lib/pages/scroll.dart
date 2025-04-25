import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScrollPage extends StatefulWidget {
  const ScrollPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<ScrollPage> createState() => _ScrollPageState();
}

class _ScrollPageState extends State<ScrollPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('You have pushed the button this many times:'),

                // 添加更多内容以演示滚动效果
                Container(
                  height: 2000, // 增加高度以演示滚动
                  color: Colors.blue.withOpacity(0.1),
                  child: Center(child: Text('更多内容区域')),
                ),
                Container(
                  height: 10, // 增加高度以演示滚动
                  color: Colors.red,
                  child: Center(child: Text('更多内容区域')),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.go("/counter");
          },
          tooltip: 'counter',
          child: const Icon(Icons.accessible_forward),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
