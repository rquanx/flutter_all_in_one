import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef Store<T> =
    ({
      StateController<T> Function() raw,
      T state,
      void Function(T Function(T)) update,
    });

Store<T> Function(WidgetRef) useStore<T>(StateProvider<T> provider) {
  return (WidgetRef ref) {
    final state = ref.watch(provider);
    return (
      raw: () => ref.read(provider.notifier),
      state: state,
      update: (cb) => ref.read(provider.notifier).update(cb),
    );
  };
}
