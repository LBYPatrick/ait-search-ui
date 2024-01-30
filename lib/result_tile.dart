import 'package:ait_search_ui/util/acrylic_container.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultTile extends ConsumerStatefulWidget {
  final Map<String, dynamic> metadata;

  const ResultTile(this.metadata, {super.key});

  @override
  ConsumerState<ResultTile> createState() => _ResultTileState();
}

class _ResultTileState extends ConsumerState<ResultTile> {
  String get source => widget.metadata["source"] ?? "";
  String get fullPath => widget.metadata["path"];
  String get fileName =>
      ((widget.metadata["path"] ?? "").split('/')[0] as String)
          .replaceAll(".markdown", "");
  String get remoteUrl => (widget.metadata["remote_path"] ?? "");
  String get content =>
      ((widget.metadata["chunk"] ?? []).cast<String>()).join("");
  String get title => widget.metadata["title"] ?? "";

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

  TextTheme get texts => Theme.of(context).textTheme;
  ColorScheme get colors => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: colors.surface.withOpacity(0.7),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
              onTap: () {
                launchUrl(Uri.parse(remoteUrl));
              },
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: gappedWidgets([
                        Wrap(spacing: 10, children: [
                          Text(source,
                              style: texts.titleLarge
                                  ?.copyWith(color: colors.primary)),
                          Text(title, style: texts.titleLarge),
                        ]),
                        // File path
                        Text(
                          "Path: $fullPath",
                          style: texts.bodySmall,
                        ),
                        const SizedBox.square(dimension: 10),

                        // Content
                        Opacity(
                            opacity: 0.5,
                            child: Text(
                              content,
                              style: texts.bodySmall,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ))
                      ], gapSize: 10))))));
}
