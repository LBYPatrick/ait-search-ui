import 'package:ait_search_ui/global/providers.dart';
import 'package:ait_search_ui/routing.dart';
import 'package:ait_search_ui/util/riverpod_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: RiverpodWrapper(
      builder: (context, widgetRef) => MaterialApp.router(
        title: "AIT SearchSys",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: widgetRef.watch(Providers.themeColor)),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
                brightness: Brightness.dark,
                seedColor: widgetRef.watch(Providers.themeColor))),
        routerDelegate: Routing.cachedRouter().routerDelegate,
        routeInformationProvider:
            Routing.cachedRouter().routeInformationProvider,
        routeInformationParser: Routing.cachedRouter().routeInformationParser,
      ),
    ));
  }
}
