import 'package:ait_search_ui/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Routing {
  static GoRouter? _cachedRouter;

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static Widget fullScreenPage(Widget? pageWidget) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: pageWidget);

  static opaquePage(Widget? child, BuildContext context) =>
      Container(color: Theme.of(context).colorScheme.background, child: child);

  //A wrapper function to avoid spawning router twice
  static GoRouter cachedRouter({BuildContext? context, WidgetRef? widgetRef}) {
    _cachedRouter ??= getRouter(context: context, widgetRef: widgetRef);
    return _cachedRouter!;
  }

  static GoRouter getRouter({BuildContext? context, WidgetRef? widgetRef}) {
    return GoRouter(
        initialLocation: "/",
        navigatorKey: _rootNavigatorKey,
        routes: [
          //Pages with nav bar
          ShellRoute(
            parentNavigatorKey: _rootNavigatorKey,
            routes: [
              GoRoute(path: "/", builder: (context, state) => HomePage(state)),
            ],
            builder: (context, state, pageWidget) => Scaffold(body: pageWidget),
          ),
          // GoRoute(
          //     parentNavigatorKey: _rootNavigatorKey,
          //     path: "/nfc-scan",
          //     builder: (context, state) => const NfcPage())
          //Login pages
          // ShellRoute(
          //     navigatorKey: _loginNavKey,
          //     parentNavigatorKey: _rootNavigatorKey,
          //
          //     routes: [
          //         GoRoute(parentNavigatorKey: _loginNavKey, path:"/login", builder: (context,state) => const LoginPage())
          //     ],
          //   builder: (context,state,pageWidget) => Scaffold(
          //       appBar: AppBar(
          //         leading: const GoBackButton(),
          //       ),
          //       body:pageWidget
          //   )
          // )
        ]);
  }
}
