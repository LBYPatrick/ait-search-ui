import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

///A dummy class that exposes WidgetRef and BuildContext to the builder method
class RiverpodWrapper extends ConsumerStatefulWidget {
  /// Builder for the child widget.
  final Widget Function(BuildContext context, WidgetRef widgetRef) builder;

  const RiverpodWrapper({super.key, required this.builder});

  @override
  ConsumerState<RiverpodWrapper> createState() => _RiverpodWrapperState();
}

class _RiverpodWrapperState extends ConsumerState<RiverpodWrapper> {
  @override
  Widget build(BuildContext context) => widget.builder(context, ref);
}
