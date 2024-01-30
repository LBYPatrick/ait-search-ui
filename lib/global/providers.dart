import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ThemeColorNotifier extends StateNotifier<Color> {
  ThemeColorNotifier() : super(Colors.deepPurple);

  update(Color newColor) {
    state = newColor;
  }

  StateNotifierProvider<ThemeColorNotifier, Color> toProvider() =>
      StateNotifierProvider<ThemeColorNotifier, Color>((ref) => this);
}

class Notifiers {
  static final themeColor = ThemeColorNotifier();
}

class Providers {
  static final themeColor = Notifiers.themeColor.toProvider();
}
