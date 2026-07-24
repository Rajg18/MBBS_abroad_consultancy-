import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A slim 4-step progress indicator shown at the top of the application flow.
class StepProgress extends StatelessWidget {
  /// 0-based index of the current step.
  final int current;

  const StepProgress({super.key, required this.current});

  static const _labels = ['Countries', 'Colleges', 'Details', 'Review'];

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 560;

    return Row(
      children: [
        for (var i = 0; i < _labels.length; i++) ...[
          _dot(i),
          if (!isNarrow || i == current) ...[
            const SizedBox(width: 8),
            Text(
              _labels[i],
              style: TextStyle(
                fontSize: 13,
                fontWeight: i == current ? FontWeight.w700 : FontWeight.w500,
                color: i <= current
                    ? AppColors.primary
                    : AppColors.textMuted,
              ),
            ),
          ],
          if (i < _labels.length - 1)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: i < current ? AppColors.primary : AppColors.border,
              ),
            ),
        ],
      ],
    );
  }

  Widget _dot(int i) {
    final done = i < current;
    final active = i == current;
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: done
            ? AppColors.primary
            : active
                ? AppColors.primaryLight
                : AppColors.surfaceMuted,
        shape: BoxShape.circle,
        border: Border.all(
          color: i <= current ? AppColors.primary : AppColors.border,
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: done
          ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
          : Text(
              '${i + 1}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: active ? AppColors.primary : AppColors.textMuted,
              ),
            ),
    );
  }
}
