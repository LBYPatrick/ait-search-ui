// ignore_for_file: constant_identifier_names;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'dart:io' show Platform;

import 'package:url_launcher/url_launcher.dart';

enum PlatformType { MACOS, WINDOWS, IOS, ANDROID, FUCHSIA, LINUX, UNKNOWN }

class SystemUtil {
  static final kPlatformMap = {
    "linux": PlatformType.LINUX,
    "macos": PlatformType.MACOS,
    "windows": PlatformType.WINDOWS,
    "android": PlatformType.ANDROID,
    "ios": PlatformType.IOS,
    "fuchsia": PlatformType.FUCHSIA
  };

  ///Get platform type this app is running on
  static PlatformType getPlatform() {
    try {
      return kPlatformMap[Platform.operatingSystem] ?? PlatformType.UNKNOWN;
    } catch (e) {
      return PlatformType.UNKNOWN;
    }
  }

  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  static bool isSafeString(String? str) => str != null && str.trim().isNotEmpty;

  static Future<String> readFile(String filePath) async =>
      rootBundle.loadString(filePath);

  static dynamic readMap(Map<String, dynamic> map, String key,
      {defaultValue = null}) {
    if (!map.containsKey(key)) {
      return defaultValue;
    }

    return map[key];
  }
}
