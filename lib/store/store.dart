import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class ComplexState {
  ComplexState copyWith({int? count});
}

({T state, dynamic Function(T Function(T)) update}) Function(WidgetRef)
useStore<T>(StateProvider<T> provider) {
  ({T state, Function(T Function(T)) update}) x(WidgetRef ref) {
    final state = ref.watch(provider);
    return (
      state: state,
      update: (T Function(T state) cb) {
        ref.read(provider.notifier).update(cb);
      },
    );
  }
  return x;
}
