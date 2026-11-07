import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';

class ResponsiveContent extends StatelessWidget {
  final Widget child;

  const ResponsiveContent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppDimensions.maxContentWidth,
        ),
        child: child,
      ),
    );
  }
}
