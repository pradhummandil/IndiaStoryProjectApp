import 'package:flutter/material.dart';

/// Interactive Discovery Map screen.
///
/// Matches `design/interactive_discovery_map_production_v2/code.html` exactly.
class DiscoveryMapScreen extends StatefulWidget {
  const DiscoveryMapScreen({super.key});

  @override
  State<DiscoveryMapScreen> createState() => _DiscoveryMapScreenState();
}

class _DiscoveryMapScreenState extends State<DiscoveryMapScreen> {
  double _eraValue = 1565;
  bool _bottomSheetOpen = false;

  void _toggleBottomSheet() {
    setState(() {
      _bottomSheetOpen = !_bottomSheetOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F3),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  _MapTopNav(),
                  Expanded(
                    child: Stack(
                      children: [
                        _MapLayer(
                          isDesktop: isDesktop,
                          onMarkerTap: _toggleBottomSheet,
                        ),
                        Positioned(
                          top: 16,
                          left: isDesktop ? 64 : 16,
                          child: _FilterChips(),
                        ),
                        Positioned(
                          bottom: isDesktop ? 32 : 24,
                          left: isDesktop ? 64 : 16,
                          right: isDesktop ? 64 : 16,
                          child: _TimelineControls(
                            value: _eraValue,
                            onChanged: (val) {
                              setState(() => _eraValue = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_bottomSheetOpen)
              _LandmarkBottomSheet(
                isDesktop: isDesktop,
                onClose: _toggleBottomSheet,
              ),
            if (!isDesktop) _MapBottomNav(),
          ],
        ),
      ),
    );
  }
}

/// Top Navigation with backdrop blur.
class _MapTopNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.8),
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu_rounded),
            color: colors.onSurface,
          ),
          const Spacer(),
          Text(
            'HERITAGE',
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 28,
              letterSpacing: -0.01,
              fontWeight: FontWeight.w600,
              color: colors.primary,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
            color: colors.onSurface,
          ),
        ],
      ),
    );
  }
}

/// Main Map Layer — antique map + heatmap + texture + markers.
class _MapLayer extends StatelessWidget {
  final bool isDesktop;
  final VoidCallback onMarkerTap;

  const _MapLayer({required this.isDesktop, required this.onMarkerTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Antique map image
        Positioned.fill(
          child: Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDumyNXegg7ud8maBQFXMC2vefAUB_Z9XF8K7wUFd_h_ifoJNpoFlen8GvGJ8YKYq6SaROsYKAQoO0lAlDZMuqjP_IuGG14cWpqJMWlwXtgQshDVEUjtmFHqX7vEzekErHRGdnSq98cvrc9s7zDeKxHt_K77UrSYGL08jxrpbBMagfx5HGZs2R5aqXdLcVFaYfnKgfcbHxPzTORPbwXpgW2jVNmBGgVN061wPmbApjp66Fe8hReNHgN6g',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFFE8E1D5),
              child: Center(
                child: Icon(
                  Icons.map_rounded,
                  size: 64,
                  color: Colors.grey[400],
                ),
              ),
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: const Color(0xFFE8E1D5),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
        // Heatmap gradient
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color(0x268B1E1E),
                  Colors.transparent,
                  Color(0x1AD0B37E),
                  Colors.transparent,
                ],
                radius: 0.8,
                center: Alignment(0.3, 0.4),
              ),
            ),
          ),
        ),
        // Noise texture
        Positioned.fill(
          child: Opacity(opacity: 0.08, child: Container(color: Colors.black)),
        ),
        // Marker: Hampi Ruins (active)
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          left: MediaQuery.of(context).size.width * 0.35,
          child: _ActiveMapMarker(label: 'Hampi Ruins', onTap: onMarkerTap),
        ),
        // Marker: Mysore Palace (inactive)
        Positioned(
          top: MediaQuery.of(context).size.height * 0.6,
          left: MediaQuery.of(context).size.width * 0.45,
          child: _InactiveMapMarker(label: 'Mysore Palace'),
        ),
        // Marker: Varanasi Ghats (inactive)
        Positioned(
          top: MediaQuery.of(context).size.height * 0.3,
          left: MediaQuery.of(context).size.width * 0.65,
          child: _InactiveMapMarker(label: 'Varanasi Ghats'),
        ),
      ],
    );
  }
}

/// Filter chips.
class _FilterChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _FilterChipWidget(label: 'All Stories', active: true, colors: colors),
        _FilterChipWidget(label: 'Landmarks', active: false, colors: colors),
        _FilterChipWidget(label: 'Wildlife', active: false, colors: colors),
        _FilterChipWidget(label: 'Culture', active: false, colors: colors),
      ],
    );
  }
}

class _FilterChipWidget extends StatelessWidget {
  final String label;
  final bool active;
  final ColorScheme colors;
  const _FilterChipWidget({
    required this.label,
    required this.active,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? colors.primary : Colors.white,
        borderRadius: BorderRadius.circular(9999),
        border: active
            ? null
            : Border.all(color: colors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            blurRadius: active ? 24 : 8,
            color: active
                ? colors.primary.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.1),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          letterSpacing: 0.05,
          fontWeight: FontWeight.w600,
          color: active ? colors.onPrimary : colors.onSurface,
        ),
      ),
    );
  }
}

/// Active map marker with pulse ring animation.
class _ActiveMapMarker extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _ActiveMapMarker({required this.label, required this.onTap});

  @override
  State<_ActiveMapMarker> createState() => _ActiveMapMarkerState();
}

class _ActiveMapMarkerState extends State<_ActiveMapMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 32 * _pulseAnimation.value,
                      height: 32 * _pulseAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.primary.withValues(alpha: 0.2),
                      ),
                    );
                  },
                ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.primary,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12,
                        color: colors.primary.withValues(alpha: 0.6),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black.withValues(alpha: 0.15),
                ),
              ],
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                letterSpacing: 0.05,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Inactive map marker.
class _InactiveMapMarker extends StatelessWidget {
  final String label;
  const _InactiveMapMarker({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF635D5A),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black.withValues(alpha: 0.2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: Colors.black.withValues(alpha: 0.15),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              letterSpacing: 0.05,
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

/// Timeline Controls — Era Explorer slider.
class _TimelineControls extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  const _TimelineControls({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            color: Colors.black.withValues(alpha: 0.15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Era Explorer',
                style: TextStyle(
                  fontFamily: 'EB Garamond',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: colors.onSurface,
                ),
              ),
              Text(
                '${value.toInt()} AD',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: colors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              activeTrackColor: colors.primary,
              inactiveTrackColor: colors.outlineVariant,
              thumbColor: colors.primary,
              overlayColor: colors.primary.withValues(alpha: 0.12),
            ),
            child: Slider(
              value: value,
              min: 1000,
              max: 2024,
              onChanged: onChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '1000 AD',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w500,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  'Present',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w500,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Landmark Bottom Sheet.
class _LandmarkBottomSheet extends StatelessWidget {
  final bool isDesktop;
  final VoidCallback onClose;
  const _LandmarkBottomSheet({required this.isDesktop, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (isDesktop) {
      return Positioned(
        top: 0,
        right: 0,
        bottom: 0,
        child: SizedBox(
          width: 400,
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 32,
                  offset: const Offset(-8, 0),
                  color: colors.primary.withValues(alpha: 0.1),
                ),
              ],
            ),
            child: Column(
              children: [
                _BottomSheetHeader(colors: colors, onClose: onClose),
                Expanded(child: _BottomSheetContent(colors: colors)),
              ],
            ),
          ),
        ),
      );
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 530,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 32,
              offset: const Offset(0, -8),
              color: colors.primary.withValues(alpha: 0.1),
            ),
          ],
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: SizedBox(
                width: 48,
                height: 6,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFDFBFBC),
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                ),
              ),
            ),
            _BottomSheetHeader(colors: colors, onClose: onClose),
            Expanded(child: _BottomSheetContent(colors: colors)),
          ],
        ),
      ),
    );
  }
}

class _BottomSheetHeader extends StatelessWidget {
  final ColorScheme colors;
  final VoidCallback onClose;
  const _BottomSheetHeader({required this.colors, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.surfaceVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'LANDMARK DETAILS',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                letterSpacing: 0.1,
                fontWeight: FontWeight.w600,
                color: colors.primary,
              ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
            color: colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _BottomSheetContent extends StatelessWidget {
  final ColorScheme colors;
  const _BottomSheetContent({required this.colors});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 256,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBo5niSIHurWZBnCM8ZBx6LaJiOKG4A10fbwos4xAWfhzFKKeiIO99EgNrwCeU1vykWX4qIzOmfn_jpHg1_S_8LQlFeWjl8UnhAt2z80xaqXqee6v6NfDSnKLeAwtBUU9nP9KK1f24ticyhRKSfwlE69jlR8Dj4Q31uLbtdF6Suzj2Lb6OViL-gXgBKqpWOQtDV7aRPoDcf5v67TXv9ZU-qHXrqYBIi4hbC5RJMFujxKhnm2gE17XBVog',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 256,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: colors.surfaceContainerHigh,
                      child: const Center(child: Icon(Icons.image_rounded)),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xFFFCF9F3)],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Vijayanagara Empire',
                  style: TextStyle(
                    fontFamily: 'EB Garamond',
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'The forgotten empire of stone and gold.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Once one of the richest and largest cities in the world, the ruins of Hampi stand as a testament to the grandeur of the Vijayanagara Empire. Amidst boulder-strewn landscapes, magnificent temples and palaces silently narrate stories of a glorious past abruptly ended in 1565.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    height: 24 / 16,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                      shadowColor: colors.primary.withValues(alpha: 0.4),
                    ),
                    child: const Text(
                      'READ FULL STORY',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        letterSpacing: 0.1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mobile Bottom Navigation Bar — matches HTML exactly.
class _MapBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(top: BorderSide(color: colors.surfaceVariant)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MapNavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  active: false,
                ),
                _MapNavItem(
                  icon: Icons.explore_rounded,
                  label: 'Explore',
                  active: true,
                ),
                _MapNavItem(
                  icon: Icons.share_rounded,
                  label: 'Share',
                  active: false,
                ),
                _MapNavItem(
                  icon: Icons.bookmark_border_rounded,
                  label: 'Saved',
                  active: false,
                ),
                _MapNavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  active: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MapNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const _MapNavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? colors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: active ? colors.onPrimary : colors.onSurfaceVariant,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              letterSpacing: 0.1,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? colors.onPrimary : colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
