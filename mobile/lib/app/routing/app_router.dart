import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

GoRouter buildAppRouter() {
  // Foundation only: no screens/routes are defined yet.
  return GoRouter(
    initialLocation: '/',
    routes: const [],
    errorBuilder: (context, state) {
      // No placeholder UI allowed; return empty widget.
      return const SizedBox.shrink();
    },
  );
}
