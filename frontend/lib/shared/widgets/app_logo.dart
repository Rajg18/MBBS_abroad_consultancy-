import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Displays the Sree Consultancy logo.
///
/// Loads `assets/images/sree_logo.png`. Until that file is added it renders a
/// tasteful navy/gold text fallback so the UI never breaks.
class AppLogo extends StatelessWidget {
  final double height;
  final bool showWordmark;

  const AppLogo({super.key, this.height = 44, this.showWordmark = true});

  @override
  Widget build(BuildContext context) {
    final mark = Image.asset(
      'assets/images/sree_logo.png',
      height: height,
      width: height,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => _fallbackMark(height),
    );

    if (!showWordmark) return mark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sree Consultancy',
              style: TextStyle(
                fontSize: height * 0.42,
                height: 1.05,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: 0.2,
              ),
            ),
            Text(
              'MBBS Abroad',
              style: TextStyle(
                fontSize: height * 0.26,
                height: 1.1,
                fontWeight: FontWeight.w600,
                color: AppColors.accentDark,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _fallbackMark(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(size * 0.24),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.spa_rounded, color: AppColors.accent, size: size * 0.6),
    );
  }
}

/// A branded top app bar with the logo on the left, for inner screens.
class BrandAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;

  const BrandAppBar({super.key, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 72,
      titleSpacing: 20,
      title: const AppLogo(height: 40),
      actions: [
        ...?actions,
        const SizedBox(width: 12),
      ],
      shape: const Border(
        bottom: BorderSide(color: AppColors.border, width: 1),
      ),
    );
  }
}
