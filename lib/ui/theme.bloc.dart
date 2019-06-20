import 'dart:async';

import 'package:test_app_1/ui/theme.dart';

class ThemeBloc {
  final StreamController<Themes> _themeController = StreamController<Themes>();
  get changeTheme => _themeController.sink.add;
  get themeEnabled => _themeController.stream;
}

final themeBloc = ThemeBloc();
