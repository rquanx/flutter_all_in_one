import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// 函数 hooks
ValueNotifier<T?> useLoggedState<T>([T? initialData]) {
  final result = useState<T?>(initialData);
  useValueChanged<T?, T?>(result.value, (_, __) {
    print(result.value);
  });
  return result;
}

/// 类 hooks
class _TimeAlive extends Hook<DateTime> {
  const _TimeAlive();

  @override
  _TimeAliveState createState() => _TimeAliveState();
}

class _TimeAliveState extends HookState<DateTime, _TimeAlive> {
  DateTime start = DateTime.now();

  @override
  void initHook() {
    super.initHook();
    start = DateTime.now();
  }

  @override
  DateTime build(BuildContext context) => start;

  @override
  void dispose() {
    print(DateTime.now().difference(start));
    super.dispose();
  }
}

DateTime useTimeAlive() => use(_TimeAlive());