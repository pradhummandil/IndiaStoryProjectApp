import 'package:flutter/material.dart';

/// Reading Progress Bar — matches HTML exactly.
///
/// HTML: fixed top-16 w-full z-40 h-1
/// Track: w-full h-1 bg-tertiary-fixed
/// Bar: h-full bg-primary, width animated via scroll
class StoryReadingProgressBar extends StatefulWidget {
  const StoryReadingProgressBar({super.key});

  @override
  State<StoryReadingProgressBar> createState() =>
      _StoryReadingProgressBarState();
}

class _StoryReadingProgressBarState extends State<StoryReadingProgressBar>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll =
        _scrollController.position.maxScrollExtent -
        _scrollController.position.minScrollExtent;
    if (maxScroll <= 0) {
      setState(() => _progress = 0.0);
      return;
    }
    final current = _scrollController.position.pixels;
    setState(() => _progress = (current / maxScroll).clamp(0.0, 1.0));
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 4, // h-1 (4px)
      color: const Color(0xFFFFE088), // tertiary-fixed
      child: FractionallySizedBox(
        widthFactor: _progress,
        child: Container(
          color: colors.primary, // bg-primary
        ),
      ),
    );
  }
}
