import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _slide;

  late final Animation<double> _wordmarkOpacity;
  late final Animation<double> _wordmarkBlur;
  late final Animation<double> _wordmarkLetterSpacing;

  late final Animation<double> _beginFade;

  bool _isFadingOut = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1900),
      vsync: this,
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _slide = Tween<double>(begin: 10, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    // Wordmark reveal: opacity + letter spacing + blur reduction.
    _wordmarkOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
      ),
    );

    _wordmarkBlur = Tween<double>(begin: 10, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
      ),
    );

    _wordmarkLetterSpacing = Tween<double>(begin: 10, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
      ),
    );

    _beginFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.70, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onBeginJourney() {
    if (_isFadingOut) return;
    setState(() => _isFadingOut = true);

    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Stack(
        children: [
          // Warm paper grain.
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(color: const Color(0xFFF8F5EF)),
            ),
          ),
          // Subtle grain texture layer.
          IgnorePointer(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://www.transparenttextures.com/patterns/natural-paper.png',
                  ),
                  fit: BoxFit.cover,
                  opacity: 0.05,
                ),
              ),
            ),
          ),
          // Royal gradient overlay.
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    scheme.primaryContainer.withOpacity(0.00),
                    scheme.primaryContainer.withOpacity(0.03),
                  ],
                ),
              ),
            ),
          ),
          // Decorative corners.
          // Top-left
          Positioned(
            top: 32,
            left: 32,
            child: SizedBox(
              width: 48,
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 1,
                      color: scheme.outlineVariant.withOpacity(0.3),
                    ),
                    left: BorderSide(
                      width: 1,
                      color: scheme.outlineVariant.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Top-right
          Positioned(
            top: 32,
            right: 32,
            child: SizedBox(
              width: 48,
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 1,
                      color: scheme.outlineVariant.withOpacity(0.3),
                    ),
                    right: BorderSide(
                      width: 1,
                      color: scheme.outlineVariant.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Bottom-left
          Positioned(
            bottom: 32,
            left: 32,
            child: SizedBox(
              width: 48,
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: scheme.outlineVariant.withOpacity(0.3),
                    ),
                    left: BorderSide(
                      width: 1,
                      color: scheme.outlineVariant.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Bottom-right
          Positioned(
            bottom: 32,
            right: 32,
            child: SizedBox(
              width: 48,
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: scheme.outlineVariant.withOpacity(0.3),
                    ),
                    right: BorderSide(
                      width: 1,
                      color: scheme.outlineVariant.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Floating editorial cards (hide on small screens).
          LayoutBuilder(
            builder: (context, constraints) {
              final showDecor = constraints.maxWidth >= 900;
              return IgnorePointer(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: showDecor
                      ? Stack(
                          children: [
                            Positioned(
                              top: constraints.maxHeight / 2 - 190,
                              left: -40,
                              child: Opacity(
                                opacity: 0.2,
                                child: Transform.rotate(
                                  angle: -6 * 3.1415926535 / 180,
                                  child: Container(
                                    width: 256,
                                    height: 384,
                                    decoration: BoxDecoration(
                                      color: scheme.surface,
                                      border: Border.all(
                                        width: 1,
                                        color: scheme.outlineVariant,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 6,
                                          color: Colors.black12,
                                        ),
                                      ],
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: FractionallySizedBox(
                                        heightFactor: 0.5,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            image: const DecorationImage(
                                              image: NetworkImage(
                                                'https://lh3.googleusercontent.com/aida-public/AB6AXuALFJ-cyC8cYQZxACBE2q1vACp_3I9xLiHxkLg09wBR-kh6Y6XSYDuFHqj6gAaaY9fJrYmOVfFLjsZI6LXO1i6l5oDv1FMe0Lsp3L4yW5kBS0BzJF3IM6H0FFbUZqZl3umLwVf3s-v8IR9iILSMjZyCD5yFFw2okhyeMtxngISl_8UerYaUGNIvfUyaxMhUpyCNuid-JTpQ5RvFfIVI4M6NLnqaDWOr7osH4N1qJXl2b0ZdnqEYqBv1Zg',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: constraints.maxHeight / 2 - 192,
                              right: -40,
                              child: Opacity(
                                opacity: 0.2,
                                child: Transform.rotate(
                                  angle: 4 * 3.1415926535 / 180,
                                  child: Container(
                                    width: 256,
                                    height: 384,
                                    decoration: BoxDecoration(
                                      color: scheme.surface,
                                      border: Border.all(
                                        width: 1,
                                        color: scheme.outlineVariant,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 6,
                                          color: Colors.black12,
                                        ),
                                      ],
                                    ),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: FractionallySizedBox(
                                        heightFactor: 0.5,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            image: const DecorationImage(
                                              image: NetworkImage(
                                                'https://lh3.googleusercontent.com/aida-public/AB6AXuDiM3pqcAYfyNeE_TQygZN2heCHOpOIfFh7GsHj9ERff9owjsUwcLJvjGOo0O6P972KpEDW__AbZBYOeLHep6ALRcVbb8K6XhnT98___P3StMFHqnfIVpv9tbFCGnIvd8StBdqWABbCJJruh1Abxv-mTXvHBiWsm-1K3x9emfrEcbI0HJm3tw6z9vOhwElHxWTBZt3gvawQgDDaDcp5X7rEtyOB1yEWX2R1Q5ODXOWIMkBcHwpOlBLyNg',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              );
            },
          ),

          // Main content.
          AnimatedOpacity(
            duration: const Duration(milliseconds: 900),
            opacity: _isFadingOut ? 0 : 1,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: SizedBox(
                  height: double.infinity,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FadeTransition(
                              opacity: _fade,
                              child: Transform.translate(
                                offset: Offset(0, _slide.value),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'The India Story Project',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color: scheme.onSurfaceVariant,
                                            letterSpacing: 4,
                                            fontWeight: FontWeight.w600,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: 80,
                                      child: _AnimatedLine(delay: 800),
                                    ),
                                    const SizedBox(height: 24),

                                    AnimatedBuilder(
                                      animation: _controller,
                                      builder: (context, child) {
                                        return Opacity(
                                          opacity: _wordmarkOpacity.value,
                                          child: ImageFiltered(
                                            imageFilter: ImageFilter.blur(
                                              sigmaX: _wordmarkBlur.value,
                                              sigmaY: _wordmarkBlur.value,
                                            ),
                                            child: Text(
                                              'ISP',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall
                                                  ?.copyWith(
                                                    letterSpacing:
                                                        _wordmarkLetterSpacing
                                                            .value,
                                                    color:
                                                        scheme.primaryContainer,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 8),

                                    AnimatedOpacity(
                                      opacity: _fade.value,
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      child: Text(
                                        'Traversing thousands of years of culture and history.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                              color: scheme.onSurfaceVariant,
                                              fontStyle: FontStyle.italic,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Begin Journey bottom hint.
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 64,
                        child: Center(
                          child: FadeTransition(
                            opacity: _beginFade,
                            child: _BeginJourneyButton(onTap: _onBeginJourney),
                          ),
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
    );
  }
}

class _AnimatedLine extends StatefulWidget {
  const _AnimatedLine({required this.delay});

  final int delay;

  @override
  State<_AnimatedLine> createState() => _AnimatedLineState();
}

class _AnimatedLineState extends State<_AnimatedLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _w;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _w = Tween<double>(
      begin: 0,
      end: 80,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
    Future<void>.delayed(Duration(milliseconds: widget.delay), () {
      if (!mounted) return;
      _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _w,
      builder: (context, child) {
        return SizedBox(
          width: _w.value,
          height: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(color: scheme.outlineVariant),
          ),
        );
      },
    );
  }
}

class _BeginJourneyButton extends StatefulWidget {
  const _BeginJourneyButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_BeginJourneyButton> createState() => _BeginJourneyButtonState();
}

class _BeginJourneyButtonState extends State<_BeginJourneyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          transform: Matrix4.translationValues(0, _pressed ? 2 : 0, 0),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Begin Journey',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  letterSpacing: 3.0,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  Icons.expand_more,
                  key: ValueKey(_pressed),
                  color: scheme.primaryContainer,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
