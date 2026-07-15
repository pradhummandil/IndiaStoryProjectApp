import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'di/app_providers.dart';

class IndiaStoryAppBootstrap extends ConsumerWidget {
  const IndiaStoryAppBootstrap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'India Story Project',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: router,
      locale: ref.watch(appConfigProvider).locale,
      supportedLocales: ref.watch(appConfigProvider).supportedLocales,
      localizationsDelegates: const [],
    );
  }
}
