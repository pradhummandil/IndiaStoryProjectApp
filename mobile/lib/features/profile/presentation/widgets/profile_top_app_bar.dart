import 'package:flutter/material.dart';

/// Top App Bar — matches `design/user_profile/code.html` exactly.
///
/// HTML: fixed top-0 w-full z-50 bg-background
/// flex justify-between items-center px-margin-mobile md:px-margin-desktop py-4
/// back button, "India Story Project" headline, share button
class ProfileTopAppBar extends StatelessWidget {
  const ProfileTopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5EF), // bg-background
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE8E2D8)), // border
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 20,
        vertical: 16,
      ),
      child: Row(
        children: [
          // Back button — w-10 h-10 rounded-full hover:bg-surface-variant
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(9999),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: colors.onSurfaceVariant,
                size: 24,
              ),
            ),
          ),
          const Spacer(),
          // "India Story Project" — font-headline-sm text-headline-sm text-primary tracking-tight font-bold
          Text(
            'India Story Project',
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.01,
              color: colors.primary, // #6a020a
            ),
          ),
          const Spacer(),
          // Share button — w-10 h-10 rounded-full hover:bg-surface-variant
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(9999),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Icon(
                Icons.share_rounded,
                color: colors.onSurfaceVariant,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
