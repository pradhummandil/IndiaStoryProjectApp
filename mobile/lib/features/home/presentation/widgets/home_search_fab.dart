import 'package:flutter/material.dart';

class HomeSearchFab extends StatelessWidget {
  const HomeSearchFab({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    if (isDesktop) return const SizedBox.shrink();

    return Positioned(
      right: 16,
      top: 112,
      child: Material(
        shape: const CircleBorder(),
        color: colors.surfaceContainerHighest,
        elevation: 3,
        child: InkWell(
          onTap: () {},
          customBorder: const CircleBorder(),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.search_rounded),
          ),
        ),
      ),
    );
  }
}
