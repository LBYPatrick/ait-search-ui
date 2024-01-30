import 'dart:ui';

import 'package:flutter/material.dart';

class AcrylicContainer extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final Widget? child;
  final double? blurRadius;

  const AcrylicContainer(
      {required this.child, super.key, this.borderRadius, this.blurRadius});

  @override
  Widget build(BuildContext context) => ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: blurRadius ?? 30, sigmaY: blurRadius ?? 30),
          child: child));
}
