import 'package:flutter/material.dart';
import 'package:flutter_application_1/store/counter.dart';
import 'package:flutter_application_1/components/counter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Page2 extends ConsumerWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterStore = useCounterStore(ref);
    return Scaffold(
      appBar: AppBar(title: const Text('Page 2')),
      body: Column(
        children: [
          Text(counterStore.state.count.toString()),
          ElevatedButton(
            onPressed:
                () =>
                    counterStore.update((s) => s.copyWith(count: s.count + 1)),
            child: const Text('button'),
          ),
          Counter(),
        ],
      ),
    );
  }
}
