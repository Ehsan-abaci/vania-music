import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MusicWidgetShimmerLoading extends StatefulWidget {
  const MusicWidgetShimmerLoading({super.key});

  @override
  State<MusicWidgetShimmerLoading> createState() =>
      _MusicWidgetShimmerLoadingState();
}

class _MusicWidgetShimmerLoadingState extends State<MusicWidgetShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _colorController;
  late Animation _colorAnimation;
  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.grey.shade700.withOpacity(.1),
      end: Colors.grey.shade700.withOpacity(.6),
    ).animate(
      CurvedAnimation(parent: _colorController, curve: Curves.easeIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorController,
      builder: (context, child) => ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 9,
        itemBuilder: (context, i) => MusicItemShimmerLoading(
          color: _colorAnimation.value,
        ),
      ),
    );
  }
}

class MusicItemShimmerLoading extends StatelessWidget {
  MusicItemShimmerLoading({super.key, required this.color});
  Color color;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: w,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _getShimmerContent(170),
                    const Expanded(flex: 2, child: SizedBox()),
                    _getShimmerContent(70),
                  ],
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: color,
            ),
          ],
        ),
      ),
    );
  }

  Expanded _getShimmerContent(double width) {
    return Expanded(
      child: Container(
        width: width,
        decoration: ShapeDecoration(
          color: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
