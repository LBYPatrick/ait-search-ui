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

  Color get seedColor => Colors.deepPurple;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ProviderScope(
          child: RiverpodWrapper(
        builder: (context, widgetRef) => MaterialApp.router(
          title: "AIT SearchSys",
          theme: ThemeData(
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a blue toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                  brightness: Brightness.dark, seedColor: seedColor)),
          routerDelegate: Routing.cachedRouter().routerDelegate,
          routeInformationProvider:
              Routing.cachedRouter().routeInformationProvider,
          routeInformationParser: Routing.cachedRouter().routeInformationParser,
        ),
      ));
}
