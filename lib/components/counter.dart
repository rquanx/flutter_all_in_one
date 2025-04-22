import 'package:flutter/material.dart';
import 'package:flutter_application_1/hooks/example.dart';
import 'package:flutter_application_1/services/post.dart';
import 'package:fquery/fquery.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_application_1/store/counter.dart';

class Counter extends HookConsumerWidget {
  const Counter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = useQuery(['posts'], getPosts);

    final funHook = useLoggedState(2);
    final classHook = useTimeAlive();
    final counterStore = useCounterStore(ref);
    return Column(
      children: [
        Text(counterStore.state.count.toString()),
        Text('value: ${funHook.value}'),
        Text('classHook: ${classHook.toString()}'),
        ElevatedButton(
          // onPressed: () => counterStore.state().count++,
          onPressed: () {
            counterStore.update(
              (state) => state.copyWith(count: state.count + 1),
            );
          },
          child: const Text('button'),
        ),
        ElevatedButton(
          onPressed: () => {funHook.value = (funHook.value ?? 0) + 1},
          child: const Text('update hooks'),
        ),
        Builder(
          builder: (context) {
            if (posts.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (posts.isError) {
              return Center(child: Text(posts.error!.toString()));
            }

            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: (posts.data?.length ?? 0) > 0 ? 10 : 0,
              itemBuilder: (context, index) {
                final post = posts.data![index];
                return ListTile(title: Text(post.title));
              },
            );
          },
        ),
      ],
    );
  }
}
