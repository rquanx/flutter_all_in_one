import 'package:flutter_application_1/store/store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterState {
  int count;
  String name = 'hello';
  CounterState({required this.count});

  CounterState copyWith({int? count}) {
    return CounterState(count: count ?? this.count);
  }
}

/// riverpod 是用于共享状态的，不是用在组件内状态，是类似 store 的东西
final counterProvider = StateProvider((ref) => CounterState(count: 0));

final useCounterStore = useStore(counterProvider);
