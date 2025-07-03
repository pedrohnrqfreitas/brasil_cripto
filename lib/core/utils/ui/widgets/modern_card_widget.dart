import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class ModernCardWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final LinearGradient? gradient;
  final VoidCallback? onTap;
  final double? elevation;

  const ModernCardWidget({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.gradient,
    this.onTap,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}