import 'dart:convert';
import 'dart:ui';

import 'package:ait_search_ui/result_tile.dart';
import 'package:ait_search_ui/util/system_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends ConsumerStatefulWidget {
  final GoRouterState routerState;
  const HomePage(this.routerState, {super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> results = [];

  String get queryString => _controller.text;
  bool get isActive => submitted;
  bool get hasInput => queryString.isNotEmpty;
  bool submitted = false;
  bool isResultReady = false;
  String? backendAddr;

  Map<String, dynamic> parse(Map<String, dynamic> input) {
    return input;
  }

  /// Fetches backend's address from config.json
  Future<String> get _backendAddr async => backendAddr ??= (jsonDecode(
          await SystemUtil.readFile("res/config.json"))["backend_addr"] ??
      "");

  void _onResetPage() async {
    if (mounted) {
      setState(() {
        submitted = false;
        _controller.clear();
      });
    }
  }

  void fireRequest() async {
    isResultReady = false;
    setState(() => true);

    final ret = await http.get(
        Uri.https(await _backendAddr, "/search", {"keyword": queryString}));

    //debugPrint("Body: ${ret.body}");

    final body = json.decode(ret.body);

    // debugPrint("Content: ${body["content"]["matches"].runtimeType}");

    //debugPrint("First element: ${jsonEncode(body["content"]["matches"][0])}");

    if ((body["content"]["matches"] as List<dynamic>).isEmpty) {
      results = [];
    } else {
      final output = List<dynamic>.from(body["content"]["matches"])
          .cast<Map<String, dynamic>>();

      results = output;
    }

    isResultReady = true;
    setState(() => true);
  }

  Widget get _searchBar => Hero(
      tag: "search_bar",
      child: SearchBar(
        autoFocus: true,
        controller: _controller,
        onChanged: (newValue) {
          //fireRequest();
          setState(() => true);
        },
        onSubmitted: (newValue) {
          submitted = true;
          debugPrint("Submitted: $newValue");
          fireRequest();

          setState(() => true);
        },

        // Close button
        trailing: hasInput
            ? [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.clear();
                      });
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color: Theme.of(context).colorScheme.onSurface,
                    ))
              ]
            : null,
        textInputAction: TextInputAction.search,
        side: MaterialStatePropertyAll(BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2))),
        padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16)),
        leading: const Icon(Icons.search_rounded),
        elevation: const MaterialStatePropertyAll(0),
      ));

  static List<Widget> gappedWidgets(List<Widget?> widgets,
      {double gapSize = 4}) {
    //Filter out null widgets (Intentionally left out)
    widgets =
        widgets.where((element) => element != null).toList(growable: false);

    List<Widget> newList = [];

    bool isFirst = true;

    for (Widget? w in widgets) {
      if (isFirst) {
        isFirst = false;
      } else {
        newList.add(SizedBox.square(dimension: gapSize));
      }

      newList.add(w!);
    }

    return newList;
  }

  Widget get _searchBtn => Hero(
      tag: "search_button",
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
                horizontal: hasInput ? 0 : 30, vertical: 20),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () {
            submitted = true;
            fireRequest();
            setState(() => true);
          },
          child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.search_rounded, size: 22),
                SizedBox.square(dimension: hasInput ? 0 : 8),
                AnimatedSize(
                    curve: Curves.easeOutCubic,
                    duration: const Duration(milliseconds: 300),
                    child: Opacity(
                        opacity: 0.8,
                        child: Text(
                          hasInput ? "" : "Search",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontSize: 22,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ))),
              ])));

  double get _aspectRatio {
    final query = MediaQuery.of(context);
    final ret = query.size.aspectRatio;

    // debugPrint("Current aspect ratio: ${ret}");
    // debugPrint("Size: ${query.size}");

    return ret;
  }

  Widget get _idlePage => Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
                children: gappedWidgets([
              FilledButton(
                  // style: _btnStyle,
                  onPressed: () => launchUrl(Uri.parse(
                      "https://cs.nyu.edu/courses/spring24/CSCI-UA.0467-001/_site/index.html")),
                  child: const Text("AIT Home")),
              TextButton(
                  //style: _btnStyle,
                  onPressed: () => launchUrl(Uri.parse(
                      "https://edstem.org/us/courses/54314/discussion/")),
                  child: const Text("Edstem")),
              const Spacer(),
              OutlinedButton(
                  //style: _btnStyle,
                  onPressed: () => launchUrl(
                      Uri.parse("https://forms.gle/D5kgR5i5DvtyZ5Lv9")),
                  child: const Text("Homework Support")),
            ])),

            const Spacer(),
            Text("AIT SearchSys",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Find everything you need for AIT!",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

            // TextField(decoration: InputDecoration(
            //     border: St(),

            _searchBar,

            Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: _searchBtn),

            const Spacer(),
          ]);

  Widget get _busyPage =>
      CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
        //SliverToBoxAdapter(child: SizedBox.square(dimension: 50)),
        SliverToBoxAdapter(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(children: [
                  InkWell(
                      onTap: _onResetPage,
                      child: Text("AIT SearchSys",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.primary))),
                  _aspectRatio > 1
                      ? Expanded(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: _searchBar))
                      : const SizedBox.square(dimension: 0),
                  _aspectRatio > 1
                      ? _searchBtn
                      : const SizedBox.square(dimension: 0)
                ]))),

        // Search bar in case it's in vertical direction
        SliverToBoxAdapter(
            child: _aspectRatio < 1
                ? Row(
                    children: [
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: _searchBar)),
                      _searchBtn
                    ],
                  )
                : const SizedBox.square(dimension: 0)),

        SliverList.builder(
          itemBuilder: (context, idx) =>

              // To Determine if current scren is widescreen
              _aspectRatio > 1.0

                  // On widescreen
                  ? Row(children: [
                      const Spacer(),
                      SizedBox(
                          height: 300,
                          child: AspectRatio(
                            aspectRatio: 2,
                            child: ResultTile(results[idx]),
                          )),
                      const Spacer()
                    ])

                  // On mobile
                  : ResultTile(results[idx]),
          itemCount: isResultReady ? results.length : 0,
        ),

        // Circular Spinny widget
        SliverToBoxAdapter(
            child: isResultReady
                ? const SizedBox.square(dimension: 0)
                : const Row(children: [
                    const Spacer(),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox.square(
                            dimension: 64,
                            child: const CircularProgressIndicator())),
                    const Spacer()
                  ])),

        // In case we cannot find anything, show an error message of sorts
        SliverToBoxAdapter(
            child: (isResultReady && results.isEmpty)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: gappedWidgets([
                      Icon(Icons.warning_rounded,
                          size: 128,
                          color: Theme.of(context).colorScheme.onSurface),
                      Text(
                        textAlign: TextAlign.center,
                        "Could not find any result. \nPlease try another keyword :(",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ]),
                  )
                : const SizedBox.square(dimension: 0))
      ]);

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Stack(children: [
        Positioned.fill(
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl:
                "https://images.unsplash.com/photo-1627398242454-45a1465c2479?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=gabriel-heinzer-g5jpH62pwes-unsplash.jpg",
          ),
        ),
        BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.9))),
        SafeArea(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: isActive ? _busyPage : _idlePage))
      ]));
}
