import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fquery/fquery.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './router.dart';

final queryClient = QueryClient(
  defaultQueryOptions: DefaultQueryOptions(
    cacheDuration: Duration(minutes: 20),
    refetchInterval: Duration(minutes: 5),
    refetchOnMount: RefetchOnMount.always,
    staleDuration: Duration(minutes: 3),
  ),
);

void main() {
  runApp(
    ProviderScope(
      child: QueryClientProvider(
        queryClient: queryClient,
        child: const ProviderScope(child: MyApp()),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 750),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return OKToast(
          child: MaterialApp.router(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            routerConfig: router,
          ),
        );
      },
    );
  }
}
