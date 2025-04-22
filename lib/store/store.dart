import 'package:hooks_riverpod/hooks_riverpod.dart';

({
  StateController<T> Function() raw,
  T state,
  dynamic Function(T Function(T)) update,
})
Function(WidgetRef)
useStore<T>(StateProvider<T> provider) {
  ({
    StateController<T> Function() raw,
    T state,
    dynamic Function(T Function(T)) update,
  })
  x(WidgetRef ref) {
    final state = ref.watch(provider);
    return (
      state: state,
      update: (T Function(T state) cb) {
        ref.read(provider.notifier).update(cb);
      },
      raw: () {
        return ref.read(provider.notifier);
      },
    );
  }
  return x;
}
