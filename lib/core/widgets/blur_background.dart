

import 'package:flutter/material.dart';


class BlurBackground extends StatelessWidget {
  const BlurBackground({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.background,
      child: ShaderMask(
        blendMode: BlendMode.difference,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          tileMode: TileMode.clamp,
          colors: [
            Colors.black45.withOpacity(.8),
            Colors.black54.withOpacity(.8),
            Colors.black87.withOpacity(.8),
          ],
        ).createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: child,
      ),
    );
  }
}
