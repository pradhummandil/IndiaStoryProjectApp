import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/app_colors.dart';
import '../../../../design_system/app_spacing.dart';
import '../../../../design_system/app_shadows.dart';
import '../../../../design_system/app_radius.dart';
import '../providers/ai_assistant_providers.dart';

/// Writer Studio AI Assistant Screen.
///
/// Matches `design/writer_studio_editor_ai_assistant/code.html` exactly.
class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  final _settingsDrawerKey = GlobalKey();
  bool _isSettingsOpen = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final isTablet = MediaQuery.of(context).size.width >= 600 && !isDesktop;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Main content
            _MainContent(
              colors: colors,
              isDesktop: isDesktop,
              isTablet: isTablet,
              onToggleSettings: () {
                setState(() => _isSettingsOpen = !_isSettingsOpen);
              },
            ),
            // Settings Drawer
            _SettingsDrawer(
              key: _settingsDrawerKey,
              colors: colors,
              isDesktop: isDesktop,
              isOpen: _isSettingsOpen,
              onClose: () => setState(() => _isSettingsOpen = false),
            ),
            // Overlay for mobile drawer
            if (!isDesktop && _isSettingsOpen)
              GestureDetector(
                onTap: () => setState(() => _isSettingsOpen = false),
                child: Container(color: const Color(0x66404030)),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Main Content ─────────────────────────────────────────────────────

class _MainContent extends StatelessWidget {
  final AppColors colors;
  final bool isDesktop;
  final bool isTablet;
  final VoidCallback onToggleSettings;

  const _MainContent({
    required this.colors,
    required this.isDesktop,
    required this.isTablet,
    required this.onToggleSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TopAppBar
        _TopAppBar(
          colors: colors,
          isDesktop: isDesktop,
          onToggleSettings: onToggleSettings,
        ),
        // Editor Canvas
        Expanded(
          child: _EditorCanvas(
            colors: colors,
            isDesktop: isDesktop,
            isTablet: isTablet,
          ),
        ),
      ],
    );
  }
}

// ── Top App Bar ──────────────────────────────────────────────────────

class _TopAppBar extends StatelessWidget {
  final AppColors colors;
  final bool isDesktop;
  final VoidCallback onToggleSettings;

  const _TopAppBar({
    required this.colors,
    required this.isDesktop,
    required this.onToggleSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Row(
        children: [
          // Menu / Spacer
          const SizedBox(width: 20),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(
                  Icons.menu_rounded,
                  color: colors.textOnSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          // Title
          Text(
            'Writer Studio',
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: colors.primary,
              height: 40 / 32,
            ),
          ),
          const Spacer(),
          // Auto-save label (desktop)
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                'Draft automatically saved',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.05,
                  color: const Color(0xFF5F6368),
                ),
              ),
            ),
          // Publish button
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.publish_rounded, size: 18),
            label: const Text('Publish'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF8B1E1E),
              foregroundColor: colors.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.05,
              ),
              elevation: 4,
              shadowColor: const Color(0x338B1E1E),
            ),
          ),
          // Mobile settings toggle
          if (!isDesktop)
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 20),
              child: InkWell(
                onTap: onToggleSettings,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.outlineVariant),
                    boxShadow: [AppShadows().z1],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.tune_rounded,
                      size: 20,
                      color: colors.textOnSurfaceVariant,
                    ),
                  ),
                ),
              ),
            )
          else
            const SizedBox(width: 64),
        ],
      ),
    );
  }
}

// ── Editor Canvas ────────────────────────────────────────────────────

class _EditorCanvas extends StatelessWidget {
  final AppColors colors;
  final bool isDesktop;
  final bool isTablet;

  const _EditorCanvas({
    required this.colors,
    required this.isDesktop,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Scrollable editor content
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            isDesktop
                ? 64
                : isTablet
                ? 32
                : 20,
            0,
            isDesktop
                ? 64
                : isTablet
                ? 32
                : 20,
            isDesktop ? 32 : 120,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 120),
                  // Cover Image Area
                  _CoverImage(colors: colors),
                  const SizedBox(height: 16),
                  // Story Metadata Row
                  _StoryMetadata(colors: colors),
                  const SizedBox(height: 8),
                  // Title Input
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'A Timeless Discovery...',
                      hintStyle: TextStyle(
                        fontFamily: 'EB Garamond',
                        fontSize: isDesktop ? 64 : 40,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.02,
                        color: colors.outlineVariant,
                        height: isDesktop ? 72 / 64 : 48 / 40,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(
                      fontFamily: 'EB Garamond',
                      fontSize: isDesktop ? 64 : 40,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.02,
                      color: colors.onBackground,
                      height: isDesktop ? 72 / 64 : 48 / 40,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Rich Text Area
                  _RichTextEditor(colors: colors),
                ],
              ),
            ),
          ),
        ),
        // Floating AI Toolbar
        Positioned(
          left: 0,
          right: 0,
          bottom: 20,
          child: Center(child: _AiFloatingToolbar(colors: colors)),
        ),
      ],
    );
  }
}

// ── Cover Image ──────────────────────────────────────────────────────

class _CoverImage extends StatelessWidget {
  final AppColors colors;

  const _CoverImage({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A000000),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border.all(color: colors.outlineVariant),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuASYyESVqIE2lGl89eOwwp3bVTaUcdVmHFUBcuG_ka_PbH40CmesJzIP14FDB98y6nuaUsFX8mIskYgC0oQdhAeIYNEK0PzO4FTH0AfHMHpoz2jd675R2VgZTMWAhIzdas4QG93t-dnfp_SQdlXawymOK1vRJEvywgNcO9qHg8MNpmq5oiQeDTWUgI9oaccBVqKY_EwlDA477xOqEhlWAnQ0tfB2fg7ajmt7sRdHG2LHPmxrqn0ayu8lw',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Hover overlay
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: colors.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_rounded,
                          size: 18,
                          color: colors.onBackground,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Change Cover Image',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.05,
                            color: colors.onBackground,
                          ),
                        ),
                      ],
                    ),
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

// ── Story Metadata ───────────────────────────────────────────────────

class _StoryMetadata extends StatelessWidget {
  final AppColors colors;

  const _StoryMetadata({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Category badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF6E9),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0x4DE8C246)),
          ),
          child: Text(
            'HERITAGE',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.05,
              color: colors.secondary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Location badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 16,
                color: colors.textOnSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                'India',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.05,
                  color: colors.textOnSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // Read time
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 14,
              color: const Color(0xFF5F6368),
            ),
            const SizedBox(width: 4),
            Text(
              '5 min read',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF5F6368),
                height: 16 / 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Rich Text Editor ─────────────────────────────────────────────────

class _RichTextEditor extends StatelessWidget {
  final AppColors colors;

  const _RichTextEditor({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First paragraph with drop cap
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'T',
                style: TextStyle(
                  fontFamily: 'EB Garamond',
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'he journey begins long before the first step is taken. It starts in the quiet anticipation of the unknown, the rustle of maps, and the faint scent of old paper. In the heart of the subcontinent, history doesn\'t just sit in museums; it breathes through the bustling streets and silent temples.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: colors.textOnSurfaceVariant,
                    height: 28 / 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Our expedition aimed to uncover the lesser-known narratives woven into the fabric of these ancient settlements. We sought not the grand monuments, but the intimate corners where time seems to have paused, preserving a way of life that feels both distant and profoundly familiar.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: colors.textOnSurfaceVariant,
              height: 28 / 18,
            ),
          ),
        ],
      ),
    );
  }
}

// ── AI Floating Toolbar ──────────────────────────────────────────────

class _AiFloatingToolbar extends StatelessWidget {
  final AppColors colors;

  const _AiFloatingToolbar({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: const Color(0x14000000),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AI Sparkle icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: colors.outlineVariant)),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 20,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: 4),
          // Improve Prose
          _ToolbarButton(
            icon: Icons.edit_note_rounded,
            label: 'Improve Prose',
            colors: colors,
            onTap: () {},
          ),
          // Generate Title
          _ToolbarButton(
            icon: Icons.title_rounded,
            label: 'Generate Title',
            colors: colors,
            onTap: () {},
          ),
          // Summarize
          _ToolbarButton(
            icon: Icons.summarize_rounded,
            label: 'Summarize',
            colors: colors,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppColors colors;
  final VoidCallback onTap;

  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: colors.onBackground),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.05,
                  color: colors.onBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Settings Drawer ──────────────────────────────────────────────────

class _SettingsDrawer extends StatefulWidget {
  final AppColors colors;
  final bool isDesktop;
  final bool isOpen;
  final VoidCallback onClose;

  const _SettingsDrawer({
    super.key,
    required this.colors,
    required this.isDesktop,
    required this.isOpen,
    required this.onClose,
  });

  @override
  State<_SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<_SettingsDrawer> {
  String _selectedTheme = 'Cultural Heritage';
  String _selectedState = 'Kerala';
  String _selectedDistrict = 'Idukki';

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      right: widget.isOpen ? 0 : -360,
      top: 0,
      bottom: 0,
      child: Container(
        width: 360,
        color: colors.surface,
        child: Column(
          children: [
            // Mobile header
            if (!widget.isDesktop)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surfaceBright,
                  border: Border(
                    bottom: BorderSide(color: colors.outlineVariant),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Story Settings',
                      style: TextStyle(
                        fontFamily: 'EB Garamond',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: colors.onBackground,
                        height: 32 / 24,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: widget.onClose,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.close_rounded,
                            color: colors.textOnSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Drawer content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header (desktop)
                    if (widget.isDesktop)
                      Container(
                        margin: const EdgeInsets.only(bottom: 32),
                        child: Text(
                          'Story Setting',
                          style: TextStyle(
                            fontFamily: 'EB Garamond',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: colors.onBackground,
                            height: 32 / 24,
                          ),
                        ),
                      ),
                    // Scores Grid
                    Row(
                      children: [
                        Expanded(
                          child: _ScoreCard(
                            colors: colors,
                            score: 85,
                            label: 'SEO Score',
                            strokeColor: const Color(0xFF8B1E1E),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ScoreCard(
                            colors: colors,
                            score: 92,
                            label: 'A11y Score',
                            strokeColor: const Color(0xFF755B00),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 32),
                    // Metadata Selectors
                    Text(
                      'METADATA',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: const Color(0xFF5F6368),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Theme Focus
                    _MetadataDropdown(
                      label: 'Theme Focus',
                      value: _selectedTheme,
                      items: [
                        'Cultural Heritage',
                        'Wildlife & Nature',
                        'Urban Chronicles',
                        'Culinary Journeys',
                      ],
                      colors: colors,
                      onChanged: (v) => setState(() => _selectedTheme = v!),
                    ),
                    const SizedBox(height: 24),
                    // State / Region
                    _MetadataDropdown(
                      label: 'State / Region',
                      value: _selectedState,
                      items: [
                        'Kerala',
                        'Rajasthan',
                        'Maharashtra',
                        'West Bengal',
                      ],
                      colors: colors,
                      onChanged: (v) => setState(() => _selectedState = v!),
                    ),
                    const SizedBox(height: 24),
                    // District
                    _MetadataDropdown(
                      label: 'District',
                      value: _selectedDistrict,
                      items: ['Idukki', 'Ernakulam', 'Wayanad'],
                      colors: colors,
                      onChanged: (v) => setState(() => _selectedDistrict = v!),
                    ),
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 32),
                    // Location Picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'LOCATION',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            color: const Color(0xFF5F6368),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.edit_rounded,
                              size: 18,
                              color: colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Map preview
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.outlineVariant),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCshVDFcHoyQ-4rUx5AbvIX2murZDEjy8BtSJXwhrGzMIC-VVrDPYqGXsmJPuiuTTK2TxOFl8Bolo7SMuX0Lnbg5tIf7UqQuR8oZDrpFPg3MosfhH2FZY7Mfq2JoSNFTe7g324bvJxG7L63LGT4aKXm0QOP0dDElivrKMgw3teUBg-iKdUmI3d4Qn7gN4-go1SmzQ5nVIbRlYL4fA62RkFImJTz_htaKbrQS9plF4zd1x3V_cXGZX6Ucg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Pin overlay
                          Positioned(
                            top: 100,
                            left: 160,
                            child: Column(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8B1E1E),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: colors.surface,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  height: 24,
                                  color: const Color(0xFF8B1E1E),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Pin dropped in Munnar, Idukki District.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          color: colors.outline,
                          height: 16 / 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Score Card ───────────────────────────────────────────────────────

class _ScoreCard extends StatelessWidget {
  final AppColors colors;
  final int score;
  final String label;
  final Color strokeColor;

  const _ScoreCard({
    required this.colors,
    required this.score,
    required this.label,
    required this.strokeColor,
  });

  @override
  Widget build(BuildContext context) {
    final circumference = 2 * 3.14159 * 40; // 251.2
    final offset = circumference - (circumference * score / 100);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        children: [
          // Progress ring
          SizedBox(
            width: 80,
            height: 80,
            child: CustomPaint(
              painter: _ProgressRingPainter(
                progress: score / 100,
                strokeColor: strokeColor,
                backgroundColor: const Color(0xFFE8E2D8),
              ),
              child: Center(
                child: Text(
                  '$score',
                  style: TextStyle(
                    fontFamily: 'EB Garamond',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: strokeColor,
                    height: 32 / 24,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.05,
              color: colors.textOnSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color strokeColor;
  final Color backgroundColor;

  _ProgressRingPainter({
    required this.progress,
    required this.strokeColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // Background circle
    paint.color = backgroundColor;
    canvas.drawCircle(center, radius, paint);

    // Progress arc
    paint.color = strokeColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // Start from top
      2 * 3.14159 * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ── Metadata Dropdown ────────────────────────────────────────────────

class _MetadataDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final AppColors colors;
  final ValueChanged<String?> onChanged;

  const _MetadataDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.colors,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: colors.outline,
            height: 16 / 12,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colors.outlineVariant, width: 2),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(
                Icons.expand_more_rounded,
                color: colors.outlineVariant,
              ),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: colors.onBackground,
                height: 24 / 16,
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
