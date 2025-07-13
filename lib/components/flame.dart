import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/store/counter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Flame extends HookConsumerWidget {
  const Flame({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = FlameGame();
    return GameWidget(game: game);
  }
}
