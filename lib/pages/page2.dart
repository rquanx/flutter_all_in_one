import 'package:flutter/material.dart';
import 'package:flutter_application_1/store/counter.dart';
import 'package:flutter_application_1/components/counter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Page2 extends ConsumerWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final x = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Page 2')),
      body: Column(
        children: [
          Text(x.toString()),
          ElevatedButton(
            onPressed:
                () => ref.read(counterProvider.notifier).state++,
            child: const Text('button'),
          ),
          Counter()
        ],
      ),
    );
  }
}
