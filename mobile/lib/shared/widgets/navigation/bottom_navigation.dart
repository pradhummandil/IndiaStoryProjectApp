  import 'package:flutter/material.dart';

/// Mobile bottom navigation bar extracted from Stitch exports.

class BottomNavigationItemData {
  const BottomNavigationItemData({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  final IconData icon;
  final String label;
  final bool isActive;
}

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    super.key,
    required this.items,
    required this.onItemSelected,
    this.height = 72,
  });

  final List<BottomNavigationItemData> items;
  final ValueChanged<int> onItemSelected;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Material(
        color: scheme.surface,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < items.length; i++)
              Expanded(
                child: InkWell(
                  onTap: () => onItemSelected(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          items[i].icon,
                          color: items[i].isActive
                              ? scheme.primary
                              : scheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          items[i].label,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: items[i].isActive
                                    ? scheme.primary
                                    : scheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
