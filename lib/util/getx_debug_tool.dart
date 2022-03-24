//A context-free debug tool that shows current routing, color printing tool
import 'dart:io';

import 'package:get/get.dart';

class Dbg {
  // debug toggle
  static const bool _debug = true;

  static const _logFilterConfigs = {
    'enableTagOnly': false, // Only allow printing with tag, the rest are filtered
    'enabledTagName': '' // Tag names allowed to be printed

    ,
    'routeOnly': false, // Allow only the specified route to print, the rest are filtered
    'enabledRouteName': '' // Names of routes allowed to be printed

    // The following are temporarily unavailable
    ,
    'disableByRegex': false,
    'disabledRegex': '',

    'enableByRegex': false,
    'enabledRegex': ''
  };

  static void log(dynamic msg, [String tag]) {
    if (Platform.isAndroid || Platform.isWindows) {
      if (_debug &&
          (!_logFilterConfigs['enableTagOnly'] ||
              _logFilterConfigs['enableTagOnly'] &&
                  tag?.compareTo(_logFilterConfigs['enabledTagName']) == 0) &&
          (!_logFilterConfigs['routeOnly'] ||
              _logFilterConfigs['routeOnly'] &&
                  Get.currentRoute
                          .compareTo(_logFilterConfigs['enabledRouteName']) ==
                      0)) {
        print('\x1B[35m[DebugTool]\x1B[0m : '
            '${tag == null ? "" : " \x1B[32m<$tag>\x1B[0m"} '
            'Route\x1B[35m["${Get.currentRoute}"]\x1B[0m->| $msg');
      }
    }
    if (Platform.isIOS) {
      print('[DebugTool] : '
          '${tag == null ? "" : " <$tag>"} '
          'Route["${Get.currentRoute}"]->| $msg');
    }
  }

  static get _colorTable => {
        'black': '\x1B[30m',
        'red': '\x1B[31m',
        'green': '\x1B[32m',
        'yellow': '\x1B[33m',
        'blue': '\x1B[34m',
        'magenta': '\x1B[35m',
        'cyan': '\x1B[36m',
        'white': '\x1B[37m',
        'reset': '\x1B[0m',
      };

  // color from color table
  static String coloredString(dynamic msg, String color) {
    return '${_colorTable[color]}$msg\x1B[0m';
  }
}
