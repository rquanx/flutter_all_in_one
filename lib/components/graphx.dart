import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/zoom_gesture_scene.dart';
import 'package:flutter_application_1/hooks/example.dart';
import 'package:flutter_application_1/services/post.dart';
import 'package:fquery/fquery.dart';
import 'package:graphx/graphx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_application_1/store/counter.dart';

class Graphx extends HookConsumerWidget {
  const Graphx({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterStore = useCounterStore(ref);
    final scene = ZoomGestureScene();
    return GestureDetector(
      onScaleStart: scene.onScaleStart,
      onScaleUpdate: scene.onScaleUpdate,
      child: SceneBuilderWidget(
        autoSize: true,
        builder: () => SceneController(front: scene),
      ),
    );
    // return Center(
    //   child: SceneBuilderWidget(
    //     /// wrap any Widget with SceneBuilderWidget
    //     builder: () => SceneController(front: GameSceneFront()),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         Text('You have pushed the button this many times:'),
    //         Text(counterStore.state.count.toString()),
    //       ],
    //     ),
    //   ),
    // );
  }
}
