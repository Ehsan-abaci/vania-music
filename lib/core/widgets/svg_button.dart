import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SVGButton extends StatelessWidget {
  const SVGButton({
    super.key,
    required this.function,
    required this.icon,
    required this.color,
  });
  final Function() function;
  final String icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: SvgPicture.asset(
        icon,
        height: 20,
        fit: BoxFit.scaleDown,
        colorFilter: ColorFilter.mode(
          color,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
