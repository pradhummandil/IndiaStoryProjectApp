import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../routing/app_router.dart';
import '../theme/theme.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig(
    locale: const Locale('en'),
    supportedLocales: const [Locale('en'), Locale('hi')],
  );
});

final appThemeProvider = Provider((ref) {
  return buildAppTheme();
});

final appRouterProvider = Provider((ref) {
  return buildAppRouter();
});
