import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.showBrandInHeader = true,
    this.appBarHeight = 56,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final bool showBrandInHeader;
  final double appBarHeight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // Warm paper base (no hardcoded tokens unless necessary)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: scheme.surface),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: appBarHeight),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (showBrandInHeader) ...[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'ISP',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(color: scheme.primary),
                                ),
                              ),
                              if (title != null) ...[
                                const SizedBox(height: 12),
                                Text(
                                  title!,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: scheme.onSurface),
                                ),
                              ],
                              if (subtitle != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  subtitle!,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ],
                            if (showBrandInHeader) const SizedBox(height: 16),
                            child,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
